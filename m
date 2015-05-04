Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:38721 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbbEDOJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 10:09:46 -0400
Message-ID: <55477DA7.4000304@cisco.com>
Date: Mon, 04 May 2015 16:09:43 +0200
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [RFC 03/12] [media] tc358743: support probe from device tree
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de> <1427713856-10240-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-4-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/2015 01:10 PM, Philipp Zabel wrote:
> Add support for probing the TC358743 subdevice from device tree.
> The reference clock must be supplied using the common clock bindings.
>
> Signed-off-by: Philipp Zabel<p.zabel@pengutronix.de>
> ---
>   drivers/media/i2c/tc358743.c | 133 +++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 128 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index dfc10f0..85a0f7a 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -29,7 +29,9 @@
>   #include <linux/module.h>
>   #include <linux/slab.h>
>   #include <linux/i2c.h>
> +#include <linux/clk.h>
>   #include <linux/delay.h>
> +#include <linux/gpio/consumer.h>
>   #include <linux/videodev2.h>
>   #include <linux/workqueue.h>
>   #include <linux/v4l2-dv-timings.h>
> @@ -84,6 +86,8 @@ struct tc358743_state {
>   
>   	struct v4l2_dv_timings timings;
>   	u32 mbus_fmt_code;
> +
> +	struct gpio_desc *reset_gpio;
>   };
>   
>   static inline struct tc358743_state *to_state(struct v4l2_subdev *sd)
> @@ -1628,12 +1632,126 @@ static const struct v4l2_ctrl_config tc358743_ctrl_audio_present = {
>   	.id = TC358743_CID_AUDIO_PRESENT,
>   	.name = "Audio present",
>   	.type = V4L2_CTRL_TYPE_BOOLEAN,
> +	.min = 0,
> +	.max = 1,
> +	.step = 1,

This is already fixed in the latest version of the driver.

The rest of the code seems to be a hack for your hardware.

Regards,
Mats Randgaard

> 	.def = 0,
>   	.flags = V4L2_CTRL_FLAG_READ_ONLY,
>   };
>   
>   /* --------------- PROBE / REMOVE --------------- */
>   
> +#if CONFIG_OF
> +static void tc358743_gpio_reset(struct tc358743_state *state)
> +{
> +	gpiod_set_value(state->reset_gpio, 0);
> +	usleep_range(5000, 10000);
> +	gpiod_set_value(state->reset_gpio, 1);
> +	usleep_range(1000, 2000);
> +	gpiod_set_value(state->reset_gpio, 0);
> +	msleep(20);
> +}
> +
> +static int tc358743_probe_of(struct tc358743_state *state)
> +{
> +	struct device *dev = &state->i2c_client->dev;
> +	struct device_node *np = dev->of_node;
> +	struct clk *refclk;
> +	u32 bps_pr_lane;
> +
> +	refclk = devm_clk_get(dev, "refclk");
> +	if (IS_ERR(refclk)) {
> +		if (PTR_ERR(refclk) != -EPROBE_DEFER)
> +			dev_err(dev, "failed to get refclk: %ld\n",
> +				PTR_ERR(refclk));
> +		return PTR_ERR(refclk);
> +	}
> +
> +	clk_prepare_enable(refclk);
> +
> +	state->pdata.refclk_hz = clk_get_rate(refclk);
> +	state->pdata.ddc5v_delay = DDC5V_DELAY_100MS;
> +	state->pdata.enable_hdcp = false;
> +	/* A FIFO level of 16 should be enough for 2-lane 720p60 at 594 MHz. */
> +	state->pdata.fifo_level = 16;
> +	/*
> +	 * The PLL input clock is obtained by dividing refclk by pll_prd.
> +	 * It must be between 6 MHz and 40 MHz, lower frequency is better.
> +	 */
> +	switch (state->pdata.refclk_hz) {
> +	case 26000000:
> +	case 27000000:
> +	case 42000000:
> +		state->pdata.pll_prd = state->pdata.refclk_hz / 6000000;
> +		break;
> +	default:
> +		dev_err(dev, "unsupported refclk rate: %u Hz\n",
> +			state->pdata.refclk_hz);
> +		clk_disable_unprepare(refclk);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * The CSI bps per lane must be between 62.5 Mbps and 1 Gbps.
> +	 * The default is 594 Mbps for 4-lane 1080p60 or 2-lane 720p60.
> +	 */
> +	bps_pr_lane = 594000000U;
> +	of_property_read_u32(np, "toshiba,bps-per-lane", &bps_pr_lane);
> +	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
> +		dev_err(dev, "unsupported bps per lane: %u bps\n", bps_pr_lane);
> +		clk_disable_unprepare(refclk);
> +		return -EINVAL;
> +	}
> +	state->pdata.bps_pr_lane = bps_pr_lane;
> +
> +	/* The CSI speed per lane is refclk / pll_prd * pll_fbd */
> +	state->pdata.pll_fbd = state->pdata.bps_pr_lane /
> +			       state->pdata.refclk_hz * state->pdata.pll_prd;
> +	bps_pr_lane = state->pdata.refclk_hz / state->pdata.pll_prd *
> +		      state->pdata.pll_fbd;
> +	if (bps_pr_lane != state->pdata.bps_pr_lane) {
> +		dev_warn(dev, "bps per lane corrected to %u bps\n",
> +			 bps_pr_lane);
> +		state->pdata.bps_pr_lane = bps_pr_lane;
> +	}
> +
> +	/* FIXME: These timings are from REF_02 for 594 Mbps per lane */
> +	state->pdata.lineinitcnt = 0xe80;
> +	state->pdata.lptxtimecnt = 0x003;
> +	/* tclk-preparecnt: 3, tclk-zerocnt: 20 */
> +	state->pdata.tclk_headercnt = 0x1403;
> +	state->pdata.tclk_trailcnt = 0x00;
> +	/* ths-preparecnt: 3, ths-zerocnt: 1 */
> +	state->pdata.ths_headercnt = 0x0103;
> +	state->pdata.twakeup = 0x4882;
> +	state->pdata.tclk_postcnt = 0x008;
> +	state->pdata.ths_trailcnt = 0x2;
> +	state->pdata.hstxvregcnt = 0;
> +
> +	/* HDMI PHY */
> +	state->pdata.phy_auto_rst = 0;
> +	state->pdata.hdmi_det_v = 0;
> +	state->pdata.h_pi_rst = 0;
> +	state->pdata.v_pi_rst = 0;
> +
> +	state->reset_gpio = devm_gpiod_get(dev, "reset");
> +	if (IS_ERR(state->reset_gpio)) {
> +		dev_err(dev, "failed to get reset gpio\n");
> +		clk_disable_unprepare(refclk);
> +		return PTR_ERR(state->reset_gpio);
> +	}
> +
> +	tc358743_gpio_reset(state);
> +
> +	return 0;
> +}
> +#else
> +static inline int tc358743_probe_of(struct tc358743_state *state)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
>   static int tc358743_probe(struct i2c_client *client,
>   			  const struct i2c_device_id *id)
>   {
> @@ -1656,14 +1774,19 @@ static int tc358743_probe(struct i2c_client *client,
>   		return -ENOMEM;
>   	}
>   
> +	state->i2c_client = client;
> +
>   	/* platform data */
> -	if (!pdata) {
> -		v4l_err(client, "No platform data!\n");
> -		return -ENODEV;
> +	if (pdata) {
> +		state->pdata = *pdata;
> +	} else {
> +		err = tc358743_probe_of(state);
> +		if (err == -ENODEV)
> +			v4l_err(client, "No platform data!\n");
> +		if (err)
> +			return err;
>   	}
> -	state->pdata = *pdata;
>   
> -	state->i2c_client = client;
>   	sd = &state->sd;
>   	v4l2_i2c_subdev_init(sd, client, &tc358743_ops);
>   	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;

