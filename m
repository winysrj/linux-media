Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s13.bay0.hotmail.com ([65.54.246.149])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <takispadaz@hotmail.com>) id 1LZU9r-0000UT-Jz
	for linux-dvb@linuxtv.org; Tue, 17 Feb 2009 18:55:01 +0100
Message-ID: <BAY111-W598DBD904310E159C109CC5B40@phx.gbl>
From: panagiotis takis_rs <takispadaz@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 17 Feb 2009 19:54:24 +0200
MIME-Version: 1.0
Subject: [linux-dvb] Problem with TV card's sound (SAA7134)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0189259475=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0189259475==
Content-Type: multipart/alternative;
	boundary="_a3a33f23-12e1-43e1-a6c9-081b63d67683_"

--_a3a33f23-12e1-43e1-a6c9-081b63d67683_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable


Hey!!
=20
I have a problem with my tv card(pinnacle pctv 310i)
I can see image but i have no sound.
I have tried both tvtime and kdetv.
=20
I have found this http://ubuntuforums.org/showthread.php?t=3D568528 . Is it=
 related with my problem?
=20
My tv card give audio output with this way: direct cable connection from
tv card to sound card ( same cable witch connect cdrom and soundcard )
=20
=20
lspci -v
00:09.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA71=
35 Video Broadcast Decoder (rev d1)
        Subsystem: Pinnacle Systems Inc. Device 002f                       =
                                  =20
        Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 11         =
                                        =20
        Memory at dffff800 (32-bit=2C non-prefetchable) [size=3D2K]        =
                                      =20
        Capabilities: [40] Power Management version 2                      =
                                  =20
        Kernel driver in use: saa7134                                      =
                                  =20
        Kernel modules: saa7134
=20
lspci -nn
00:09.0
Multimedia controller [0480]: Philips Semiconductors
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
=20
dmesg
http://pastebin.com/m2b8c172f
=20
Sorry for my bad english. Please help...
_________________________________________________________________
More than messages=96check out the rest of the Windows Live=99.
http://www.microsoft.com/windows/windowslive/=

--_a3a33f23-12e1-43e1-a6c9-081b63d67683_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Verdana
}
</style>
</head>
<body class=3D'hmmessage'>
<pre>Hey!!<br> <br>I have a problem with my tv card(pinnacle pctv 310i)<br>=
I can see image but i have no sound.<br>I have tried both tvtime and kdetv.=
<br> <br>I have found this <a href=3D"http://ubuntuforums.org/showthread.ph=
p?t=3D568528" target=3D"_blank">http://ubuntuforums.org/showthread.php?t=3D=
568528</a> . Is it related with my problem?<br> <br>My tv card give audio o=
utput with this way: direct cable connection from<br>tv card to sound card =
( same cable witch connect cdrom and soundcard )<br> <br> <br>lspci -v<br>0=
0:09.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA713=
5 Video Broadcast Decoder (rev d1)<br>        Subsystem: Pinnacle Systems I=
nc. Device 002f                                                          <b=
r>        Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 11       =
                                           <br>        Memory at dffff800 (=
32-bit=2C non-prefetchable) [size=3D2K]                                    =
           <br>        Capabilities: [40] Power Management version 2       =
                                                  <br>        Kernel driver=
 in use: saa7134                                                           =
              <br>        Kernel modules: saa7134<br> <br>lspci -nn<br>00:0=
9.0<br>Multimedia controller [0480]: Philips Semiconductors<br>SAA7131/SAA7=
133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)<br> <br>dmesg<br><=
a href=3D"http://pastebin.com/m2b8c172f" target=3D"_blank">http://pastebin.=
com/m2b8c172f</a><br> <br>Sorry for my bad english. Please help...</pre><br=
 /><hr />check out the rest of the Windows Live=99.
More than mail=96Windows Live=99 goes way beyond your inbox.
 <a href=3D'http://www.microsoft.com/windows/windowslive/' target=3D'_new'>=
More than messages</a></body>
</html>=

--_a3a33f23-12e1-43e1-a6c9-081b63d67683_--


--===============0189259475==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0189259475==--
