Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.icp-qv1-irony-out4.iinet.net.au ([203.59.1.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1LHrFW-0005fY-BQ
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 03:56:00 +0100
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: 'Devin Heitmueller' <devin.heitmueller@gmail.com>
Date: Wed, 31 Dec 2008 11:55:48 +0900
Message-Id: <60716.1230692148@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO dual express incorrect readback of firmware
	message (2.6.28 kernel)
Reply-To: sonofzev@iinet.net.au
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1946164541=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1946164541==
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

<HTML>
Upgrade to latest hg...<BR>
<BR>
Issue is still occurring. <BR>
<BR>
I also noticed some other messages in dmesg that I didn't see before that h=
opefully may help. <BR>
<BR>
cheers <BR>
Allan<BR>
<BR>
Here is the output..<BR>
<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
zl10353: write to reg 5f failed (err =3D -5)!<BR>
zl10353: write to reg 71 failed (err =3D -5)!<BR>
xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 3-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 4)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
zl10353: write to reg 5f failed (err =3D -5)!<BR>
zl10353: write to reg 71 failed (err =3D -5)!<BR>
xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 3-0061: Incorrect readback of firmware version.<BR>
zl10353_read_register: readreg error (reg=3D6, ret=3D=3D-5)<BR>
zl10353: write to reg 55 failed (err =3D -5)!<BR>
zl10353: write to reg ea failed (err =3D -5)!<BR>
zl10353: write to reg ea failed (err =3D -5)!<BR>
zl10353: write to reg 56 failed (err =3D -5)!<BR>
zl10353: write to reg 5e failed (err =3D -5)!<BR>
zl10353: write to reg 5c failed (err =3D -5)!<BR>
zl10353: write to reg 64 failed (err =3D -5)!<BR>
zl10353: write to reg cc failed (err =3D -5)!<BR>
zl10353: write to reg 65 failed (err =3D -5)!<BR>
zl10353: write to reg 66 failed (err =3D -5)!<BR>
zl10353: write to reg 6c failed (err =3D -5)!<BR>
zl10353: write to reg 6d failed (err =3D -5)!<BR>
zl10353: write to reg 6e failed (err =3D -5)!<BR>
zl10353: write to reg 6f failed (err =3D -5)!<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
zl10353: write to reg 5f failed (err =3D -5)!<BR>
zl10353: write to reg 71 failed (err =3D -5)!<BR>
zl10353_read_register: readreg error (reg=3D6, ret=3D=3D-5)<BR>
zl10353: write to reg 55 failed (err =3D -5)!<BR>
zl10353: write to reg ea failed (err =3D -5)!<BR>
zl10353: write to reg ea failed (err =3D -5)!<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 4-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 3-0061: Incorrect readback of firmware version.<BR>
xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 4)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
zl10353: write to reg 5f failed (err =3D -5)!<BR>
zl10353: write to reg 71 failed (err =3D -5)!<BR>
zl10353_read_register: readreg error (reg=3D6, ret=3D=3D-5)<BR>
zl10353: write to reg 55 failed (err =3D -5)!<BR>
xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
zl10353: write to reg ea failed (err =3D -5)!<BR>
zl10353: write to reg ea failed (err =3D -5)!<BR>
zl10353: write to reg 56 failed (err =3D -5)!<BR>
zl10353: write to reg 5e failed (err =3D -5)!<BR>
zl10353: write to reg 5c failed (err =3D -5)!<BR>
zl10353: write to reg 64 failed (err =3D -5)!<BR>
zl10353: write to reg cc failed (err =3D -5)!<BR>
xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
zl10353: write to reg 65 failed (err =3D -5)!<BR>
zl10353: write to reg 66 failed (err =3D -5)!<BR>
zl10353: write to reg 6c failed (err =3D -5)!<BR>
zl10353: write to reg 6d failed (err =3D -5)!<BR>
zl10353: write to reg 6e failed (err =3D -5)!<BR>
zl10353: write to reg 6f failed (err =3D -5)!<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
xc2028 3-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
zl10353: write to reg 5f failed (err =3D -5)!<BR>
zl10353: write to reg 71 failed (err =3D -5)!<BR>
zl10353_read_register: readreg error (reg=3D6, ret=3D=3D-5)<BR>
zl10353: write to reg 55 failed (err =3D -5)!<BR>
zl10353: write to reg ea failed (err =3D -5)!<BR>
zl10353: write to reg ea failed (err =3D -5)!<BR>
zl10353: write to reg 56 failed (err =3D -5)!<BR>
zl10353: write to reg 5e failed (err =3D -5)!<BR>
zl10353: write to reg 5c failed (err =3D -5)!<BR>
zl10353: write to reg 64 failed (err =3D -5)!<BR>
zl10353: write to reg cc failed (err =3D -5)!<BR>
zl10353: write to reg 65 failed (err =3D -5)!<BR>
zl10353: write to reg 66 failed (err =3D -5)!<BR>
zl10353: write to reg 6c failed (err =3D -5)!<BR>
zl10353: write to reg 6d failed (err =3D -5)!<BR>
zl10353: write to reg 6e failed (err =3D -5)!<BR>
zl10353: write to reg 6f failed (err =3D -5)!<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 3-0061: Incorrect readback of firmware version.<BR>
xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 4-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 3-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 4-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 4)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>
xc2028 4-0061: -5 returned from send<BR>
xc2028 4-0061: Error -22 while loading base firmware<BR>
zl10353: write to reg 5f failed (err =3D -5)!<BR>
zl10353: write to reg 71 failed (err =3D -5)!<BR>
xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 3-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 4-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 3-0061: Incorrect readback of firmware version.<BR>
xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id 000000000000=
0000.<BR>
xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456=
 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>
xc2028 4-0061: Incorrect readback of firmware version.<BR>
xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id 0000000000000=
000.<BR>
<BR>
<BR>
 <BR>
<BR>
<span style=3D"font-weight: bold;">On Wed Dec 31 12:16 , "Devin Heitmueller=
" <devin.heitmueller@gmail.com> sent:<BR>
<BR>
</devin.heitmueller@gmail.com></span><blockquote style=3D"border-left: 2px =
solid rgb(245, 245, 245); margin-left: 5px; margin-right: 0px; padding-left=
: 5px; padding-right: 0px;">On Tue, Dec 30, 2008 at 8:14 PM, <a href=3D"jav=
ascript:top.opencompose('sonofzev@iinet.net.au','','','')">sonofzev@iinet.n=
et.au</a><BR>

&lt;<a href=3D"javascript:top.opencompose('sonofzev@iinet.net.au','','','')=
">sonofzev@iinet.net.au</a>&gt; wrote:<BR>

&gt;<BR>

&gt; oops.. didn't finish the last sentence.. at the time I checked dmesg t=
his<BR>

&gt; morning, it was displaying this behaviour but nothing was being record=
ed or<BR>

&gt; watched at that moment in time.<BR>

&gt;<BR>

&gt; In the short term is this something that might be worked around by goi=
ng<BR>

&gt; back to hg drivers, or would you prefer I stick with the in-kernel one=
s, to<BR>

&gt; help work out what is happening.<BR>

<BR>

Are you saying you upgrade to 2.6.28 from the hg?  I would be very<BR>

surprised if this issue wasn't in the latest hg as well.<BR>

<BR>

I would upgrade to the latest hg, and then debug it from there.<BR>

<BR>

Devin<BR>

<BR>

-- <BR>

Devin J. Heitmueller<BR>

<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Fwww.devinheitmueller.com" targe=
t=3D"_blank"><span style=3D"color: red;">http://www.devinheitmueller.com</s=
pan></a><BR>

AIM: devinheitmueller<BR>

</blockquote></HTML>
<BR>=


--===============1946164541==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1946164541==--
