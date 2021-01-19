function MarrHildreth(fileName,rec) 
%% Read Image and convert to Double
    org_img=imread(fileName);
    img=double(org_img);
%% Calculate LoG filter and Convolve
    sigma = min(size(org_img)) * 0.005; % calculate sigma
    kernel = calcLoG(sigma);
    q=conv2(img,kernel,'same'); %Convolution of image and LoG filter

%% Detecting Zero Crossings
    threshold = 0.5 * mean(abs(q(:))); % set threshold
    % fprintf('\nSigma for calcLoG: %d\n',sigma); 
    % fprintf('Threshold value: %d\n',threshold);
    [row,col]=size(q);
    new=zeros([row,col]);
    thresh=zeros([row,col]);
    for i=2:row-1
        for j=2:col-1
            if (q(i,j)>0)
                % RIGHT - LEFT
                if ((q(i,j+1)>=0 && q(i,j-1)<0) || (q(i,j+1)<0 && q(i,j-1)>=0))
                    new(i,j) = q(i,j);
                        if(abs(q(i,j+1) - q(i,j-1))>threshold) % THRESHOLD
                            thresh(i,j) = q(i,j);
                        end
                % UP - DOWN
                elseif ((q(i+1,j)>=0 && q(i-1,j)<0) || (q(i+1,j)<0 && q(i-1,j)>=0))
                    new(i,j) = q(i,j);
                        if (abs(q(i+1,j) - q(i-1,j))>threshold) % THRESHOLD
                            thresh(i,j) = q(i,j);
                        end                   
                % UP/RIGHT - DOWN/LEFT
                elseif ((q(i+1,j+1)>=0 && q(i-1,j-1)<0) || (q(i+1,j+1)<0 && q(i-1,j-1)>=0))
                    new(i,j) = q(i,j);
                        if (abs(q(i+1,j+1) - q(i-1,j-1))>threshold) % THRESHOLD
                            thresh(i,j) = q(i,j);
                        end         
                % DOWN/RIGHT - UP/LEFT 
                elseif ((q(i-1,j+1)>=0 && q(i+1,j-1)<0) || (q(i-1,j+1)<0 && q(i+1,j-1)>=0))
                    new(i,j) = q(i,j);
                        if (abs(q(i-1,j+1) - q(i+1,j-1))>threshold) % THRESHOLD
                            thresh(i,j) = q(i,j);
                        end      
                end          
            end        
        end
    end
%% Ploting
    figure('Name','Steps in Processing','NumberTitle','off')
    subplot(2,2,1);    
        imshow(org_img);
        title('Original image');
    subplot(2,2,2);        
        imshow(q);
        title(sprintf('LoG image, \\sigma = %d',sigma));
    subplot(2,2,3);
        imshow(new);
        title('Zero Crossing');
    subplot(2,2,4);    
        imshow(thresh);
        title(sprintf('Threshold LoG \n(Threshold = %d)',threshold));
    saveas(gcf,fullfile('.\results', sprintf('%s',rec)),'png'); % .png file for steps
    savefig(fullfile('.\results', sprintf('%s.fig',rec)))       % .fig file for steps
    
    figure('Name','Final Result','NumberTitle','off')
    imshow(thresh);
    saveas(gcf,fullfile('.\final', sprintf('%s',rec)),'png');   % .png file for end result
    savefig(fullfile('.\final', sprintf('%s.fig',rec)))       % .fig file for end result
close all;
end