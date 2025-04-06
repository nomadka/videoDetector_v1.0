load ACFdetector4tracking
video = VideoReader("turtle.avi");
frame = readFrame(video);

motionModel = "ConstantVelocity"
initialLoc = centroid
measurementNoise = 100
motionNoise = [1 25]
initialError = [1 25]
kalmanFilter = configureKalmanFilter(motionModel, initialLoc, ...
    initialError, motionNoise, measurementNoise)

while hasFrame(video)

    trackedLoc = predict(kf)
    frame = readFrame(turtleVideo)
    [bbox,score] = detect(detector,frame);
    bbox = bbox(score>95,:);
    score = score(score>95);

        if ~isempty(bbox)
        strongestBbox = selectStrongestBbox(bbox,score, ...
        NumStrongest=1);
        centroid = [bbox(1)+bbox(3)/2  bbox(2)+bbox(4)/2];
        frame = insertShape(frame,"filled-circle",[centroid 50],Color="green");
        trackedLoc = correct(kf, centroid)
        end

    frame = insertShape(frame, "filled-circle",[trackedLoc 30], Color = "red")
    imshow(frame)
    drawnow
end