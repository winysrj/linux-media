Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <matt.keyra@gmail.com>) id 1LXwK3-0003fc-9E
	for linux-dvb@linuxtv.org; Fri, 13 Feb 2009 12:35:08 +0100
Received: by ug-out-1314.google.com with SMTP id 30so60512ugs.16
	for <linux-dvb@linuxtv.org>; Fri, 13 Feb 2009 03:35:03 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Feb 2009 12:35:03 +0100
Message-ID: <acde52650902130335h5e747b96q2228731a8893f5a5@mail.gmail.com>
From: Mathieu Seguy <matt.keyra@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] DSMCC : How to add descriptors for PMT Generation into
	"psi-config.py" file ?
Reply-To: linux-media@vger.kernel.org, mathieu.seguy@telecom-bretagne.eu
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,
I would know how can I include a new descriptor into the PMT
declaration, in order to respect the French configuration.

That's is a piece (which is concerned by the modification) of the PMT :

 data_broadcast_id_descriptor(
        data_broadcast_ID =3D 10, # System Software Update
        ID_selector_bytes =3D '',
        ),

To respect French configuration, I need to add this descriptor into
the data_broadcast_id_descriptor :

System_software_update_info(){
     OUI_data_length
     for (i=3D0; i<N; i++){
       OUI
       reserved
       update_typeprofil =E9tendu)
       reserved
       update_versioning_flag
       update_version
       selector_length
     }
}


But if I choose to modify the PMT like that :

data_broadcast_id_descriptor(
		data_broadcast_ID =3D 10, # System Software Update
		ID_selector_bytes =3D '',
		system_software_update_info =3D [
		    OUI =3D 0x00e064, # <<<<<<<<<<<<
		    update_type =3D 1,
		]
	    ),

I have the following error message:
File "./psi-config.py", line 261, in <module>    OUI_data_length( :
NameError: name 'OUI_data_length' is not defined

Or :
File "./psi-config.py", line 262    OUI =3D 0x00e064, # <<<<<<<<<<<<
    ^ SyntaxError: invalid syntax


How can I define my descriptor so ?

Thanks for any answer

Best regards

----------
Mathieu
Network Apprentice Engineer

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
