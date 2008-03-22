Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jd1dC-0007gw-St
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 12:11:28 +0100
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 22 Mar 2008 07:11:06 +0100
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<47E3D790.4020004@gmail.com> <47E3E89B.3040305@gmail.com>
In-Reply-To: <47E3E89B.3040305@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803220711.07186@orion.escape-edv.de>
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
	transponder fails
Reply-To: linux-dvb@linuxtv.org
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

Hi Manu,

Manu Abraham wrote:
> Manu Abraham wrote:
> > Hi Oliver,
> > 
> > Oliver Endriss wrote:
> >> Hi,
> >>
> >> Manu Abraham wrote:
> >>> Hi Hartmut,
> >>>
> >>> Hartmut Hackmann wrote:
> >>>
> >>>> This might be right! I could not get good information regarding the
> >>>> transponder bandwidths. We might need to make this depend on the
> >>>> symbol rate or a module parameter.
> >>> You can calculate the tuner bandwidth from the transponder symbol rate
> >>> (in Mbaud) for DVB-S:
> >>>
> >>> BW = (1 + RO) * SR/2 + 5) * 1.3
> >> Apparently I need some lessons in signal theory. ;-)
> >> What does R0 stand for?
> > 
> > RO stands for Rolloff. This isn't anything big, but just defines the
> > sharpness of the bandwidth curve. You can think how a filter's bandwidth
> > would look like, when it is plotted out. This is just a filter
> > characteristic.
> > 
> > Normally why you need this is not new. Traditionally for old PLL based
> > tuners, this used to be in hardware, ie a LC component in the pre
> > stages, prior to the tuner.
> > 
> > With the arrival of Silicon Tuners, things do have changed. These things
> > have been made software configurable. There are advantages and
> > disadvantages to this. Well, there's so much that can talked about it,
> > but well let me not make it too long.
> > 
> > For Broadcast applications, ie all TV signals that we receive RO = 35%
> > We do have other rolloff as well, but generally the others are not used
> > in broadcast apps, but for professional purposes. When you have a lower
> > rolloff, what happens is that the filter is more of a tuned filter and
> > considered narrower slightly.
> > 
> > The advantage of a narrower filter is that since the edges fall of
> > sharply, lesser power is wasted, but brings in the disadvantage that the
> > spectrum is a bit more congested, but alternatibvely somebody could just
> > argue as well, you can pack in more into the entire spectrum.

Thank you for these detailed explanations. This stuff is sometimes hard
to understand for someone who only deals with electronics as a hobby.
;-)

> >> Do we have to select a higher cut-off value to compensate for the LNB
> >> drift and other stuff like that?
> > 
> > The "5" in there, is in fact implies +/-5Mhz for the LNB drift (5 Mhz on
> > either side off the offset. A LNB can drift in either direction at
> > different periods of the day, depending on the temperature. This drift
> > can cause an acquisition to fail, or an already acquired LOCK to fail on
> > a very general note). The drift is standard and is specified in one of
> > the ETSI specifications, one which i read a while back but don't
> > remember the specification number.

Ok, some calculations according your formula

> >>> BW = (1 + RO) * SR/2 + 5) * 1.3

45 MSPS:
BW = ((1 + 0.35) * 45/2 + 5) * 1.3 = 46

-> cutoff 36 MHz (maximum value supported)

27 MSPS:
BW = ((1 + 0.35) * 27/2 + 5) * 1.3 = 30,2

-> cutoff 31 MHz

22 MSPS:
BW = ((1 + 0.35) * 22/2 + 5) * 1.3 = 25,8

-> cutoff 26 MHz

Are these calculations correct, or did I miss something here?

> I just looked at the tuner (TDA8262) datasheet, it says:
> 
> The internal circuitry performs the Zero-IF quadrature frequency
> conversion and two in-phase (IP/IN) and two quadrature(QP/QN) output
> signals can directly be used to feed a Satellite Demodulator and Decoder
> circuit (SDD). Low pass filter cut-off frequency can be adjusted from 5
> MHz to 36 MHz in 32 steps.

(See table 14 in the datasheet.)

> This allows a large flexibility in the SDD 
> input. 10 gain values are present at output amplifier to compensate
> cut-off frequency adjustment and single output application.
> 
> 
> 
> 
> Maybe, the best thing to do is divide the spectrum into 32 parts with
> the lower end at 5MHz and the upper end at 36Mhz equi-distantly. I don't
> know  why it is done in steps as mentioned in there, but i think it is
> due to a NCO (Numerically Controlled Oscillator) which has 32 steps.
> 
> With these different steps, based on the calculation, you can slightly
> optimize the offset if needed for the ones at the end of the spectrum,
> from what you calculated out.

Afaics a simple pre-calculated lookup table with 32 entries should do
the job. At least for the cut-off frequency.

> Also note that, the tuner can do 5 - 36 Mhz, so 45 MSPS will be at the
> very last block and in the case of almost all silicon tuners will need a
> bit of care to handle properly, also you might see a higher BER in some
> cases when the filter cannot be pushed to what extend it needs to be.
> 
> I took a look at the driver, tda826x.c, just saw how simple that driver
> looks. No wonder ... Even with the vendors, there are just a few people
> who can really explain all the aspects.
> 
> (RF and math can sometimes be considered as drinking and driving on a
> much lighter aspect, when used "properly", anyone who looks at it, won't
> understand what's going on and what would happen next, in most cases,
> unless you are in the same state, where you might tend to be in the same
> harmonic. Maybe that's why some people claim that beer provides a much
> higher level of success. ;-) )

Ah - now I understand why our drivers work surprisingly well. We ignore
all math due to lack of support from the vendors, and rely on the
assumption that the chip designers had enough beer. :-)

> The worst part in there is that, like all Silicon tuners, gain also
> plays a significant part. Normally the vendor provides what gain is
> required for each step, but the datasheet doesn't seem to specify that
> any place. Normally the higher gain will be applied to the lower SR, and
> the lower gain to the higher SR. Maybe you can experiment with the gain
> distribution with regards to the SR.
> 
> The reason to have a gain distribution, is to avoid the demodulator
> getting saturated somehow. The "somehow" part is a bit device specific.
> 
> There's so much math going on within the demodulator. In fact a
> demodulator is nothing but a device doing a transform from one domain to
> the other, as it's core functionality although there are other features
> too in a demodulator.
> 
> Additionally, it looks like the VCO needs calibration too .. The
> calibration helps the VCO to remain within the defined limits, rather
> than with some unknown offset to a tuned frequency. All of which seems
> to be missing from the driver. Our drivers are far away from being
> sub-optimal even. It isn't doing anything what is the bare minimum even.
> It looks like the driver is a 1:1 register dump from an existing windows
> driver for a particular frequency, symbol rate and rolloff.. :-(

After reading the comments in the driver, I think this is a valid
assumption...

> The datasheet is also a bit cryptic. It looks to me, at first glance
> that the VCO needs to be calibrated for that specific step, wait for
> that specific VCO comparator settling time, then attempt a tune with the
> relevant step. This might help to reduce the BER as seen by the
> demodulator, what i saw in another post by somebody else.
> 
> Well it is not easy too, but far from it. .. So can't blame anyone for
> it. Also with all this done, it needs some tinkering practically, to
> reach the best what is possible within the resources available.

Obviously there is no public datasheet for the TDA10086,
and I don't have a TT-1401 card either. :-(

Changeset http://linuxtv.org/hg/v4l-dvb/rev/8a19aa788239 was the result
of combining patches from the ML, more or less educated guessing and
some testing done by a user.

I don't know what register 0x02 exactly does. The tests showed that
value 0x35 was required for reliable tuning, while 0x00 was required to
redurce BER after establishing the lock...

The driver is just a hack, but this is all we have atm.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
