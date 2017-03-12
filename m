Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44626 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935007AbdCLRsX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 13:48:23 -0400
Date: Sun, 12 Mar 2017 17:47:26 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, sakari.ailus@linux.intel.com,
        nick@shmanahar.org, songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        mchehab@kernel.org, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, tiffany.lin@mediatek.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170312174725.GO21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170310201356.GA21222@n2100.armlinux.org.uk>
 <26d4a31f-f9d3-8b2b-391e-fc4b44cc8e5d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26d4a31f-f9d3-8b2b-391e-fc4b44cc8e5d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 10, 2017 at 03:20:34PM -0800, Steve Longerbeam wrote:
> 
> 
> On 03/10/2017 12:13 PM, Russell King - ARM Linux wrote:
> >Version 5 gives me no v4l2 controls exposed through the video device
> >interface.
> >
> >Just like with version 4, version 5 is completely useless with IMX219:
> >
> >imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
> >ipu1_csi0: pipeline start failed with -110
> >imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
> >ipu1_csi0: pipeline start failed with -110
> >imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
> >ipu1_csi0: pipeline start failed with -110
> >
> >So, like v4, I can't do any further testing.
> >
> 
> Is the imx219 placing the csi-2 bus in LP-11 state on exit
> from s_power(ON)?
> 
> I realize that probably means bringing the chip up to a
> completely operational state and then setting it to stream
> OFF in the s_power() op.
> 
> The same had to be done for the OV5640.

What do you suggest - setting it to the highest CSI2 bus speed that
it supports?  That's likely to be over the maximum data rate specified
for iMX6Q if it's wired up using four lanes.


Also, as I've already said, I think that powering on the sensor just
because it's got an enabled media-controller link is a silly idea.

Right now, the only way of using the imx6 capture stuff is to manually
configure it with media-ctl, which means that happens either at boot
due to a custom boot script, or when you first use it (by manually
running a script.)

This results in the sensor staying powered from that point onwards,
wasting power unnecessarily.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
