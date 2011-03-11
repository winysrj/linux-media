Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <jwhecker@gmail.com>) id 1PyBzk-0000Sv-T9
	for linux-dvb@linuxtv.org; Sat, 12 Mar 2011 00:43:45 +0100
Received: from mail-iy0-f182.google.com ([209.85.210.182])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-a) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1PyBzk-0003Ix-Aa; Sat, 12 Mar 2011 00:43:44 +0100
Received: by iyj12 with SMTP id 12so3727766iyj.41
	for <linux-dvb@linuxtv.org>; Fri, 11 Mar 2011 15:43:41 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 12 Mar 2011 10:43:41 +1100
Message-ID: <AANLkTikV3LW5JZdUMjctretv8_ZWN6YFhhfwzDo8NzbW@mail.gmail.com>
From: Jason Hecker <jhecker@wireless.org.au>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with saa7134: Asus Tiger revision 1.0,
	subsys 1043:4857
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1724287045=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============1724287045==
Content-Type: multipart/alternative; boundary=90e6ba6e82aa2f5d59049e3d887b

--90e6ba6e82aa2f5d59049e3d887b
Content-Type: text/plain; charset=ISO-8859-1

I just bought a pair of what are a version of the My Cinema 7131 Hybrid
cards.

The kernel reports it as saa7134: Asus Tiger revision 1.0, subsys 1043:4857

I did inititially try Mythbuntu 10.04 but the firmware upload seemed to fail
fairly consistently.  Restarting with v10.10 the firmware loads but I can't
seem to scan the channels with Mythbackend - it has a 0% signal and 100%
signal to noise.  I am using MythTV 0.24 with Avenard's latest patches.

This version of the card has written on the silkscreen Tiger rev 3.02, a
sticker that says Tiger_8M AA.F7.C0.01 (which would appear to be the latest
firmware for this card on Asus's support site) but there is only one RF
connector on CON1.  CON2 is not fitted nor is the IR receiver.  Now I saw
mentioned on a list that to get DVB working on this card in Linux you need
to connect the TV antenna to the FM port, which I suspect is the one not
fitted.  The latest Windows drivers for this card is circa 2009.

Two questions:
- Is there some sort of SAA7134 module argument I need to use to get the
card working on the TV RF input?
- Why does the kernel show the firmware is being reloaded every time MythTV
seems to want to talk to the card?  This slows down access as it seems to
take about 30 seconds for the firmware to install each time.

I am happy to provide whatever debug dumps or more info if need be.

--90e6ba6e82aa2f5d59049e3d887b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I just bought a pair of what are a version of the <span id=3D"msg_model2" c=
lass=3D"TITLESS">My Cinema 7131 Hybrid cards.<br><br>The kernel reports it =
as saa7134: Asus Tiger revision 1.0, subsys 1043:4857 <br><br>I did inititi=
ally try Mythbuntu 10.04 but the firmware upload seemed to fail fairly cons=
istently.=A0 Restarting with v10.10 the firmware loads but I can&#39;t seem=
 to scan the channels with Mythbackend - it has a 0% signal and 100% signal=
 to noise.=A0 I am using MythTV 0.24 with Avenard&#39;s latest patches.<br>
<br>This version of the card has written on the silkscreen Tiger rev 3.02, =
a sticker that says Tiger_8M AA.F7.C0.01 (which would appear to be the late=
st firmware for this card on Asus&#39;s support site) but there is only one=
 RF connector on CON1.=A0 CON2 is not fitted nor is the IR receiver.=A0 Now=
 I saw mentioned on a list that to get DVB working on this card in Linux yo=
u need to connect the TV antenna to the FM port, which I suspect is the one=
 not fitted.=A0 The latest Windows drivers for this card is circa 2009.<br>
<br>Two questions:<br>- Is there some sort of SAA7134 module argument I nee=
d to use to get the card working on the TV RF input?<br>- Why does the kern=
el show the firmware is being reloaded every time MythTV seems to want to t=
alk to the card?=A0 This slows down access as it seems to take about 30 sec=
onds for the firmware to install each time.<br>
<br>I am happy to provide whatever debug dumps or more info if need be.<br>=
<br><br></span>

--90e6ba6e82aa2f5d59049e3d887b--


--===============1724287045==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1724287045==--
