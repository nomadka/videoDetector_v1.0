video = VideoReader("rawData_Kaggle\v_Bowling_g01_c04.avi");
frame = readFrame(video);

 motionModel = "ConstantVelocity"
 initialLoc = [0 0]
 measurementNoise = 100
 motionNoise = [1 25]
 initialError = [1 25]
 kalmanFilter = configureKalmanFilter(motionModel, initialLoc,...
     initialError, motionNoise, measurementNoise)

while hasFrame(video)

    trackedLoc = predict(kalmanFilter);
    frame = readFrame(video);
    [bbox,score] = detect(detector,frame);
    bbox = bbox(score>50,:);
    score = score(score>50);

        if ~isempty(bbox)
        strongestBbox = selectStrongestBbox(bbox,score, ...
        NumStrongest=1);
        centroid = [bbox(1)+bbox(3)/2  bbox(2)+bbox(4)/2];
        frame = insertShape(frame,"circle",[centroid 20],Color="green");
        trackedLoc = correct(kalmanFilter, centroid);
        end

    frame = insertShape(frame, "filled-circle",[trackedLoc 10], Color = "red");
    imshow(frame)
    drawnow
end