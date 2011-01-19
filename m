Return-path: <mchehab@pedra>
Received: from smtp01.frii.com ([216.17.135.167]:54776 "EHLO smtp01.frii.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab1ASRjr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 12:39:47 -0500
Received: from io.frii.com (io.frii.com [216.17.222.1])
	by smtp01.frii.com (FRII) with ESMTP id D73ACD914E
	for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 10:39:46 -0700 (MST)
Date: Wed, 19 Jan 2011 10:39:46 -0700
From: Mark Zimmerman <markzimm@frii.com>
To: linux-media@vger.kernel.org
Subject: Re: DViCO FusionHDTV7 Dual Express I2C write failed
Message-ID: <20110119173946.GA64847@io.frii.com>
References: <20101207190753.GA21666@io.frii.com> <20110110021439.GA70495@io.frii.com> <AANLkTingFP9ajGckXXy2wScHHGxhz+KTyOBa-mE7SUs5@mail.gmail.com> <AANLkTi=59dytuN25H3DVRrPAB8GAcn6N88Ji_dkorsGB@mail.gmail.com> <AANLkTi=FFV8CWrBU-20huQRDysTPWGaen2mtP2sBQJef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=FFV8CWrBU-20huQRDysTPWGaen2mtP2sBQJef@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jan 19, 2011 at 09:22:28AM -0800, VDR User wrote:
> On Wed, Jan 19, 2011 at 8:13 AM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
> >> Can someone please look into this and possibly provide a fix for the
> >> bug? ??I'm surprised it hasn't happened yet after all this time but
> >> maybe it's been forgotten the bug existed.
> >
> > You shouldn't be too surprised. ??In many cases device support for more
> > obscure products comes not from the maintainer of the actual driver
> > but rather from some random user who hacked in an additional board
> > profile (in many cases, not doing it correctly but good enough so it
> > "works for them"). ??In cases like that, the changes get committed, the
> > original submitter disappears, and then when things break there is
> > nobody with the appropriate knowledge and the hardware to debug the
> > problem.
> 
> Good point.  My understanding is that this is a fairly common card so
> I wouldn't think that would be the case.  At any rate, hopefully we'll
> be able to narrow down the cause of the problem and get it fixed.
> 

Were there changes to i2c between 2.6.35 and 2.6.36 that are missing
from the xc5000 driver?  If so, is there another driver that has the
required updates so I can look at what changed?  I would like to get
some traction on this but I really don't know where to start.

Thanks,
-- Mark
