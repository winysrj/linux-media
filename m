Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRigX-000678-2n
	for linux-dvb@linuxtv.org; Tue, 27 Jan 2009 08:48:37 +0100
Received: by qyk9 with SMTP id 9so7038529qyk.17
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 23:48:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233017978.3061.2.camel@palomino.walls.org>
References: <497C3F0F.1040107@makhutov.org>
	<Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org>
	<c74595dc0901260135x32f7c2bm59506de420dab978@mail.gmail.com>
	<Pine.LNX.4.64.0901261729280.19881@shogun.pilppa.org>
	<c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>
	<16900.1232991151@kewl.org>
	<c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com>
	<18268.1233001231@kewl.org>
	<c74595dc0901261231l4448f6cepfcb570557c54f60a@mail.gmail.com>
	<1233017978.3061.2.camel@palomino.walls.org>
Date: Tue, 27 Jan 2009 09:48:02 +0200
Message-ID: <c74595dc0901262348x55e870bfmc18ada404f4ae911@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0721896934=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0721896934==
Content-Type: multipart/alternative; boundary=0015175cb05c2f87a204617213a8

--0015175cb05c2f87a204617213a8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, Jan 27, 2009 at 2:59 AM, Andy Walls <awalls@radix.net> wrote:

> On Mon, 2009-01-26 at 22:31 +0200, Alex Betis wrote:
> >
> > On Mon, Jan 26, 2009 at 10:20 PM, Darron Broad <darron@kewl.org>
> > wrote:
> >         In message
> >         <c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com>,
> >         Alex
> >         Betis wrote:
> >         >
> >         >On Mon, Jan 26, 2009 at 7:32 PM, Darron Broad
> >         <darron@kewl.org> wrote:
> >         >
> >         >> In message
> >         <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>,
> >         >> Alex Betis wrote:
> >         >>
> >         >> lo
> >         >>
> >         >> <snip>
> >         >> >
> >         >> >The bug is in S2API that doesn't return ANY error message
> >         at all :)
>
> Aside from Darron's observation, doesn't the result field of any
> particular S2API property return with a non-0 value on failure?

Depends how you define the "failure".
If you order to tune, than for S2API failure would be something like "could
not initiate tune command" and not like "tuning failed".
Apparently the "tuning failed" failure should be checked with events and not
rely on return code from commands.

Correct me if I'm wrong with that.


>
>
> (Sorry, I missed the original thread on the S2API return values.)
>
> Regards,
> Andy
>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--0015175cb05c2f87a204617213a8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Tue, Jan 27, 2009 at 2:59 AM=
, Andy Walls <span dir=3D"ltr">&lt;<a href=3D"mailto:awalls@radix.net">awal=
ls@radix.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" sty=
le=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex;=
 padding-left: 1ex;">
On Mon, 2009-01-26 at 22:31 +0200, Alex Betis wrote:<br>
&gt;<br>
&gt; On Mon, Jan 26, 2009 at 10:20 PM, Darron Broad &lt;<a href=3D"mailto:d=
arron@kewl.org">darron@kewl.org</a>&gt;<br>
&gt; wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; In message<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;<a href=3D"mailto:c74595dc0901261130k6=
bdb6882lfb18c650cbca4abf@mail.gmail.com">c74595dc0901261130k6bdb6882lfb18c6=
50cbca4abf@mail.gmail.com</a>&gt;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Alex<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Betis wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;On Mon, Jan 26, 2009 at 7:32 PM, Darro=
n Broad<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;<a href=3D"mailto:darron@kewl.org">dar=
ron@kewl.org</a>&gt; wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; In message<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;<a href=3D"mailto:c74595dc0901260753x8=
b9185fu33f2a96ffbe13016@mail.gmail.com">c74595dc0901260753x8b9185fu33f2a96f=
fbe13016@mail.gmail.com</a>&gt;,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Alex Betis wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; lo<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &lt;snip&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; &gt;The bug is in S2API that does=
n&#39;t return ANY error message<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; at all :)<br>
<br>
Aside from Darron&#39;s observation, doesn&#39;t the result field of any<br=
>
particular S2API property return with a non-0 value on failure?</blockquote=
><div>Depends how you define the &quot;failure&quot;.<br>If you order to tu=
ne, than for S2API failure would be something like &quot;could not initiate=
 tune command&quot; and not like &quot;tuning failed&quot;.<br>
Apparently the &quot;tuning failed&quot; failure should be checked with eve=
nts and not rely on return code from commands.<br><br>Correct me if I&#39;m=
 wrong with that.<br>&nbsp;<br></div><blockquote class=3D"gmail_quote" styl=
e=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; =
padding-left: 1ex;">
<br>
<br>
(Sorry, I missed the original thread on the S2API return values.)<br>
<br>
Regards,<br>
Andy<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb users mailing list<br>
For V4L/DVB development, please use instead <a href=3D"mailto:linux-media@v=
ger.kernel.org">linux-media@vger.kernel.org</a><br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</blockquote></div><br></div>

--0015175cb05c2f87a204617213a8--


--===============0721896934==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0721896934==--
