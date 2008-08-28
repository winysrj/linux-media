Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from belle.abrahamsson.com ([194.187.61.10])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sverker@abrahamsson.com>) id 1KYg8M-0007C8-MX
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 13:57:51 +0200
Message-ID: <483940C30C8D406C93CF3978F5371313@shrek>
From: "Sverker Abrahamsson" <sverker@abrahamsson.com>
To: <abraham.manu@gmail.com>
Date: Thu, 28 Aug 2008 13:57:14 +0200
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] Mantis status? VP3030 questions
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1041000068=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Det här är ett flerdelat meddelande i MIME-format.

--===============1041000068==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_003D_01C90915.F9936740"

Det här är ett flerdelat meddelande i MIME-format.

------=_NextPart_000_003D_01C90915.F9936740
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi,
what is the current status of the Mantis driver (Manu Abrahams tree)? =
Does it work stable with any card?

I've been trying to make it work for the Twinhan VP3030 DVB-T card but I =
see that the part that enables the frontend was disabled. I've enabled =
it and made the neccesary API changes to make it compile (such as using =
dvb_attach instead of calling directly to the specific frontend attach). =
The frontend is a ZL10353 (it is now called CE6353 after being aquired =
by Intel) which is supported on other cards.

In the zl10353_attach routine I see that it's trying to read CHIP_ID =
from i2c device 0x0f but I'm getting undefined results. Yesterday it was =
0xfd, today it has been 0x00. Not 0x14 as it should be.

The only reason I can see for that is that the chip has not been reset =
properly. The sequence for initializing the frontend is to first power =
it up by setting gpio bit 0x0c on mantis to 1, then reset it by writing =
first 0 to gpio bit 13 for 200 ms, then 1.

One potential scenario is that the reset pin is not connected to gpio =
pin 13 on this board but has some other wiring, other than that I don't =
know what to look for.

I tested to comment out the check for CARD_ID, then the frontend is =
established and it finds the tuner correctly on i2c address 0x60 but it =
does not work to scann, get tuning failed on all frequencies.

Any suggestions?
/Sverker
------=_NextPart_000_003D_01C90915.F9936740
Content-Type: text/html;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type =
content=3Dtext/html;charset=3DWindows-1252>
<META content=3D"MSHTML 6.00.6000.16705" name=3DGENERATOR></HEAD>
<BODY id=3DMailContainerBody=20
style=3D"PADDING-RIGHT: 10px; PADDING-LEFT: 10px; PADDING-TOP: 15px"=20
bgColor=3D#ffffff leftMargin=3D0 topMargin=3D0 CanvasTabStop=3D"true"=20
name=3D"Compose message area">
<DIV><FONT face=3DArial size=3D2>Hi,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>what is the current status of the =
Mantis driver=20
(Manu Abrahams tree)? Does it work stable with any card?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I've been trying to make it work for =
the Twinhan=20
VP3030 DVB-T card but I see that the part that enables the frontend was=20
disabled. I've enabled it and made the neccesary API changes to make it =
compile=20
(such as using dvb_attach instead of calling directly to the specific =
frontend=20
attach). The frontend is a ZL10353 (it&nbsp;is now called CE6353 after =
being=20
aquired by Intel)&nbsp;which is supported on other cards.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>In the zl10353_attach routine I see =
that it's=20
trying to read CHIP_ID from i2c device 0x0f but I'm getting undefined =
results.=20
Yesterday it was 0xfd, today it has been 0x00. Not 0x14 as it should=20
be.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>The only reason I can see for that is =
that the chip=20
has not been reset properly. The sequence for initializing the frontend =
is to=20
first power it up by setting gpio bit 0x0c on mantis to 1, then reset it =
by=20
writing first 0 to gpio bit 13 for 200 ms, then 1.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>One potential scenario is that the =
reset pin is not=20
connected to gpio pin 13 on this board but has some other wiring, other =
than=20
that I don't know what to look for.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I tested to comment out the check for =
CARD_ID, then=20
the frontend is established and it finds the tuner correctly on i2c =
address 0x60=20
but it does not work to scann, get tuning failed on all=20
frequencies.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Any suggestions?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>/Sverker</FONT></DIV></BODY></HTML>

------=_NextPart_000_003D_01C90915.F9936740--



--===============1041000068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1041000068==--
