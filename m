Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LVjFE-0003NU-0Z
	for linux-dvb@linuxtv.org; Sat, 07 Feb 2009 10:13:00 +0100
Received: by qyk9 with SMTP id 9so1706199qyk.17
	for <linux-dvb@linuxtv.org>; Sat, 07 Feb 2009 01:12:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090207015744.GA19668@raven.wolf.lan>
References: <20090207015744.GA19668@raven.wolf.lan>
Date: Sat, 7 Feb 2009 11:12:25 +0200
Message-ID: <c74595dc0902070112k19946af8h8885dcdc73de8a55@mail.gmail.com>
From: Alex Betis <alex.betis@gmail.com>
To: linux-media@vger.kernel.org, Josef Wolf <jw@raven.inka.de>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Tuning problems with loss of TS packets
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1699741919=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1699741919==
Content-Type: multipart/alternative; boundary=0015175cb7c6342792046250891a

--0015175cb7c6342792046250891a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Sat, Feb 7, 2009 at 3:57 AM, Josef Wolf <jw@raven.inka.de> wrote:

> Hello,
>
> sometimes, I experience non-deterministic problems with tuning on some
> transponders with dvb-s.  For example, on astra-H-11954, I have about
> 50% chance to get a good tune.  If I get a bad tune, I still receive
> TS packets from the chosen transponder, but about 10%..20% of the
> packets are lost.  The (remaining) packets contain PAT/PMT/PES packets
> from the chosen transponder, so it is pretty safe to assume that
> actual tuning worked properly.
>
> What I do is pretty much straight forward:
>
>  1. open frontend/dmx/dvr devices
>  2. send diseqc command to switch to desired input
>  3. use FE_SET_FRONTEND ioctl to tune to desired transponder
>  4. wait for FE_HAS_LOCK
>  5. set dmx_pesfilter_params to:
>         pid:      0x2000  /* yes, I want the whole transponder */
>         input:    DMX_IN_FRONTEND
>         output:   DMX_OUT_TS_TAP
>         pes_type: DMX_PES_OTHER
>         flags:    DMX_IMMEDIATE_START
>
> With this sequence, I have about 50% chance to receive a proper TS
> stream.  When the stream is not OK, I can see about 10%..20% loss
> of TS packets.
>
> I have checked signal quality, but there is no significant difference
> from working to non-working:
>
>   Status:1f sig:ac80 snr:d9e0 ber:00000000 unc:fffffffe FE_HAS_LOCK
>   Status:1f sig:adbe snr:dac4 ber:00000000 unc:fffffffe FE_HAS_LOCK
>
> So I have tried to narrow the problem, and I think I've come pretty
> close (but still no cigar):
>
> Once the sequence (which is listed above) is completed, I can easily
> (but randomly, IOW: I have to try 1..3 times) switch from proper stream
> to broken stream and vice-versa simply by repeating step 3 with _exactly_
> the _same_ values.
>
> To be precise: on an already set-up transponder, re-executing this
> function:
>
>  static void tune_frequency (int ifreq, int sr)
>  {
>      struct dvb_frontend_parameters tuneto;
>
>      tuneto.frequency = ifreq*1000;
>      tuneto.inversion = INVERSION_AUTO;
>      tuneto.u.qpsk.symbol_rate = sr*1000;
>      tuneto.u.qpsk.fec_inner = FEC_AUTO;
>
>      if (ioctl(fefd, FE_SET_FRONTEND, &tuneto) == -1) {
>          fatal ("FE_SET_FRONTEND failed: %s\n", strerror (errno));
>      }
>  }
>
> with _exactly_ the same values for ifreq and sr, is able to toggle from
> good TS stream to bad TS stream or vice-versa.  As long as I avoid to
> call this function, the quality of the stream does _not_ change.

I had exactly the same behavior of Twinhan SP-200 (1027) card until I
totally gave up and bought Twinhan SP-400 (1041) card.
Interesting if those 2 cards have the same components.


>
>
> I have tried to use fixed values instead of *_AUTO for FEC and INVERSION,
> but that did not help either.
>
> Any ideas?

What driver repository you use? And what driver is loaded for that card?
My guess was that the tuner is not properly reset/set before the tuning.
But (again) since I don't have any chip specification, I didn't have much
progress with that.



>
>
> BTW:
>  $ lspci -v
>  [ ... ]
>  03:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: Technotrend Systemtechnik GmbH
> Technotrend-Budget/Hauppauge WinTV-NOVA-CI DVB card
>         Flags: bus master, medium devsel, latency 32, IRQ 21
>         Memory at fdcfe000 (32-bit, non-prefetchable) [size=512]
>         Kernel driver in use: budget_ci dvb
>         Kernel modules: snd-aw2, budget-ci
>  $ uname -a
>  Linux raven 2.6.27.7-9-default #1 SMP 2008-12-04 18:10:04 +0100 x86_64
> x86_64 x86_64 GNU/Linux
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--0015175cb7c6342792046250891a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Sat, Feb 7, 2009 at 3:57 AM,=
 Josef Wolf <span dir=3D"ltr">&lt;<a href=3D"mailto:jw@raven.inka.de">jw@ra=
ven.inka.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; =
padding-left: 1ex;">
Hello,<br>
<br>
sometimes, I experience non-deterministic problems with tuning on some<br>
transponders with dvb-s. &nbsp;For example, on astra-H-11954, I have about<=
br>
50% chance to get a good tune. &nbsp;If I get a bad tune, I still receive<b=
r>
TS packets from the chosen transponder, but about 10%..20% of the<br>
packets are lost. &nbsp;The (remaining) packets contain PAT/PMT/PES packets=
<br>
from the chosen transponder, so it is pretty safe to assume that<br>
actual tuning worked properly.<br>
<br>
What I do is pretty much straight forward:<br>
<br>
 &nbsp;1. open frontend/dmx/dvr devices<br>
 &nbsp;2. send diseqc command to switch to desired input<br>
 &nbsp;3. use FE_SET_FRONTEND ioctl to tune to desired transponder<br>
 &nbsp;4. wait for FE_HAS_LOCK<br>
 &nbsp;5. set dmx_pesfilter_params to:<br>
 &nbsp; &nbsp; &nbsp; &nbsp; pid: &nbsp; &nbsp; &nbsp;0x2000 &nbsp;/* yes, =
I want the whole transponder */<br>
 &nbsp; &nbsp; &nbsp; &nbsp; input: &nbsp; &nbsp;DMX_IN_FRONTEND<br>
 &nbsp; &nbsp; &nbsp; &nbsp; output: &nbsp; DMX_OUT_TS_TAP<br>
 &nbsp; &nbsp; &nbsp; &nbsp; pes_type: DMX_PES_OTHER<br>
 &nbsp; &nbsp; &nbsp; &nbsp; flags: &nbsp; &nbsp;DMX_IMMEDIATE_START<br>
<br>
With this sequence, I have about 50% chance to receive a proper TS<br>
stream. &nbsp;When the stream is not OK, I can see about 10%..20% loss<br>
of TS packets.<br>
<br>
I have checked signal quality, but there is no significant difference<br>
from working to non-working:<br>
<br>
 &nbsp; Status:1f sig:ac80 snr:d9e0 ber:00000000 unc:fffffffe FE_HAS_LOCK<b=
r>
 &nbsp; Status:1f sig:adbe snr:dac4 ber:00000000 unc:fffffffe FE_HAS_LOCK<b=
r>
<br>
So I have tried to narrow the problem, and I think I&#39;ve come pretty<br>
close (but still no cigar):<br>
<br>
Once the sequence (which is listed above) is completed, I can easily<br>
(but randomly, IOW: I have to try 1..3 times) switch from proper stream<br>
to broken stream and vice-versa simply by repeating step 3 with _exactly_<b=
r>
the _same_ values.<br>
<br>
To be precise: on an already set-up transponder, re-executing this<br>
function:<br>
<br>
 &nbsp;static void tune_frequency (int ifreq, int sr)<br>
 &nbsp;{<br>
 &nbsp; &nbsp; &nbsp;struct dvb_frontend_parameters tuneto;<br>
<br>
 &nbsp; &nbsp; &nbsp;tuneto.frequency =3D ifreq*1000;<br>
 &nbsp; &nbsp; &nbsp;tuneto.inversion =3D INVERSION_AUTO;<br>
 &nbsp; &nbsp; &nbsp;tuneto.u.qpsk.symbol_rate =3D sr*1000;<br>
 &nbsp; &nbsp; &nbsp;tuneto.u.qpsk.fec_inner =3D FEC_AUTO;<br>
<br>
 &nbsp; &nbsp; &nbsp;if (ioctl(fefd, FE_SET_FRONTEND, &amp;tuneto) =3D=3D -=
1) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;fatal (&quot;FE_SET_FRONTEND failed: %s\=
n&quot;, strerror (errno));<br>
 &nbsp; &nbsp; &nbsp;}<br>
 &nbsp;}<br>
<br>
with _exactly_ the same values for ifreq and sr, is able to toggle from<br>
good TS stream to bad TS stream or vice-versa. &nbsp;As long as I avoid to<=
br>
call this function, the quality of the stream does _not_ change.</blockquot=
e><div>I had exactly the same behavior of Twinhan SP-200 (1027) card until =
I totally gave up and bought Twinhan SP-400 (1041) card.<br>Interesting if =
those 2 cards have the same components.<br>
&nbsp;<br></div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px=
 solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><=
br>
<br>
I have tried to use fixed values instead of *_AUTO for FEC and INVERSION,<b=
r>
but that did not help either.<br>
<br>
Any ideas?</blockquote><div>What driver repository you use? And what driver=
 is loaded for that card?<br></div><div>My guess was that the tuner is not =
properly reset/set before the tuning.<br>But (again) since I don&#39;t have=
 any chip specification, I didn&#39;t have much progress with that.<br>
<br><br></div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px s=
olid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br=
>
<br>
<br>
BTW:<br>
&nbsp;$ lspci -v<br>
&nbsp;[ ... ]<br>
&nbsp;03:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01=
)<br>
 &nbsp; &nbsp; &nbsp; &nbsp; Subsystem: Technotrend Systemtechnik GmbH Tech=
notrend-Budget/Hauppauge WinTV-NOVA-CI DVB card<br>
 &nbsp; &nbsp; &nbsp; &nbsp; Flags: bus master, medium devsel, latency 32, =
IRQ 21<br>
 &nbsp; &nbsp; &nbsp; &nbsp; Memory at fdcfe000 (32-bit, non-prefetchable) =
[size=3D512]<br>
 &nbsp; &nbsp; &nbsp; &nbsp; Kernel driver in use: budget_ci dvb<br>
 &nbsp; &nbsp; &nbsp; &nbsp; Kernel modules: snd-aw2, budget-ci<br>
&nbsp;$ uname -a<br>
&nbsp;Linux raven 2.6.27.7-9-default #1 SMP 2008-12-04 18:10:04 +0100 x86_6=
4 x86_64 x86_64 GNU/Linux<br>
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

--0015175cb7c6342792046250891a--


--===============1699741919==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1699741919==--
