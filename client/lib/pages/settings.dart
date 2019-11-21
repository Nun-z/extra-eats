import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var settings = {
    'notifications': true,
    'stayLogin': true,
  };
  bool _saved = true;

  Future savePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', settings['notifications']);
    prefs.setBool('stayLogin', settings['stayLogin']);
    setState(() {
      _saved = true;
    });
    return true;
  }

  Future getPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    settings['notifications'] = prefs.getBool('notifications') ?? true;
    settings['stayLogin'] = prefs.getBool('stayLogin') ?? true;
    _saved = true;
    return settings;
  }

  Widget settingsSwitch(BuildContext context,
      {Icon icon, String label, String setting}) {
    return ListTile(
        leading: icon,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(label, style: TextStyle(fontWeight: FontWeight.w300)),
            Spacer(flex: 1),
            Transform.scale(
                scale: 1.5,
                child: Switch(
                  value: settings[setting],
                  onChanged: (bool changed) async {
                    setState(() {
                      settings[setting] = changed;
                      _saved = false;
                    });
                  },
                ))
          ],
        ),
        onTap: () async {
          setState(() {
            settings[setting] = !settings[setting];
            _saved = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        settingsListOrError(context),
        Spacer(),
        Text('Sponsored by:',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/sambazon.png'), width: 200.0),
        ),
      ],
    );
  }

  Widget settingsListOrError(BuildContext context) {
    var errorStyle = TextStyle(color: Theme.of(context).errorColor);
    if (!_saved)
      return settingsList(context);
    else
      return FutureBuilder(
          future: getPreferences(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Can\'t connect', style: errorStyle);
              case ConnectionState.active:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}', style: errorStyle);
                //else
                return settingsList(context);
            }
          });
  }

  Widget settingsList(BuildContext context) {
    return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          settingsSwitch(context,
              icon: Icon(Icons.person),
              label: 'Stay logged in',
              setting: 'stayLogin'),
          settingsSwitch(context,
              icon: Icon(Icons.notifications),
              label: 'Push notifications',
              setting: 'notifications'),
          ListTile(
              leading: Icon(Icons.assignment),
              title:
                  Text('Terms and Conditions', style: TextStyle(fontWeight: FontWeight.w300)),
              //TODO
              onTap: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => LegalInfo())); }
              ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title:
                Text('Sign out', style: TextStyle(fontWeight: FontWeight.w300)),
            onTap: () async {
              settings['stayLogin'] = false;
              await savePreferences();
              InheritedClient.of(context).logout();
            },
          ),
          if (!_saved)
            RaisedButton(
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: savePreferences),
        ]);
  }
}

class LegalInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Terms and Conditions"),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: '',
                style: TextStyle(color: Colors.black.withOpacity(1.0)),
                children: <TextSpan>[
                  TextSpan(text: 'Extra Eats General Terms and Conditions\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Last updated: September 25\n\n', style: TextStyle(color: Colors.black.withOpacity(1.0))),
                  TextSpan(text: 'These Terms of Use ("Terms") govern your access or use, from within the United States and its '
                                 'territories and possessions, of the applications, websites, content, products, and services '
                                 '("Services”) between the user of the Services (“You” or the “User”) and Extra Eats (“We” or '
                                 '“Our” or “Us”)(individually a “party” and collectively the “parties”)\n\n'),
                  TextSpan(text: '1. Warranties; Disclaimer.\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '1.1 Warranties.\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  TextSpan(text: 'Each party hereby represents and warrants that: (a) it has full power and authority to enter '
                                 'into this Agreement and perform its obligations hereunder; (b) it will comply with all applicable '
                                 'laws and regulations in its performance of this Agreement (including without limitation all applicable '
                                 'data protection and privacy laws); and (c) the content, media and other materials used or provided '
                                 'as part of this Agreement shall not infringe or otherwise violate the intellectual property rights, '
                                 'rights of publicity or other proprietary rights of '
                                 'any third party.\n\n', style: TextStyle(color: Colors.black.withOpacity(1.0))),
                  TextSpan(text: '1.2 Disclaimer.\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  TextSpan(text: 'Except as set forth herein, each party makes no representations, and hereby expressly disclaims '
                                 'all warranties, express or implied, regarding its services or products or any portion thereof, including, '
                                 'without limitation, any implied warranty of merchantability or fitness for a particular purpose and '
                                 'implied warranties arising from course of dealing or course of performance. The Services and any food '
                                 'or beverage that is made available through the application is made available on an as-is and '
                                 'as-available basis. No representations or warranties are made as to the safety, accuracy, '
                                 'or availability of any food or beverage. You will consume food and beverage at '
                                 'their own risk. \n\n', style: TextStyle(color: Colors.black.withOpacity(1.0))),
                  TextSpan(text: '2. Indemnity.\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'In addition, the User acknowledges that consuming the food and beverages made available '
                                 'by Us may cause illness or other negative health consequences due to a variety of reasons, '
                                 'including, but not limited to, improper storage. Accordingly, You agree to indemnify, defend '
                                 'and hold Extra Eats and any food handlers, food prepares, or event organizers harmless from any '
                                 'claims, including, without limitation, third party claims, resulting from the Your consumption, '
                                 'storage, or sharing of the food after the food has been made available on the Extra Eats platform, '
                                 'except to the extent that any harm was caused by the gross negligence or willful misconduct of '
                                 'the food handler.', style: TextStyle(color: Colors.black.withOpacity(1.0))),
                  TextSpan(text: '\n\nEach Indemnified Party shall provide prompt notice to the Indemnifying Party of any potential '
                                 'claim subject to indemnification hereunder. The Indemnifying Party will assume the defense of the '
                                 'claim through counsel designated by it and reasonably acceptable to the Indemnified Party. '
                                 'The Indemnifying Party will not settle or compromise any claim, or consent to the entry of any '
                                 'judgment, without written consent of the Indemnified Party, which will not be unreasonably withheld or '
                                 'delayed. The Indemnified Party will reasonably cooperate with the Indemnifying Party in the defense of '
                                 'a claim, at Indemnifying Party’s expense.\n\n', style: TextStyle(color: Colors.black.withOpacity(1.0))),
                  TextSpan(text: '3. Limits of Liability.\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Except for a party’s indemnification obligations, (a) in no event shall either party be liable '
                                 'for any claim for any indirect, willful, punitive, incidental, exemplary, special or consequential '
                                 'damages, for loss of business profits, or damages for loss of business of restaurant or any third '
                                 'party arising out of this agreement, or loss or inaccuracy of data of any kind, whether based on '
                                 'contract, tort or any other legal theory, even if such party has been advised of the possibility '
                                 'of such damages; and (b) each party’s total cumulative liability of each and every kind under this '
                                 'agreement shall not exceed \$1,000. The foregoing limitation of liability and exclusion of certain '
                                 'damages shall apply regardless of the success or effectiveness of other '
                                 'remedies.\n\n', style: TextStyle(color: Colors.black.withOpacity(1.0))),
                  TextSpan(text: '4. Term and Termination\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'By downloading and using the Services, you agree to all of the Terms and Conditions contained herein.  '
                                 'We reserve the right to update these Terms and Conditions at any time. It is Your responsibility to '
                                 'check these Terms and Conditions for any changes.  If at any time you no longer agree to all of the '
                                 'Terms and Conditions contained herein, discontinue your use of the Services immediately.  At its sole '
                                 'discretion, We may modify or discontinue the Services, or may modify, suspend or terminate your access '
                                 'to the Services, for any reason, with or without notice to you and without liability to You or '
                                 'any third party.\n\n', style: TextStyle(color: Colors.black.withOpacity(1.0))),
                  TextSpan(text: '5. General.\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'This Agreement shall be governed by and construed in accordance with the laws of the State of '
                                 'California without regard to its conflict of laws provisions. You hereby consent to the '
                                 'exclusive jurisdiction and venue in the State and Federal courts sitting in Santa Clara County, '
                                 'California. In addition, You agree to receive autodialed calls or SMS messages sent by or on behalf '
                                 'of Us. The failure of either party to enforce, at any time or for any period of time, the provisions '
                                 'hereof, or the failure of either party to exercise any option herein, shall not be construed as a '
                                 'waiver of such provision or option and shall in no way affect that party’s right to enforce such '
                                 'provisions or exercise such option. Any modification or amendment to this Agreement shall be '
                                 'effective only if in writing and signed by both parties. In the event any provision of this Agreement '
                                 'is determined to be invalid or unenforceable by ruling of an arbitrator or court of competent jurisdiction, '
                                 'the remainder of this Agreement (and each of the remaining terms and conditions contained herein) shall remain '
                                 'in full force and effect. Nothing herein shall be construed as to create an exclusive arrangement between '
                                 'the parties. This Agreement shall not restrict you from acquiring similar, equal, or like services from other '
                                 'entities or sources, nor shall it restrict Company from providing similar, equal, or like services to '
                                 'other entities.   No joint venture, partnership, employment, or agency relationship exists between you, We or '
                                 'any third party provider as a result of this Agreement or use of the '
                                 'Services.', style: TextStyle(color: Colors.black.withOpacity(1.0))),
                ],
              ),
            )
          ],
        )
    );
  }
}