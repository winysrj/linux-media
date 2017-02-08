Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56686 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdBHXxF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 18:53:05 -0500
Date: Wed, 8 Feb 2017 23:42:35 +0000
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
Message-ID: <20170208234235.GA27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
 <1486036237.2289.37.camel@pengutronix.de>
 <ca0a2eb3-21b6-d312-c8e0-61da48c4c700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca0a2eb3-21b6-d312-c8e0-61da48c4c700@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 08, 2017 at 03:23:53PM -0800, Steve Longerbeam wrote:
> >Actually, this exact function already exists as dw_mipi_dsi_phy_write in
> >drivers/gpu/drm/rockchip/dw-mipi-dsi.c, and it looks like the D-PHY
> >register 0x44 might contain a field called HSFREQRANGE_SEL.
> 
> Thanks for pointing out drivers/gpu/drm/rockchip/dw-mipi-dsi.c.
> It's clear from that driver that there probably needs to be a fuller
> treatment of the D-PHY programming here, but I don't know where
> to find the MIPI CSI-2 D-PHY documentation for the i.MX6. The code
> in imxcsi2_reset() was also pulled from FSL, and that's all I really have
> to go on for the D-PHY programming. I assume the D-PHY is also a
> Synopsys core, like the host controller, but the i.MX6 manual doesn't
> cover it.

Why exactly?  What problems are you seeing that would necessitate a
more detailed programming of the D-PHY?  From my testing, I can wind
a 2-lane MIPI bus on iMX6D from 912Mbps per lane down to (eg) 308Mbps
per lane with your existing code without any issues.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
