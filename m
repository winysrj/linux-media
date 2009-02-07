Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LVlfH-0004QM-Ny
	for linux-dvb@linuxtv.org; Sat, 07 Feb 2009 12:48:06 +0100
Received: by qyk9 with SMTP id 9so1731139qyk.17
	for <linux-dvb@linuxtv.org>; Sat, 07 Feb 2009 03:47:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090207105713.GB19668@raven.wolf.lan>
References: <20090207015744.GA19668@raven.wolf.lan>
	<c74595dc0902070112k19946af8h8885dcdc73de8a55@mail.gmail.com>
	<20090207105713.GB19668@raven.wolf.lan>
Date: Sat, 7 Feb 2009 13:47:29 +0200
Message-ID: <c74595dc0902070347p62f8453cpf584ba702b43e934@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1200528015=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1200528015==
Content-Type: multipart/alternative; boundary=0015175cd2eec5003a046252b397

--0015175cd2eec5003a046252b397
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Sat, Feb 7, 2009 at 12:57 PM, Josef Wolf <jw@raven.inka.de> wrote:

> On Sat, Feb 07, 2009 at 11:12:25AM +0200, Alex Betis wrote:
> [ ... ]
> > > To be precise: on an already set-up transponder, re-executing this
> > > function:
> > >
> > >  static void tune_frequency (int ifreq, int sr)
> > >  {
> > >      struct dvb_frontend_parameters tuneto;
> > >
> > >      tuneto.frequency = ifreq*1000;
> > >      tuneto.inversion = INVERSION_AUTO;
> > >      tuneto.u.qpsk.symbol_rate = sr*1000;
> > >      tuneto.u.qpsk.fec_inner = FEC_AUTO;
> > >
> > >      if (ioctl(fefd, FE_SET_FRONTEND, &tuneto) == -1) {
> > >          fatal ("FE_SET_FRONTEND failed: %s\n", strerror (errno));
> > >      }
> > >  }
> > >
> > > with _exactly_ the same values for ifreq and sr, is able to toggle from
> > > good TS stream to bad TS stream or vice-versa.  As long as I avoid to
> > > call this function, the quality of the stream does _not_ change.
> >
> > I had exactly the same behavior of Twinhan SP-200 (1027) card until I
> > totally gave up and bought Twinhan SP-400 (1041) card.
> > Interesting if those 2 cards have the same components.
>
> The cards I have are of those:
> http://www.linuxtv.org/wiki/index.php/TechnoTrend_PCline_budget_DVB-S
> Do you think the problem is related to hardware?


Since the tuning works from time to time, I tend to think that its a driver
problem.


>
>
> > > I have tried to use fixed values instead of *_AUTO for FEC and
> INVERSION,
> > > but that did not help either.
> > >
> > > Any ideas?
> >
> > What driver repository you use? And what driver is loaded for that card?
> > My guess was that the tuner is not properly reset/set before the tuning.
> > But (again) since I don't have any chip specification, I didn't have much
> > progress with that.
>
>  # lsmod|egrep '(dvb|budget|stv|saa|ttpci)'
>  stv0299                11280  1
>  budget_ci              18956  3
>  budget_core            12332  1 budget_ci
>  dvb_core               87948  3 stv0299,budget_ci,budget_core
>  saa7146                18080  2 budget_ci,budget_core
>  ttpci_eeprom            2520  1 budget_core
>  ir_common              43340  1 budget_ci
>  i2c_core               35280  5
> stv0299,budget_ci,budget_core,ttpci_eeprom,i2c_piix4
>  #
>
Don't remember when drivers it used, I've removed it from my box long ago.


>
> I have not yet compiled my own drivers, so I use the drivers that came
> with the disro (opensuse-11.1, x86_64).  But I am about to dive into the
> driver to narrow down the problem closer.  Any hint how to compile my
> own drivers on opensuse?

I dont have opensuse, but I'd suggest to use this repository:
http://mercurial.intuxication.org/hg/s2-liplianin


>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--0015175cd2eec5003a046252b397
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Sat, Feb 7, 2009 at 12:57 PM=
, Josef Wolf <span dir=3D"ltr">&lt;<a href=3D"mailto:jw@raven.inka.de">jw@r=
aven.inka.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" sty=
le=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex;=
 padding-left: 1ex;">
On Sat, Feb 07, 2009 at 11:12:25AM +0200, Alex Betis wrote:<br>
[ ... ]<br>
&gt; &gt; To be precise: on an already set-up transponder, re-executing thi=
s<br>
&gt; &gt; function:<br>
&gt; &gt;<br>
&gt; &gt; &nbsp;static void tune_frequency (int ifreq, int sr)<br>
&gt; &gt; &nbsp;{<br>
&gt; &gt; &nbsp; &nbsp; &nbsp;struct dvb_frontend_parameters tuneto;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp; &nbsp; &nbsp;tuneto.frequency =3D ifreq*1000;<br>
&gt; &gt; &nbsp; &nbsp; &nbsp;tuneto.inversion =3D INVERSION_AUTO;<br>
&gt; &gt; &nbsp; &nbsp; &nbsp;tuneto.u.qpsk.symbol_rate =3D sr*1000;<br>
&gt; &gt; &nbsp; &nbsp; &nbsp;tuneto.u.qpsk.fec_inner =3D FEC_AUTO;<br>
&gt; &gt;<br>
&gt; &gt; &nbsp; &nbsp; &nbsp;if (ioctl(fefd, FE_SET_FRONTEND, &amp;tuneto)=
 =3D=3D -1) {<br>
&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;fatal (&quot;FE_SET_FRONTEND fa=
iled: %s\n&quot;, strerror (errno));<br>
&gt; &gt; &nbsp; &nbsp; &nbsp;}<br>
&gt; &gt; &nbsp;}<br>
&gt; &gt;<br>
&gt; &gt; with _exactly_ the same values for ifreq and sr, is able to toggl=
e from<br>
&gt; &gt; good TS stream to bad TS stream or vice-versa. &nbsp;As long as I=
 avoid to<br>
&gt; &gt; call this function, the quality of the stream does _not_ change.<=
br>
&gt;<br>
&gt; I had exactly the same behavior of Twinhan SP-200 (1027) card until I<=
br>
&gt; totally gave up and bought Twinhan SP-400 (1041) card.<br>
&gt; Interesting if those 2 cards have the same components.<br>
<br>
The cards I have are of those:<br>
<a href=3D"http://www.linuxtv.org/wiki/index.php/TechnoTrend_PCline_budget_=
DVB-S" target=3D"_blank">http://www.linuxtv.org/wiki/index.php/TechnoTrend_=
PCline_budget_DVB-S</a><br>
Do you think the problem is related to hardware?</blockquote><div><br>Since=
 the tuning works from time to time, I tend to think that its a driver prob=
lem.<br>&nbsp;<br></div><blockquote class=3D"gmail_quote" style=3D"border-l=
eft: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left:=
 1ex;">
<br>
<br>
&gt; &gt; I have tried to use fixed values instead of *_AUTO for FEC and IN=
VERSION,<br>
&gt; &gt; but that did not help either.<br>
&gt; &gt;<br>
&gt; &gt; Any ideas?<br>
&gt;<br>
&gt; What driver repository you use? And what driver is loaded for that car=
d?<br>
&gt; My guess was that the tuner is not properly reset/set before the tunin=
g.<br>
&gt; But (again) since I don&#39;t have any chip specification, I didn&#39;=
t have much<br>
&gt; progress with that.<br>
<br>
 &nbsp;# lsmod|egrep &#39;(dvb|budget|stv|saa|ttpci)&#39;<br>
 &nbsp;stv0299 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;11280=
 &nbsp;1<br>
 &nbsp;budget_ci &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;18956 &nbs=
p;3<br>
 &nbsp;budget_core &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;12332 &nbsp;1 b=
udget_ci<br>
 &nbsp;dvb_core &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 87948 &nbs=
p;3 stv0299,budget_ci,budget_core<br>
 &nbsp;saa7146 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;18080=
 &nbsp;2 budget_ci,budget_core<br>
 &nbsp;ttpci_eeprom &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2520 &nbsp;1 b=
udget_core<br>
 &nbsp;ir_common &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;43340 &nbs=
p;1 budget_ci<br>
 &nbsp;i2c_core &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 35280 &nbs=
p;5 stv0299,budget_ci,budget_core,ttpci_eeprom,i2c_piix4<br>
 &nbsp;#<br>
</blockquote><div>Don&#39;t remember when drivers it used, I&#39;ve removed=
 it from my box long ago.<br>&nbsp;<br></div><blockquote class=3D"gmail_quo=
te" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt=
 0.8ex; padding-left: 1ex;">
<br>
I have not yet compiled my own drivers, so I use the drivers that came<br>
with the disro (opensuse-11.1, x86_64). &nbsp;But I am about to dive into t=
he<br>
driver to narrow down the problem closer. &nbsp;Any hint how to compile my<=
br>
own drivers on opensuse?</blockquote><div>I dont have opensuse, but I&#39;d=
 suggest to use this repository:<br><a href=3D"http://mercurial.intuxicatio=
n.org/hg/s2-liplianin">http://mercurial.intuxication.org/hg/s2-liplianin</a=
><br>
&nbsp;<br></div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px=
 solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><=
br>
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

--0015175cd2eec5003a046252b397--


--===============1200528015==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1200528015==--
