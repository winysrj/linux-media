Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.icp-qv1-irony-out1.iinet.net.au ([203.59.1.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1LHrhW-00018U-GV
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 04:24:56 +0100
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: sonofzev@iinet.net.au, 'Devin Heitmueller' <devin.heitmueller@gmail.com>
Date: Wed, 31 Dec 2008 12:24:47 +0900
Message-Id: <61079.1230693887@iinet.net.au>
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
Content-Type: multipart/mixed; boundary="===============0952977434=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0952977434==
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

<HTML>
<BR>
<BR>
 <BR>
<BR>
<span style=3D"font-weight: bold;">On Wed Dec 31 13:58 , "Devin Heitmueller=
" <devin.heitmueller@gmail.com> sent:<BR>
<BR>
</devin.heitmueller@gmail.com></span><blockquote style=3D"border-left: 2px =
solid rgb(245, 245, 245); margin-left: 5px; margin-right: 0px; padding-left=
: 5px; padding-right: 0px;">On Tue, Dec 30, 2008 at 9:55 PM, <a href=3D"jav=
ascript:top.opencompose('sonofzev@iinet.net.au','','','')">sonofzev@iinet.n=
et.au</a><BR>

&lt;<a href=3D"javascript:top.opencompose('sonofzev@iinet.net.au','','','')=
">sonofzev@iinet.net.au</a>&gt; wrote:<BR>

&gt; Upgrade to latest hg...<BR>

&gt;<BR>

&gt; Issue is still occurring.<BR>

&gt;<BR>

&gt; I also noticed some other messages in dmesg that I didn't see before t=
hat<BR>

&gt; hopefully may help.<BR>

&gt;<BR>

&gt; cheers<BR>

&gt; Allan<BR>

&gt;<BR>

&gt; Here is the output..<BR>

&gt;<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; zl10353: write to reg 5f failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 71 failed (err =3D -5)!<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 3-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 4)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; zl10353: write to reg 5f failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 71 failed (err =3D -5)!<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 3-0061: Incorrect readback of firmware version.<BR>

&gt; zl10353_read_register: readreg error (reg=3D6, ret=3D=3D-5)<BR>

&gt; zl10353: write to reg 55 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg ea failed (err =3D -5)!<BR>

&gt; zl10353: write to reg ea failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 56 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 5e failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 5c failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 64 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg cc failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 65 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 66 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6c failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6d failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6e failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6f failed (err =3D -5)!<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; zl10353: write to reg 5f failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 71 failed (err =3D -5)!<BR>

&gt; zl10353_read_register: readreg error (reg=3D6, ret=3D=3D-5)<BR>

&gt; zl10353: write to reg 55 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg ea failed (err =3D -5)!<BR>

&gt; zl10353: write to reg ea failed (err =3D -5)!<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 4-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 3-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 4)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; zl10353: write to reg 5f failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 71 failed (err =3D -5)!<BR>

&gt; zl10353_read_register: readreg error (reg=3D6, ret=3D=3D-5)<BR>

&gt; zl10353: write to reg 55 failed (err =3D -5)!<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; zl10353: write to reg ea failed (err =3D -5)!<BR>

&gt; zl10353: write to reg ea failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 56 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 5e failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 5c failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 64 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg cc failed (err =3D -5)!<BR>

&gt; xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; zl10353: write to reg 65 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 66 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6c failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6d failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6e failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6f failed (err =3D -5)!<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; xc2028 3-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; zl10353: write to reg 5f failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 71 failed (err =3D -5)!<BR>

&gt; zl10353_read_register: readreg error (reg=3D6, ret=3D=3D-5)<BR>

&gt; zl10353: write to reg 55 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg ea failed (err =3D -5)!<BR>

&gt; zl10353: write to reg ea failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 56 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 5e failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 5c failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 64 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg cc failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 65 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 66 failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6c failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6d failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6e failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 6f failed (err =3D -5)!<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 3-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 4-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 3-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 4-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 4)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: i2c output error: rc =3D -5 (should be 64)<BR>

&gt; xc2028 4-0061: -5 returned from send<BR>

&gt; xc2028 4-0061: Error -22 while loading base firmware<BR>

&gt; zl10353: write to reg 5f failed (err =3D -5)!<BR>

&gt; zl10353: write to reg 71 failed (err =3D -5)!<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 3-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 4-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 3-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 3-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DD2633 DTV7 (90), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading SCODE for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLI=
NK456<BR>

&gt; SCODE HAS_IF_4760 (620003e0), id 0000000000000000.<BR>

&gt; xc2028 4-0061: Incorrect readback of firmware version.<BR>

&gt; xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

&gt; xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3), id<BR>

&gt; 0000000000000000.<BR>

<BR>

Do me a favor and please stop top posting.  It's a violation of list policy=
.<BR>

<BR>

Were those there before you upgraded to the latest hg?<BR>

<BR>

I suspect that perhaps the components are powered down, which is why<BR>

the i2c calls are failing.  Very strange.<BR>

<BR>

-- <BR>

Devin J. Heitmueller<BR>

<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Fwww.devinheitmueller.com" targe=
t=3D"_blank"><span style=3D"color: red;">http://www.devinheitmueller.com</s=
pan></a><BR>

AIM: devinheitmueller<BR>

)<BR>
<BR>
<BR>
------------------------------------------------------------------<BR>
Hi Devin<BR>
&nbsp;<BR>
<BR>
I did not see the messages before upgrading. However, I cannot confirm if t=
hey weren't there and I suspect they actually were. As the dmesg buffer is =
being constantly overwritten by these errors, and after more recent checks =
these more detailed messages aren't showing up any more.&nbsp; I believe I =
just missed them. <BR>
<BR>
I will also enable the timing messages in my next kernel build but this pro=
bably won't be for a couple of days. If I get a chance before NYE celebrati=
ons tonight I will disable the option in MythTV that releases the adaptors =
when not in use. I don't really need this option as there are no other TV a=
pplications that will access these tuners. I will also check for any powers=
aving options both in the kernel and in the PCIe configuration of the mobo.=
 <BR>
<BR>
<BR>
cheers<BR>
<BR>
Allan<BR>
<BR>
<BR>
<BR>
<BR>
<BR>
&nbsp; <BR>
<BR>
<BR>
<BR>
<BR>
<BR>
<BR>
<BR>

</blockquote></HTML>
<BR>=


--===============0952977434==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0952977434==--
