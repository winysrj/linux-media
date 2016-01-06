Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38077 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbcAFKzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 05:55:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/10] [media] tvp5150: Configure data interface via pdata or DT
Date: Wed, 06 Jan 2016 12:56 +0200
Message-ID: <1743151.ozK6T8LOF3@avalon>
In-Reply-To: <1451910332-23385-11-git-send-email-javier@osg.samsung.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com> <1451910332-23385-11-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Monday 04 January 2016 09:25:32 Javier Martinez Canillas wrote:
> The video decoder supports either 8-bit 4:2:2 YUV with discrete syncs
> or 8-bit ITU-R BT.656 with embedded syncs output format but currently
> BT.656 it's always reported. Allow to configure the format to use via
> either platform data or a device tree definition.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
>  drivers/media/i2c/tvp5150.c | 61 ++++++++++++++++++++++++++++++++++++++++--
>  include/media/i2c/tvp5150.h |  5 ++++
>  2 files changed, 64 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index fed89a811ab7..8bce45a6e264 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -6,6 +6,7 @@
>   */
> 
>  #include <linux/of_gpio.h>
> +#include <linux/of_graph.h>
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
> @@ -15,6 +16,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/i2c/tvp5150.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-of.h>
> 
>  #include "tvp5150_reg.h"
> 
> @@ -39,6 +41,7 @@ struct tvp5150 {
>  	struct media_pad pad;
>  	struct v4l2_ctrl_handler hdl;
>  	struct v4l2_rect rect;
> +	struct tvp5150_platform_data *pdata;

How about embedding tvp5150_platform_data instead of pointing to it ? It would 
save an allocation and you could get rid of the pdata != NULL checks.

>  	v4l2_std_id norm;	/* Current set standard */
>  	u32 input;
> @@ -757,6 +760,7 @@ static int tvp5150_s_std(struct v4l2_subdev *sd,
> v4l2_std_id std) static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
>  {
>  	struct tvp5150 *decoder = to_tvp5150(sd);
> +	struct tvp5150_platform_data *pdata = decoder->pdata;
> 
>  	/* Initializes TVP5150 to its default values */
>  	tvp5150_write_inittab(sd, tvp5150_init_default);
> @@ -774,6 +778,10 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32
> val) v4l2_ctrl_handler_setup(&decoder->hdl);
> 
>  	tvp5150_set_std(sd, decoder->norm);
> +
> +	if (pdata && pdata->bus_type == V4L2_MBUS_PARALLEL)
> +		tvp5150_write(sd, TVP5150_DATA_RATE_SEL, 0x40);
> +
>  	return 0;
>  };
> 
> @@ -940,6 +948,16 @@ static int tvp5150_cropcap(struct v4l2_subdev *sd,
> struct v4l2_cropcap *a) static int tvp5150_g_mbus_config(struct v4l2_subdev
> *sd,
>  				 struct v4l2_mbus_config *cfg)
>  {
> +	struct tvp5150_platform_data *pdata = to_tvp5150(sd)->pdata;
> +
> +	if (pdata) {
> +		cfg->type = pdata->bus_type;
> +		cfg->flags = pdata->parallel_flags;

The clock and sync signals polarity don't seem configurable, shouldn't they 
just be hardcoded as currently done ?

> +		return 0;
> +	}
> +
> +	/* Default values if no platform data was provided */
>  	cfg->type = V4L2_MBUS_BT656;
>  	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING
> 
>  		   | V4L2_MBUS_FIELD_EVEN_LOW | V4L2_MBUS_DATA_ACTIVE_HIGH;
> 
> @@ -986,13 +1004,20 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev
> *sd,
> 
>  static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
>  {
> +	struct tvp5150_platform_data *pdata = to_tvp5150(sd)->pdata;
> +	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
> +	int val = 0x09;
> +
> +	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
> +	if (pdata && pdata->bus_type == V4L2_MBUS_PARALLEL)
> +		val = 0x0d;
> +
>  	/* Initializes TVP5150 to its default values */
>  	/* # set PCLK (27MHz) */
>  	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
> 
> -	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
>  	if (enable)
> -		tvp5150_write(sd, TVP5150_MISC_CTL, 0x09);
> +		tvp5150_write(sd, TVP5150_MISC_CTL, val);
>  	else
>  		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);
> 
> @@ -1228,11 +1253,42 @@ static inline int tvp5150_init(struct i2c_client *c)
> return 0;
>  }
> 
> +static struct tvp5150_platform_data *tvp5150_get_pdata(struct device *dev)
> +{
> +	struct tvp5150_platform_data *pdata = dev_get_platdata(dev);
> +	struct v4l2_of_endpoint bus_cfg;
> +	struct device_node *ep;
> +
> +	if (pdata)
> +		return pdata;

Nobody uses platform data today, I wonder whether we shouldn't postpone adding 
support for it until we have a use case. Embedded systems (at least the ARM-
based ones) should use DT.

> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
> +		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata)
> +			return NULL;
> +
> +		ep = of_graph_get_next_endpoint(dev->of_node, NULL);
> +		if (!ep)
> +			return NULL;
> +
> +		v4l2_of_parse_endpoint(ep, &bus_cfg);

Shouldn't you check the return value of the function ?

> +
> +		pdata->bus_type = bus_cfg.bus_type;
> +		pdata->parallel_flags = bus_cfg.bus.parallel.flags;

The V4L2_MBUS_DATA_ACTIVE_HIGH flags set returned by tvp5150_g_mbus_config() 
when pdata is NULL is never set by v4l2_of_parse_endpoint(), should you add it 
unconditionally ?

> +		of_node_put(ep);
> +		return pdata;
> +	}
> +
> +	return NULL;
> +}
> +
>  static int tvp5150_probe(struct i2c_client *c,
>  			 const struct i2c_device_id *id)
>  {
>  	struct tvp5150 *core;
>  	struct v4l2_subdev *sd;
> +	struct tvp5150_platform_data *pdata = tvp5150_get_pdata(&c->dev);
>  	int res;
> 
>  	/* Check if the adapter supports the needed features */
> @@ -1262,6 +1318,7 @@ static int tvp5150_probe(struct i2c_client *c,
>  	if (res < 0)
>  		return res;
> 
> +	core->pdata = pdata;
>  	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
>  	core->input = TVP5150_COMPOSITE1;
>  	core->enable = 1;
> diff --git a/include/media/i2c/tvp5150.h b/include/media/i2c/tvp5150.h
> index 649908a25605..e4cda0c843df 100644
> --- a/include/media/i2c/tvp5150.h
> +++ b/include/media/i2c/tvp5150.h
> @@ -30,4 +30,9 @@
>  #define TVP5150_NORMAL       0
>  #define TVP5150_BLACK_SCREEN 1
> 
> +struct tvp5150_platform_data {
> +	enum v4l2_mbus_type bus_type;
> +	unsigned int parallel_flags;
> +};
> +
>  #endif

-- 
Regards,

Laurent Pinchart

