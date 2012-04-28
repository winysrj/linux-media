Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58010 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755248Ab2D1Vtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 17:49:32 -0400
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
From: Andy Walls <awalls@md.metrocast.net>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	stoth@kernellabs.com
Date: Sat, 28 Apr 2012 17:48:25 -0400
In-Reply-To: <4F9C3223.10501@interlinx.bc.ca>
References: <jn2ibp$pot$1@dough.gmane.org>
	 <1335307344.8218.11.camel@palomino.walls.org>
	 <jn7pph$qed$1@dough.gmane.org>
	 <1335624964.2665.37.camel@palomino.walls.org>
	 <4F9C3223.10501@interlinx.bc.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1335649707.2489.34.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2012-04-28 at 14:08 -0400, Brian J. Murrell wrote:
> On 12-04-28 10:56 AM, Andy Walls wrote:

> > OK.  There are two ways to go here:
> > 
> > 1. We assume your signal is marginal.  Take a look here for things to
> > check and fix if needed:
> > 
> > http://ivtvdriver.org/index.php/Howto:Improve_signal_quality
> 
> I will see what I can do with those.
> 
> > As a test, you you might also want to temporarily change your coax
> > wiring setup to reduce the number of splits and connectors before the
> > signal goes into the HVR-1600, and see if things are better.
> 
> Indeed.  That was at the top of my list also, so isolate the rest of the
> cable plant in here.
> 
> > Every
> > 2-way splitter will drop 3-5 dB of signal.
> 
> OK.  So about splitters.  Given that I'm in a house with 4 cable
> television runs to different rooms, plus a cable modem, plus 4 PVR tuner
> inputs (so yeah, 9 consumers), what is my best splitter plan/options.
> Probably ideally I want to split the incoming signal into two, one for
> the cable modem and one to feed the television consumers.

Assuming ideal splitters:
a  2 way split is a 3 dB signal loss for each leg
a  4 way split is a 6 dB signal loss for each leg
an 8 way split is a 9 dB signal loss for each leg

Signal losses in dB are additive.  So for example, a device downstream
from a 2-way split and then 4 way split, experiences a minimum of 9 dB
of signal loss.


> Once I have the feed off to the televisions though, am I best trying to
> split that into 8, (i.e. equally with an 8-way splitter -- if that's
> even possible) or would I be better served with some more smaller splits
> in somewhat of a tree formation?

With ideal splitters and perfect cable connections, it wouldn't matter.
With real-life splitters and cable connectors, the fewer the devices and
cable connections you use, the better.


> I'm also assuming that all splitters are not of the same quality and
> that the "dollar store" ones are likely of inferior quality.  But
> "dollar store" aside, even amongst reasonable retailers, how can I tell
> (without having to get all electronics geeky with an oscilliscope and
> whatnot) what's good and what's bad?

When looking for splitters as a consumer, you need to ensure frequency
range of the splitter covers your needed range.

Splitters for terrestrial OTA broadcasts only need to pass signals to
about 900 MHz.  Splitters for satellite TV need to pass signals to
around 2300 MHz (2.3 GHz) or so.  For cable you will need to pass
signals up to about 1000 MHz (1.0 GHz).

You shouldn't woory about splitter performance variabtions on the order
of 1 or 2 dB.  You can compensate for that with a distribution amplifier
and better quality cable and connectors.

BTW, I have in the past purchased a brand name, somewhat expensive, 4
way splitter from a Lowes hardware store, only to find one of the
outputs didn't pass any signal - it was broken. :(



> Also, splitting 8 ways, am I into amplification/boosting territory or am
> I likely to just boost noise along with the signal?

Yes you will be amplifying the incoming noise.  But you've got to do
something to preserve SNR against cable plant losses, which degrade
signal but don't reduce noise.

Put any distribution amplifier you purchase, as close to where the
signal comes into your home as possible.  Make sure it is a low noise
amplifier.  Variable gain is a nice feature, to avoid overdriving your
components.

BTW, the noise figure of a receiving system (your cable plant and
tuners) is dominated by the Noise Figure of it's first amplification
stage:
http://en.wikipedia.org/wiki/Friis_formulas_for_noise

A good, low noise, distribution amplifier can go a long way to helping
eliminate other problems.  Don't skimp; pay the money for a decent one.


Also, you must take steps to reduce other losses and stop signal
reflections: good cable, good cable connections, and properly terminate
every split/leg.  One missing or bad termination results in signal
reflections (i.e. additional noise) in your entire cable plant.


> > 2. We assume your signal is too strong, and that it is overdriving the
> > MXL5005s digital tuner of the HVR-1600, causing problems for the CX24227
> > demodulator.
> 
> Heh.  I wonder if that could be possible given my description above.  :-)

Probably not. :)

> > Your corrective action here would be to attenuate the incoming RF signal
> > with either an inline attenuator, or with additional, properly
> > terminated, splitters.
> 
> Indeed.
> 
> Thanks sooooo much for all of the input here.


No problem.

Regards,
Andy


