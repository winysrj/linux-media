Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49256 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752061AbeD0J1L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 05:27:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
Date: Fri, 27 Apr 2018 12:27:24 +0300
Message-ID: <3075738.A80d5ULHjc@avalon>
In-Reply-To: <CAFwsNOEV0Q2HjmaoT-m-znD-+0VSfE4tJ2vCPuNpUe2M72ErAA@mail.gmail.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com> <20180419123244.tujbrkpazbdyows6@flea> <CAFwsNOEV0Q2HjmaoT-m-znD-+0VSfE4tJ2vCPuNpUe2M72ErAA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sam,

On Wednesday, 25 April 2018 01:11:19 EEST Sam Bobrowicz wrote:
> FYI, still hard at work on this. Did some more experiments last week
> that seemed to corroborate the clock tree in the spreadsheet. It also
> seems that the output of the P divider cell, SCLK cell and MIPI Rate
> cell in the spreadsheet must have a ratio of 2x:1x:8x (respectively)
> in order for the sensor to work properly on my platform, and that the
> SCLK value must be close to the "rate" variable that you calculate and
> pass to set_mipi_pclk. Unfortunately, I've only got the sensor working
> well for 1080p@15Hz and 720p@30Hz, both with a SCLK of 42MHz (aka
> 84:42:336). I'm running experiments now trying to adjust the htot and
> vtot values to create different required rates, and also to try to get
> faster Mipi rates working. Any information you have on the
> requirements of the htot and vtot values with respect to vact and hact
> values would likely be helpful.
> 
> I'm also keeping an eye on the scaler clock, which I think may be
> affecting certain resolutions, but haven't been able to see it make a
> difference yet (see register 0x3824 and 0x460c)
> 
> I plan on pushing a set of patches once I get this figured out, we can
> discuss what I should base them on when I get closer to that point.
> I'm new to this process :)

I'm also interested in getting the ov5640 driver working with MIPI CSI-2. 
Studying the datasheet and the driver code, I found the stream on sequence to 
be a bit weird. In particular the configuration of OV5640_REG_IO_MIPI_CTRL00, 
OV5640_REG_PAD_OUTPUT00 and OV5640_REG_MIPI_CTRL00 caught my attention.

OV5640_REG_IO_MIPI_CTRL00 (0x300e) is set to 0x45 in the large array of init 
mode data and never touched for MIPI CSI-2 (the register is only touched in 
ov5640_set_stream_dvp). The value means

- mipi_lane_mode: 010 is documented as "debug mode", I would have expected 000 
for one lane or 001 for two lanes.

- MIPI TX PHY power down: 0 is documented as "debug mode" and 1 as "Power down 
PHY HS TX", so I suppose 0 is correct.

- MIPI RX PHY power down: 0 is documented as "debug mode" and 1 as "Power down 
PHY LP RX module", so I suppose 0 is correct. I however wonder why there's a 
RX PHY, it could be a typo.

- mipi_en: 1 means MIPI enable, which should be correct.

- BIT(0) is undocumented.

OV5640_REG_PAD_OUTPUT00 (0x3019) isn't initialized explicitly and thus retains 
its default value of 0x00, and is controlled when starting and stopping the 
stream where it's set to 0x00 and 0x70 respectively. Bits 6:4 control the 
"sleep mode" state of lane 2, lane 1 and clock lane respectively, and should 
be LP11 in my opinion (that's the PHY stop state). However, setting them to 
0x00 when starting the stream mean that LP00 is selected as the sleep state at 
stream start, and LP11 when stopping the stream. Maybe "sleep mode" means 
LPDT, but I would expect that to be controlled by the idle status bit in 
register 0x4800.

OV5640_REG_MIPI_CTRL00 (0x4800) is set to 0x04 in the large array of init mode 
data, and BIT(5) is then cleared at stream on time and set at stream off time. 
This means:

- Clock lane gate enable: Clock lane is free running
- Line sync enable: Do not send line short packets for each line (I assume 
that's LS/LE)
- Lane select: Use lane1 as default data lane.
- Idle status: MIPI bus will be LP11 when no packet to transmit. I would have 
expected the idle status to correspond to LPDT, and thus be LP00 (as opposed 
to the stop state that should be LP11, which I believe is named "sleep mode" 
in the datasheet and controlled in register 0x3019).

BIT(5) is the clock lane gate enable, so at stream on time the clock is set to 
free running, and at stream off time to "Gate clock lane when no packet to 
transmit". Couldn't we always enable clock gating ?

Do you have any insight on this ? Have you modified the MIPI CSI-2 
configuration to get the CSI-2 output working ?

-- 
Regards,

Laurent Pinchart
