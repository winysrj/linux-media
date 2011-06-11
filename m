Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <reality_es@yahoo.es>) id 1QVJtH-00010s-18
	for linux-dvb@linuxtv.org; Sat, 11 Jun 2011 10:49:59 +0200
Received: from nm9.bullet.mail.ird.yahoo.com ([77.238.189.35])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with smtp
	for <linux-dvb@linuxtv.org>
	id 1QVJtG-0002oa-Hs; Sat, 11 Jun 2011 10:49:58 +0200
Message-ID: <354345.80583.qm@web24108.mail.ird.yahoo.com>
References: <mailman.0.1307781263.2460.linux-dvb@linuxtv.org> 
Date: Sat, 11 Jun 2011 09:49:57 +0100 (BST)
From: Lopez Lopez <reality_es@yahoo.es>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1510961206-1307782197=:80583"
Subject: Re: [linux-dvb] sveon stv22 af9015 support
Reply-To: linux-media@vger.kernel.org, Lopez Lopez <reality_es@yahoo.es>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--0-1510961206-1307782197=:80583
Content-Type: multipart/alternative; boundary="0-2037000963-1307782197=:80583"

--0-2037000963-1307782197=:80583
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

=0A=0A=0A=0A________________________________=0ADe: Lopez Lopez <reality_es@=
yahoo.es>=0APara: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>=0AEnviado=
: s=E1bado 11 de junio de 2011 10:46=0AAsunto: sveon stv22 af9015 support=
=0A=0A=0AHello to EveryBody:=0A=0AI have patched af9015.c and dvb-usb-ids t=
o support sveon stv22 ( KWorld USB Dual DVB-T TV Stick (DVB-T 399U)=A0 clon=
e ) dual with=0A-----=0A#define USB_PID_SVEON_STV22=A0=A0=A0 =A0=A0=A0 =A0=
=A0=A0 =A0=A0=A0 0xe401=0A------=0A=A0in dvb-usb-ids.h file =0A=0Aand =0A--=
---=0A/* 30 */{USB_DEVICE(USB_VID_KWORLD_2,=A0 USB_PID_KWORLD_UB383_T)},=0A=
=A0=A0=A0 {USB_DEVICE(USB_VID_KWORLD_2,=A0=0A USB_PID_KWORLD_395U_4)},=0A=
=A0=A0=A0 {USB_DEVICE(USB_VID_KWORLD_2,=A0 USB_PID_SVEON_STV22)},=0A=A0=A0=
=A0 {0},=0A};=0A=0A------=0A{=0A=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 .na=
me =3D "Sveon STV22 Dual USB DVB-T Tuner HDTV ",=0A=A0=A0=A0 =A0=A0=A0 =A0=
=A0=A0 =A0=A0=A0 .cold_ids =3D {&af9015_usb_table[32], NULL},=0A=A0=A0=A0 =
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 .warm_ids =3D {NULL},=0A=A0=A0=A0 =A0=A0=A0 =
=A0=A0=A0 },=0A=0A-----=0A=0Ain af9015.c file=0A=0Ai expect to help you ext=
ends linux dvb usb support.=0A=0Athanks for your time=0A=0ADavid
--0-2037000963-1307782197=:80583
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:ti=
mes new roman, new york, times, serif;font-size:12pt"><div><span></span></d=
iv><div><br></div><div style=3D"font-family: times new roman, new york, tim=
es, serif; font-size: 12pt;"><div style=3D"font-family: times new roman, ne=
w york, times, serif; font-size: 12pt;"><font size=3D"2" face=3D"Arial"><hr=
 size=3D"1"><b><span style=3D"font-weight:bold;">De:</span></b> Lopez Lopez=
 &lt;reality_es@yahoo.es&gt;<br><b><span style=3D"font-weight: bold;">Para:=
</span></b> "linux-dvb@linuxtv.org" &lt;linux-dvb@linuxtv.org&gt;<br><b><sp=
an style=3D"font-weight: bold;">Enviado:</span></b> s=E1bado 11 de junio de=
 2011 10:46<br><b><span style=3D"font-weight: bold;">Asunto:</span></b> sve=
on stv22 af9015 support<br></font><br><div id=3D"yiv1382135425"><div style=
=3D"color:#000;background-color:#fff;font-family:times new roman, new york,=
 times, serif;font-size:12pt;"><div style=3D"font-family:times new roman, n=
ew york, times,
 serif;font-size:12pt;">Hello to EveryBody:<br><br>I have patched af9015.c =
and dvb-usb-ids to support sveon stv22 ( <a rel=3D"nofollow" target=3D"_bla=
nk" href=3D"http://www.linuxtv.org/wiki/index.php/KWorld" title=3D"KWorld">=
KWorld</a> <a rel=3D"nofollow" target=3D"_blank" href=3D"http://www.linuxtv=
.org/wiki/index.php/KWorld_USB_Dual_DVB-T_TV_Stick_%28DVB-T_399U%29" title=
=3D"KWorld USB Dual DVB-T TV Stick (DVB-T 399U)">USB Dual DVB-T TV Stick (D=
VB-T 399U)</a>&nbsp; clone ) dual with<br>-----<br>#define USB_PID_SVEON_ST=
V22&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nb=
sp; 0xe401<span style=3D"font-weight:bold;"><br>------<br>&nbsp;in dvb-usb-=
ids.h file <br><br>and <br>-----<br>/* 30 */{USB_DEVICE(USB_VID_KWORLD_2,&n=
bsp; USB_PID_KWORLD_UB383_T)},<br>&nbsp;&nbsp;&nbsp; {USB_DEVICE(USB_VID_KW=
ORLD_2,&nbsp;=0A USB_PID_KWORLD_395U_4)},<br>&nbsp;&nbsp;&nbsp; {USB_DEVICE=
(USB_VID_KWORLD_2,&nbsp; USB_PID_SVEON_STV22)},<br>&nbsp;&nbsp;&nbsp; {0},<=
br>};<br><br>------<br>{<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nb=
sp;&nbsp; &nbsp;&nbsp;&nbsp; .name =3D "Sveon STV22 Dual USB DVB-T Tuner HD=
TV ",<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nb=
sp;&nbsp; .cold_ids =3D {&amp;af9015_usb_table[32], NULL},<br>&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .warm_ids =
=3D {NULL},<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; },<=
br><br>-----<br><br>in af9015.c file<br><br>i expect to help you extends li=
nux dvb usb support.<br><br>thanks for your time<br><br>David<br><br><br></=
span></div></div></div><br><br></div></div></div></body></html>
--0-2037000963-1307782197=:80583--

--0-1510961206-1307782197=:80583
Content-Type: text/plain; name="af9015.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="af9015.c"

SW50eExOSwEuAC4ALwBsAGkAbgB1AHgALwBkAHIAaQB2AGUAcgBzAC8AbQBl
AGQAaQBhAC8AZAB2AGIALwBkAHYAYgAtAHUAcwBiAC8AYQBmADkAMAAxADUA
LgBjAA==

--0-1510961206-1307782197=:80583
Content-Type: text/plain; name="dvb-usb-ids.h"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dvb-usb-ids.h"

SW50eExOSwEuAC4ALwBsAGkAbgB1AHgALwBkAHIAaQB2AGUAcgBzAC8AbQBl
AGQAaQBhAC8AZAB2AGIALwBkAHYAYgAtAHUAcwBiAC8AZAB2AGIALQB1AHMA
YgAtAGkAZABzAC4AaAA=

--0-1510961206-1307782197=:80583
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--0-1510961206-1307782197=:80583--
