Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from helios.cedo.cz ([193.165.198.226] helo=postak.cedo.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@drajsajtl.cz>) id 1L0xhk-0003GI-Dj
	for linux-dvb@linuxtv.org; Fri, 14 Nov 2008 13:23:18 +0100
Message-ID: <006c01c94653$edd44070$f4c6a5c1@tommy>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: "Rune Evjen" <rune.evjen@gmail.com>
References: <001101c93ce7$23bcfdb0$7f79a8c0@tommy>
	<57808ff0811130556l4c182aaak5d95be36c2ff2e07@mail.gmail.com>
Date: Fri, 14 Nov 2008 13:24:24 +0100
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any DVB-C tuner with working CAM?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1915130838=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1915130838==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0069_01C9465C.4F8F80B0"

This is a multi-part message in MIME format.

------=_NextPart_000_0069_01C9465C.4F8F80B0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Dear Rune,
what is your kernel version? I have the same tuner from the same shop =
but the CAM is Technisat. I cannot replace the CAM provided by my cable =
oprerator because they won't pair their Conax card with the CAM like you =
have for me. :-(
Is it possible that TT 2300-C Premium + Technisat Technicrypt CX =
http://www.technisat.com/index9acb.html?nav=3DCI_modules,en,68-32 can =
have problems with the linux driver?

Regards,
Tomas

  ----- Original Message -----=20
  From: Rune Evjen=20
  To: Tomas Drajsajtl=20
  Cc: linux-dvb@linuxtv.org=20
  Sent: Thursday, November 13, 2008 2:56 PM
  Subject: Re: [linux-dvb] Any DVB-C tuner with working CAM?


  Hi,

  I use the TT 2300-C Premium card with a Conax CAM (rev 1.1) - 4.00e =
and this works fine with my cable provider. The CAM was ordered from =
www.dvb-shop.net along with the DVB-C card.

  Apparently they only ship rev 1.2 ( =
(http://www.dvbshop.net/product_info.php/info/p20_Conax-CAM--Rev--1-2----=
4-00e.html) now which also supports the bitrates of HDTV, but I have not =
tested this CAM, although dvb-shop states that rev 1.2 is compatible as =
well.

  My cable provider is not Technisat, but I guess that if Technisat =
encryption is based on Conax 4.00e then the CAM should be okay.=20

  My configuration works in mythtv and (by recollection) mplayer and =
xine.

  I get the same dmesg output as you for the tt-dvbpci card.



------=_NextPart_000_0069_01C9465C.4F8F80B0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1615" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Dear Rune,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>what is your kernel version? I have the =
same tuner=20
from the same shop but the&nbsp;CAM is Technisat. I cannot replace the =
CAM=20
provided by my cable oprerator because they won't pair their Conax card=20
with&nbsp;the&nbsp;CAM like you have for me. :-(</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Is it possible that TT 2300-C =
Premium&nbsp;+=20
Technisat Technicrypt CX&nbsp;<A=20
href=3D"http://www.technisat.com/index9acb.html?nav=3DCI_modules,en,68-32=
">http://www.technisat.com/index9acb.html?nav=3DCI_modules,en,68-32</A></=
FONT>&nbsp;<FONT=20
face=3DArial size=3D2>can have problems with the linux =
driver?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Regards,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Tomas</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<BLOCKQUOTE=20
style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt arial">----- Original Message ----- </DIV>
  <DIV=20
  style=3D"BACKGROUND: #e4e4e4; FONT: 10pt arial; font-color: =
black"><B>From:</B>=20
  <A title=3Drune.evjen@gmail.com =
href=3D"mailto:rune.evjen@gmail.com">Rune=20
  Evjen</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A =
title=3Dlinux-dvb@drajsajtl.cz=20
  href=3D"mailto:linux-dvb@drajsajtl.cz">Tomas Drajsajtl</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Cc:</B> <A =
title=3Dlinux-dvb@linuxtv.org=20
  href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Thursday, November 13, =
2008 2:56=20
  PM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [linux-dvb] Any =
DVB-C tuner=20
  with working CAM?</DIV>
  <DIV><FONT face=3DArial size=3D2></FONT><FONT face=3DArial=20
  size=3D2></FONT><BR></DIV>Hi,<BR><BR>I use the TT 2300-C Premium card =
with a=20
  Conax CAM (rev 1.1) - 4.00e and this works fine with my cable =
provider. The=20
  CAM was ordered from <A =
href=3D"http://www.dvb-shop.net">www.dvb-shop.net</A>=20
  along with the DVB-C card.<BR><BR>Apparently they only ship rev 1.2 ( =
(<A=20
  =
href=3D"http://www.dvbshop.net/product_info.php/info/p20_Conax-CAM--Rev--=
1-2----4-00e.html"=20
  =
target=3D_blank>http://www.dvbshop.net/product_info.php/info/p20_Conax-<S=
PAN=20
  class=3DnfakPe>CAM</SPAN>--Rev--1-2----4-00e.html</A>) now which also =
supports=20
  the bitrates of HDTV, but I have not tested this CAM, although =
dvb-shop states=20
  that rev 1.2 is compatible as well.<BR><BR>My cable provider is not =
Technisat,=20
  but I guess that if Technisat encryption is based on Conax 4.00e then =
the CAM=20
  should be okay. <BR><BR>My configuration works in mythtv and (by =
recollection)=20
  mplayer and xine.<BR><BR>I get the same dmesg output as you for the =
tt-dvbpci=20
  card.<BR><BR>
  <DIV class=3Dgmail_quote>
  <BLOCKQUOTE class=3Dgmail_quote=20
  style=3D"PADDING-LEFT: 1ex; MARGIN: 0pt 0pt 0pt 0.8ex; BORDER-LEFT: =
rgb(204,204,204) 1px solid"><FONT=20
    face=3DArial =
size=3D2></FONT>&nbsp;</BLOCKQUOTE></DIV></BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_0069_01C9465C.4F8F80B0--



--===============1915130838==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1915130838==--
