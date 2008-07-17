Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n45.bullet.mail.ukl.yahoo.com ([87.248.110.178])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1KJYpy-0006RU-Dy
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 21:08:22 +0200
Date: Thu, 17 Jul 2008 19:07:47 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <168825.3161.qm@web23207.mail.ird.yahoo.com>
Subject: [linux-dvb]  TT S2-3200 driver
Reply-To: newspaperman_germany@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1734423795=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1734423795==
Content-Type: multipart/alternative; boundary="0-2010522484-1216321667=:3161"

--0-2010522484-1216321667=:3161
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thanks very much for your patch. Channel switching is now really much faste=
r (even ondvb-s(1) channels).

Unfortunately transponders with 8PSK 30000-3/4 aren't working correctly. I =
can lock them when choosing a SR of 29998. Still part of the stream is lost=
.. Only 6 Mbit/s of Video data (instead of 12 Mbit/s) and I can only see som=
e pixels.

kind regards

Newsy
--- Ales Jurik <ajurik@quick.cz> schrieb am Do, 17.7.2008:
Von: Ales Jurik <ajurik@quick.cz>
Betreff: [linux-dvb] TT S2-3200 driver
An: linux-dvb@linuxtv.org
Datum: Donnerstag, 17. Juli 2008, 0:23

Hi,

please try attached patch. With this patch I'm able to get lock
 on channels

before it was impossible. But not at all problematic channels and the=20
reception is not without errors. Also it seems to me that channel switching=
 is=20
quicklier.

Within investigating I've found some problems, I've tried to compare
data with=20
data sent by BDA drivers under Windows (by monitoring i2c bus between stb08=
99=20
and stb6100):

- under Windows stb6100 reports not so wide bandwith. (23-31MHz, 21-22MHz a=
nd=20
so on).
- under Windows the gain is set by 1 or 2 higher.

When setting those parameters constantly to values used under Windows nothi=
ng=20
change. So maybe some cooperation with stb0899 part of driver is necessary.=
=20

Also it is interesting that clock speed of i2c bus is 278kHz, not 400kHz=20
(measured with digital oscilloscope). But this should not have any influenc=
e.

Maybe somebody will be so capable to
 continue?

BR,

Ales_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



     =20
Ungl=C3=BCcklich mit Ihrer Mail-Adresse?


Registrieren Sie Ihre Wunschmailadresse@ymail.com



Millionen neuer Mail-Adressen - jetzt bei Yahoo!=0A=0A=0A      ____________=
______________________________________________=0AGesendet von Yahoo! Mail.=
=0ADem pfiffigeren Posteingang.=0Ahttp://de.overview.mail.yahoo.com
--0-2010522484-1216321667=:3161
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D'0' cellpadding=3D'0' border=3D'0' ><tr><td valign=3D'=
top' style=3D'font: inherit;'><blockquote style=3D"border-left: 2px solid r=
gb(16, 16, 255); margin-left: 5px; padding-left: 5px;"><b></b><div id=3D"yi=
v2119002025"><table border=3D"0" cellpadding=3D"0" cellspacing=3D"0"><tbody=
><tr><td style=3D"font-family: inherit; font-style: inherit; font-variant: =
inherit; font-weight: inherit; font-size: inherit; line-height: inherit; fo=
nt-size-adjust: inherit; font-stretch: inherit;" valign=3D"top"><span style=
=3D"font-weight: bold;">T</span>hanks very much for your patch. Channel swi=
tching is now really much faster (even ondvb-s(1) channels).<br><br><font s=
ize=3D"2">Unfortunately transponders with </font><font face=3D"Verdana" siz=
e=3D"2">8PSK 30000-3/4 aren't working correctly. I can lock them when choos=
ing a SR of 29998. Still part of the stream is lost. Only 6 Mbit/s of Video=
 data (instead of 12 Mbit/s) and I can only see some pixels.<br></font><br>=
kind
 regards<br><br>Newsy<br>--- Ales Jurik <i>&lt;ajurik@quick.cz&gt;</i> schr=
ieb am <b>Do, 17.7.2008:<br></b><blockquote style=3D"border-left: 2px solid=
 rgb(16, 16, 255); margin-left: 5px; padding-left: 5px;"><b>Von: Ales Jurik=
 &lt;ajurik@quick.cz&gt;<br>Betreff: [linux-dvb] TT S2-3200 driver<br>An: l=
inux-dvb@linuxtv.org<br>Datum: Donnerstag, 17. Juli 2008, 0:23<br><br></b><=
pre><b>Hi,<br><br>please try attached patch. With this patch I'm able to ge=
t lock<br> on channels<br><br>before it was impossible. But not at all prob=
lematic channels and the <br>reception is not without errors. Also it seems=
 to me that channel switching is <br>quicklier.<br><br>Within investigating=
 I've found some problems, I've tried to compare<br>data with <br>data sent=
 by BDA drivers under Windows (by monitoring i2c bus between stb0899 <br>an=
d stb6100):<br><br>- under Windows stb6100 reports not so wide bandwith. (2=
3-31MHz, 21-22MHz and <br>so on).<br>- under Windows the gain is set
 by 1 or 2 higher.<br><br>When setting those parameters constantly to value=
s used under Windows nothing <br>change. So maybe some cooperation with stb=
0899 part of driver is necessary. <br><br>Also it is interesting that clock=
 speed of i2c bus is 278kHz, not 400kHz <br>(measured with digital oscillos=
cope). But this should not have any influence.<br><br>Maybe somebody will b=
e so capable to<br> continue?<br><br>BR,<br><br>Ales</b></pre><pre><b>_____=
__________________________________________<br>linux-dvb mailing list<br>lin=
ux-dvb@linuxtv.org<br>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux=
-dvb</b></pre></blockquote></td></tr></tbody></table><b><br>


      </b><hr size=3D"1">
<b>Ungl=C3=BCcklich mit Ihrer Mail-Adresse?
<br>
Registrieren Sie Ihre Wunschmailadresse@ymail.com
<br>
<a rel=3D"nofollow" target=3D"_blank" href=3D"http://de.docs.yahoo.com/mail=
/wunschmailadresse/index.html">
Millionen neuer Mail-Adressen - jetzt bei Yahoo!</a></b></div></blockquote>=
</td></tr></table><br>=0A=0A=0A      <hr size=3D1>=0AUngl=C3=BCcklich mit I=
hrer Mail-Adresse?=0A<br>=0ARegistrieren Sie Ihre Wunschmailadresse@ymail.c=
om=0A<br>=0A<a href=3Dhttp://de.docs.yahoo.com/mail/wunschmailadresse/index=
..html target=3D_new>=0AMillionen neuer Mail-Adressen - jetzt bei Yahoo!</a>
--0-2010522484-1216321667=:3161--



--===============1734423795==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1734423795==--
