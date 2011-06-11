Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <reality_es@yahoo.es>) id 1QVJpa-0000rs-83
	for linux-dvb@linuxtv.org; Sat, 11 Jun 2011 10:46:35 +0200
Received: from nm8.bullet.mail.ird.yahoo.com ([77.238.189.23])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-1) with smtp
	for <linux-dvb@linuxtv.org>
	id 1QVJpZ-0001eb-Lu; Sat, 11 Jun 2011 10:46:10 +0200
Message-ID: <344579.53969.qm@web24105.mail.ird.yahoo.com>
References: <mailman.0.1307781263.2460.linux-dvb@linuxtv.org>
Date: Sat, 11 Jun 2011 09:46:08 +0100 (BST)
From: Lopez Lopez <reality_es@yahoo.es>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <mailman.0.1307781263.2460.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] sveon stv22 af9015 support
Reply-To: linux-media@vger.kernel.org, Lopez Lopez <reality_es@yahoo.es>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0411734230=="
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============0411734230==
Content-Type: multipart/alternative; boundary="0-434008300-1307781968=:53969"

--0-434008300-1307781968=:53969
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hello to EveryBody:=0A=0AI have patched af9015.c and dvb-usb-ids to support=
 sveon stv22 ( KWorld USB Dual DVB-T TV Stick (DVB-T 399U)=A0 clone ) dual =
with=0A-----=0A#define USB_PID_SVEON_STV22=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=
=A0=A0 0xe401=0A------=0A=A0in dvb-usb-ids.h file =0A=0Aand =0A-----=0A/* 3=
0 */{USB_DEVICE(USB_VID_KWORLD_2,=A0 USB_PID_KWORLD_UB383_T)},=0A=A0=A0=A0 =
{USB_DEVICE(USB_VID_KWORLD_2,=A0 USB_PID_KWORLD_395U_4)},=0A=A0=A0=A0 {USB_=
DEVICE(USB_VID_KWORLD_2,=A0 USB_PID_SVEON_STV22)},=0A=A0=A0=A0 {0},=0A};=0A=
=0A------=0A{=0A=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 .name =3D "Sveon ST=
V22 Dual USB DVB-T Tuner HDTV ",=0A=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =
.cold_ids =3D {&af9015_usb_table[32], NULL},=0A=A0=A0=A0 =A0=A0=A0 =A0=A0=
=A0 =A0=A0=A0 .warm_ids =3D {NULL},=0A=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 },=0A=
=0A-----=0A=0Ain af9015.c=0A=0Ai expect to help you to extends linux dvb us=
b support.=0A=0Athanks for your time=0A=0ADavid
--0-434008300-1307781968=:53969
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:ti=
mes new roman, new york, times, serif;font-size:12pt"><div style=3D"font-fa=
mily: times new roman, new york, times, serif; font-size: 12pt;">Hello to E=
veryBody:<br><br>I have patched af9015.c and dvb-usb-ids to support sveon s=
tv22 ( <a href=3D"http://www.linuxtv.org/wiki/index.php/KWorld" title=3D"KW=
orld">KWorld</a> <a href=3D"http://www.linuxtv.org/wiki/index.php/KWorld_US=
B_Dual_DVB-T_TV_Stick_%28DVB-T_399U%29" title=3D"KWorld USB Dual DVB-T TV S=
tick (DVB-T 399U)">USB Dual DVB-T TV Stick (DVB-T 399U)</a>&nbsp; clone ) d=
ual with<br>-----<br>#define USB_PID_SVEON_STV22&nbsp;&nbsp;&nbsp; &nbsp;&n=
bsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 0xe401<span style=3D"font-=
weight: bold;"><br>------<br>&nbsp;in dvb-usb-ids.h file <br><br>and <br>--=
---<br>/* 30 */{USB_DEVICE(USB_VID_KWORLD_2,&nbsp; USB_PID_KWORLD_UB383_T)}=
,<br>&nbsp;&nbsp;&nbsp; {USB_DEVICE(USB_VID_KWORLD_2,&nbsp;
 USB_PID_KWORLD_395U_4)},<br>&nbsp;&nbsp;&nbsp; {USB_DEVICE(USB_VID_KWORLD_=
2,&nbsp; USB_PID_SVEON_STV22)},<br>&nbsp;&nbsp;&nbsp; {0},<br>};<br><br>---=
---<br>{<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;=
&nbsp;&nbsp; .name =3D "Sveon STV22 Dual USB DVB-T Tuner HDTV ",<br>&nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .cold_=
ids =3D {&amp;af9015_usb_table[32], NULL},<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbs=
p;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .warm_ids =3D {NULL},<br>&nb=
sp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; },<br><br>-----<br><b=
r>in af9015.c<br><br>i expect to help you to extends linux dvb usb support.=
<br><br>thanks for your time<br><br>David<br><br><br></span></div></div></b=
ody></html>
--0-434008300-1307781968=:53969--


--===============0411734230==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0411734230==--
