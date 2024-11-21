import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var textController = TextEditingController();
  String? encryptedText;
  String? decryptedText;

  // AES Encryption Key and IV
  final initVector = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8('16characterslong')));


  //encryption
  void convertToEncryptedText() {
    final plainText = textController.text;
    if (plainText.isNotEmpty) {
      final encrypted = encrypter.encrypt(plainText, iv: initVector);

      setState(() {
       // encryptedText = encrypted.base64;
        encryptedText = encrypted.base64;
        decryptedText = null; // Reset decrypted text on new encryption
      });


    }
  }


//decryption
  void convertToDecryptedText() {
    if (encryptedText != null) {
      final encryptedData = encrypt.Encrypted.fromBase64(encryptedText!);
      final decrypted = encrypter.decrypt(encryptedData, iv: initVector);

      setState(() {
        decryptedText = decrypted;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Encryption",style: TextStyle(
          color: Colors.white
        ),),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Text',
              ),
            ),
          ),
          SizedBox(height: 20),



          ElevatedButton(
            onPressed: ()
            {

              //call to function
              convertToEncryptedText();
            },
            child: Text('Encrypt'),
          ),




          if (encryptedText != null) ...[
            SizedBox(height: 20),
            Text(
              'Encrypted Text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(encryptedText!),
          ],
          SizedBox(height: 20),


          //button
          if (encryptedText != null) ...[
            ElevatedButton(
              onPressed: convertToDecryptedText,
              child: Text('Decrypt'),
            )
          ],


          //text
          if (decryptedText != null) ...[
            SizedBox(height: 20),
            Text(
              'Decrypted Text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(decryptedText!),
          ],



        ],
      ),

    );
  }
}

