Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35836 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752468AbdBHXag (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 18:30:36 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v3 21/24] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
 <1486036237.2289.37.camel@pengutronix.de>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
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
Message-ID: <ca0a2eb3-21b6-d312-c8e0-61da48c4c700@gmail.com>
Date: Wed, 8 Feb 2017 15:23:53 -0800
MIME-Version: 1.0
In-Reply-To: <1486036237.2289.37.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/02/2017 03:50 AM, Philipp Zabel wrote:
>
>> +	struct v4l2_subdev     *src_sd;
>> +	struct v4l2_subdev     *sink_sd[CSI2_NUM_SRC_PADS];
> I see no reason to store pointers to the remote v4l2_subdevs.
>
>> +	int                    input_pad;
>> +	struct clk             *dphy_clk;
>> +	struct clk             *cfg_clk;
>> +	struct clk             *pix_clk; /* what is this? */
>> +	void __iomem           *base;
>> +	int                     intr1;
>> +	int                     intr2;
> The interrupts are not used, I'd remove them and the dead code in
> _probe.

done.

>> +
>> +static inline u32 imxcsi2_read(struct imxcsi2_dev *csi2, unsigned int regoff)
>> +{
>> +	return readl(csi2->base + regoff);
>> +}
>> +
>> +static inline void imxcsi2_write(struct imxcsi2_dev *csi2, u32 val,
>> +				 unsigned int regoff)
>> +{
>> +	writel(val, csi2->base + regoff);
>> +}
> Do those two wrappers really make the code more readable?

It doesn't really matter to me either way, I removed these
macros.

>> +
>> +static void imxcsi2_enable(struct imxcsi2_dev *csi2, bool enable)
>> +{
>> +	if (enable) {
>> +		imxcsi2_write(csi2, 0xffffffff, CSI2_PHY_SHUTDOWNZ);
>> +		imxcsi2_write(csi2, 0xffffffff, CSI2_DPHY_RSTZ);
>> +		imxcsi2_write(csi2, 0xffffffff, CSI2_RESETN);
> Given that these registers only contain a single bit, and bits 31:1 are
> documented as reserved, 0, I think these should write 1 instead of
> 0xffffffff.

Yes, these lines are lifted from the FSL BSP's mipi csi-2 driver. I
did notice this but left it in place because I was worried about
possible undocumented bits. I tried writing 1 to these registers
and the behavior is the same as before (still works).

>> +	} else {
>> +		imxcsi2_write(csi2, 0x0, CSI2_PHY_SHUTDOWNZ);
>> +		imxcsi2_write(csi2, 0x0, CSI2_DPHY_RSTZ);
>> +		imxcsi2_write(csi2, 0x0, CSI2_RESETN);
>> +	}
>> +}
>> +
>> +static void imxcsi2_reset(struct imxcsi2_dev *csi2)
>> +{
>> +	imxcsi2_enable(csi2, false);
>> +
>> +	imxcsi2_write(csi2, 0x00000001, CSI2_PHY_TST_CTRL0);
>> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL1);
>> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
>> +	imxcsi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
>> +	imxcsi2_write(csi2, 0x00010044, CSI2_PHY_TST_CTRL1);
>> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
>> +	imxcsi2_write(csi2, 0x00000014, CSI2_PHY_TST_CTRL1);
>> +	imxcsi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
>> +	imxcsi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
> These magic constants should be replaced with proper defines for the
> documented bitfields, if available.
>
> #define PHY_TESTCLR		BIT(0)
> #define PHY_TESTCLK		BIT(1)
>
> #define PHY_TESTEN		BIT(16)
>
> 	/* Clear PHY test interface */
> 	imxcsi2_write(csi2, PHY_TESTCLR, CSI2_PHY_TST_CTRL0);
> 	imxcsi2_write(csi2, 0, CSI2_PHY_TST_CTRL1);
> 	imxcsi2_write(csi2, 0, CSI2_PHY_TST_CTRL0);
>
> 	/* Raise test interface strobe signal */
> 	imxcsi2_write(csi2, PHY_TESTCLK, CSI2_PHY_TST_CTRL0);
>
> 	/* Configure address write on falling edge and lower strobe signal */
> 	u8 addr = 0x44;
> 	imxcsi2_write(csi2, PHY_TESTEN | addr, CSI2_PHY_TST_CTRL1);
> 	imxcsi2_write(csi2, 0, CSI2_PHY_TST_CTRL0);
>
> 	/* Configure data write on rising edge and raise strobe signal */
> 	u8 data = 0x14;
> 	imxcsi2_write(csi2, data, CSI2_PHY_TST_CTRL1);
> 	imxcsi2_write(csi2, PHY_TESTCLK, CSI2_PHY_TST_CTRL0);
>
> 	/* Clear strobe signal */
> 	imxcsi2_write(csi2, 0, CSI2_PHY_TST_CTRL0);
>
> The whole sequence should probably be encapsulated in a
> dw_mipi_dphy_write function.
>
> Actually, this exact function already exists as dw_mipi_dsi_phy_write in
> drivers/gpu/drm/rockchip/dw-mipi-dsi.c, and it looks like the D-PHY
> register 0x44 might contain a field called HSFREQRANGE_SEL.

Thanks for pointing out drivers/gpu/drm/rockchip/dw-mipi-dsi.c.
It's clear from that driver that there probably needs to be a fuller
treatment of the D-PHY programming here, but I don't know where
to find the MIPI CSI-2 D-PHY documentation for the i.MX6. The code
in imxcsi2_reset() was also pulled from FSL, and that's all I really have
to go on for the D-PHY programming. I assume the D-PHY is also a
Synopsys core, like the host controller, but the i.MX6 manual doesn't
cover it.

In any case I've created dw_mipi_csi2_phy_write(), modeled after
dw_mipi_dsi_phy_write(). The "0x14" value is a value derived for
a target max bandwidth per lane of 300 Mbps, at least that is what
drivers/gpu/drm/rockchip/dw-mipi-dsi.c suggests. I've added a FIXME
note that effect, that this value should be derived based on the D-PHY
PLL clock rate and the desired max lane bandwidth.


>> +	imxcsi2_enable(csi2, true);
>> +}
>> +
>> +static int imxcsi2_dphy_wait(struct imxcsi2_dev *csi2)
>> +{
>> +	u32 reg;
>> +	int i;
>> +
>> +	/* wait for mipi sensor ready */
> More specifically, wait for the clock lane module to leave ULP state.

I've split this function in two:

imxcsi2_dphy_wait_lp_11()

which waits for !PHY_RXULPSCLKNOT, and stable/error-free
CSI-2 bus (CSI2_ERR1 == 0),

and

  imxcsi2_dphy_wait_clock_lane()

which waits for PHY_RXCLKACTIVEHS.

The former is called during s_power(1), the latter in s_stream(1).

>> +	for (i = 0; i < 50; i++) {
>> +		reg = imxcsi2_read(csi2, CSI2_PHY_STATE);
>> +		if (reg != 0x200)
> Magic constants are bad. This is PHY_RXULPSCLKNOT (clock lane module in
> ultra low power state).

Fixed.


>> +			break;
>> +		usleep_range(10000, 20000);
>> +	}
> How about breaking this out into a wait function, or even better, using
> readl_poll_timeout instead of open coding these loops multiple times?

Cool, thanks for pointing out that macro. I've switched to 
readl_poll_timeout()
everywhere.

>
>> +
>> +	if (i >= 50) {
>> +		v4l2_err(&csi2->sd,
>> +			 "wait for clock lane timeout, phy_state = 0x%08x\n",
>> +			 reg);
>> +		return -ETIME;
>> +	}
>> +
>> +	/* wait for mipi stable */
> Wait for error free transmission?

Changed to /* wait until no errors on bus */.

>
>> +
>> +	if (i >= 50) {
>> +		v4l2_err(&csi2->sd,
>> +			 "wait for controller timeout, err1 = 0x%08x\n",
>> +			 reg);
>> +		return -ETIME;
>> +	}
>> +
>> +	/* finally let's wait for active clock on the clock lane */
>> +	for (i = 0; i < 50; i++) {
>> +		reg = imxcsi2_read(csi2, CSI2_PHY_STATE);
>> +		if (reg & (1 << 8))
> Yes, and that is PHY_RXCLKACTIVEHS.

done.


>> +	return 0;
>> +}
>> +
>> +/*
>> + * V4L2 subdev operations
>> + */
>> +
>> +static int imxcsi2_link_setup(struct media_entity *entity,
>> +			      const struct media_pad *local,
>> +			      const struct media_pad *remote, u32 flags)
>> +{
>> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
>> +	struct imxcsi2_dev *csi2 = sd_to_dev(sd);
>> +	struct v4l2_subdev *remote_sd;
>> +
>> +	dev_dbg(csi2->dev, "link setup %s -> %s", remote->entity->name,
>> +		local->entity->name);
>> +
>> +	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
>> +
>> +	if (local->flags & MEDIA_PAD_FL_SOURCE) {
>> +		if (flags & MEDIA_LNK_FL_ENABLED) {
>> +			if (csi2->sink_sd[local->index])
>> +				return -EBUSY;
>> +			csi2->sink_sd[local->index] = remote_sd;
>> +		} else {
>> +			csi2->sink_sd[local->index] = NULL;
>> +		}
>> +	} else {
>> +		if (flags & MEDIA_LNK_FL_ENABLED) {
>> +			if (csi2->src_sd)
>> +				return -EBUSY;
>> +			csi2->src_sd = remote_sd;
>> +		} else {
>> +			csi2->src_sd = NULL;
>> +		}
>> +	}
> This whole code block is just to check if there is another link already
> active on the given pad. This could be stored in a boolean or a bit, no
> need to store pointers to remote subdevices.

I converted these to true booleans.

>
>> +
>> +static int imxcsi2_get_fmt(struct v4l2_subdev *sd,
>> +			   struct v4l2_subdev_pad_config *cfg,
>> +			   struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct imxcsi2_dev *csi2 = sd_to_dev(sd);
>> +
>> +	sdformat->format = csi2->format_mbus;
> The output formats are different from the input formats, see the media
> bus format discussion in the other thread. The input pad is the MIPI
> CSI-2 bus, but the four output pads are connected to the muxes / CSIs
> via a 16-bit parallel bus.
>
> So if the input format is UYVY8_1X16, for example, the output should be
> set to UYVY8_2X8.

Since the output buses from the CSI2IPU gasket are 16-bit
parallel buses, shouldn't an input format UYVY8_1X16 also be
the same at the output?

Steve

