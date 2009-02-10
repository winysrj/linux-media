Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.175])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LWrtT-00009f-3O
	for linux-dvb@linuxtv.org; Tue, 10 Feb 2009 13:39:15 +0100
Received: by wf-out-1314.google.com with SMTP id 28so2819387wfc.17
	for <linux-dvb@linuxtv.org>; Tue, 10 Feb 2009 04:39:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234217761.2790.15.camel@pc10.localdom.local>
References: <200902091233.26086.Nicola.Sabbi@poste.it>
	<1234217761.2790.15.camel@pc10.localdom.local>
Date: Tue, 10 Feb 2009 14:39:09 +0200
Message-ID: <c74595dc0902100439j66981bd7tc68b4a3d177abbe3@mail.gmail.com>
From: Alex Betis <alex.betis@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] mt352 no more working after suspend to disk
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0972737128=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0972737128==
Content-Type: multipart/alternative; boundary=001636e1fcd912f75504628fc624

--001636e1fcd912f75504628fc624
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I've tried to configure my system for suspends and here are my conclusions,
maybe it will be helpful:

Make sure no applications are using drivers that generally make problems
after suspend, that means you have to stop/kill them before suspending. I
use pm-utils script to stop application before suspend and start
applications after that.
Make sure you reload the drivers after resume. pm-utils has a feature to
unload modules before suspend and reload them after resume automatically,
check the SUSPEND_MODULES configuration. That method works fine for my DVB-S
drivers, but don't work for my WiFi card, so I had to reload the driver
after resume in my script.

Hope it helps.

On Tue, Feb 10, 2009 at 12:16 AM, hermann pitton <hermann-pitton@arcor.de>wrote:

> Hi Nico,
>
> Am Montag, den 09.02.2009, 12:33 +0100 schrieb Nico Sabbi:
> > Hi,
> > if I suspend to disk and next resume I have to manually remove and
> > reload my mt352 driver, otherwise it complains of a lot of i2c
> > errors.
> >
> > My kernel is suse's 2.6.27.
> >
> > Is this problem fixed in recent kernels or in hg?
> >
> > Thanks,
> >       Nico
> >
>
> don't know on what driver you report it, but since I know you also have
> saa7134 driver devices, nobody claimed so far that dvb is suspend/resume
> safe.
>
> I recently reported that people have to stay aware after resume, that
> even without using any dvb app actually during suspend, analog needs to
> be re-initialized first after that to get the tda10046 in a proper state
> for DVB-T again, at least on hybrid devices. Unshared DVB-S tuners and
> demods do stand this already. (medion 8800quad, CTX948, Asus 3in1)
>
> You can suspend to RAM on analog for example with a running tvtime and
> resume, but dma sound on saa7134-alsa is also not handled yet. Analog
> sound works.
>
> That is the status as far I have it.
>
> Cheers,
> Hermann
>
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

--001636e1fcd912f75504628fc624
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;ve tried to configure my system for suspends and her=
e are my conclusions, maybe it will be helpful:<br><br>Make sure no applica=
tions are using drivers that generally make problems after suspend, that me=
ans you have to stop/kill them before suspending. I use pm-utils script to =
stop application before suspend and start applications after that.<br>
Make sure you reload the drivers after resume. pm-utils has a feature to un=
load modules before suspend and reload them after resume automatically, che=
ck the SUSPEND_MODULES configuration. That method works fine for my DVB-S d=
rivers, but don&#39;t work for my WiFi card, so I had to reload the driver =
after resume in my script.<br>
<br>Hope it helps.<br><br><div class=3D"gmail_quote">On Tue, Feb 10, 2009 a=
t 12:16 AM, hermann pitton <span dir=3D"ltr">&lt;<a href=3D"mailto:hermann-=
pitton@arcor.de">hermann-pitton@arcor.de</a>&gt;</span> wrote:<br><blockquo=
te class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204)=
; margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi Nico,<br>
<br>
Am Montag, den 09.02.2009, 12:33 +0100 schrieb Nico Sabbi:<br>
&gt; Hi,<br>
&gt; if I suspend to disk and next resume I have to manually remove and<br>
&gt; reload my mt352 driver, otherwise it complains of a lot of i2c<br>
&gt; errors.<br>
&gt;<br>
&gt; My kernel is suse&#39;s 2.6.27.<br>
&gt;<br>
&gt; Is this problem fixed in recent kernels or in hg?<br>
&gt;<br>
&gt; Thanks,<br>
&gt; &nbsp; &nbsp; &nbsp; Nico<br>
&gt;<br>
<br>
don&#39;t know on what driver you report it, but since I know you also have=
<br>
saa7134 driver devices, nobody claimed so far that dvb is suspend/resume<br=
>
safe.<br>
<br>
I recently reported that people have to stay aware after resume, that<br>
even without using any dvb app actually during suspend, analog needs to<br>
be re-initialized first after that to get the tda10046 in a proper state<br=
>
for DVB-T again, at least on hybrid devices. Unshared DVB-S tuners and<br>
demods do stand this already. (medion 8800quad, CTX948, Asus 3in1)<br>
<br>
You can suspend to RAM on analog for example with a running tvtime and<br>
resume, but dma sound on saa7134-alsa is also not handled yet. Analog<br>
sound works.<br>
<br>
That is the status as far I have it.<br>
<br>
Cheers,<br>
Hermann<br>
<br>
<br>
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

--001636e1fcd912f75504628fc624--


--===============0972737128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0972737128==--
