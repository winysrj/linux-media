Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:32140 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754425Ab0GaSvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 14:51:01 -0400
Subject: Re: [PATCH 13/13] IR: Port ene driver to new IR subsystem and
 enable  it.
From: Andy Walls <awalls@md.metrocast.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jarod@wilsonet.com,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, maximlevitsky@gmail.com,
	mchehab@redhat.com
In-Reply-To: <AANLkTikRBupAsSSk5QmudHrpEccMSOjmK2bT+xg8CocK@mail.gmail.com>
References: <AANLkTimaut1mMUXwbJAgjNjmQkxgsf-GOCTXmKYNm1Lz@mail.gmail.com>
	 <BTtOJbzJjFB@christoph>
	 <AANLkTikRBupAsSSk5QmudHrpEccMSOjmK2bT+xg8CocK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 14:51:21 -0400
Message-ID: <1280602281.20879.76.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-07-31 at 14:14 -0400, Jon Smirl wrote:
> On Sat, Jul 31, 2010 at 1:47 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> > Hi Jon,
> >
> > on 31 Jul 10 at 12:25, Jon Smirl wrote:
> >> On Sat, Jul 31, 2010 at 11:12 AM, Andy Walls <awalls@md.metrocast.net>
> >> wrote:
> >>> I think you won't be able to fix the problem conclusively either way.  A
> >>> lot of how the chip's clocks should be programmed depends on how the
> >>> GPIOs are used and what crystal is used.
> >>>
> >>> I suspect many designers will use some reference design layout from ENE,
> >>> but it won't be good in every case.  The wire-up of the ENE of various
> >>> motherboards is likely something you'll have to live with as unknowns.
> >>>
> >>> This is a case where looser tolerances in the in kernel decoders could
> >>> reduce this driver's complexity and/or get rid of arbitrary fudge
> >>> factors in the driver.
> >
> >> The tolerances are as loose as they can be. The NEC protocol uses
> >> pulses that are 4% longer than JVC. The decoders allow errors up to 2%
> >> (50% of 4%).  The crystals used in electronics are accurate to
> >> 0.0001%+.
> >
> > But the standard IR receivers are far from being accurate enough to allow
> > tolerance windows of only 2%.
> > I'm surprised that this works for you. LIRC uses a standard tolerance of
> > 30% / 100 us and even this is not enough sometimes.
> >
> > For the NEC protocol one signal consists of 22 individual pulses at 38kHz.
> > If the receiver just misses one pulse, you already have an error of 1/22
> >> 4%.
> 
> There are different types of errors. The decoders can take large
> variations in bit times. The problem is with cumulative errors. In
> this case the error had accumulated up to 450us in the lead pulse.
> That's just too big of an error 

Hi Jon,

Hmmm.  Leader marks are, by protocol design, there to give time for the
receiver's AGC to settle.  We should make it OK to miss somewhat large
portions of leader marks.  I'm not sure what the harm is in accepting
too long of a leader mark, but I'm pretty sure a leader mark that is too
long will always be due to systematic error and not noise errors.

However, if we know we have systematic errors caused by unknowns, we
should be designing and imlpementing a decoding system that reasonably
deals with those systematic errors.  Again the part of the system almost
completely out of our control is the remote controls, and we *have no
control* over systematic errors introduced by remotes.

Obviously we want to reduce or elimiinate systematic errors by
determining the unknowns and undoing their effects or by compensating
for their overall effect.  But in the case of the ENE receiver driver,
you didn't seem to like the Maxim's software compensation for the
systematic receiver errors.


> and caused the JVC code to be
> misclassified as NEC.

I still have not heard why we need protocol discrimination/classifcation
in the kernel.  Doing discrimination between two protocols with such
close timings is whose requirement again?

Since these two protocols have such close timings that systematic errors
can cause misclassifcation when using simple mark or space measurments
against fixed thresholds, it indicates that a more sophisticated
discrimation mechanism would be needed.  Perhaps one that takes multiple
successive measurments into account?

Regards,
Andy

