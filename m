Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:48649 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbeDYTxn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 15:53:43 -0400
Date: Wed, 25 Apr 2018 21:53:31 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20180425195331.54fkzk2yahipuouf@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <CAFwsNOF6t-AAXr8gEBLnCx2OF-PjAWALhsJRVYHSdnaP9hswWA@mail.gmail.com>
 <20180417160122.rfdlbdafmivgi5cd@flea>
 <CAFwsNOE3aockxFDbPP4B6LDckGrvM5grqcov5wui0aCyuQs4Tw@mail.gmail.com>
 <20180419123244.tujbrkpazbdyows6@flea>
 <CAFwsNOEV0Q2HjmaoT-m-znD-+0VSfE4tJ2vCPuNpUe2M72ErAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAFwsNOEV0Q2HjmaoT-m-znD-+0VSfE4tJ2vCPuNpUe2M72ErAA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Samuel,

On Tue, Apr 24, 2018 at 03:11:19PM -0700, Sam Bobrowicz wrote:
> FYI, still hard at work on this. Did some more experiments last week
> that seemed to corroborate the clock tree in the spreadsheet.

Ok, good, I'll send an updated version next week taking this into
account then. Thanks!

> It also seems that the output of the P divider cell, SCLK cell and
> MIPI Rate cell in the spreadsheet must have a ratio of 2x:1x:8x
> (respectively) in order for the sensor to work properly on my
> platform, and that the SCLK value must be close to the "rate"
> variable that you calculate and pass to set_mipi_pclk.

It might be quite simple to support actually. Most of the other
dividers were hardcoded in the driver, so maybe it's the case for
those as well. I'll check and see how it goes.

> Unfortunately, I've only got the sensor working well for 1080p@15Hz
> and 720p@30Hz, both with a SCLK of 42MHz (aka 84:42:336). I'm
> running experiments now trying to adjust the htot and vtot values to
> create different required rates, and also to try to get faster Mipi
> rates working. Any information you have on the requirements of the
> htot and vtot values with respect to vact and hact values would
> likely be helpful.

Unfortunately, I don't have an answer to that one.

> I'm also keeping an eye on the scaler clock, which I think may be
> affecting certain resolutions, but haven't been able to see it make a
> difference yet (see register 0x3824 and 0x460c)
> 
> I plan on pushing a set of patches once I get this figured out, we can
> discuss what I should base them on when I get closer to that point.
> I'm new to this process :)

I was planning on sending a new version based on your feedback for the
MIPI-CSI2 formula, most likely next week. I guess you could test them
and see how it goes. Or send patches on top of this version if you
prefer :)

You have more documentation on how to do that here:
https://www.kernel.org/doc/Documentation/process/submitting-patches.rst

Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
