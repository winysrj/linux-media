Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37730 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdBABOr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 20:14:47 -0500
Date: Wed, 1 Feb 2017 01:13:49 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 21/24] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
Message-ID: <20170201011349.GJ27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
 <20170131000125.GO27312@n2100.armlinux.org.uk>
 <1485856160.2932.10.camel@pengutronix.de>
 <6e77aefa-4f22-60e9-7cc0-55c3a2de3124@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e77aefa-4f22-60e9-7cc0-55c3a2de3124@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Tue, Jan 31, 2017 at 05:02:40PM -0800, Steve Longerbeam wrote:
> But this also puts a requirement on MIPI sensors that s_power(ON)
> should only place the D_PHY in LP-11, and _not_ start the clock lane.
> But perhaps that is correct behavior anyway.

If the CSI2 DPHY is held in reset state, it shouldn't matter what the
sensor does.  In the case of IMX219, it needs a full setup of the
device, including enabling it to stream (so it starts the clock lane
etc) in order to get it into LP-11 state.  Merely disabling the XCLR
signal leaves the lanes grounded.

I do seem to remember reading in one of the MIPI specs that this is
rather expected behaviour, though I can't point at a paragraph this
late in the night.

So, the only way to satisfy these requirements is this order:

- assert PHY reset signals (so blocking any activity on the CSI lanes)
- initialise the sensor (including allowing it to start streaming and
  then stopping the stream - at that point, the lanes will be in LP-11.)
- deassert the resets as per the iMX6 documentation and follow the
  remaining procedure.

I'll look at your other points tomorrow.

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
