Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43499 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752039AbdIUJEw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 05:04:52 -0400
Message-ID: <1505984680.10081.2.camel@pengutronix.de>
Subject: Re: [PATCH 2/3] [media] tc358743: Increase FIFO level to 300.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Thu, 21 Sep 2017 11:04:40 +0200
In-Reply-To: <df9bd5db-6d89-6dfa-3754-5de14470c92a@cisco.com>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
         <3e638375aff788b24f988e452214649d6100a596.1505826082.git.dave.stevenson@raspberrypi.org>
         <1505834685.10076.5.camel@pengutronix.de>
         <20170919134930.6fa28562@recife.lan>
         <CAAoAYcNCPrpZWvxTTsCtGd4vobsQKDw-ckLhXyRst0dS++h_Ag@mail.gmail.com>
         <1505903026.7865.6.camel@pengutronix.de>
         <CAAoAYcN+KGSNNvF2SZVg=HnS5DC8pR26S+=ofwbaeJim5tsQaA@mail.gmail.com>
         <f4824a16-13ce-7d49-c7dd-19a11f3c01ec@cisco.com>
         <20170920125023.p4u3fi3itsgx456v@valkosipuli.retiisi.org.uk>
         <df9bd5db-6d89-6dfa-3754-5de14470c92a@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, 2017-09-20 at 15:12 +0200, Hans Verkuil wrote:
[...]
> I don't like it :-)
> 
> Currently g_mbus_config returns (and I quote from v4l2-mediabus.h): "How
> many lanes the client can use". I.e. the capabilities of the HW.
> 
> If we are going to use this to communicate how many lines are currently
> in use, then I would propose that we add a lane mask, i.e. something like
> this:
> 
> /* Number of lanes in use, 0 == use all available lanes (default) */
> #define V4L2_MBUS_CSI2_LANE_MASK                (3 << 10)
> 
> And add comments along the lines that this is a temporary fix.
> 
> I would feel a lot happier (or a lot less unhappy) if we'd do it this way.
> Rather than re-interpreting bits that are not quite what they should be.
> 
> I'd also add a comment that all other flags must be 0 if the device tree is
> used. This to avoid mixing the two.

I would like to try this.

Currently the driver sets the V4L2_MBUS_CSI2_[1-4]_LANE bits according
to csi_lanes_in_use, which is wrong as you say.

After moving the csi_lanes_in_use info into a new
V4L2_MBUS_CSI2_LANE_MASK bitfield, the V4L2_MBUS_CSI2_[1-4]_LANE bits
could be either set to zero or to the really connected lanes as
configured in the device tree (csi->bus.num_data_lanes) in the DT case.

What would the bits be set to in the pdata case, though? Should a lane
count setting be added to tc358743_platform_data with, defaulting to all
bits set?

regards
Philipp
