Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRuj6-0004zD-GL
	for linux-dvb@linuxtv.org; Tue, 27 Jan 2009 21:40:05 +0100
Received: by qw-out-2122.google.com with SMTP id 9so1537611qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 27 Jan 2009 12:40:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497F6B2E.6010305@gmail.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>
	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>
	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
	<c74595dc0901261107i66125bfdpe35cb7b89144ab11@mail.gmail.com>
	<497F6B2E.6010305@gmail.com>
Date: Tue, 27 Jan 2009 22:40:00 +0200
Message-ID: <c74595dc0901271240i2008cacdp565fe69f3269ea55@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1163142024=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1163142024==
Content-Type: multipart/alternative; boundary=0015175cde2cea90c804617cdb05

--0015175cde2cea90c804617cdb05
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, Jan 27, 2009 at 10:14 PM, Manu Abraham <abraham.manu@gmail.com>wrote:

> Alex Betis wrote:
> >> It won't. All you will manage to do is burn your demodulator, if you
> happen
> >> to
> >> be that lucky one, with that change. At least a few people have burned
> >> demodulators by now, from what i do see.
> >>
> > What are the symptoms of burned demodulator? How can someone know if its
> > still ok?
>
> The first time i saw it was that the DVB-S2 demod was returning no
> carrier. After some time it was stating timing error for DVB-S as
> well. Finally it all ended up with demodulator I2C ACK failure, and
> eventually a frozen machine after a week (my test boxes run throughout)
>
> Touching the demodulator, i happened to have almost a burned finger.
> I wanted to know whether this was a single case. During the
> development phase, i did mention it to Julian about this, since he
> was the very first person to test for the stb0899 driver. He
> jovially laughed about a burned demodulator and a finger, left his
> machine on after i did some tests on it. Eventually he too had the
> same results. Finally we changed cards.

What frequency did you use to burn it?

I didn't see anyone here on the list that reported a hardware failure so
far.

By the way, Igor returned the chip frequency for 27.5 channels to 99MHz and
raised it a bit for higher SR channels, so there is no danger for majority
of the users.


>
> >
> > Does your mantis driver work ok with such channels?
>
> I don't have such channels. Tested with a max of 27.5 MSPS
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

--0015175cde2cea90c804617cdb05
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Tue, Jan 27, 2009 at 10:14 P=
M, Manu Abraham <span dir=3D"ltr">&lt;<a href=3D"mailto:abraham.manu@gmail.=
com">abraham.manu@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt=
 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class=3D"Ih2E3d">Alex Betis wrote:<br>
&gt;&gt; It won&#39;t. All you will manage to do is burn your demodulator, =
if you happen<br>
&gt;&gt; to<br>
&gt;&gt; be that lucky one, with that change. At least a few people have bu=
rned<br>
&gt;&gt; demodulators by now, from what i do see.<br>
&gt;&gt;<br>
</div>&gt; What are the symptoms of burned demodulator? How can someone kno=
w if its<br>
&gt; still ok?<br>
<br>
The first time i saw it was that the DVB-S2 demod was returning no<br>
carrier. After some time it was stating timing error for DVB-S as<br>
well. Finally it all ended up with demodulator I2C ACK failure, and<br>
eventually a frozen machine after a week (my test boxes run throughout)<br>
<br>
Touching the demodulator, i happened to have almost a burned finger.<br>
I wanted to know whether this was a single case. During the<br>
development phase, i did mention it to Julian about this, since he<br>
was the very first person to test for the stb0899 driver. He<br>
jovially laughed about a burned demodulator and a finger, left his<br>
machine on after i did some tests on it. Eventually he too had the<br>
same results. Finally we changed cards.</blockquote><div>What frequency did=
 you use to burn it?<br><br>I didn&#39;t see anyone here on the list that r=
eported a hardware failure so far.<br><br>By the way, Igor returned the chi=
p frequency for 27.5 channels to 99MHz and raised it a bit for higher SR ch=
annels, so there is no danger for majority of the users.<br>
<br></div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid=
 rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
&gt;<br>
&gt; Does your mantis driver work ok with such channels?<br>
<br>
I don&#39;t have such channels. Tested with a max of 27.5 MSPS<br>
<div><div></div><div class=3D"Wj3C7c"><br>
Regards,<br>
Manu<br>
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
</div></div></blockquote></div><br></div>

--0015175cde2cea90c804617cdb05--


--===============1163142024==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1163142024==--
