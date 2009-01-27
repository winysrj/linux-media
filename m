Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRw0W-0003aO-VQ
	for linux-dvb@linuxtv.org; Tue, 27 Jan 2009 23:02:10 +0100
Received: by el-out-1112.google.com with SMTP id s27so1599539ele.14
	for <linux-dvb@linuxtv.org>; Tue, 27 Jan 2009 14:02:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497F7C40.6030300@gmail.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
	<c74595dc0901261107i66125bfdpe35cb7b89144ab11@mail.gmail.com>
	<497F6B2E.6010305@gmail.com>
	<c74595dc0901271240i2008cacdp565fe69f3269ea55@mail.gmail.com>
	<497F7C40.6030300@gmail.com>
Date: Wed, 28 Jan 2009 00:02:04 +0200
Message-ID: <c74595dc0901271402g5a44fe05pecae642570e54e0f@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1914163933=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1914163933==
Content-Type: multipart/alternative; boundary=000e0cd20b20685efa04617e01ab

--000e0cd20b20685efa04617e01ab
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, Jan 27, 2009 at 11:27 PM, Manu Abraham <abraham.manu@gmail.com>wrote:

> Alex Betis wrote:
> > On Tue, Jan 27, 2009 at 10:14 PM, Manu Abraham <abraham.manu@gmail.com
> >wrote:
> >
> >> Alex Betis wrote:
> >>>> It won't. All you will manage to do is burn your demodulator, if you
> >> happen
> >>>> to
> >>>> be that lucky one, with that change. At least a few people have burned
> >>>> demodulators by now, from what i do see.
> >>>>
> >>> What are the symptoms of burned demodulator? How can someone know if
> its
> >>> still ok?
> >> The first time i saw it was that the DVB-S2 demod was returning no
> >> carrier. After some time it was stating timing error for DVB-S as
> >> well. Finally it all ended up with demodulator I2C ACK failure, and
> >> eventually a frozen machine after a week (my test boxes run throughout)
> >>
> >> Touching the demodulator, i happened to have almost a burned finger.
> >> I wanted to know whether this was a single case. During the
> >> development phase, i did mention it to Julian about this, since he
> >> was the very first person to test for the stb0899 driver. He
> >> jovially laughed about a burned demodulator and a finger, left his
> >> machine on after i did some tests on it. Eventually he too had the
> >> same results. Finally we changed cards.
> >
> > What frequency did you use to burn it?
>
>
> It was a long time back, don't remember. It has nothing to do with
> the frequency of the transponder, but just the master clock. You can
> run it to a maximum of 108Mhz overclocked, 99Mhz to be safe and
> sufficient.
>
>
> > I didn't see anyone here on the list that reported a hardware failure so
> > far.
>
> May god help you. I didn't know that you knew more than the
> demodulator manufacturer !

Please speak for yourself, I never said I know more than a manufacturer.
I wrote a fact.
Intel also rate their chips and everybody overclocks them to crazy ratings.


>
>
>
> > By the way, Igor returned the chip frequency for 27.5 channels to 99MHz
> and
> > raised it a bit for higher SR channels, so there is no danger for
> majority
> > of the users.
>
> Ok, be happy with his change and keep quiet. 135Mhz is out of bounds
> of the hardware specification. You are on your own. Raising the
> master clock, doesn't bring you any advantage.

Did someone overclock you as well?
Chill out!
It would be better if you'll be more productive instead of quieting people
who try to help.

Again, I'm commenting facts. As I saw from the reports the overclock seems
to help with the problem.


>
> From your statement (and the patch), it is clearly evident that you
> don't understand head or tail what you are stating or patched the
> code for:

So be so kind, and add comments to the code you write so everybody could
find its head and tail when trying to fix bugs.
It is clearly evident that you don't really want that someone else will
understand your code.

Again, facts are that the patch help and make the device more stable for
DVB-S channels.



Oh well, I hate that I had to get so low with my message, but that's that
happen when someone try to align with your expressions.
In case you didn't know, you're not alone in the universe, get used to it.


>
> For a lower sampling frequency (aka Symbol rate), you need a higher
> clock and or higher time period. For higher sampling rates (Symbol
> Rates) the the master clock has to be decimated to  avoid overflows
>
> This implies the patch to increase the master clock for acquisition
> at a higher symbol rate was utter nonsense only.
>
> All i have is to say:
>
> Alas !
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--000e0cd20b20685efa04617e01ab
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Tue, Jan 27, 2009 at 11:27 P=
M, Manu Abraham <span dir=3D"ltr">&lt;<a href=3D"mailto:abraham.manu@gmail.=
com">abraham.manu@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt=
 0pt 0pt 0.8ex; padding-left: 1ex;">
Alex Betis wrote:<br>
&gt; On Tue, Jan 27, 2009 at 10:14 PM, Manu Abraham &lt;<a href=3D"mailto:a=
braham.manu@gmail.com">abraham.manu@gmail.com</a>&gt;wrote:<br>
&gt;<br>
&gt;&gt; Alex Betis wrote:<br>
&gt;&gt;&gt;&gt; It won&#39;t. All you will manage to do is burn your demod=
ulator, if you<br>
&gt;&gt; happen<br>
&gt;&gt;&gt;&gt; to<br>
&gt;&gt;&gt;&gt; be that lucky one, with that change. At least a few people=
 have burned<br>
&gt;&gt;&gt;&gt; demodulators by now, from what i do see.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt; What are the symptoms of burned demodulator? How can someone k=
now if its<br>
&gt;&gt;&gt; still ok?<br>
&gt;&gt; The first time i saw it was that the DVB-S2 demod was returning no=
<br>
&gt;&gt; carrier. After some time it was stating timing error for DVB-S as<=
br>
&gt;&gt; well. Finally it all ended up with demodulator I2C ACK failure, an=
d<br>
&gt;&gt; eventually a frozen machine after a week (my test boxes run throug=
hout)<br>
&gt;&gt;<br>
&gt;&gt; Touching the demodulator, i happened to have almost a burned finge=
r.<br>
&gt;&gt; I wanted to know whether this was a single case. During the<br>
&gt;&gt; development phase, i did mention it to Julian about this, since he=
<br>
&gt;&gt; was the very first person to test for the stb0899 driver. He<br>
&gt;&gt; jovially laughed about a burned demodulator and a finger, left his=
<br>
&gt;&gt; machine on after i did some tests on it. Eventually he too had the=
<br>
&gt;&gt; same results. Finally we changed cards.<br>
&gt;<br>
&gt; What frequency did you use to burn it?<br>
<br>
<br>
It was a long time back, don&#39;t remember. It has nothing to do with<br>
the frequency of the transponder, but just the master clock. You can<br>
run it to a maximum of 108Mhz overclocked, 99Mhz to be safe and<br>
sufficient.<br>
<br>
<br>
&gt; I didn&#39;t see anyone here on the list that reported a hardware fail=
ure so<br>
&gt; far.<br>
<br>
May god help you. I didn&#39;t know that you knew more than the<br>
demodulator manufacturer !</blockquote><div>Please speak for yourself, I ne=
ver said I know more than a manufacturer.<br>I wrote a fact.<br>Intel also =
rate their chips and everybody overclocks them to crazy ratings.<br>&nbsp;<=
br>
</div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb=
(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
<br>
&gt; By the way, Igor returned the chip frequency for 27.5 channels to 99MH=
z and<br>
&gt; raised it a bit for higher SR channels, so there is no danger for majo=
rity<br>
&gt; of the users.<br>
<br>
Ok, be happy with his change and keep quiet. 135Mhz is out of bounds<br>
of the hardware specification. You are on your own. Raising the<br>
master clock, doesn&#39;t bring you any advantage.</blockquote><div>Did som=
eone overclock you as well? <br>Chill out! <br>It would be better if you&#3=
9;ll be more productive instead of quieting people who try to help.<br>
<br>Again, I&#39;m commenting facts. As I saw from the reports the overcloc=
k seems to help with the problem.<br><br></div><blockquote class=3D"gmail_q=
uote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0=
pt 0.8ex; padding-left: 1ex;">
<br>
<br>
>From your statement (and the patch), it is clearly evident that you<br>
don&#39;t understand head or tail what you are stating or patched the<br>
code for:</blockquote><div>So be so kind, and add comments to the code you =
write so everybody could find its head and tail when trying to fix bugs. <b=
r>It is clearly evident that you don&#39;t really want that someone else wi=
ll understand your code.<br>
&nbsp;<br>Again, facts are that the patch help and make the device more sta=
ble for DVB-S channels.<br><br><br><br>Oh well, I hate that I had to get so=
 low with my message, but that&#39;s that happen when someone try to align =
with your expressions.<br>
In case you didn&#39;t know, you&#39;re not alone in the universe, get used=
 to it.<br><br></div><blockquote class=3D"gmail_quote" style=3D"border-left=
: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1e=
x;">
<br>
<br>
For a lower sampling frequency (aka Symbol rate), you need a higher<br>
clock and or higher time period. For higher sampling rates (Symbol<br>
Rates) the the master clock has to be decimated to &nbsp;avoid overflows<br=
>
<br>
This implies the patch to increase the master clock for acquisition<br>
at a higher symbol rate was utter nonsense only.<br>
<br>
All i have is to say:<br>
<br>
Alas !<br>
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

--000e0cd20b20685efa04617e01ab--


--===============1914163933==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1914163933==--
