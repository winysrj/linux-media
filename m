Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KR3DI-0006uu-IW
	for linux-dvb@linuxtv.org; Thu, 07 Aug 2008 12:59:26 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	38CC51801562
	for <linux-dvb@linuxtv.org>; Thu,  7 Aug 2008 10:58:49 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Tim Farrington" <timf@iinet.net.au>, David <dvb-t@iinet.com.au>
Date: Thu, 7 Aug 2008 20:58:49 +1000
Message-Id: <20080807105849.22997BE4078@ws1-9.us4.outblaze.com>
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
Content-Type: multipart/mixed; boundary="===============1101115767=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1101115767==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1218106729181430"

This is a multi-part message in MIME format.

--_----------=_1218106729181430
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Tim, David,



I like top posting, then I don't have to scroll too far for the main=20
information.

The firmware file is incorrect, if it states only 3 firmware images=20
loaded then it is wrong (it should be 80). Here is what that line=20
should read:
[  154.867137] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw=
, type: xc2028 firmware, ver 2.7

Make sure you are using the correct extract script and follow the=20
instructions in the header (script is in the linux/Documentation/video4linu=
x)

Also, the "new" firmware does work in Australia as this is where I=20
live... (Melbourne, and it has been tested against 3 different=20
transmitters here [1 of which is Mt Dandenong], with varying reception leve=
ls.=20
The card has really good sensitivity however it can easily be drowned out i=
f=20
you have an amplifier).

If you still have trouble load the following modules with debug =3D 1:
cx23885
zl10353
tuner_xc2028

Regards,

Stephen.


----Original Message----
Message: 1
Date: Thu, 07 Aug 2008 15:52:15 +0800
From: Tim Farrington <timf@iinet.net.au>
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
        FusionHDTV DVB-T Dual Express
To: David <dvb-t@iinet.com.au>
Cc: patrick.claven@manildra.com.au, linux-dvb@linuxtv.org
Message-ID: <489AA9AF.2060803@iinet.net.au>
Content-Type: text/plain; charset=3DISO-8859-1; format=3Dflowed


The point is that the developers are trying to incorporate Chris's work
into the
main v4l-dvb driver.

Chris's original firmware requirements were:
dvb-usb-bluebird-01.fw xc3028-dvico-au-01.fw dvb-usb-bluebird-02.fw

whereas now it needs:
xc3028-v27.fw

It seems that the "new" firmware doesn't work as of yet for Australia,
for this device.

IIRC, Chris had an "offset" for Australia.

Regards,
Timf

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_1218106729181430
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

<span id=3D"obmessage"><pre>Tim, David,<br><br>I like top posting, then I d=
on't have to scroll too far for the main <br>information.<br><br>The firmwa=
re file is incorrect, if it states only 3 firmware images <br>loaded then i=
t is wrong (it should be 80). Here is what that line <br>should read:<br>[ =
 154.867137] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, =
type: xc2028 firmware, ver 2.7<br><br>Make sure you are using the correct e=
xtract script and follow the <br>instructions in the header (script is in t=
he linux/Documentation/video4linux)<br><br>Also, the "new" firmware does wo=
rk in Australia as this is where I <br>live... (Melbourne, and it has been =
tested against 3 different <br>transmitters here [1 of which is Mt Dandenon=
g], with varying reception levels. <br>The card has really good sensitivity=
 however it can easily be drowned out if <br>you have an amplifier).<br><br=
>If you still have trouble load the following modules with debug =3D 1:<br>=
cx23885<br>zl10353<br>tuner_xc2028<br><br>Regards,<br><br>Stephen.<br><br><=
br>----Original Message----<br>Message: 1<br>Date: Thu, 07 Aug 2008 15:52:1=
5 +0800<br>From: Tim Farrington &lt;<a href=3D"compose.mail?compose=3D1&amp=
;.ob=3D91b1d7a80344cde0ca8699ab10b419c4e6025abb&amp;composeto=3Dtimf%40iine=
t.net.au">timf@iinet.net.au</a>&gt;<br>Subject: Re: [linux-dvb] [PATCH] Add=
 initial support for DViCO<br>	FusionHDTV DVB-T Dual Express<br>To: David &=
lt;<a href=3D"compose.mail?compose=3D1&amp;.ob=3D91b1d7a80344cde0ca8699ab10=
b419c4e6025abb&amp;composeto=3Ddvb-t%40iinet.com.au">dvb-t@iinet.com.au</a>=
&gt;<br>Cc: <a href=3D"compose.mail?compose=3D1&amp;.ob=3D91b1d7a80344cde0c=
a8699ab10b419c4e6025abb&amp;composeto=3Dpatrick.claven%40manildra.com.au">p=
atrick.claven@manildra.com.au</a>, <a href=3D"compose.mail?compose=3D1&amp;=
.ob=3D91b1d7a80344cde0ca8699ab10b419c4e6025abb&amp;composeto=3Dlinux-dvb%40=
linuxtv.org">linux-dvb@linuxtv.org</a><br>Message-ID: &lt;<a href=3D"compos=
e.mail?compose=3D1&amp;.ob=3D91b1d7a80344cde0ca8699ab10b419c4e6025abb&amp;c=
omposeto=3D489AA9AF.2060803%40iinet.net.au">489AA9AF.2060803@iinet.net.au</=
a>&gt;<br>Content-Type: text/plain; charset=3DISO-8859-1; format=3Dflowed<b=
r><br><br>The point is that the developers are trying to incorporate Chris'=
s work<br>into the<br>main v4l-dvb driver.<br><br>Chris's original firmware=
 requirements were:<br>dvb-usb-bluebird-01.fw xc3028-dvico-au-01.fw dvb-usb=
-bluebird-02.fw<br><br>whereas now it needs:<br>xc3028-v27.fw<br><br>It see=
ms that the "new" firmware doesn't work as of yet for Australia,<br>for thi=
s device.<br><br>IIRC, Chris had an "offset" for Australia.<br><br>Regards,=
<br>Timf<br><br><br></pre></span>
<div>

</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_1218106729181430--



--===============1101115767==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1101115767==--
