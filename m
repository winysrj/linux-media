Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:45913 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751436AbdIUMbd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 08:31:33 -0400
Message-ID: <1505997089.10081.9.camel@pengutronix.de>
Subject: Re: [PATCH] tc358743: fix connected/active CSI-2 lane reporting
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>
Date: Thu, 21 Sep 2017 14:31:29 +0200
In-Reply-To: <CAAoAYcPckrO5-Z1quY+TCsMMgr7mRDsaqy5B3yYtSCBBdn0LiA@mail.gmail.com>
References: <20170921102428.30709-1-p.zabel@pengutronix.de>
         <CAAoAYcPckrO5-Z1quY+TCsMMgr7mRDsaqy5B3yYtSCBBdn0LiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-09-21 at 12:41 +0100, Dave Stevenson wrote:
> Hi Philipp
> 
> On 21 September 2017 at 11:24, Philipp Zabel <p.zabel@pengutronix.de>
> wrote:
[...]
> > +       if (state->csi_lanes_in_use > 4)
> 
> One could suggest
> if (state->csi_lanes_in_use > state->bus.num_data_lanes)
> here. Needing to use more lanes than are configured is surely an
> error, although that may be detectable at the other end. See below
> too.

True. The OF parser could be improved to make sure that
num_data_lanes <= 4, and also that all lanes are in the correct order.

[...]
> > +/*
> > + * Number of lanes in use, 0 == use all available lanes (default)
> > + *
> > + * This is a temporary fix for devices that need to reduce the number of active
> > + * lanes for certain modes, until g_mbus_config() can be replaced with a better
> > + * solution.
> > + */
> > +#define V4L2_MBUS_CSI2_LANE_MASK                (3 << 10)
> 
> I know this was Hans' suggested define, but are we saying 4 lanes is
> not a valid value? If it is then the mask needs to be at least (7 <<
> 10).

0 must map to "all lanes" for backwards compatibility, but I see no
reason why we shouldn't add another bit here to support reporting 4
lanes explicitly.

> 4 lanes is not necessarily "all available lanes".

Correct.

> - There are now CSI2 devices supporting up to 8 lanes (although
> V4L2_FWNODE_CSI2_MAX_DATA_LANES limits you to 4 at the moment).

So how about we just add two bits, then?

#define V4L2_MBUS_CSI2_LANE_MASK                (0xf << 10)

> - Or you could have 2 lanes configured in DT and ask TC358743 for (eg)
> 1080P60 UYVY at 594Mbps (needs 4 lanes) which passes the current logic
> in the TC358743 driver and would return 0, when it is actually going
> to use 4 lanes. That could be classed as a driver bug though.

Right, the driver shouldn't try to start streaming at all if it knows
that the available CSI-2 bandwidth will be exceeded.

> My view is that if a driver is going to report how many lanes to use
> then it should always report it explicitly. The default 0 value should
> only be used for devices that will never change it from the DT
> settings. Perhaps others disagree
> 
> Otherwise the patch works for me.

I'm fine with changing this as you suggest.

regards
Philipp
