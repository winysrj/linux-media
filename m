Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <silvercordiagsr@hotmail.com>) id 1QNJ4s-0006v3-R8
	for linux-dvb@linuxtv.org; Fri, 20 May 2011 08:20:51 +0200
Received: from snt0-omc2-s30.snt0.hotmail.com ([65.55.90.105])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1QNJ4s-00012J-Ea; Fri, 20 May 2011 08:20:50 +0200
Message-ID: <SNT124-W4826814BFEF35D02DDBB99AC710@phx.gbl>
From: Nicholas Leahy <silvercordiagsr@hotmail.com>
To: <linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
Date: Fri, 20 May 2011 16:20:46 +1000
In-Reply-To: <1305838128.4dd582301742e@imp.free.fr>
References: <1305838128.4dd582301742e@imp.free.fr>
MIME-Version: 1.0
Subject: Re: [linux-dvb] AverMedia A306 (cx23385, xc3028,
 af9013) (A577 too ?)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0572381941=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============0572381941==
Content-Type: multipart/alternative;
	boundary="_0c59f756-80f7-496e-94e5-f6fd6c3dfa5d_"

--_0c59f756-80f7-496e-94e5-f6fd6c3dfa5d_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hi Wallak=20
How do you see the chips on the I2C bus? I have been trying to get a DiVCO =
card to work (it uses the same CX23885)=20
I dont get the following parts
CX23885_BOARD_AVERMEDIA_A306:> + // ?? PIO0: 1:on 0:nothing work> + // ?? P=
IO1: demodulator address 1: 0x1c=2C 0:0x1d ??> + // ?? PIO2: tuner reset ?>=
 + // ?? PIO3: demodulator reset ?> + printk(KERN_INFO "gpio...\n")=3B


and GPIO stuff



Cheers Nick
=20
> Date: Thu=2C 19 May 2011 22:48:48 +0200
> From: wallak@free.fr
> To: linux-dvb@linuxtv.org
> Subject: [linux-dvb] AverMedia A306 (cx23385=2C xc3028=2C af9013) (A577 t=
oo ?)
>=20
> Hello All=2C
>=20
> I've tried to use my A306 board on my system. All the main chips are full=
y
> supported by linux.
>=20
> At this stage the CX23385 and the tuner: xc3028 seem to respond properly.=
 But
> the DVB-T chip (af9013) is silent. Nevertheless both chips are visible on=
 the
> I2C bus.
>=20
> I've no full datasheet of theses chips. with exception of the af9013 wher=
e this
> information is available:
> http://wenku.baidu.com/view/42240f72f242336c1eb95e08.html
>=20
> At this stage the CLK signal of the DVB-T chip may be missing or somethin=
g is
> wrong elsewhere.
>=20

> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development=2C please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
 		 	   		  =

--_0c59f756-80f7-496e-94e5-f6fd6c3dfa5d_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Tahoma
}
--></style>
</head>
<body class=3D'hmmessage'>
Hi Wallak <BR>
<DIV><FONT class=3DApple-style-span face=3DTahoma size=3D2>How do you see t=
he chips on the I2C bus? I have been trying to get a DiVCO card to work (it=
 uses the same CX23885)</FONT>=20
<DIV><FONT class=3DApple-style-span face=3DTahoma size=3D2>I dont get the&n=
bsp=3Bfollowing&nbsp=3Bparts</FONT></DIV>
<DIV style=3D"FONT-SIZE: 10pt=3B FONT-FAMILY: Tahoma">CX23885_BOARD_AVERMED=
IA_A306:<BR style=3D"TEXT-INDENT: 0px! important">&gt=3B + // ?? PIO0: 1:on=
 0:nothing work<BR style=3D"TEXT-INDENT: 0px! important">&gt=3B + // ?? PIO=
1: demodulator address 1: 0x1c=2C 0:0x1d ??<BR style=3D"TEXT-INDENT: 0px! i=
mportant">&gt=3B + // ?? PIO2: tuner reset ?<BR style=3D"TEXT-INDENT: 0px! =
important">&gt=3B + // ?? PIO3: demodulator reset ?<BR style=3D"TEXT-INDENT=
: 0px! important">&gt=3B + printk(KERN_INFO "gpio...\n")=3B</DIV>
<DIV style=3D"FONT-SIZE: 10pt=3B FONT-FAMILY: Tahoma"><BR></DIV>
<DIV style=3D"FONT-SIZE: 10pt=3B FONT-FAMILY: Tahoma">and GPIO stuff<BR>
<DIV><BR></DIV>
<DIV>Cheers Nick</DIV><BR>&nbsp=3B</DIV></DIV>
&gt=3B Date: Thu=2C 19 May 2011 22:48:48 +0200<BR>&gt=3B From: wallak@free.=
fr<BR>&gt=3B To: linux-dvb@linuxtv.org<BR>&gt=3B Subject: [linux-dvb] AverM=
edia A306 (cx23385=2C xc3028=2C af9013) (A577 too ?)<BR>&gt=3B <BR>&gt=3B H=
ello All=2C<BR>&gt=3B <BR>&gt=3B I've tried to use my A306 board on my syst=
em. All the main chips are fully<BR>&gt=3B supported by linux.<BR>&gt=3B <B=
R>&gt=3B At this stage the CX23385 and the tuner: xc3028 seem to respond pr=
operly. But<BR>&gt=3B the DVB-T chip (af9013) is silent. Nevertheless both =
chips are visible on the<BR>&gt=3B I2C bus.<BR>&gt=3B <BR>&gt=3B I've no fu=
ll datasheet of theses chips. with exception of the af9013 where this<BR>&g=
t=3B information is available:<BR>&gt=3B http://wenku.baidu.com/view/42240f=
72f242336c1eb95e08.html<BR>&gt=3B <BR>&gt=3B At this stage the CLK signal o=
f the DVB-T chip may be missing or something is<BR>&gt=3B wrong elsewhere.<=
BR>&gt=3B <BR><BR>&gt=3B _______________________________________________<BR=
>&gt=3B linux-dvb users mailing list<BR>&gt=3B For V4L/DVB development=2C p=
lease use instead linux-media@vger.kernel.org<BR>&gt=3B linux-dvb@linuxtv.o=
rg<BR>&gt=3B http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb<BR> =
		 	   		  </body>
</html>=

--_0c59f756-80f7-496e-94e5-f6fd6c3dfa5d_--


--===============0572381941==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0572381941==--
