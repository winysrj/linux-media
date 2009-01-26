Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRXAc-0005Pg-1F
	for linux-dvb@linuxtv.org; Mon, 26 Jan 2009 20:30:54 +0100
Received: by qyk9 with SMTP id 9so6677610qyk.17
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 11:30:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <16900.1232991151@kewl.org>
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de>
	<c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
	<Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org>
	<c74595dc0901260135x32f7c2bm59506de420dab978@mail.gmail.com>
	<Pine.LNX.4.64.0901261729280.19881@shogun.pilppa.org>
	<c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>
	<16900.1232991151@kewl.org>
Date: Mon, 26 Jan 2009 21:30:19 +0200
Message-ID: <c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0010102614=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0010102614==
Content-Type: multipart/alternative; boundary=0015175ccf34e7d8df046167c4e9

--0015175ccf34e7d8df046167c4e9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Mon, Jan 26, 2009 at 7:32 PM, Darron Broad <darron@kewl.org> wrote:

> In message <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>,
> Alex Betis wrote:
>
> lo
>
> <snip>
> >
> >The bug is in S2API that doesn't return ANY error message at all :)
> >So the tuner is left locked on previous channel.
> >
> >There are many things that can be done in driver to improve the situation,
> >but I'll leave it to someone who has card with cx24116 chips.
>
> When tuning the event status should change to 0 and if
> it stays that way the tuning operation failed.
>
> If you read the frontend status directly then you will
> retrieve the state of the previous tuning operation
> that suceeded.

What do you call an event status and what direct status?

scan-s2 uses FE_READ_STATUS that always success and indicates channel lock,
even if cx24116 driver returned an error due to AUTO parameters.


>
> If this the above is not true then it needs investigation.
>
> cya
>
>

--0015175ccf34e7d8df046167c4e9
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Mon, Jan 26, 2009 at 7:32 PM=
, Darron Broad <span dir=3D"ltr">&lt;<a href=3D"mailto:darron@kewl.org">dar=
ron@kewl.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" sty=
le=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex;=
 padding-left: 1ex;">
In message &lt;<a href=3D"mailto:c74595dc0901260753x8b9185fu33f2a96ffbe1301=
6@mail.gmail.com">c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.co=
m</a>&gt;, Alex Betis wrote:<br>
<br>
lo<br>
<br>
&lt;snip&gt;<br>
&gt;<br>
&gt;The bug is in S2API that doesn&#39;t return ANY error message at all :)=
<br>
&gt;So the tuner is left locked on previous channel.<br>
&gt;<br>
&gt;There are many things that can be done in driver to improve the situati=
on,<br>
&gt;but I&#39;ll leave it to someone who has card with cx24116 chips.<br>
<br>
When tuning the event status should change to 0 and if<br>
it stays that way the tuning operation failed.<br>
<br>
If you read the frontend status directly then you will<br>
retrieve the state of the previous tuning operation<br>
that suceeded.</blockquote><div>What do you call an event status and what d=
irect status?<br><br>scan-s2 uses FE_READ_STATUS that always success and in=
dicates channel lock, even if cx24116 driver returned an error due to AUTO =
parameters.<br>
<br></div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid=
 rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
If this the above is not true then it needs investigation.<br>
<br>
cya<br>
<br>
</blockquote></div><br></div>

--0015175ccf34e7d8df046167c4e9--


--===============0010102614==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0010102614==--
