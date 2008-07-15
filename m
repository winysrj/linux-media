Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n31.bullet.mail.ukl.yahoo.com ([87.248.110.148])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1KIj4p-0005eh-TC
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 13:52:16 +0200
Date: Tue, 15 Jul 2008 11:51:41 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <20080715113658.720efc2d@bk.ru>
MIME-Version: 1.0
Message-ID: <850923.73195.qm@web23203.mail.ird.yahoo.com>
Subject: [linux-dvb]  problems with multiproto & dvb-s2 with high SR,
	losing parts of stream (TT S2-3200)
Reply-To: newspaperman_germany@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0196409135=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0196409135==
Content-Type: multipart/alternative; boundary="0-2003642994-1216122701=:73195"

--0-2003642994-1216122701=:73195
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

anyone knows about a similar solution like settings legacy=3D0 for TT s2-32=
00?
I'm getting only half of the video rates Goga777 gets.

regards

Newsy

--- Goga777 <goga777@bk.ru> schrieb am Di, 15.7.2008:
Von: Goga777 <goga777@bk.ru>
Betreff: Re: [linux-dvb] Re : Re : problems with multiproto & dvb-s2 with h=
igh SR, losing parts of stream
An: newspaperman_germany@yahoo.com
Datum: Dienstag, 15. Juli 2008, 9:36

> with femon I can see that data rates. Which datarate can you see at 12130=
 H
30000 3/4 "TV 4"? (Not the on on 11341 V
> 25000 3/4, this one is working fine) Me getting only 5 Mbit/s at 12130 H
although the channel has about 12 Mbit/s.

do you mean video/audio bitrate ?

well for History HD - video bitrate is - 17 Mbit/s , audio - 245-258 kbit/s
for Silver HD - 14 and 258
for TV4 HD - videobitrate - 16 Mbit/s , audio bitrate - is 0 kbit/s - it's
strange I don't unsderstand why audio is 0

so, I don't have official card I can't open this channels


> how can you set " (cx24116 demod with legacy=3D0 option)"?

it's only for cx24116 based cards - hvr4000, Nova HD ... !!!

modprobe cx24116 legacy=3D0



>=20
> regards=20
>=20
> Newsy
> --- Goga777 <goga777@bk.ru> schrieb am Mo, 14.7.2008:
> Von: Goga777 <goga777@bk.ru>
> Betreff: Re: [linux-dvb] Re : Re : problems with multiproto & dvb-s2
with high SR, losing parts of stream
> An: linux-dvb@linuxtv.org
> Datum: Montag, 14. Juli 2008, 22:14
>=20
> > > > And you could retrieve the stream with no problemn even
watch it?
> > >=20
> > > do you mean H264/ffmpeg decoding problem ? Ah, I can't open
these
> > > encrypted channels=20
> >=20
> > Is it a card problem? I mean my TT-3200 has problems to tune on some=20
> > channels, but when it tunes the CI/CAM works perfectly (here almost=20
> > every channel is encrypted). Does HVR-4000 has a good CI?
>=20
> I don't have the card, that's why I can't open these channels.
We
> have spoken about LOCK :)
>=20
> Goga
>=20
>=20
>=20
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>=20
>=20
>       __________________________________________________________
> Gesendet von Yahoo! Mail.
> Dem pfiffigeren Posteingang.
> http://de.overview.mail.yahoo.com


--=20
=D0=A3=D0=B4=D0=B0=D1=87=D0=B8,
=D0=98=D0=B3=D0=BE=D1=80=D1=8C=0A=0A=0A      ______________________________=
____________________________=0AGesendet von Yahoo! Mail.=0ADem pfiffigeren =
Posteingang.=0Ahttp://de.overview.mail.yahoo.com
--0-2003642994-1216122701=:73195
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D'0' cellpadding=3D'0' border=3D'0' ><tr><td valign=3D'=
top' style=3D'font: inherit;'>anyone knows about a similar solution like se=
ttings legacy=3D0 for TT s2-3200?<br>I'm getting only half of the video rat=
es Goga777 gets.<br><br>regards<br><br>Newsy<br><br>--- Goga777 <i>&lt;goga=
777@bk.ru&gt;</i> schrieb am <b>Di, 15.7.2008:<br></b><blockquote style=3D"=
border-left: 2px solid rgb(16, 16, 255); margin-left: 5px; padding-left: 5p=
x;"><b>Von: Goga777 &lt;goga777@bk.ru&gt;<br>Betreff: Re: [linux-dvb] Re : =
Re : problems with multiproto &amp; dvb-s2 with high SR, losing parts of st=
ream<br>An: newspaperman_germany@yahoo.com<br>Datum: Dienstag, 15. Juli 200=
8, 9:36<br><br></b><pre><b>&gt; with femon I can see that data rates. Which=
 datarate can you see at 12130 H<br>30000 3/4 "TV 4"? (Not the on on 11341 =
V<br>&gt; 25000 3/4, this one is working fine) Me getting only 5 Mbit/s at =
12130 H<br>although the channel has about 12 Mbit/s.<br><br>do you mean
 video/audio bitrate ?<br><br>well for History HD - video bitrate is - 17 M=
bit/s , audio - 245-258 kbit/s<br>for Silver HD - 14 and 258<br>for TV4 HD =
- videobitrate - 16 Mbit/s , audio bitrate - is 0 kbit/s - it's<br>strange =
I don't unsderstand why audio is 0<br><br>so, I don't have official card I =
can't open this channels<br><br><br>&gt; how can you set " (cx24116 demod w=
ith legacy=3D0 option)"?<br><br>it's only for cx24116 based cards - hvr4000=
, Nova HD ... !!!<br><br>modprobe cx24116 legacy=3D0<br><br><br><br>&gt; <b=
r>&gt; regards <br>&gt; <br>&gt; Newsy<br>&gt; --- Goga777 &lt;goga777@bk.r=
u&gt; schrieb am Mo, 14.7.2008:<br>&gt; Von: Goga777 &lt;goga777@bk.ru&gt;<=
br>&gt; Betreff: Re: [linux-dvb] Re : Re : problems with multiproto &amp; d=
vb-s2<br>with high SR, losing parts of stream<br>&gt; An: linux-dvb@linuxtv=
..org<br>&gt; Datum: Montag, 14. Juli 2008, 22:14<br>&gt; <br>&gt; &gt; &gt;=
 &gt; And you could retrieve the stream with no problemn even<br>watch
 it?<br>&gt; &gt; &gt; <br>&gt; &gt; &gt; do you mean H264/ffmpeg decoding =
problem ? Ah, I can't open<br>these<br>&gt; &gt; &gt; encrypted channels <b=
r>&gt; &gt; <br>&gt; &gt; Is it a card problem? I mean my TT-3200 has probl=
ems to tune on some <br>&gt; &gt; channels, but when it tunes the CI/CAM wo=
rks perfectly (here almost <br>&gt; &gt; every channel is encrypted). Does =
HVR-4000 has a good CI?<br>&gt; <br>&gt; I don't have the card, that's why =
I can't open these channels.<br>We<br>&gt; have spoken about LOCK :)<br>&gt=
; <br>&gt; Goga<br>&gt; <br>&gt; <br>&gt; <br>&gt; ________________________=
_______________________<br>&gt; linux-dvb mailing list<br>&gt; linux-dvb@li=
nuxtv.org<br>&gt; http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=
<br>&gt; <br>&gt; <br>&gt;       __________________________________________=
________________<br>&gt; Gesendet von Yahoo! Mail.<br>&gt; Dem pfiffigeren =
Posteingang.<br>&gt; http://de.overview.mail.yahoo.com<br><br><br>--
 <br>=D0=A3=D0=B4=D0=B0=D1=87=D0=B8,<br>=D0=98=D0=B3=D0=BE=D1=80=D1=8C</b><=
/pre></blockquote></td></tr></table><br>=0A=0A=0A=0A      <hr size=3D1>=0AG=
esendet von <a  =0Ahref=3D"http://us.rd.yahoo.com/mailuk/taglines/isp/contr=
ol/*http://us.rd.yahoo.com/evt=3D52427/*http://de.overview.mail.yahoo.com" =
target=3D_blank>Yahoo! Mail</a>.=0A<br>=0ADem pfiffigeren Posteingang.
--0-2003642994-1216122701=:73195--



--===============0196409135==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0196409135==--
