Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRTeH-00020p-H0
	for linux-dvb@linuxtv.org; Mon, 26 Jan 2009 16:45:18 +0100
Received: by qyk9 with SMTP id 9so6516972qyk.17
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 07:44:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>
	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>
Date: Mon, 26 Jan 2009 17:44:41 +0200
Message-ID: <c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
From: Alex Betis <alex.betis@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on
	HDchannels
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1739751241=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1739751241==
Content-Type: multipart/alternative; boundary=0015175cba7af3a28d0461649d1e

--0015175cba7af3a28d0461649d1e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Mon, Jan 26, 2009 at 5:41 PM, Chris Silva <2manybills@gmail.com> wrote:

> On Mon, Jan 26, 2009 at 2:40 PM, Newsy Paper
> <newspaperman_germany@yahoo.com> wrote:
> > the transponders you don't get lock are problem transponders of s2-3200.
> > The driver is still not able to lock on dvb-s2 30000 3/4 transponders :(
> >
> > Which software do you use to play HD content?
> > you need either xine-lib 1.2 with external ffmpeg (recent developer's
> version).
> > or xine-vdpau (if you have a NVIDIA graka that supports h264 hw
> acceleration).
> >
> > regards
> >
> > Newsy
>
> I can confirm this. I use S30W (Hispasat) and one of the providers,
> Meo, broadcasts everything on DVB-S2 30000 3/4.
> I can't get a lock on any of the transponders/channels. And to make
> matters worse, not even scan-s2 can get a really usable channel list.
> I had to build the list by hand, according to
> http://pt.kingofsat.net/pack-meo.php page.
>
> And it still doesn't work.
>
> I use vdr-xine and xineliboutput with vdr 1.7.0 and up, plus
> xine-vdpau to no avail.
>
> What's the point of having a DVB-S2 card if we can't tune to those
> channels? What's missing in the S2-3200 drivers?

What drivers do you use?
I saw that Igor did some changes in his repository to lock on high SR
channels.


>
>
> Chris
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--0015175cba7af3a28d0461649d1e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Mon, Jan 26, 2009 at 5:41 PM=
, Chris Silva <span dir=3D"ltr">&lt;<a href=3D"mailto:2manybills@gmail.com"=
>2manybills@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">On Mon, Jan 26, 2009 at 2:40 PM,=
 Newsy Paper<br>&lt;<a href=3D"mailto:newspaperman_germany@yahoo.com">newsp=
aperman_germany@yahoo.com</a>&gt; wrote:<br>
&gt; the transponders you don&#39;t get lock are problem transponders of s2=
-3200.<br>&gt; The driver is still not able to lock on dvb-s2 30000 3/4 tra=
nsponders :(<br>&gt;<br>&gt; Which software do you use to play HD content?<=
br>
&gt; you need either xine-lib 1.2 with external ffmpeg (recent developer&#3=
9;s version).<br>&gt; or xine-vdpau (if you have a NVIDIA graka that suppor=
ts h264 hw acceleration).<br>&gt;<br>&gt; regards<br>&gt;<br>&gt; Newsy<br>
<br>I can confirm this. I use S30W (Hispasat) and one of the providers,<br>=
Meo, broadcasts everything on DVB-S2 30000 3/4.<br>I can&#39;t get a lock o=
n any of the transponders/channels. And to make<br>matters worse, not even =
scan-s2 can get a really usable channel list.<br>
I had to build the list by hand, according to<br><a href=3D"http://pt.kingo=
fsat.net/pack-meo.php" target=3D"_blank">http://pt.kingofsat.net/pack-meo.p=
hp</a> page.<br><br>And it still doesn&#39;t work.<br><br>I use vdr-xine an=
d xineliboutput with vdr 1.7.0 and up, plus<br>
xine-vdpau to no avail.<br><br>What&#39;s the point of having a DVB-S2 card=
 if we can&#39;t tune to those<br>channels? What&#39;s missing in the S2-32=
00 drivers?</blockquote>
<div>What drivers do you use?</div>
<div>I saw that Igor did some changes in his repository to lock on high SR =
channels.</div>
<div>&nbsp;</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=3D""></span><br><br>Chr=
is<br><br>_______________________________________________<br>linux-dvb user=
s mailing list<br>
For V4L/DVB development, please use instead <a href=3D"mailto:linux-media@v=
ger.kernel.org">linux-media@vger.kernel.org</a><br><a href=3D"mailto:linux-=
dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv=
.org/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linux=
tv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

--0015175cba7af3a28d0461649d1e--


--===============1739751241==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1739751241==--
