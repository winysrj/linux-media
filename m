Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s30.bay0.hotmail.com ([65.54.246.166])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mehmetcanser@hotmail.com>) id 1JypF8-0000Xf-Me
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 16:24:39 +0200
Message-ID: <BAY114-W19D6AA945D0699B6AD7193DBC70@phx.gbl>
From: mehmet canser <mehmetcanser@hotmail.com>
To: bvidinli <bvidinli@gmail.com>, <stev391@email.com>, <linux-dvb@linuxtv.org>
Date: Wed, 21 May 2008 14:22:38 +0000
In-Reply-To: <36e8a7020805210610q2f1b7cfam367eb0f369366e31@mail.gmail.com>
References: <36e8a7020805210610q2f1b7cfam367eb0f369366e31@mail.gmail.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] fail:Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04,
	kernel 2.6.24-16-generic (bvidin
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1242500406=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1242500406==
Content-Type: multipart/alternative;
	boundary="_98bd9c6e-8e8c-45e5-ae1d-d4408e5ac556_"

--_98bd9c6e-8e8c-45e5-ae1d-d4408e5ac556_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable


Compile modules and install them=20

 - sudo make install
 - open your file manager, mc or nautilus  ( with sudo mc or sudo nautilus)
 - find modules directory,
 - look at the file dates and find old ones,=20
 - delete old files, copy the new files (the files you compiled)
 - reboot your computer.

This is not a clean way, but it works.

Look if it s loaded;
 dmseg | grep saa

if not loaded, try =20
  sudo modprobe saa7134 i2c_scan=3D1

Regards


_________________________________________________________________
Give to a good cause with every e-mail. Join the i=92m Initiative from Micr=
osoft.
http://im.live.com/Messenger/IM/Join/Default.aspx?souce=3DEML_WL_ GoodCause=

--_98bd9c6e-8e8c-45e5-ae1d-d4408e5ac556_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt;
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'>
Compile modules and install them <br><br>&nbsp;- sudo make install<br>&nbsp=
;- open your file manager, mc or nautilus&nbsp; ( with sudo mc or sudo naut=
ilus)<br>&nbsp;- find modules directory,<br>&nbsp;- look at the file dates =
and find old ones, <br>&nbsp;- delete old files, copy the new files (the fi=
les you compiled)<br>&nbsp;- reboot your computer.<br><br>This is not a cle=
an way, but it works.<br><br>Look if it s loaded;<br>&nbsp;dmseg | grep saa=
<br><br>if not loaded, try&nbsp; <br>&nbsp; sudo modprobe saa7134 i2c_scan=
=3D1<br><br>Regards<br><br><br /><hr />Give to a good cause with every e-ma=
il. <a href=3D'http://im.live.com/Messenger/IM/Join/Default.aspx?souce=3DEM=
L_WL_ GoodCause' target=3D'_new'>Join the i=92m Initiative from Microsoft.<=
/a></body>
</html>=

--_98bd9c6e-8e8c-45e5-ae1d-d4408e5ac556_--


--===============1242500406==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1242500406==--
