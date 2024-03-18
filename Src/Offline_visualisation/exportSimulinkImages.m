% Copyright 2024 Delft University of Technology
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%      http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

function exportSimulinkImages(jsonFile, outputFolder)
%Export Simulink model images to png from json input file
%
% :param jsonFile: .json File containing the simulink models
% :param outputFolder: String of output directory

% Read json file
jsonInput = jsondecode(fileread(jsonFile));

% Create output folder
if ~exist(outputFolder, 'dir')
    fprintf('Creating output folder "%s" \n', outputFolder')
    mkdir(outputFolder)
end

baseModels = fieldnames(jsonInput);
for i = 1:numel(baseModels)
    
    % Get the submodels for this base model
    subModels = jsonInput.(baseModels{i});

    % Load Simulink model in memory
    load_system(baseModels{i})

    % Save images of all submodels in the basemodel
    for j = 1:numel(subModels)
        saveSimulinkImage(baseModels{i}, subModels{j}, outputFolder)
    end

    % Remove Simulink model from memory
    close_system(baseModels{i})
    
end

end


function saveSimulinkImage(baseModel, subModel, outputFolder)
%Save the Simulink image to the output directory
%
% :param baseModel: base Simulink model
% :param subModel: path to the Simulink submodel
% :param outputFolder: String of output directory

% Get model path 
modelToExport = getSubmodelName(baseModel, subModel);
exportFile = fullfile(outputFolder, replace(modelToExport, '/', '_'));

% Save model image
fprintf('Exporting "%s" \n', modelToExport)
saveas(get_param(modelToExport, 'Handle'), [ exportFile, '.png']);

end


function modelName = getSubmodelName(baseModel, subModel)
%Get full sub model names

if ~isempty(subModel)
    modelName = strcat(baseModel, '/', subModel);
else
    modelName = baseModel;
end
end