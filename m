Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LR8Hs-0002Yb-SM
	for linux-dvb@linuxtv.org; Sun, 25 Jan 2009 17:56:45 +0100
Received: by qyk9 with SMTP id 9so6084329qyk.17
	for <linux-dvb@linuxtv.org>; Sun, 25 Jan 2009 08:56:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090125162959.86940@gmx.net>
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de>
	<c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
	<20090125144112.86930@gmx.net>
	<c74595dc0901250654l49b419dcw2327b1cfb0ebe0dc@mail.gmail.com>
	<20090125162959.86940@gmx.net>
Date: Sun, 25 Jan 2009 18:56:05 +0200
Message-ID: <c74595dc0901250856s6b230b8cqc21f8cfa455f676b@mail.gmail.com>
From: Alex Betis <alex.betis@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use scan-s2?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0015414445=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0015414445==
Content-Type: multipart/alternative; boundary=0015175cda7278a6a20461517fb1

--0015175cda7278a6a20461517fb1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 25, 2009 at 6:29 PM, Hans Werner <HWerner4@gmx.de> wrote:

> > On Sun, Jan 25, 2009 at 4:41 PM, Hans Werner <HWerner4@gmx.de> wrote:
> >
> > > > If you have a stb0899 device, don't forget to add "-k 3".
> > >
> > > Oh. Can someone say what's different about the stb0899 here,
> > > and how -k 3 helps ?
> >
> >
> > Since I've added it, I'll try to defend it :)
> >
> > stb0899 driver (or maybe the chip?) has some buffers inside that are no=
t
> > reset between tunnings.
> > In that case messages from *previous* channel will arrive after the
> > tunning
> > to new channel is complete.
> > Those messages will create a big mess in the results, such as channels
> > without names, duplicate channels on different transponders.
> > -k option specifies how many messages should be ignored before processi=
ng
> > it. I couldn't think of a more elegant way to ignore messages from
> > previously tuned channel. I use "-k 3" by myself, but after playing
> around
> > with "-k 2" saw that its also working. "-k 1" was still not enough.
> >
> > The proper way is to have an option to reset that buffer in the driver
> > after
> > tunning.
> > Since I don't know how it can be done and how it will affect tunning of
> > channels for viewing, I didn't want to go that way and solve it in
> > scan-s2.
> >
> > Regards,
> > Alex.
>
> OK, thanks, I will check if I see that problem. Which card(s)
> did you see this with?
> Hans

I'm aware only about Twinhan 1041 and TT-3200 based stb0899 cards. Both hav=
e
the same problem.


>
> --
> Release early, release often.
>
> Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen=
:
> http://www.gmx.net/de/go/multimessenger
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--0015175cda7278a6a20461517fb1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Sun, Jan 25, 2009 at 6:29 PM=
, Hans Werner <span dir=3D"ltr">&lt;<a href=3D"mailto:HWerner4@gmx.de">HWer=
ner4@gmx.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">&gt; On Sun, Jan 25, 2009 at 4:4=
1 PM, Hans Werner &lt;<a href=3D"mailto:HWerner4@gmx.de">HWerner4@gmx.de</a=
>&gt; wrote:<br>
&gt;<br>&gt; &gt; &gt; If you have a stb0899 device, don&#39;t forget to ad=
d &quot;-k 3&quot;.<br>&gt; &gt;<br>&gt; &gt; Oh. Can someone say what&#39;=
s different about the stb0899 here,<br>&gt; &gt; and how -k 3 helps ?<br>
&gt;<br>&gt;<br>&gt; Since I&#39;ve added it, I&#39;ll try to defend it :)<=
br>&gt;<br>&gt; stb0899 driver (or maybe the chip?) has some buffers inside=
 that are not<br>&gt; reset between tunnings.<br>&gt; In that case messages=
 from *previous* channel will arrive after the<br>
&gt; tunning<br>&gt; to new channel is complete.<br>&gt; Those messages wil=
l create a big mess in the results, such as channels<br>&gt; without names,=
 duplicate channels on different transponders.<br>&gt; -k option specifies =
how many messages should be ignored before processing<br>
&gt; it. I couldn&#39;t think of a more elegant way to ignore messages from=
<br>&gt; previously tuned channel. I use &quot;-k 3&quot; by myself, but af=
ter playing around<br>&gt; with &quot;-k 2&quot; saw that its also working.=
 &quot;-k 1&quot; was still not enough.<br>
&gt;<br>&gt; The proper way is to have an option to reset that buffer in th=
e driver<br>&gt; after<br>&gt; tunning.<br>&gt; Since I don&#39;t know how =
it can be done and how it will affect tunning of<br>&gt; channels for viewi=
ng, I didn&#39;t want to go that way and solve it in<br>
&gt; scan-s2.<br>&gt;<br>&gt; Regards,<br>&gt; Alex.<br><br>OK, thanks, I w=
ill check if I see that problem. Which card(s)<br>did you see this with?<br=
>Hans</blockquote>
<div>I&#39;m aware only about Twinhan 1041 and TT-3200 based stb0899 cards.=
 Both have the same problem.</div>
<div>&nbsp;</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=3D""></span><br>--<br>R=
elease early, release often.<br><br>Psssst! Schon vom neuen GMX MultiMessen=
ger geh=F6rt? Der kann`s mit allen: <a href=3D"http://www.gmx.net/de/go/mul=
timessenger" target=3D"_blank">http://www.gmx.net/de/go/multimessenger</a><=
br>
<br>_______________________________________________<br>linux-dvb users mail=
ing list<br>For V4L/DVB development, please use instead <a href=3D"mailto:l=
inux-media@vger.kernel.org">linux-media@vger.kernel.org</a><br><a href=3D"m=
ailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br></blockquote></div><br></div>

--0015175cda7278a6a20461517fb1--


--===============0015414445==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0015414445==--
