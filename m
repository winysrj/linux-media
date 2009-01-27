Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LRvWe-0001OY-T8
	for linux-dvb@linuxtv.org; Tue, 27 Jan 2009 22:31:17 +0100
Received: by wf-out-1314.google.com with SMTP id 27so7593948wfd.17
	for <linux-dvb@linuxtv.org>; Tue, 27 Jan 2009 13:31:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497F78E9.9090608@gmail.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
	<1232998154.24736.2@manu-laptop> <497F66E5.9060901@gmail.com>
	<c74595dc0901271237j7495ddeaif44288ad47416ddd@mail.gmail.com>
	<497F78E9.9090608@gmail.com>
Date: Tue, 27 Jan 2009 23:31:11 +0200
Message-ID: <c74595dc0901271331g19833f1fg3885084cd08a69fb@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0422837034=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0422837034==
Content-Type: multipart/alternative; boundary=000e0cd32d060275e504617d93a0

--000e0cd32d060275e504617d93a0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, Jan 27, 2009 at 11:13 PM, Manu Abraham <abraham.manu@gmail.com>wrote:

> Alex Betis wrote:
>
> > Manu,
> > I've tried to increase those timers long ago when played around with my
> card
> > (Twinhan 1041) and scan utility.
> > I must say that I've concentrated mostly on DVB-S channels that wasn't
> > always locking.
> > I didn't notice much improvements. The thing that did help was increasing
> > the resolution of scan zigzags.
>
> With regards to the zig-zag, one bug is fixed in the v4l-dvb tree.
> Most likely you haven't tried that change.

I use Igor's version, but he merges v4l changes quite often.
Can you point me to a patch or code that was changes? I want to make sure I
have that fix.


>
>
> > I've sent a patch on that ML and people were happy with the results.
>
> I did look at your patch, but that was completely against the tuning
> algorithm.

Well, you know, it works :)
What is the algorithm? I didn't make major changes beside increasing the
zigzag resolution for different scan stages and zigzag around the frequency
that previous stage was able to detect instead of starting from the
beginning. Sounds logical to me.


>
> [..]
>
> > I believe DVB-S2 lock suffer from the same problem, but in that case the
> > zigzag is done in the chip and not in the driver.
>
> Along with the patch i sent, does the attached patch help you in
> anyway (This works out for DVB-S2 only)?

I didn't tried to watch any DVB-S2 channels yet, not sure I have any FTA
with my current directions.
But I'll try that change later for scanning.

BTW, too bad the code has very few comments inside to understand all the
numeric values used for calculations.


>
>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--000e0cd32d060275e504617d93a0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Tue, Jan 27, 2009 at 11:13 P=
M, Manu Abraham <span dir=3D"ltr">&lt;<a href=3D"mailto:abraham.manu@gmail.=
com">abraham.manu@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt=
 0pt 0pt 0.8ex; padding-left: 1ex;">
Alex Betis wrote:<br>
<br>
&gt; Manu,<br>
&gt; I&#39;ve tried to increase those timers long ago when played around wi=
th my card<br>
&gt; (Twinhan 1041) and scan utility.<br>
&gt; I must say that I&#39;ve concentrated mostly on DVB-S channels that wa=
sn&#39;t<br>
&gt; always locking.<br>
&gt; I didn&#39;t notice much improvements. The thing that did help was inc=
reasing<br>
&gt; the resolution of scan zigzags.<br>
<br>
With regards to the zig-zag, one bug is fixed in the v4l-dvb tree.<br>
Most likely you haven&#39;t tried that change.</blockquote><div>I use Igor&=
#39;s version, but he merges v4l changes quite often. <br>Can you point me =
to a patch or code that was changes? I want to make sure I have that fix.<b=
r>
&nbsp;<br></div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px=
 solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><=
br>
<br>
&gt; I&#39;ve sent a patch on that ML and people were happy with the result=
s.<br>
<br>
I did look at your patch, but that was completely against the tuning<br>
algorithm.</blockquote><div>Well, you know, it works :)<br>What is the algo=
rithm? I didn&#39;t make major changes beside increasing the zigzag resolut=
ion for different scan stages and zigzag around the frequency that previous=
 stage was able to detect instead of starting from the beginning. Sounds lo=
gical to me.<br>
<br></div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid=
 rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
<br>
[..]<br>
<br>
&gt; I believe DVB-S2 lock suffer from the same problem, but in that case t=
he<br>
&gt; zigzag is done in the chip and not in the driver.<br>
<br>
Along with the patch i sent, does the attached patch help you in<br>
anyway (This works out for DVB-S2 only)?</blockquote><div>I didn&#39;t trie=
d to watch any DVB-S2 channels yet, not sure I have any FTA with my current=
 directions.<br>But I&#39;ll try that change later for scanning.<br><br>
BTW, too bad the code has very few comments inside to understand all the nu=
meric values used for calculations.<br>&nbsp;<br></div><blockquote class=3D=
"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0=
pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<br>
<br>
<br>_______________________________________________<br>
linux-dvb users mailing list<br>
For V4L/DVB development, please use instead <a href=3D"mailto:linux-media@v=
ger.kernel.org">linux-media@vger.kernel.org</a><br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br></blockquote></div><br></div>

--000e0cd32d060275e504617d93a0--


--===============0422837034==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0422837034==--
