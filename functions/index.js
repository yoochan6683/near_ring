const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

var serviceAccount = require("./nearring-4082c-firebase-adminsdk-2ke2w-d4cd606798.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

exports.createCustomToken = functions.region("asia-northeast3").https.onRequest(async (request, response) => {
  const user = request.body;

  const uid = `kakao:${user.uid}`;
  const updateParams = {
    email: user.email,
    photoURL: user.photoURL,
    displayName: user.displayName,
  };

  try {
    await admin.auth().updateUser(uid, updateParams);
  } catch (error) {
    updateParams["uid"] = uid;
    await admin.auth().createUser(updateParams);
  }

  const token = await admin.auth().createCustomToken(uid);

  response.send(token);
});
