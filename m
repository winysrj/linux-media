Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60854 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727854AbeKPXpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 18:45:02 -0500
Date: Fri, 16 Nov 2018 15:32:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com,
        enrico.scholz@sigma-chemnitz.de, akinobu.mita@gmail.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH v2 4/6] media: mt9m111: allow to setup pixclk polarity
Message-ID: <20181116133235.kge7xept2sgfnnwo@valkosipuli.retiisi.org.uk>
References: <20181029182410.18783-1-m.felsch@pengutronix.de>
 <20181029182410.18783-5-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029182410.18783-5-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marco, Enrico,

On Mon, Oct 29, 2018 at 07:24:08PM +0100, Marco Felsch wrote:
> From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> 
> The chip can be configured to output data transitions on the
> rising or falling edge of PIXCLK (Datasheet R58:1[9]), default is on the
> falling edge.
> 
> Parsing the fw-node is made in a subfunction to bundle all (future)
> dt-parsing / fw-parsing stuff.
> 
> Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> (m.grzeschik@pengutronix.de: Fix inverting clock. INV_PIX_CLOCK bit is set
> per default. Set bit to 0 (enable mask bit without value) to enable
> falling edge sampling.)
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> (m.felsch@pengutronix.de: use fwnode helpers)
> (m.felsch@pengutronix.de: mv fw parsing into own function)
> (m.felsch@pengutronix.de: adapt commit msg)
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> 
> ---
> Changelog:
> 
> v2:
> - make use of fwnode_*() to drop OF dependency and ifdef's
> - mt9m111_g_mbus_config: fix pclk_sample logic which I made due the
>   conversion from Enrico's patch.
> 
>  drivers/media/i2c/mt9m111.c | 46 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> index e9879e111f58..112eaa5ba917 100644
> --- a/drivers/media/i2c/mt9m111.c
> +++ b/drivers/media/i2c/mt9m111.c
> @@ -15,12 +15,14 @@
>  #include <linux/delay.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/module.h>
> +#include <linux/property.h>
>  
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-clk.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
>  
>  /*
>   * MT9M111, MT9M112 and MT9M131:
> @@ -239,6 +241,8 @@ struct mt9m111 {
>  	const struct mt9m111_datafmt *fmt;
>  	int lastpage;	/* PageMap cache value */
>  	bool is_streaming;
> +	/* user point of view - 0: falling 1: rising edge */
> +	unsigned int pclk_sample:1;

You could use a bool. Up to you.

>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_pad pad;
>  #endif
> @@ -591,6 +595,10 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
>  		return -EINVAL;
>  	}
>  
> +	/* receiver samples on falling edge, chip-hw default is rising */
> +	if (mt9m111->pclk_sample == 0)
> +		mask_outfmt2 |= MT9M111_OUTFMT_INV_PIX_CLOCK;
> +
>  	ret = mt9m111_reg_mask(client, context_a.output_fmt_ctrl2,
>  			       data_outfmt2, mask_outfmt2);
>  	if (!ret)
> @@ -1051,9 +1059,15 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
>  static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
>  				struct v4l2_mbus_config *cfg)
>  {
> -	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
> +	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
> +
> +	cfg->flags = V4L2_MBUS_MASTER |
>  		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
>  		V4L2_MBUS_DATA_ACTIVE_HIGH;
> +
> +	cfg->flags |= mt9m111->pclk_sample ? V4L2_MBUS_PCLK_SAMPLE_RISING :
> +		V4L2_MBUS_PCLK_SAMPLE_FALLING;
> +
>  	cfg->type = V4L2_MBUS_PARALLEL;
>  
>  	return 0;
> @@ -1123,6 +1137,32 @@ static int mt9m111_video_probe(struct i2c_client *client)
>  	return ret;
>  }
>  
> +static int mt9m111_probe_fw(struct i2c_client *client, struct mt9m111 *mt9m111)
> +{
> +	struct v4l2_fwnode_endpoint *bus_cfg;
> +	struct fwnode_handle *np;
> +	int ret = 0;
> +
> +	np = fwnode_graph_get_next_endpoint(dev_fwnode(&client->dev), NULL);
> +	if (!np)
> +		return -EINVAL;
> +
> +	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(np);
> +	if (IS_ERR(bus_cfg)) {
> +		ret = PTR_ERR(bus_cfg);
> +		goto out_put_fw;
> +	}
> +
> +	mt9m111->pclk_sample = !!(bus_cfg->bus.parallel.flags &
> +				  V4L2_MBUS_PCLK_SAMPLE_RISING);
> +
> +	v4l2_fwnode_endpoint_free(bus_cfg);
> +
> +out_put_fw:
> +	fwnode_handle_put(np);
> +	return ret;
> +}
> +
>  static int mt9m111_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *did)
>  {
> @@ -1147,6 +1187,10 @@ static int mt9m111_probe(struct i2c_client *client,
>  	/* Default HIGHPOWER context */
>  	mt9m111->ctx = &context_b;
>  
> +	ret = mt9m111_probe_fw(client, mt9m111);
> +	if (ret)
> +		return ret;

Can you do this before v4l2_clk_get()? That'll go anyway, but for now,
you'd need extra error handling for it.

> +
>  	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
>  	mt9m111->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  

Please also put this patch after the DT binding changes.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
