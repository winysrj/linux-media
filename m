Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55554 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932491AbdBQLHU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 06:07:20 -0500
Date: Fri, 17 Feb 2017 11:06:16 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
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
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 23/36] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
Message-ID: <20170217110616.GD21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-24-git-send-email-steve_longerbeam@mentor.com>
 <1487328479.3107.21.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487328479.3107.21.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 17, 2017 at 11:47:59AM +0100, Philipp Zabel wrote:
> On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
> > +static void csi2_dphy_init(struct csi2_dev *csi2)
> > +{
> > +	/*
> > +	 * FIXME: 0x14 is derived from a fixed D-PHY reference
> > +	 * clock from the HSI_TX PLL, and a fixed target lane max
> > +	 * bandwidth of 300 Mbps. This value should be derived
> 
> If the table in https://community.nxp.com/docs/DOC-94312 is correct,
> this should be 850 Mbps. Where does this 300 Mbps value come from?

I thought you had some code to compute the correct value, although
I guess we've lost the ability to know how fast the sensor is going
to drive the link.

Note that the IMX219 currently drives the data lanes at 912Mbps almost
exclusively, as I've yet to finish working out how to derive the PLL
parameters.  (I have something that works, but it currently takes on
the order of 100k iterations to derive the parameters.  gcd() doesn't
help you in this instance.)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
