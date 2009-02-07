Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1LVkvL-0001VB-33
	for linux-dvb@linuxtv.org; Sat, 07 Feb 2009 12:00:37 +0100
Date: Sat, 7 Feb 2009 11:57:13 +0100
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090207105713.GB19668@raven.wolf.lan>
References: <20090207015744.GA19668@raven.wolf.lan>
	<c74595dc0902070112k19946af8h8885dcdc73de8a55@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c74595dc0902070112k19946af8h8885dcdc73de8a55@mail.gmail.com>
Subject: Re: [linux-dvb] Tuning problems with loss of TS packets
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, Feb 07, 2009 at 11:12:25AM +0200, Alex Betis wrote:
[ ... ]
> > To be precise: on an already set-up transponder, re-executing this
> > function:
> >
> >  static void tune_frequency (int ifreq, int sr)
> >  {
> >      struct dvb_frontend_parameters tuneto;
> >
> >      tuneto.frequency = ifreq*1000;
> >      tuneto.inversion = INVERSION_AUTO;
> >      tuneto.u.qpsk.symbol_rate = sr*1000;
> >      tuneto.u.qpsk.fec_inner = FEC_AUTO;
> >
> >      if (ioctl(fefd, FE_SET_FRONTEND, &tuneto) == -1) {
> >          fatal ("FE_SET_FRONTEND failed: %s\n", strerror (errno));
> >      }
> >  }
> >
> > with _exactly_ the same values for ifreq and sr, is able to toggle from
> > good TS stream to bad TS stream or vice-versa.  As long as I avoid to
> > call this function, the quality of the stream does _not_ change.
> 
> I had exactly the same behavior of Twinhan SP-200 (1027) card until I
> totally gave up and bought Twinhan SP-400 (1041) card.
> Interesting if those 2 cards have the same components.

The cards I have are of those:
http://www.linuxtv.org/wiki/index.php/TechnoTrend_PCline_budget_DVB-S
Do you think the problem is related to hardware?

> > I have tried to use fixed values instead of *_AUTO for FEC and INVERSION,
> > but that did not help either.
> >
> > Any ideas?
> 
> What driver repository you use? And what driver is loaded for that card?
> My guess was that the tuner is not properly reset/set before the tuning.
> But (again) since I don't have any chip specification, I didn't have much
> progress with that.

  # lsmod|egrep '(dvb|budget|stv|saa|ttpci)'
  stv0299                11280  1
  budget_ci              18956  3
  budget_core            12332  1 budget_ci
  dvb_core               87948  3 stv0299,budget_ci,budget_core
  saa7146                18080  2 budget_ci,budget_core
  ttpci_eeprom            2520  1 budget_core
  ir_common              43340  1 budget_ci
  i2c_core               35280  5 stv0299,budget_ci,budget_core,ttpci_eeprom,i2c_piix4
  #

I have not yet compiled my own drivers, so I use the drivers that came
with the disro (opensuse-11.1, x86_64).  But I am about to dive into the
driver to narrow down the problem closer.  Any hint how to compile my
own drivers on opensuse?

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
