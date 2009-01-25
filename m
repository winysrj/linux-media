Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LR6O0-0003K7-H5
	for linux-dvb@linuxtv.org; Sun, 25 Jan 2009 15:54:57 +0100
Received: by qyk9 with SMTP id 9so6054420qyk.17
	for <linux-dvb@linuxtv.org>; Sun, 25 Jan 2009 06:54:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090125144112.86930@gmx.net>
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de>
	<c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
	<20090125144112.86930@gmx.net>
Date: Sun, 25 Jan 2009 16:54:22 +0200
Message-ID: <c74595dc0901250654l49b419dcw2327b1cfb0ebe0dc@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0383139798=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0383139798==
Content-Type: multipart/alternative; boundary=0015175cdf6a294c5d04614fccac

--0015175cdf6a294c5d04614fccac
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 25, 2009 at 4:41 PM, Hans Werner <HWerner4@gmx.de> wrote:

> > If you have a stb0899 device, don't forget to add "-k 3".
>
> Oh. Can someone say what's different about the stb0899 here,
> and how -k 3 helps ?


Since I've added it, I'll try to defend it :)

stb0899 driver (or maybe the chip?) has some buffers inside that are not
reset between tunnings.
In that case messages from *previous* channel will arrive after the tunning
to new channel is complete.
Those messages will create a big mess in the results, such as channels
without names, duplicate channels on different transponders.
-k option specifies how many messages should be ignored before processing
it. I couldn't think of a more elegant way to ignore messages from
previously tuned channel. I use "-k 3" by myself, but after playing around
with "-k 2" saw that its also working. "-k 1" was still not enough.

The proper way is to have an option to reset that buffer in the driver afte=
r
tunning.
Since I don't know how it can be done and how it will affect tunning of
channels for viewing, I didn't want to go that way and solve it in scan-s2.

Regards,
Alex.


>
>
> Thanks,
> Hans
>
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

--0015175cdf6a294c5d04614fccac
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Sun, Jan 25, 2009 at 4:41 PM=
, Hans Werner <span dir=3D"ltr">&lt;<a href=3D"mailto:HWerner4@gmx.de">HWer=
ner4@gmx.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">&gt; If you have a stb0899 devic=
e, don&#39;t forget to add &quot;-k 3&quot;.<br><br>Oh. Can someone say wha=
t&#39;s different about the stb0899 here,<br>
and how -k 3 helps ?</blockquote>
<div>&nbsp;</div>
<div>Since I&#39;ve added it, I&#39;ll try to defend it :)</div>
<div>&nbsp;</div>
<div>stb0899 driver (or maybe the chip?) has some buffers inside that are n=
ot reset between tunnings.</div>
<div>In that case messages from <strong><u>previous</u></strong> channel wi=
ll arrive after the tunning to new channel is complete.</div>
<div>Those messages will create a big mess in the results, such as channels=
 without names, duplicate channels on different transponders.</div>
<div>-k option specifies how many messages should be ignored before process=
ing it. I couldn&#39;t think of a more elegant way to ignore messages from =
previously tuned channel. I use &quot;-k 3&quot; by myself, but after playi=
ng around with &quot;-k 2&quot; saw that its also working. &quot;-k 1&quot;=
 was still not enough.</div>

<div>&nbsp;</div>
<div>The proper way is to have an option to reset that buffer in the driver=
 after tunning. </div>
<div>Since I don&#39;t know how it can be done and how it will affect tunni=
ng of channels for viewing, I didn&#39;t want to go that way and solve it i=
n scan-s2.</div>
<div>&nbsp;</div>
<div>Regards,</div>
<div>Alex.</div>
<div>&nbsp;</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=3D""></span><br><br>Tha=
nks,<br>Hans<br><font color=3D"#888888"><br><br>--<br>Release early, releas=
e often.<br>
<br>Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: <a href=3D"http://www.gmx.net/de/go/multimessenger" target=3D"_blank">h=
ttp://www.gmx.net/de/go/multimessenger</a><br></font>
<div>
<div></div>
<div class=3D"Wj3C7c"><br>_______________________________________________<b=
r>linux-dvb users mailing list<br>For V4L/DVB development, please use inste=
ad <a href=3D"mailto:linux-media@vger.kernel.org">linux-media@vger.kernel.o=
rg</a><br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a hr=
ef=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target=3D"=
_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></=
div>
</div></blockquote></div><br></div>

--0015175cdf6a294c5d04614fccac--


--===============0383139798==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0383139798==--
