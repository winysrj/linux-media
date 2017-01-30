Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46718 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbdA3Xav (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 18:30:51 -0500
Date: Mon, 30 Jan 2017 23:29:55 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 22/24] media: imx: Add MIPI CSI-2 OV5640 sensor subdev
 driver
Message-ID: <20170130232955.GK27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-23-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483755102-24785-23-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 06:11:40PM -0800, Steve Longerbeam wrote:
> +config IMX_OV5640_MIPI
> +       tristate "OmniVision OV5640 MIPI CSI-2 camera support"
> +       depends on GPIOLIB && VIDEO_IMX_CAMERA
> +       select IMX_MIPI_CSI2
> +       default y

Why is this defaulting to y?  New drivers should not default to enabled
unless they are replacing some already pre-existing functionality.
Ditto for the other camera driver.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
