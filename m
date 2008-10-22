Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <fnagato@gmail.com>) id 1KsdDN-00061G-79
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 14:53:39 +0200
Received: by yx-out-2324.google.com with SMTP id 8so588791yxg.41
	for <linux-dvb@linuxtv.org>; Wed, 22 Oct 2008 05:51:54 -0700 (PDT)
Message-ID: <1F2104E0FBD146A092E4CD3644D46282@Nagasoft>
From: "Felippe Nagato" <fnagato@gmail.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 22 Oct 2008 10:51:41 -0300
MIME-Version: 1.0
Subject: [linux-dvb] dsmcc-mhp-tools - npt stream
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0409803947=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0409803947==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0086_01C93434.2ACFE060"

This is a multi-part message in MIME format.

------=_NextPart_000_0086_01C93434.2ACFE060
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

hi,

in dsmcc-mhp-tools source code, when i generate a npt stream, the =
descriptor tag used is 0x17. but iso13818-6 says that npt reference =
descriptor should be 0x01. does anybody know the reason to this? am i =
saying something wrong?

another question: i generated a npt stream with zero in numerator and =
any number in denominator. it means that the stream is "paused". but =
when i open the stream in a hex viewer, i see that the npt reference =
field is still being incremented. is it correct? in my opinion, this =
field should be freezed with some value while the scale =
numerador/denominator is 0/1, for example.

im not sure if im posting this thread in the correct topic...

thanks!
------=_NextPart_000_0086_01C93434.2ACFE060
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.6000.16386" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>hi,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>in dsmcc-mhp-tools&nbsp;source code, =
when i=20
generate a&nbsp;npt stream, the descriptor tag used is 0x17. =
but&nbsp;iso13818-6=20
says that npt reference descriptor&nbsp;should be&nbsp;0x01. does =
anybody know=20
the reason to this? am i&nbsp;saying something wrong?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>another question: i generated =
a&nbsp;npt stream=20
with&nbsp;zero in numerator and any number in denominator. it means that =
the=20
stream is "paused". but when i open the stream in a hex viewer, i see =
that the=20
npt reference field is still being incremented. is it correct? in my =
opinion,=20
this field should be freezed with some value while the scale=20
numerador/denominator is 0/1, for example.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>
<DIV><FONT face=3DArial size=3D2>im not sure if im posting this thread =
in the=20
correct topic...</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV>thanks!</DIV></FONT></DIV></BODY></HTML>

------=_NextPart_000_0086_01C93434.2ACFE060--



--===============0409803947==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0409803947==--
