Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8997 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbbCPJPl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 05:15:41 -0400
Message-ID: <55069F38.5000607@linux.intel.com>
Date: Mon, 16 Mar 2015 11:15:36 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v6] media: i2c: add support for omnivision's ov2659 sensor
References: <1426415656-20775-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1426415656-20775-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Prabhakar,

Lad Prabhakar wrote:
...
> +static const struct ov2659_pixfmt ov2659_formats[] = {
> +	{
> +		.code = MEDIA_BUS_FMT_YUYV8_2X8,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +		.format_ctrl_regs = ov2659_format_yuyv,
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_UYVY8_2X8,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +		.format_ctrl_regs = ov2659_format_uyvy,
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_RGB565_2X8_BE,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +		.format_ctrl_regs = ov2659_format_rgb565,
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
> +		.colorspace = V4L2_COLORSPACE_SMPTE170M,
> +		.format_ctrl_regs = ov2659_format_bggr,
> +	},
> +};

...

> +static int ov2659_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	const struct ov2659_platform_data *pdata = ov2659_get_pdata(client);
> +	struct v4l2_subdev *sd;
> +	struct ov2659 *ov2659;
> +	struct clk *clk;
> +	int ret;
> +
> +	if (!pdata) {
> +		dev_err(&client->dev, "platform data not specified\n");
> +		return -EINVAL;
> +	}
> +
> +	ov2659 = devm_kzalloc(&client->dev, sizeof(*ov2659), GFP_KERNEL);
> +	if (!ov2659)
> +		return -ENOMEM;
> +
> +	ov2659->pdata = pdata;
> +	ov2659->client = client;
> +
> +	clk = devm_clk_get(&client->dev, "xvclk");
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	ov2659->xvclk_frequency = clk_get_rate(clk);
> +	if (ov2659->xvclk_frequency < 6000000 ||
> +	    ov2659->xvclk_frequency > 27000000)
> +		return -EINVAL;
> +
> +	v4l2_ctrl_handler_init(&ov2659->ctrls, 2);
> +	v4l2_ctrl_new_std(&ov2659->ctrls, &ov2659_ctrl_ops,
> +			  V4L2_CID_PIXEL_RATE, pdata->link_frequency,
> +			  pdata->link_frequency, 1, pdata->link_frequency);

Are the formats that you advertise correct? If so, you should divide the
link frequency by two to get pixel rate on formats that have two samples
per clock cycle, i.e. use v4l2_ctrl_s_ctrl_int64() /
__v4l2_ctrl_s_ctrl_int64().

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
