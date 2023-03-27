
const fs = require('fs');
const path = require('path');

const folderPath = './metadata/metadata';

fs.readdir(folderPath, (err, files) => {
  if (err) throw err;

                    
  files.forEach((file,index) => {
    if (path.extname(file) === '.json') {
      const filePath = path.join(folderPath, file);
      // Read the JSON object
      const fileContent = fs.readFileSync(filePath, 'utf8');
      const jsonData = JSON.parse(fileContent);
      
      //Fields that you wants to change
      jsonData.name = `Name/ #${file.slice(0, -5)}`;   //slice function will find the current no.file
      jsonData.description = "Description";
      jsonData.image = `image/${file.slice(0, -5)}.png`;

      // Write the modified JSON object back to the file
      const newFileContent = JSON.stringify(jsonData, null, 2);

      fs.writeFileSync(filePath, newFileContent, 'utf8');
      
    }
  });

  console.log("Done")
});
