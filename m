Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60958 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab0AGBw1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2010 20:52:27 -0500
Subject: Re: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)    
 tuning      regression
From: Andy Walls <awalls@radix.net>
To: Robert Lowery <rglowery@exemail.com.au>
Cc: mchehab@redhat.com,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Vincent McIntyre <vincent.mcintyre@gmail.com>,
	terrywu2009@gmail.com, linux-media@vger.kernel.org
In-Reply-To: <55306.115.70.135.213.1262748017.squirrel@webmail.exetel.com.au>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
	 <50104.115.70.135.213.1259224041.squirrel@webmail.exetel.com.au>
	 <702870ef0911260137r35f1784exc27498d0db3769c2@mail.gmail.com>
	 <56069.115.70.135.213.1259234530.squirrel@webmail.exetel.com.au>
	 <46566.64.213.30.2.1259278557.squirrel@webmail.exetel.com.au>
	 <702870ef0912010118r1e5e3been840726e6364d991a@mail.gmail.com>
	 <829197380912020657v52e42690k46172f047ebd24b0@mail.gmail.com>
	 <36364.64.213.30.2.1260252173.squirrel@webmail.exetel.com.au>
	 <1328.64.213.30.2.1260920972.squirrel@webmail.exetel.com.au>
	 <2088.115.70.135.213.1262579258.squirrel@webmail.exetel.com.au>
	 <1262658469.3054.48.camel@palomino.walls.org>
	 <1262661512.3054.67.camel@palomino.walls.org>
	 <55306.115.70.135.213.1262748017.squirrel@webmail.exetel.com.au>
Content-Type: text/plain
Date: Wed, 06 Jan 2010 20:51:39 -0500
Message-Id: <1262829099.3065.61.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-01-06 at 14:20 +1100, Robert Lowery wrote:
> > On Mon, 2010-01-04 at 21:27 -0500, Andy Walls wrote:
> >> On Mon, 2010-01-04 at 15:27 +1100, Robert Lowery wrote:
> >> > > Mauro,
> >> > >
> >> > > I've split the revert2.diff that I sent you previously to fix the
> >> tuning
> >> > > regression on my DViCO Dual Digital 4 (rev 1) into three separate
> >> patches
> >> > > that will hopefully allow you to review more easily.
> >> > >
> >> > > The first two patches revert their respective changesets and
> nothing
> >> else,
> >> > > fixing the issue for me.
> >> > > 12167:966ce12c444d tuner-xc2028: Fix 7 MHz DVB-T
> >> > > 11918:e6a8672631a0 tuner-xc2028: Fix offset frequencies for DVB @
> >> 6MHz
> >> > >
> >> > > The third patch does what I believe is the obvious equivalent fix
> to
> >> > > e6a8672631a0 but without the cleanup that breaks tuning on my card.
> >> > >
> >> > > Please review and merge
> >> > >
> >> > > Signed-off-by: Robert Lowery <rglowery@exemail.com.au>
> >> >
> >> > Mauro,
> >> >
> >> > I'm yet to receive a response from you on this clear regression
> >> introduced
> >> > in the 2.6.31 kernel.  You attention would be appreciated
> >> >
> >> > Thanks
> >> >
> >> > -Rob
> >> Robert,
> >> The changes in question (mostly authored by me) are based on
> >> documentation on what offsets are to be used with the firmware for
> various DVB bandwidths and demodulators.  The change was tested by Terry
> >> on a Leadtek DVR 3100 H Analog/DVB-T card (CX23418, ZL10353, XC3028)
> and
> >> some other cards I can't remember, using a DVB-T pattern generator for
> 7
> >> and 8 MHz in VHF and UHF, and live DVB-T broadcasts in UHF for 6 MHz.
> (Devin,
> >>  Maybe you can double check on the offsets in tuner-xc2028.c with any
> documentation you have available to you?)
> >> I haven't been following this thread really at all as the board in the
> subject line was unfamiliar to me, so sorry for any late response or dumb
> questions by me.
> >> May I ask:
> >> 1. what are the exact problem frequencies?
> >> 2. what is the data source from which you are getting the frequency
> information?
> >> 3. what does tuner-xc2028 debug logging show as the firmware loaded
> when
> >> tune to one of the the problem frequencies?
> >
> >
> > Robert,
> >
> > I just found that ACMA has a very nice compilation licensed DTV
> > transmitters in Australia and their frequencies.  Have a look at the
> Excel spreadsheet linked on this page:
> >
> > 	http://acma.gov.au/WEB/STANDARD/pc=PC_9150
> >
> > The DTV tab has a list of the Area, callsign, and DTV center freq. The
> Glossary tab mentions that DTV broadcasters can have an offset of +/- 125
> kHz from the DTV center freq.
> >
> > If you could verify that the frequencies you are using for the problem
> stations match the list, that would help eliminate commanded tuning
> frequency as source of the problem.
> 
> Andy, I don't think this issue is frequency, it is the removal of the
> 500kHz offset.

OK.  I forgot there were two offsets at play here: one for the RF
frequency and one for the SCODE/Intermediate Frequency.

Right, the S-CODE offsets are somewhat of a mystery to me as I don't
exactly know the mathematical basis behind them.  The 500 kHz came from
the best interpretation Maruo and I could make at the time, but it could
very well be the wrong thing.  (I was guessing it came from a relation
something like this: 8 MHz - 7 MHz / 2 = 500 kHz)

If it is the wrong thing, and it looks like it could be, we can back it
out.  As my colleauge, who used to work at CERN, says "Experiment trumps
theory ... *every* time".  Terry had positive results, you and Vincent
have negative results.  So I'd like to see what Devin finds, if he can
test with a DVB-T generator.



> The channel with the biggest problem (most stuttering) is Channel 8 in
> Melbourne, which looks correct at 191.625 MHz on the above site.

OK.  Vincent must have been the one with all the Sydney stations.

DTV Channel GTV8 (Fc = 191.625 MHz at 50 kW) for Melbourne is
interesting; it comes from the same towers as the adjacent analog
channels HSV7 (Fr = 182.25 MHz @ 200 kW) and GTV9 (Fr = 196.25 MHz @ 200
kW).

I guess if anything is off center when setting up the XC3028, the analog
stations may show up as strong noise - a situation that would not be
obvious with a single channel DVB-T signal generator.  GTV8 is probably
a good channel for you to use for testing.


(BTW, given that the analog channel of where GTV8 now resides would have
been Fr = 189.25 MHz, I would have expected GTV8 to really be operating
at Fc = Fr + 2.25 MHz = 191.50 MHz and not 191.625 MHz)



> With debug enabled on the the current hg tip (stuttering case) we have
> divisor= 00 00 2f 58 (freq=191.625)
> 
> With the patch reverted (working case)
> divisor= 00 00 2f 38 (freq=191.625)
> 
> Have you reviewed my patch.  It leaves your original DTV6 fix in place,
> but reverts the cleanup which broke the offset calculation for me.

I don't have a copy in my email archives, I'll have to go check for them
on the list archives.

Regards,
Andy

> -Rob
> 
> >
> > Regards,
> > Andy
> >
> >
> >> BTW, I note that in linux/drivers/media/dvb/dvb-usb/cxusb.c:
> >> cxusb_dvico_xc3028_tuner_attach(), this declaration
> >>         static struct xc2028_ctrl ctl = {
> >>                 .fname       = XC2028_DEFAULT_FIRMWARE,
> >>                 .max_len     = 64,
> >>                 .demod       = XC3028_FE_ZARLINK456,
> >>         };
> >> really should have ".type = XC2028_AUTO" or ".type = XC2028_D2633", but
> since XC2028_AUTO has a value of 0, it probably doesn't matter.
> Regards,
> >> Andy


