Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRUB0-00075T-Gv
	for linux-dvb@linuxtv.org; Mon, 26 Jan 2009 17:19:07 +0100
Received: by qw-out-2122.google.com with SMTP id 9so1328822qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 08:19:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>
	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>
	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
Date: Mon, 26 Jan 2009 18:19:01 +0200
Message-ID: <c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0608402265=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0608402265==
Content-Type: multipart/alternative; boundary=0015175cb19ac18e11046165183b

--0015175cb19ac18e11046165183b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Mon, Jan 26, 2009 at 6:08 PM, Chris Silva <2manybills@gmail.com> wrote:

> On Mon, Jan 26, 2009 at 3:51 PM, Chris Silva <2manybills@gmail.com> wrote:
> > On Mon, Jan 26, 2009 at 3:44 PM, Alex Betis <alex.betis@gmail.com>
> wrote:
> >> On Mon, Jan 26, 2009 at 5:41 PM, Chris Silva <2manybills@gmail.com>
> wrote:
> >>>
> >>> On Mon, Jan 26, 2009 at 2:40 PM, Newsy Paper
> >>> <newspaperman_germany@yahoo.com> wrote:
> >>> > the transponders you don't get lock are problem transponders of
> s2-3200.
> >>> > The driver is still not able to lock on dvb-s2 30000 3/4 transponders
> :(
> >>> >
> >>> > Which software do you use to play HD content?
> >>> > you need either xine-lib 1.2 with external ffmpeg (recent developer's
> >>> > version).
> >>> > or xine-vdpau (if you have a NVIDIA graka that supports h264 hw
> >>> > acceleration).
> >>> >
> >>> > regards
> >>> >
> >>> > Newsy
> >>>
> >>> I can confirm this. I use S30W (Hispasat) and one of the providers,
> >>> Meo, broadcasts everything on DVB-S2 30000 3/4.
> >>> I can't get a lock on any of the transponders/channels. And to make
> >>> matters worse, not even scan-s2 can get a really usable channel list.
> >>> I had to build the list by hand, according to
> >>> http://pt.kingofsat.net/pack-meo.php page.
> >>>
> >>> And it still doesn't work.
> >>>
> >>> I use vdr-xine and xineliboutput with vdr 1.7.0 and up, plus
> >>> xine-vdpau to no avail.
> >>>
> >>> What's the point of having a DVB-S2 card if we can't tune to those
> >>> channels? What's missing in the S2-3200 drivers?
> >>
> >> What drivers do you use?
> >> I saw that Igor did some changes in his repository to lock on high SR
> >> channels.
> >>
> >
> > I've tried with both v4l-dvb and Igor repository. Haven't tried with
> > latest changes Igor made.
> >
> > I'll try it tonight and comment on the state.
> >
> > But for now, I'm somewhat disappointed. It's been over 6 months trying
> > to make DVB-S2 transponders to work and no result to show.
> >
> > But wey... DVB-S works perfectly.
> >
> > Chris
> >
>
> Latest changes I can see at
> http://mercurial.intuxication.org/hg/s2-liplianin/ were made about 7
> to 10 days ago. Is this correct? If that's correct, then I'm using
> latest Igor drivers. And behavior described above is what I'm getting.
>
> I can't see anything related do high SR channels on Igor repository.

He did it few months ago. If you're on latest than you should have it.


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

--0015175cb19ac18e11046165183b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Mon, Jan 26, 2009 at 6:08 PM=
, Chris Silva <span dir=3D"ltr">&lt;<a href=3D"mailto:2manybills@gmail.com"=
>2manybills@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">On Mon, Jan 26, 2009 at 3:51 PM,=
 Chris Silva &lt;<a href=3D"mailto:2manybills@gmail.com">2manybills@gmail.c=
om</a>&gt; wrote:<br>
&gt; On Mon, Jan 26, 2009 at 3:44 PM, Alex Betis &lt;<a href=3D"mailto:alex=
.betis@gmail.com">alex.betis@gmail.com</a>&gt; wrote:<br>&gt;&gt; On Mon, J=
an 26, 2009 at 5:41 PM, Chris Silva &lt;<a href=3D"mailto:2manybills@gmail.=
com">2manybills@gmail.com</a>&gt; wrote:<br>
&gt;&gt;&gt;<br>&gt;&gt;&gt; On Mon, Jan 26, 2009 at 2:40 PM, Newsy Paper<b=
r>&gt;&gt;&gt; &lt;<a href=3D"mailto:newspaperman_germany@yahoo.com">newspa=
perman_germany@yahoo.com</a>&gt; wrote:<br>&gt;&gt;&gt; &gt; the transponde=
rs you don&#39;t get lock are problem transponders of s2-3200.<br>
&gt;&gt;&gt; &gt; The driver is still not able to lock on dvb-s2 30000 3/4 =
transponders :(<br>&gt;&gt;&gt; &gt;<br>&gt;&gt;&gt; &gt; Which software do=
 you use to play HD content?<br>&gt;&gt;&gt; &gt; you need either xine-lib =
1.2 with external ffmpeg (recent developer&#39;s<br>
&gt;&gt;&gt; &gt; version).<br>&gt;&gt;&gt; &gt; or xine-vdpau (if you have=
 a NVIDIA graka that supports h264 hw<br>&gt;&gt;&gt; &gt; acceleration).<b=
r>&gt;&gt;&gt; &gt;<br>&gt;&gt;&gt; &gt; regards<br>&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; Newsy<br>&gt;&gt;&gt;<br>&gt;&gt;&gt; I can confirm this.=
 I use S30W (Hispasat) and one of the providers,<br>&gt;&gt;&gt; Meo, broad=
casts everything on DVB-S2 30000 3/4.<br>&gt;&gt;&gt; I can&#39;t get a loc=
k on any of the transponders/channels. And to make<br>
&gt;&gt;&gt; matters worse, not even scan-s2 can get a really usable channe=
l list.<br>&gt;&gt;&gt; I had to build the list by hand, according to<br>&g=
t;&gt;&gt; <a href=3D"http://pt.kingofsat.net/pack-meo.php" target=3D"_blan=
k">http://pt.kingofsat.net/pack-meo.php</a> page.<br>
&gt;&gt;&gt;<br>&gt;&gt;&gt; And it still doesn&#39;t work.<br>&gt;&gt;&gt;=
<br>&gt;&gt;&gt; I use vdr-xine and xineliboutput with vdr 1.7.0 and up, pl=
us<br>&gt;&gt;&gt; xine-vdpau to no avail.<br>&gt;&gt;&gt;<br>&gt;&gt;&gt; =
What&#39;s the point of having a DVB-S2 card if we can&#39;t tune to those<=
br>
&gt;&gt;&gt; channels? What&#39;s missing in the S2-3200 drivers?<br>&gt;&g=
t;<br>&gt;&gt; What drivers do you use?<br>&gt;&gt; I saw that Igor did som=
e changes in his repository to lock on high SR<br>&gt;&gt; channels.<br>
&gt;&gt;<br>&gt;<br>&gt; I&#39;ve tried with both v4l-dvb and Igor reposito=
ry. Haven&#39;t tried with<br>&gt; latest changes Igor made.<br>&gt;<br>&gt=
; I&#39;ll try it tonight and comment on the state.<br>&gt;<br>&gt; But for=
 now, I&#39;m somewhat disappointed. It&#39;s been over 6 months trying<br>
&gt; to make DVB-S2 transponders to work and no result to show.<br>&gt;<br>=
&gt; But wey... DVB-S works perfectly.<br>&gt;<br>&gt; Chris<br>&gt;<br><br=
>Latest changes I can see at<br><a href=3D"http://mercurial.intuxication.or=
g/hg/s2-liplianin/" target=3D"_blank">http://mercurial.intuxication.org/hg/=
s2-liplianin/</a> were made about 7<br>
to 10 days ago. Is this correct? If that&#39;s correct, then I&#39;m using<=
br>latest Igor drivers. And behavior described above is what I&#39;m gettin=
g.<br><br>I can&#39;t see anything related do high SR channels on Igor repo=
sitory.</blockquote>

<div>He did it few months ago. If you&#39;re on latest than you should have=
 it.</div>
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

--0015175cb19ac18e11046165183b--


--===============0608402265==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0608402265==--
