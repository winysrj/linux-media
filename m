Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47511 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751743AbdIUMf4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 08:35:56 -0400
Message-ID: <1505997354.10081.11.camel@pengutronix.de>
Subject: Re: [PATCH] tc358743: fix connected/active CSI-2 lane reporting
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ian Arkver <ian.arkver.dev@gmail.com>, linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>
Date: Thu, 21 Sep 2017 14:35:54 +0200
In-Reply-To: <9518ed83-48da-472f-f895-4cd4c3797373@gmail.com>
References: <20170921102428.30709-1-p.zabel@pengutronix.de>
         <f3d4ce20-d3aa-f76f-0d07-e8153e3558a9@gmail.com>
         <9518ed83-48da-472f-f895-4cd4c3797373@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ian,

On Thu, 2017-09-21 at 12:06 +0100, Ian Arkver wrote:
[...]
> > My understanding of Hans' comment:
> > "I'd also add a comment that all other flags must be 0 if the device 
> > tree is used. This to avoid mixing the two."
> > 
> > is that all the above should only happen if (!!state->pdata).
> 
> Except that state->pdata is a copy of the pdata, not a pointer, but you 
> know what I mean. Some other check for DT needed here.

Yes, I'll change this to zero all V4L2_MBUS_CSI2_[1-4]_LANE in the DT
case. I suppose the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK and
V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK bits should be zeroed as well, then?

> > I don't know if this would break any existing DT-using bridge drivers.

The only current users of g_mbus_config are the pxa_camera and
sh_mobile_ceu_camera soc_camera drivers. Neither supports MIPI CSI-2, as
far as I can tell.

regards
Philipp
