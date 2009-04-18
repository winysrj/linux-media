Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.adamobredband.com ([91.126.224.27])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sacha@hemmail.se>) id 1LvBZu-0004hG-9M
	for linux-dvb@linuxtv.org; Sat, 18 Apr 2009 16:31:34 +0200
Received: from asrock (c-94-255-208-135.cust.bredband2.com [94.255.208.135])
	by smtp.adamobredband.com (Postfix) with ESMTP id 913767B8BC
	for <linux-dvb@linuxtv.org>; Sat, 18 Apr 2009 16:31:19 +0200 (CEST)
From: "Sacha" <sacha@hemmail.se>
To: <linux-dvb@linuxtv.org>
Date: Sat, 18 Apr 2009 16:31:17 +0200
Message-ID: <000001c9c032$5697da60$0401a8c0@asrock>
MIME-Version: 1.0
Subject: [linux-dvb] How to compile Mantis driver with em28xx driver
	installed?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1521546670=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1521546670==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0001_01C9C043.1A20AA60"

This is a multi-part message in MIME format.

------=_NextPart_000_0001_01C9C043.1A20AA60
Content-Type: text/plain;
	charset="x-user-defined"
Content-Transfer-Encoding: 7bit

Hello
 
I have a Pinnacle USB DVB-T stick and Azurwave Azurewave AD-SP400 CI
(Twinhan VP-1041) DVB-S2 on my system.
USB stick uses em28xx-new drivers from mcentral.
It works well untill I install Mantis/S2API drivers from I. Liplianin.
I get my DVB-S2 card workin but em28xx drivers wont load complaining
about unknown symbol etc...
If I understand well S2API installation overwrite some files used by
em28xx driver with its own leading to this conflict.
My question is how to avoide this? I want both cards working.
 
KR

------=_NextPart_000_0001_01C9C043.1A20AA60
Content-Type: text/html;
	charset="x-user-defined"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<TITLE>Meddelande</TITLE>

<META content=3D"MSHTML 6.00.2900.3268" name=3DGENERATOR></HEAD>
<BODY>
<DIV><SPAN class=3D234291214-18042009><FONT =
size=3D2>Hello</FONT></SPAN></DIV>
<DIV><SPAN class=3D234291214-18042009><FONT =
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D234291214-18042009><FONT size=3D2>I have a Pinnacle =
USB DVB-T=20
stick and Azurwave Azurewave AD-SP400 CI (Twinhan VP-1041) DVB-S2 on my=20
system.</FONT></SPAN></DIV>
<DIV><SPAN class=3D234291214-18042009><FONT size=3D2>USB stick uses =
em28xx-new=20
drivers from mcentral.</FONT></SPAN></DIV>
<DIV><SPAN class=3D234291214-18042009><FONT size=3D2>It works well =
untill I install=20
Mantis/S2API drivers from I. Liplianin.</FONT></SPAN></DIV>
<DIV><SPAN class=3D234291214-18042009><FONT size=3D2>I get my DVB-S2 =
card workin but=20
em28xx drivers wont load complaining about unknown symbol=20
etc...</FONT></SPAN></DIV>
<DIV><SPAN class=3D234291214-18042009><FONT size=3D2>If I understand =
well S2API=20
installation overwrite some files used by em28xx driver with its own =
leading to=20
this conflict.</FONT></SPAN></DIV>
<DIV><SPAN class=3D234291214-18042009><FONT size=3D2>My question is how =
to avoide=20
this? I want both cards working.</FONT></SPAN></DIV>
<DIV><SPAN class=3D234291214-18042009><FONT =
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D234291214-18042009><FONT=20
size=3D2>KR</FONT></SPAN></DIV></BODY></HTML>

------=_NextPart_000_0001_01C9C043.1A20AA60--



--===============1521546670==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1521546670==--
