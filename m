Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRY8B-0002Mw-EW
	for linux-dvb@linuxtv.org; Mon, 26 Jan 2009 21:32:28 +0100
Received: by qyk9 with SMTP id 9so6725530qyk.17
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 12:31:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <18268.1233001231@kewl.org>
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de>
	<c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
	<Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org>
	<c74595dc0901260135x32f7c2bm59506de420dab978@mail.gmail.com>
	<Pine.LNX.4.64.0901261729280.19881@shogun.pilppa.org>
	<c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>
	<16900.1232991151@kewl.org>
	<c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com>
	<18268.1233001231@kewl.org>
Date: Mon, 26 Jan 2009 22:31:50 +0200
Message-ID: <c74595dc0901261231l4448f6cepfcb570557c54f60a@mail.gmail.com>
From: Alex Betis <alex.betis@gmail.com>
To: Darron Broad <darron@kewl.org>
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] How to use scan-s2?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0230214778=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0230214778==
Content-Type: multipart/alternative; boundary=0015175cba82e5f1ee046168a0ae

--0015175cba82e5f1ee046168a0ae
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Mon, Jan 26, 2009 at 10:20 PM, Darron Broad <darron@kewl.org> wrote:

> In message <c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com>,
> Alex
> Betis wrote:
> >
> >On Mon, Jan 26, 2009 at 7:32 PM, Darron Broad <darron@kewl.org> wrote:
> >
> >> In message <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com
> >,
> >> Alex Betis wrote:
> >>
> >> lo
> >>
> >> <snip>
> >> >
> >> >The bug is in S2API that doesn't return ANY error message at all :)
> >> >So the tuner is left locked on previous channel.
> >> >
> >> >There are many things that can be done in driver to improve the
> situation,
> >> >but I'll leave it to someone who has card with cx24116 chips.
> >>
> >> When tuning the event status should change to 0 and if
> >> it stays that way the tuning operation failed.
> >>
> >> If you read the frontend status directly then you will
> >> retrieve the state of the previous tuning operation
> >> that suceeded.
> >
> >What do you call an event status and what direct status?
> >
> >scan-s2 uses FE_READ_STATUS that always success and indicates channel
> lock,
> >even if cx24116 driver returned an error due to AUTO parameters.
>
> refer to
>
> FE_SET_FRONTEND:
>
> http://www.linuxtv.org/docs/dvbapi/DVB_Frontend_API.html#SECTION00328000000000000000
>
> and,
>
> FE_GET_EVENT
>
> http://www.linuxtv.org/docs/dvbapi/DVB_Frontend_API.html#SECTION003210000000000000000
>
Ohh, ok. So there is a solution for that after all. Thanks!
Unfortunately no one gave me a clear answer on that when I asked about it
last time.
Seems to work for stb0899, waiting for confirmation on cx24116.

Darron, looks you're the right person to ask:
How can I retrieve the REAL tuned parameters from the driver?
Looks like using FE_GET_PROPERTY returns cached properties that were issued
with FE_SET_PROPERTY before that.

Thanks.


> l8r
>
> --
>
>  // /
> {:)==={ Darron Broad <darron@kewl.org>
>  \\ \
>
>

--0015175cba82e5f1ee046168a0ae
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_quote">On Mon, Jan 26, 2009 at 10:=
20 PM, Darron Broad <span dir=3D"ltr">&lt;<a href=3D"mailto:darron@kewl.org=
">darron@kewl.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0=
.8ex; padding-left: 1ex;">
In message &lt;<a href=3D"mailto:c74595dc0901261130k6bdb6882lfb18c650cbca4a=
bf@mail.gmail.com">c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.=
com</a>&gt;, Alex<br>
Betis wrote:<br>
&gt;<br>
&gt;On Mon, Jan 26, 2009 at 7:32 PM, Darron Broad &lt;<a href=3D"mailto:dar=
ron@kewl.org">darron@kewl.org</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; In message &lt;<a href=3D"mailto:c74595dc0901260753x8b9185fu33f2a9=
6ffbe13016@mail.gmail.com">c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail=
.gmail.com</a>&gt;,<br>
&gt;&gt; Alex Betis wrote:<br>
&gt;&gt;<br>
&gt;&gt; lo<br>
&gt;&gt;<br>
&gt;&gt; &lt;snip&gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;The bug is in S2API that doesn&#39;t return ANY error message =
at all :)<br>
&gt;&gt; &gt;So the tuner is left locked on previous channel.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;There are many things that can be done in driver to improve th=
e situation,<br>
&gt;&gt; &gt;but I&#39;ll leave it to someone who has card with cx24116 chi=
ps.<br>
&gt;&gt;<br>
&gt;&gt; When tuning the event status should change to 0 and if<br>
&gt;&gt; it stays that way the tuning operation failed.<br>
&gt;&gt;<br>
&gt;&gt; If you read the frontend status directly then you will<br>
&gt;&gt; retrieve the state of the previous tuning operation<br>
&gt;&gt; that suceeded.<br>
&gt;<br>
&gt;What do you call an event status and what direct status?<br>
&gt;<br>
&gt;scan-s2 uses FE_READ_STATUS that always success and indicates channel l=
ock,<br>
&gt;even if cx24116 driver returned an error due to AUTO parameters.<br>
<br>
refer to<br>
<br>
FE_SET_FRONTEND:<br>
<a href=3D"http://www.linuxtv.org/docs/dvbapi/DVB_Frontend_API.html#SECTION=
00328000000000000000" target=3D"_blank">http://www.linuxtv.org/docs/dvbapi/=
DVB_Frontend_API.html#SECTION00328000000000000000</a><br>
<br>
and,<br>
<br>
FE_GET_EVENT<br>
<a href=3D"http://www.linuxtv.org/docs/dvbapi/DVB_Frontend_API.html#SECTION=
003210000000000000000" target=3D"_blank">http://www.linuxtv.org/docs/dvbapi=
/DVB_Frontend_API.html#SECTION003210000000000000000</a><br>
</blockquote><div>Ohh, ok. So there is a solution for that after all. Thank=
s!<br>Unfortunately no one gave me a clear answer on that when I asked abou=
t it last time.<br>Seems to work for stb0899, waiting for confirmation on c=
x24116.<br>
<br>Darron, looks you&#39;re the right person to ask:<br>How can I retrieve=
 the REAL tuned parameters from the driver?<br>Looks like using FE_GET_PROP=
ERTY returns cached properties that were issued with FE_SET_PROPERTY before=
 that.<br>
<br>Thanks.<br><br></div><blockquote class=3D"gmail_quote" style=3D"border-=
left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left=
: 1ex;"><br>
l8r<br>
<font color=3D"#888888"><br>
--<br>
<br>
&nbsp;// /<br>
{:)=3D=3D=3D{ Darron Broad &lt;<a href=3D"mailto:darron@kewl.org">darron@ke=
wl.org</a>&gt;<br>
&nbsp;\\ \<br>
<br>
</font></blockquote></div><br></div>

--0015175cba82e5f1ee046168a0ae--


--===============0230214778==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0230214778==--
