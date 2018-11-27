Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49789 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbeK1ApZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 19:45:25 -0500
Date: Tue, 27 Nov 2018 14:47:18 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH v3 6/6] media: mt9m111: allow to setup pixclk polarity
Message-ID: <20181127134718.7rtlkbsha3jj3qhj@pengutronix.de>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
 <20181127100253.30845-7-m.felsch@pengutronix.de>
 <20181127131948.maqwyqmlnwowf4ng@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127131948.maqwyqmlnwowf4ng@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 18-11-27 15:19, Sakari Ailus wrote:
> Hi Marco,
> 
> On Tue, Nov 27, 2018 at 11:02:53AM +0100, Marco Felsch wrote:
> > From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > 
> > The chip can be configured to output data transitions on the
> > rising or falling edge of PIXCLK (Datasheet R58:1[9]), default is on the
> > falling edge.
> > 
> > Parsing the fw-node is made in a subfunction to bundle all (future)
> > dt-parsing / fw-parsing stuff.
> > 
> > Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > (m.grzeschik@pengutronix.de: Fix inverting clock. INV_PIX_CLOCK bit is set
> > per default. Set bit to 0 (enable mask bit without value) to enable
> > falling edge sampling.)
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > (m.felsch@pengutronix.de: use fwnode helpers)
> > (m.felsch@pengutronix.de: mv fw parsing into own function)
> > (m.felsch@pengutronix.de: adapt commit msg)
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> 
> Applied with the following diff:
> 
> diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> index 2ef332b9b914..b6011bfddde8 100644
> --- a/drivers/media/i2c/mt9m111.c
> +++ b/drivers/media/i2c/mt9m111.c
> @@ -1172,24 +1172,24 @@ static int mt9m111_video_probe(struct i2c_client *client)
>  
>  static int mt9m111_probe_fw(struct i2c_client *client, struct mt9m111 *mt9m111)
>  {
> -	struct v4l2_fwnode_endpoint *bus_cfg;
> +	struct v4l2_fwnode_endpoint bus_cfg = {
> +		.bus_type = V4L2_MBUS_PARALLEL
> +	};
>  	struct fwnode_handle *np;
> -	int ret = 0;
> +	int ret;
>  
>  	np = fwnode_graph_get_next_endpoint(dev_fwnode(&client->dev), NULL);
>  	if (!np)
>  		return -EINVAL;
>  
> -	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(np);
> -	if (IS_ERR(bus_cfg)) {
> -		ret = PTR_ERR(bus_cfg);
> +	ret = v4l2_fwnode_endpoint_alloc_parse(np, &bus_cfg);
> +	if (ret)
>  		goto out_put_fw;
> -	}
>  
> -	mt9m111->pclk_sample = !!(bus_cfg->bus.parallel.flags &
> +	mt9m111->pclk_sample = !!(bus_cfg.bus.parallel.flags &
>  				  V4L2_MBUS_PCLK_SAMPLE_RISING);
>  
> -	v4l2_fwnode_endpoint_free(bus_cfg);
> +	v4l2_fwnode_endpoint_free(&bus_cfg);
>  
>  out_put_fw:
>  	fwnode_handle_put(np);
> 
> Please base on current media tree master on the next time. Thanks.

Sorry, thanks for the inline fix :)

Kind regards,
Marco

> -- 
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
