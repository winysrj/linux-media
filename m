Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3001 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbeJTFcX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 01:32:23 -0400
Date: Sat, 20 Oct 2018 00:24:28 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, akinobu.mita@gmail.com,
        enrico.scholz@sigma-chemnitz.de, linux-media@vger.kernel.org,
        kernel@pengutronix.de,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH 4/4] media: mt9m111: allow to setup pixclk polarity
Message-ID: <20181019212427.ignw3tmi675jspoj@kekkonen.localdomain>
References: <20181019155027.28682-1-m.felsch@pengutronix.de>
 <20181019155027.28682-5-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181019155027.28682-5-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marco,

Thanks for the patchset.

On Fri, Oct 19, 2018 at 05:50:27PM +0200, Marco Felsch wrote:
> From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> 
> The chip can be configured to output data transitions on the
> rising or falling edge of PIXCLK (Datasheet R58:1[9]), default is on the
> falling edge.
> 
> Parsing the fw-node is made in a subfunction to bundle all (future)
> dt-parsing / fw-parsing stuff.

Could you rebase this on current mediatree master, please?

> 
> Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> (m.grzeschik@pengutronix.de: Fix inverting clock. INV_PIX_CLOCK bit is set
> per default. Set bit to 0 (enable mask bit without value) to enable
> falling edge sampling.)
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> (m.felsch@pengutronix.de: use fwnode helpers)
> (m.felsch@pengutronix.de: mv of parsing into own function)
> (m.felsch@pengutronix.de: adapt commit msg)
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/mt9m111.c | 52 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> index 13080c6c1ba3..5d45bc9ea0cb 100644
> --- a/drivers/media/i2c/mt9m111.c
> +++ b/drivers/media/i2c/mt9m111.c
> @@ -15,12 +15,14 @@
>  #include <linux/delay.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/module.h>
> +#include <linux/of_graph.h>
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
> @@ -236,6 +238,8 @@ struct mt9m111 {
>  	const struct mt9m111_datafmt *fmt;
>  	int lastpage;	/* PageMap cache value */
>  	bool is_streaming;
> +	/* user point of view - 0: falling 1: rising edge */
> +	unsigned int pclk_sample:1;
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_pad pad;
>  #endif
> @@ -586,6 +590,10 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
>  		return -EINVAL;
>  	}
>  
> +	/* receiver samples on falling edge, chip-hw default is rising */

Could you add DT binding documentation that would cover this? The existing
documentation is, well, rather vague. Which properties are relevant for the
hardware, are they mandatory or optional and if they're optional, then are
there relevant default values?

> +	if (mt9m111->pclk_sample == 0)
> +		mask_outfmt2 |= MT9M111_OUTFMT_INV_PIX_CLOCK;
> +
>  	ret = mt9m111_reg_mask(client, context_a.output_fmt_ctrl2,
>  			       data_outfmt2, mask_outfmt2);
>  	if (!ret)
> @@ -1045,9 +1053,15 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
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
> +	cfg->flags |= mt9m111->pclk_sample ? V4L2_MBUS_PCLK_SAMPLE_FALLING :
> +		V4L2_MBUS_PCLK_SAMPLE_RISING;
> +
>  	cfg->type = V4L2_MBUS_PARALLEL;
>  
>  	return 0;
> @@ -1117,6 +1131,33 @@ static int mt9m111_video_probe(struct i2c_client *client)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_OF
> +static int mt9m111_probe_of(struct i2c_client *client, struct mt9m111 *mt9m111)
> +{
> +	struct v4l2_fwnode_endpoint *bus_cfg;
> +	struct device_node *np;
> +	int ret = 0;
> +
> +	np = of_graph_get_next_endpoint(client->dev.of_node, NULL);
> +	if (!np)
> +		return -EINVAL;
> +
> +	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(np));
> +	if (IS_ERR(bus_cfg)) {
> +		ret = PTR_ERR(bus_cfg);
> +		goto out_of_put;
> +	}
> +
> +	mt9m111->pclk_sample = !!(bus_cfg->bus.parallel.flags &
> +				  V4L2_MBUS_PCLK_SAMPLE_RISING);
> +
> +	v4l2_fwnode_endpoint_free(bus_cfg);
> +out_of_put:
> +	of_node_put(np);
> +	return ret;
> +}
> +#endif
> +
>  static int mt9m111_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *did)
>  {
> @@ -1141,6 +1182,15 @@ static int mt9m111_probe(struct i2c_client *client,
>  	/* Default HIGHPOWER context */
>  	mt9m111->ctx = &context_b;
>  
> +	if (IS_ENABLED(CONFIG_OF)) {
> +		ret = mt9m111_probe_of(client, mt9m111);
> +		if (ret)
> +			return ret;
> +	} else {
> +		/* use default chip hardware values */
> +		mt9m111->pclk_sample = 1;
> +	}
> +
>  	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
>  	mt9m111->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
