Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46487 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaBKMCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 07:02:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 43/47] adv7604: Control hot-plug detect through a GPIO
Date: Tue, 11 Feb 2014 13:03:57 +0100
Message-ID: <1637754.DCKyOCpBtn@avalon>
In-Reply-To: <52F9F6DB.1080700@xs4all.nl>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-44-git-send-email-laurent.pinchart@ideasonboard.com> <52F9F6DB.1080700@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 11 February 2014 11:09:31 Hans Verkuil wrote:
> On 02/05/14 17:42, Laurent Pinchart wrote:
> > Replace the ADV7604-specific hotplug notifier with a GPIO to control the
> > HPD pin directly instead of going through the bridge driver.
> 
> Hmm, that's not going to work for me. I don't have a GPIO pin here, instead
> it is a bit in a register that I have to set.

But that bit controls a GPIO, doesn't it ? In that case it should be exposed 
as a GPIO controller.

> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/i2c/adv7604.c | 47 ++++++++++++++++++++++++++++++++++++----
> >  include/media/adv7604.h     |  5 ++++-
> >  2 files changed, 47 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> > index 369cb1e..2f38071 100644
> > --- a/drivers/media/i2c/adv7604.c
> > +++ b/drivers/media/i2c/adv7604.c
> > @@ -28,6 +28,7 @@
> >   */
> >  
> >  #include <linux/delay.h>
> > +#include <linux/gpio.h>
> >  #include <linux/i2c.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > @@ -608,6 +609,23 @@ static inline int edid_write_block(struct v4l2_subdev
> > *sd,
> >  	return err;
> >  }
> > 
> > +static void adv7604_set_hpd(struct adv7604_state *state, unsigned int
> > hpd)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < state->info->num_dv_ports; ++i) {
> > +		unsigned int enable = hpd & BIT(i);
> > +
> > +		if (IS_ERR_VALUE(state->pdata.hpd_gpio[i]))
> 
> IS_ERR_VALUE: that's normally used for pointers, not integers. I would
> much prefer something simple like 'bool hpd_use_gpio[4]'.

I've reworked this to use the gpiod_* API, I'll post v2 when the whole set 
will be reviewed.

> > +			continue;
> > +
> > +		if (state->pdata.hpd_gpio_low[i])
> > +			enable = !enable;
> > +
> > +		gpio_set_value_cansleep(state->pdata.hpd_gpio[i], enable);
> > +	}
> > +}
> > +
> > 
> >  static void adv7604_delayed_work_enable_hotplug(struct work_struct *work)
> >  {
> >  	struct delayed_work *dwork = to_delayed_work(work);
> > @@ -617,7 +635,7 @@ static void adv7604_delayed_work_enable_hotplug(struct
> > work_struct *work)> 
> >  	v4l2_dbg(2, debug, sd, "%s: enable hotplug\n", __func__);
> > 
> > -	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state-
>edid.present);
> > +	adv7604_set_hpd(state, state->edid.present);
> >  }
> >  
> >  static inline int hdmi_read(struct v4l2_subdev *sd, u8 reg)
> > @@ -2022,7 +2040,6 @@ static int adv7604_set_edid(struct v4l2_subdev *sd,
> > struct v4l2_subdev_edid *edi> 
> >  	struct adv7604_state *state = to_state(sd);
> >  	const struct adv7604_chip_info *info = state->info;
> >  	int spa_loc;
> > -	int tmp = 0;
> >  	int err;
> >  	int i;
> > 
> > @@ -2033,7 +2050,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd,
> > struct v4l2_subdev_edid *edi> 
> >  	if (edid->blocks == 0) {
> >  		/* Disable hotplug and I2C access to EDID RAM from DDC port */
> >  		state->edid.present &= ~(1 << edid->pad);
> > -		v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state-
>edid.present);
> > +		adv7604_set_hpd(state, state->edid.present);
> >  		rep_write_clr_set(sd, info->edid_enable_reg, 0x0f,
> >  		state->edid.present);
> >  		/* Fall back to a 16:9 aspect ratio */
> > @@ -2059,7 +2076,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd,
> > struct v4l2_subdev_edid *edi
> >  	/* Disable hotplug and I2C access to EDID RAM from DDC port */
> >  	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
> > 
> > -	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&tmp);
> > +	adv7604_set_hpd(state, 0);
> > 
> >  	rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, 0x00);
> >  	
> >  	spa_loc = get_edid_spa_location(edid->edid);
> > @@ -2655,6 +2672,28 @@ static int adv7604_probe(struct i2c_client *client,
> >  		return -ENODEV;
> >  	}
> >  	state->pdata = *pdata;
> > +
> > +	/* Request GPIOs. */
> > +	for (i = 0; i < state->info->num_dv_ports; ++i) {
> > +		char name[5];
> > +
> > +		if (IS_ERR_VALUE(state->pdata.hpd_gpio[i]))
> > +			continue;
> > +
> > +		sprintf(name, "hpd%u", i);
> > +		err = devm_gpio_request_one(&client->dev,
> > +					    state->pdata.hpd_gpio[i],
> > +					    state->pdata.hpd_gpio_low[i] ?
> > +					    GPIOF_OUT_INIT_HIGH :
> > +					    GPIOF_OUT_INIT_LOW,
> > +					    name);
> > +		if (err < 0) {
> > +			v4l_err(client, "Failed to request HPD %u GPIO (%u)\n",
> > +				i, state->pdata.hpd_gpio[i]);
> > +			return err;
> > +		}
> > +	}
> > +
> > 
> >  	state->timings = cea640x480;
> >  	state->format = adv7604_format_info(state, V4L2_MBUS_FMT_YUYV8_2X8);
> > diff --git a/include/media/adv7604.h b/include/media/adv7604.h
> > index 4da678c..dddb0cb 100644
> > --- a/include/media/adv7604.h
> > +++ b/include/media/adv7604.h
> > @@ -90,6 +90,10 @@ struct adv7604_platform_data {
> >  	/* DIS_CABLE_DET_RST: 1 if the 5V pins are unused and unconnected */
> >  	unsigned disable_cable_det_rst:1;
> > 
> > +	/* Hot-Plug Detect control GPIOs */
> > +	int hpd_gpio[4];
> > +	bool hpd_gpio_low[4];
> > +
> >  	/* Analog input muxing mode */
> >  	enum adv7604_ain_sel ain_sel;
> > 
> > @@ -133,7 +137,6 @@ struct adv7604_platform_data {
> > 
> >  #define V4L2_CID_ADV_RX_FREE_RUN_COLOR		(V4L2_CID_DV_CLASS_BASE + 
0x1002)
> >  
> >  /* notify events */
> > -#define ADV7604_HOTPLUG		1
> >  #define ADV7604_FMT_CHANGE	2
> >  
> >  #endif

-- 
Regards,

Laurent Pinchart

