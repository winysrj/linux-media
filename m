Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:12295 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728245AbeINSqd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 14:46:33 -0400
Date: Fri, 14 Sep 2018 16:31:57 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, afshin.nasser@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/7] [media] tvp5150: add input source selection
 of_graph support
Message-ID: <20180914133157.wppvzfvbssmm2zer@paasikivi.fi.intel.com>
References: <20180813092508.1334-1-m.felsch@pengutronix.de>
 <20180813092508.1334-2-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180813092508.1334-2-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marco,

On Mon, Aug 13, 2018 at 11:25:02AM +0200, Marco Felsch wrote:
...
> +static void tvp5150_dt_cleanup(struct tvp5150 *decoder)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < TVP5150_NUM_PADS; i++)
> +		of_node_put(decoder->endpoints[i]);
> +}
> +
>  static const char * const tvp5150_test_patterns[2] = {
>  	"Disabled",
>  	"Black screen"
> @@ -1586,7 +1996,7 @@ static int tvp5150_probe(struct i2c_client *c,
>  		res = tvp5150_parse_dt(core, np);
>  		if (res) {
>  			dev_err(sd->dev, "DT parsing error: %d\n", res);
> -			return res;
> +			goto err_cleanup_dt;
>  		}
>  	} else {
>  		/* Default to BT.656 embedded sync */
> @@ -1594,25 +2004,16 @@ static int tvp5150_probe(struct i2c_client *c,
>  	}
>  
>  	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
> +	sd->internal_ops = &tvp5150_internal_ops;
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
> -#if defined(CONFIG_MEDIA_CONTROLLER)
> -	core->pads[TVP5150_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
> -	core->pads[TVP5150_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
> -	core->pads[TVP5150_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
> -	core->pads[TVP5150_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
> -
> -	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> -
> -	res = media_entity_pads_init(&sd->entity, TVP5150_NUM_PADS, core->pads);
> -	if (res < 0)
> -		return res;
> -
> -#endif
> +	res = tvp5150_mc_init(sd);
> +	if (res)
> +		goto err_cleanup_dt;
>  
>  	res = tvp5150_detect_version(core);
>  	if (res < 0)
> -		return res;
> +		goto err_cleanup_dt;
>  
>  	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
>  	core->detected_norm = V4L2_STD_UNKNOWN;
> @@ -1664,6 +2065,9 @@ static int tvp5150_probe(struct i2c_client *c,
>  err:

Now that you have more error labels, you could rename this one.

>  	v4l2_ctrl_handler_free(&core->hdl);
>  	return res;

Is the above line intended to be kept?

> +err_cleanup_dt:
> +	tvp5150_dt_cleanup(core);
> +	return res;
>  }
>  
>  static int tvp5150_remove(struct i2c_client *c)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
