Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47140 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdAaACP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 19:02:15 -0500
Date: Tue, 31 Jan 2017 00:01:25 +0000
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
Subject: Re: [PATCH v3 21/24] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
Message-ID: <20170131000125.GO27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 06:11:39PM -0800, Steve Longerbeam wrote:
> +static void imxcsi2_enable(struct imxcsi2_dev *csi2, bool enable)
> +{
> +	if (enable) {
> +		imxcsi2_write(csi2, 0xffffffff, CSI2_PHY_SHUTDOWNZ);
> +		imxcsi2_write(csi2, 0xffffffff, CSI2_DPHY_RSTZ);
> +		imxcsi2_write(csi2, 0xffffffff, CSI2_RESETN);
> +	} else {
> +		imxcsi2_write(csi2, 0x0, CSI2_PHY_SHUTDOWNZ);
> +		imxcsi2_write(csi2, 0x0, CSI2_DPHY_RSTZ);
> +		imxcsi2_write(csi2, 0x0, CSI2_RESETN);
> +	}
> +}
> +
> +static void imxcsi2_reset(struct imxcsi2_dev *csi2)
> +{
> +	imxcsi2_enable(csi2, false);
> +
> +	imxcsi2_write(csi2, 0x00000001, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL1);
> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00010044, CSI2_PHY_TST_CTRL1);
> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00000014, CSI2_PHY_TST_CTRL1);
> +	imxcsi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
> +
> +	imxcsi2_enable(csi2, true);
> +}
> +
> +static int imxcsi2_dphy_wait(struct imxcsi2_dev *csi2)
> +{
> +	u32 reg;
> +	int i;
> +
> +	/* wait for mipi sensor ready */
> +	for (i = 0; i < 50; i++) {
> +		reg = imxcsi2_read(csi2, CSI2_PHY_STATE);
> +		if (reg != 0x200)
> +			break;
> +		usleep_range(10000, 20000);
> +	}
> +
> +	if (i >= 50) {
> +		v4l2_err(&csi2->sd,
> +			 "wait for clock lane timeout, phy_state = 0x%08x\n",
> +			 reg);
> +		return -ETIME;
> +	}
> +
> +	/* wait for mipi stable */
> +	for (i = 0; i < 50; i++) {
> +		reg = imxcsi2_read(csi2, CSI2_ERR1);
> +		if (reg == 0x0)
> +			break;
> +		usleep_range(10000, 20000);
> +	}
> +
> +	if (i >= 50) {
> +		v4l2_err(&csi2->sd,
> +			 "wait for controller timeout, err1 = 0x%08x\n",
> +			 reg);
> +		return -ETIME;
> +	}
> +
> +	/* finally let's wait for active clock on the clock lane */
> +	for (i = 0; i < 50; i++) {
> +		reg = imxcsi2_read(csi2, CSI2_PHY_STATE);
> +		if (reg & (1 << 8))
> +			break;
> +		usleep_range(10000, 20000);
> +	}
> +
> +	if (i >= 50) {
> +		v4l2_err(&csi2->sd,
> +			 "wait for active clock timeout, phy_state = 0x%08x\n",
> +			 reg);
> +		return -ETIME;
> +	}
> +
> +	v4l2_info(&csi2->sd, "ready, dphy version 0x%x\n",
> +		  imxcsi2_read(csi2, CSI2_VERSION));
> +
> +	return 0;
> +}
...
> +static int imxcsi2_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct imxcsi2_dev *csi2 = sd_to_dev(sd);
> +
> +	if (on && !csi2->on) {
> +		v4l2_info(&csi2->sd, "power ON\n");
> +		clk_prepare_enable(csi2->cfg_clk);
> +		clk_prepare_enable(csi2->dphy_clk);
> +		imxcsi2_set_lanes(csi2);
> +		imxcsi2_reset(csi2);

The iMX6 manuals call for a very specific seven sequence of initialisation
for CSI2, which begins with:

1. reset the D-PHY.
2. place MIPI sensor in LP-11 state
3. perform D-PHY initialisation
4. configure CSI2 lanes and de-assert resets and shutdown signals

Since you reset the CSI2 at power up and then release it, how do you
guarantee that the published sequence is followed?

With Philipp's driver, this is easy, because there is a prepare_stream
callback which gives the sensor an opportunity to get everything
correctly configured according to the negotiated parameters, and place
the sensor in LP-11 state.

Some sensors do not power up in LP-11 state, but need to be programmed
fully before being asked to momentarily stream.  Only at that point is
the sensor guaranteed to be in the required LP-11 state.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
