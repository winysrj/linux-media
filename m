Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRugy-0004QS-AL
	for linux-dvb@linuxtv.org; Tue, 27 Jan 2009 21:37:54 +0100
Received: by qyk9 with SMTP id 9so7478806qyk.17
	for <linux-dvb@linuxtv.org>; Tue, 27 Jan 2009 12:37:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497F66E5.9060901@gmail.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>
	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>
	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
	<1232998154.24736.2@manu-laptop> <497F66E5.9060901@gmail.com>
Date: Tue, 27 Jan 2009 22:37:17 +0200
Message-ID: <c74595dc0901271237j7495ddeaif44288ad47416ddd@mail.gmail.com>
From: Alex Betis <alex.betis@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org, Manu <eallaud@gmail.com>
Subject: Re: [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts
	on HDchannels
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1047763510=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1047763510==
Content-Type: multipart/alternative; boundary=0015175cd68a3a05dd04617cd297

--0015175cd68a3a05dd04617cd297
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, Jan 27, 2009 at 9:56 PM, Manu Abraham <abraham.manu@gmail.com>wrote:

>
> > Hmm OK, but is there by any chance a fix for those issues somewhere or
> > in the pipe at least? I am willing to test (as I already offered), I
> > can compile the drivers, spread printk or whatever else is needed to
> > get useful reports. Let me know if I can help sort this problem. BTW in
> > my case it is DVB-S2 30000 SR and FEC 5/6.
>
> It was quite not appreciable on my part to provide a fix or reply in
> time nor spend much time on it earlier, but that said i was quite
> stuck up with some other things.
>
> Can you please pull a copy of the multiproto tree
> http://jusst.de/hg/multiproto or the v4l-dvb tree from
> http://jusst.de/hg/v4l-dvb
>
> and apply the following patch and comment what your result is ?
> Before applying please do check whether you still have the issues.

Manu,
I've tried to increase those timers long ago when played around with my card
(Twinhan 1041) and scan utility.
I must say that I've concentrated mostly on DVB-S channels that wasn't
always locking.
I didn't notice much improvements. The thing that did help was increasing
the resolution of scan zigzags.
I've sent a patch on that ML and people were happy with the results.
The patch went to Igor's repository, don't know were it goes from there.

I believe DVB-S2 lock suffer from the same problem, but in that case the
zigzag is done in the chip and not in the driver.
Since I have no documentation of the chip I was stuck and left it. So if you
have the knowledge or documentation of the chip,
try to go in that direction.

By the way, question to those who have such channels:
Does windows based applications show those channels properly?


>
>
>
> BTW: lot of patience you have compared to the other users :)
>
> Regards,
> Manu
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--0015175cd68a3a05dd04617cd297
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Tue, Jan 27, 2009 at 9:56 PM=
, Manu Abraham <span dir=3D"ltr">&lt;<a href=3D"mailto:abraham.manu@gmail.c=
om">abraham.manu@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gm=
ail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt =
0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
&gt; Hmm OK, but is there by any chance a fix for those issues somewhere or=
<br>
&gt; in the pipe at least? I am willing to test (as I already offered), I<b=
r>
&gt; can compile the drivers, spread printk or whatever else is needed to<b=
r>
&gt; get useful reports. Let me know if I can help sort this problem. BTW i=
n<br>
&gt; my case it is DVB-S2 30000 SR and FEC 5/6.<br>
<br>
It was quite not appreciable on my part to provide a fix or reply in<br>
time nor spend much time on it earlier, but that said i was quite<br>
stuck up with some other things.<br>
<br>
Can you please pull a copy of the multiproto tree<br>
<a href=3D"http://jusst.de/hg/multiproto" target=3D"_blank">http://jusst.de=
/hg/multiproto</a> or the v4l-dvb tree from<br>
<a href=3D"http://jusst.de/hg/v4l-dvb" target=3D"_blank">http://jusst.de/hg=
/v4l-dvb</a><br>
<br>
and apply the following patch and comment what your result is ?<br>
Before applying please do check whether you still have the issues.</blockqu=
ote><div>Manu,<br>I&#39;ve tried to increase those timers long ago when pla=
yed around with my card (Twinhan 1041) and scan utility.<br>I must say that=
 I&#39;ve concentrated mostly on DVB-S channels that wasn&#39;t always lock=
ing.<br>
I didn&#39;t notice much improvements. The thing that did help was increasi=
ng the resolution of scan zigzags.<br>I&#39;ve sent a patch on that ML and =
people were happy with the results. <br>The patch went to Igor&#39;s reposi=
tory, don&#39;t know were it goes from there.<br>
<br>I believe DVB-S2 lock suffer from the same problem, but in that case th=
e zigzag is done in the chip and not in the driver.<br>Since I have no docu=
mentation of the chip I was stuck and left it. So if you have the knowledge=
 or documentation of the chip,<br>
try to go in that direction.<br><br>By the way, question to those who have =
such channels:<br>Does windows based applications show those channels prope=
rly?<br>&nbsp;<br></div><blockquote class=3D"gmail_quote" style=3D"border-l=
eft: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left:=
 1ex;">
<br>
<br>
<br>
BTW: lot of patience you have compared to the other users :)<br>
<br>
Regards,<br>
<font color=3D"#888888">Manu<br>
<br>
</font><br>_______________________________________________<br>
linux-dvb users mailing list<br>
For V4L/DVB development, please use instead <a href=3D"mailto:linux-media@v=
ger.kernel.org">linux-media@vger.kernel.org</a><br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br></blockquote></div><br></div>

--0015175cd68a3a05dd04617cd297--


--===============1047763510==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1047763510==--
