Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dvb-t@iinet.com.au>) id 1KUDPG-0006IZ-AA
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 06:29:03 +0200
Message-ID: <2E13932B9AB84E5CAE2F4B2707C95EC8@mce>
From: "David" <dvb-t@iinet.com.au>
To: <stev391@email.com>
References: <20080807105849.22997BE4078@ws1-9.us4.outblaze.com>
Date: Sat, 16 Aug 2008 14:28:42 +1000
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
	DVB-T Dual Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0897475451=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0897475451==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_005B_01C8FFAC.62309CF0"

This is a multi-part message in MIME format.

------=_NextPart_000_005B_01C8FFAC.62309CF0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

From: stev391@email.com=20
  To: Tim Farrington ; David=20
  Cc: linux-dvb@linuxtv.org=20
  Sent: Thursday, August 07, 2008 8:58 PM
  Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO =
FusionHDTV DVB-T Dual Express

  The firmware file is incorrect, if it states only 3 firmware images=20
  loaded then it is wrong (it should be 80). Here is what that line=20
  should read:
  [  154.867137] xc2028 3-0061: Loading 80 firmware images from =
xc3028-v27.fw, type: xc2028 firmware, ver 2.7

  Make sure you are using the correct extract script and follow the=20
  instructions in the header (script is in the =
linux/Documentation/video4linux)

  Also, the "new" firmware does work in Australia as this is where I=20
  live... (Melbourne, and it has been tested against 3 different=20
  transmitters here [1 of which is Mt Dandenong], with varying reception =
levels.=20
  The card has really good sensitivity however it can easily be drowned =
out if=20
  you have an amplifier).

  If you still have trouble load the following modules with debug =3D 1:
  cx23885
  zl10353
  tuner_xc2028

  Regards,

  Stephen.


  Hi Steve

  Just got the first chance to revisit this today.
  Extracted the firmware again and this time all images were present.
  Tested with tzap and locked all Brisbane channels.
  Fired up MythTV and tested dual tuner operation with the HD channels.
  I'm currently happily tuned to 7HD for the afternoon's Olympic events =
and the performance is simply stunning.

  Many thanks to you, Steven, Chris and all the developers for doing =
such a great job.

  Regards
  David=20




------=_NextPart_000_005B_01C8FFAC.62309CF0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.6000.16608" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><B>From:</B> <A title=3Dstev391@email.com=20
href=3D"mailto:stev391@email.com">stev391@email.com</A> </DIV>
<BLOCKQUOTE dir=3Dltr=20
style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A =
title=3Dtimf@iinet.net.au=20
  href=3D"mailto:timf@iinet.net.au">Tim Farrington</A> ; <A=20
  title=3Ddvb-t@iinet.com.au =
href=3D"mailto:dvb-t@iinet.com.au">David</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Cc:</B> <A =
title=3Dlinux-dvb@linuxtv.org=20
  href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Thursday, August 07, 2008 =
8:58=20
  PM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [linux-dvb] =
[PATCH] Add=20
  initial support for DViCO FusionHDTV DVB-T Dual Express</DIV><SPAN=20
  id=3Dobmessage><FONT face=3DArial size=3D2></FONT>
  <DIV><BR>The firmware file is incorrect, if it states only 3 firmware =
images=20
  <BR>loaded then it is wrong (it should be 80). Here is what that line=20
  <BR>should read:<BR>[&nbsp; 154.867137] xc2028 3-0061: Loading 80 =
firmware=20
  images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7<BR><BR>Make =
sure you=20
  are using the correct extract script and follow the <BR>instructions =
in the=20
  header (script is in the linux/Documentation/video4linux)<BR><BR>Also, =
the=20
  "new" firmware does work in Australia as this is where I <BR>live...=20
  (Melbourne, and it has been tested against 3 different =
<BR>transmitters here=20
  [1 of which is Mt Dandenong], with varying reception levels. <BR>The =
card has=20
  really good sensitivity however it can easily be drowned out if =
<BR>you have=20
  an amplifier).<BR><BR>If you still have trouble load the following =
modules=20
  with debug =3D=20
  =
1:<BR>cx23885<BR>zl10353<BR>tuner_xc2028<BR><BR>Regards,<BR><BR>Stephen.<=
BR></DIV>
  <DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></SPAN>
  <DIV><SPAN><FONT face=3DArial size=3D2>Hi Steve</FONT></SPAN></DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2></FONT></SPAN>&nbsp;</DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2>Just got the first chance to =
revisit this=20
  today.</FONT></SPAN></DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2>Extracted the firmware again =
and this time=20
  all images were present.</FONT></SPAN></DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2>Tested with&nbsp;tzap and =
locked all=20
  Brisbane channels.</FONT></SPAN></DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2>Fired up&nbsp;MythTV and tested =
dual tuner=20
  operation with the HD channels.</FONT></SPAN></DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2>I'm currently happily tuned to =
7HD for the=20
  afternoon's&nbsp;Olympic events and the performance is simply=20
  stunning.</FONT></SPAN></DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2></FONT></SPAN>&nbsp;</DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2>Many thanks to you, Steven,=20
  Chris&nbsp;and&nbsp;all the&nbsp;developers for doing&nbsp;such a =
great=20
  job.</FONT></SPAN></DIV>
  <DIV><SPAN></SPAN>&nbsp;</DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2>Regards</FONT></SPAN></DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2>David</FONT>&nbsp;</SPAN></DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2></FONT></SPAN>&nbsp;</DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2></FONT></SPAN>&nbsp;</DIV>
  <DIV><SPAN><FONT face=3DArial size=3D2></FONT></SPAN>&nbsp;</DIV>
  <DIV><SPAN><FONT face=3DArial=20
size=3D2></FONT>&nbsp;</DIV></SPAN></BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_005B_01C8FFAC.62309CF0--


--===============0897475451==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0897475451==--
