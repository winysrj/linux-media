Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46941 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751386AbdAaJt5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 04:49:57 -0500
Message-ID: <1485856160.2932.10.camel@pengutronix.de>
Subject: Re: [PATCH v3 21/24] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
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
Date: Tue, 31 Jan 2017 10:49:20 +0100
In-Reply-To: <20170131000125.GO27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
         <20170131000125.GO27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-01-31 at 00:01 +0000, Russell King - ARM Linux wrote:
[...]
> The iMX6 manuals call for a very specific seven sequence of initialisation
> for CSI2, which begins with:
> 
> 1. reset the D-PHY.
> 2. place MIPI sensor in LP-11 state
> 3. perform D-PHY initialisation
> 4. configure CSI2 lanes and de-assert resets and shutdown signals
> 
> Since you reset the CSI2 at power up and then release it, how do you
> guarantee that the published sequence is followed?
> 
> With Philipp's driver, this is easy, because there is a prepare_stream
> callback which gives the sensor an opportunity to get everything
> correctly configured according to the negotiated parameters, and place
> the sensor in LP-11 state.
> 
> Some sensors do not power up in LP-11 state, but need to be programmed
> fully before being asked to momentarily stream.  Only at that point is
> the sensor guaranteed to be in the required LP-11 state.

Do you expect that 1. and 2. could depend on the negotiated parameters
in any way on some hardware? I had removed the prepare_stream callback
from my driver in v2 because for my use case at least the above sequence
could be realized by

1. in imx-mipi-csi2 s_power(1)
2. in MIPI sensor s_power(1)
3./4. in imx-mipi-csi2 s_stream(1)
4. in MIPI sensor s_stream(1)

as long as the sensor is correctly put back into LP-11 in s_stream(0).

regards
Philipp

