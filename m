Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37010 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751055AbeCGING (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 03:13:06 -0500
Date: Wed, 7 Mar 2018 10:13:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH] media: ov5640: fix get_/set_fmt colorspace related fields
Message-ID: <20180307081302.h47mjhlkeq72shw7@valkosipuli.retiisi.org.uk>
References: <1520355879-20291-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520355879-20291-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Tue, Mar 06, 2018 at 06:04:39PM +0100, Hugues Fruchet wrote:
> Fix set of missing colorspace related fields in get_/set_fmt.
> Detected by v4l2-compliance tool.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>

Could you confirm this is the one you intended to send? There are two
others with similar content.

...

> @@ -2497,16 +2504,22 @@ static int ov5640_probe(struct i2c_client *client,
>  	struct fwnode_handle *endpoint;
>  	struct ov5640_dev *sensor;
>  	int ret;
> +	struct v4l2_mbus_framefmt *fmt;

This one I'd arrange before ret. The local variable declarations should
generally look like a Christmas tree but upside down.

If you're happy with that, I can swap the two lines as well (no need for
v2).

>  
>  	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
>  	if (!sensor)
>  		return -ENOMEM;
>  
>  	sensor->i2c_client = client;
> -	sensor->fmt.code = MEDIA_BUS_FMT_UYVY8_2X8;
> -	sensor->fmt.width = 640;
> -	sensor->fmt.height = 480;
> -	sensor->fmt.field = V4L2_FIELD_NONE;
> +	fmt = &sensor->fmt;
> +	fmt->code = ov5640_formats[0].code;
> +	fmt->colorspace = ov5640_formats[0].colorspace;
> +	fmt->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(fmt->colorspace);
> +	fmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +	fmt->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(fmt->colorspace);
> +	fmt->width = 640;
> +	fmt->height = 480;
> +	fmt->field = V4L2_FIELD_NONE;
>  	sensor->frame_interval.numerator = 1;
>  	sensor->frame_interval.denominator = ov5640_framerates[OV5640_30_FPS];
>  	sensor->current_fr = OV5640_30_FPS;

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
