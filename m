Return-path: <mchehab@pedra>
Received: from smtp02.frii.com ([216.17.135.168]:45684 "EHLO smtp02.frii.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab1AXPtf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:49:35 -0500
Received: from io.frii.com (io.frii.com [216.17.222.1])
	by smtp02.frii.com (FRII) with ESMTP id 6FED9DA6B4
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 08:49:35 -0700 (MST)
Date: Mon, 24 Jan 2011 08:49:35 -0700
From: Mark Zimmerman <markzimm@frii.com>
To: linux-media@vger.kernel.org
Subject: Re: DViCO FusionHDTV7 Dual Express I2C write failed
Message-ID: <20110124154935.GA51009@io.frii.com>
References: <20101207190753.GA21666@io.frii.com> <20110110021439.GA70495@io.frii.com> <AANLkTingFP9ajGckXXy2wScHHGxhz+KTyOBa-mE7SUs5@mail.gmail.com> <AANLkTi=59dytuN25H3DVRrPAB8GAcn6N88Ji_dkorsGB@mail.gmail.com> <AANLkTi=FFV8CWrBU-20huQRDysTPWGaen2mtP2sBQJef@mail.gmail.com> <20110119173946.GA64847@io.frii.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119173946.GA64847@io.frii.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jan 19, 2011 at 10:39:46AM -0700, Mark Zimmerman wrote:
> On Wed, Jan 19, 2011 at 09:22:28AM -0800, VDR User wrote:
> > On Wed, Jan 19, 2011 at 8:13 AM, Devin Heitmueller
> > <dheitmueller@kernellabs.com> wrote:
> > >> Can someone please look into this and possibly provide a fix for the
> > >> bug? ??I'm surprised it hasn't happened yet after all this time but
> > >> maybe it's been forgotten the bug existed.
> > >
> > > You shouldn't be too surprised. ??In many cases device support for more
> > > obscure products comes not from the maintainer of the actual driver
> > > but rather from some random user who hacked in an additional board
> > > profile (in many cases, not doing it correctly but good enough so it
> > > "works for them"). ??In cases like that, the changes get committed, the
> > > original submitter disappears, and then when things break there is
> > > nobody with the appropriate knowledge and the hardware to debug the
> > > problem.
> > 
> > Good point.  My understanding is that this is a fairly common card so
> > I wouldn't think that would be the case.  At any rate, hopefully we'll
> > be able to narrow down the cause of the problem and get it fixed.
> > 
> 
> Were there changes to i2c between 2.6.35 and 2.6.36 that are missing
> from the xc5000 driver?  If so, is there another driver that has the
> required updates so I can look at what changed?  I would like to get
> some traction on this but I really don't know where to start.
> 

>From looking at the code and a dump of the firmware file, the first
i2c write would have a length of 3; so this error:

xc5000: I2C write failed (len=3)

tells me that there were probably no successful i2c transactions on
this device. The i2c write call looks the same as that in other
drivers, so I wonder if there is an initialization step that is now
necessary but which is missing.

Still hoping for suggestions...
-- Mark
