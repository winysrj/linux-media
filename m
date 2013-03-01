Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37228 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3CALCS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 06:02:18 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MIZ00BBPAK3MI70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Mar 2013 11:02:15 +0000 (GMT)
Received: from [106.116.147.108] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MIZ00DMSANRWD60@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Mar 2013 11:02:15 +0000 (GMT)
Message-id: <51308AB6.3090309@samsung.com>
Date: Fri, 01 Mar 2013 12:02:14 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 10/18] s5p-tv: add dv_timings support for hdmiphy.
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
 <c1ace44350055629138909c9a16a566f36add130.1361006882.git.hans.verkuil@cisco.com>
In-reply-to: <c1ace44350055629138909c9a16a566f36add130.1361006882.git.hans.verkuil@cisco.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Please refer to the comments below.

On 02/16/2013 10:28 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This just adds dv_timings support without modifying existing dv_preset
> support, although I had to refactor a little bit in order to share
> hdmiphy_find_conf() between the preset and timings code.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-tv/hdmiphy_drv.c |   48 ++++++++++++++++++++++-----
>  1 file changed, 39 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
> index 80717ce..85b4211 100644
> --- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
> +++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
> @@ -197,14 +197,9 @@ static unsigned long hdmiphy_preset_to_pixclk(u32 preset)
>  		return 0;
>  }
>  
> -static const u8 *hdmiphy_find_conf(u32 preset, const struct hdmiphy_conf *conf)
> +static const u8 *hdmiphy_find_conf(unsigned long pixclk,
> +		const struct hdmiphy_conf *conf)
>  {
> -	unsigned long pixclk;
> -
> -	pixclk = hdmiphy_preset_to_pixclk(preset);
> -	if (!pixclk)
> -		return NULL;
> -
>  	for (; conf->pixclk; ++conf)
>  		if (conf->pixclk == pixclk)
>  			return conf->data;
> @@ -220,15 +215,49 @@ static int hdmiphy_s_power(struct v4l2_subdev *sd, int on)
>  static int hdmiphy_s_dv_preset(struct v4l2_subdev *sd,
>  	struct v4l2_dv_preset *preset)
>  {
> -	const u8 *data;
> +	const u8 *data = NULL;
>  	u8 buffer[32];
>  	int ret;
>  	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	unsigned long pixclk;
>  	struct device *dev = &client->dev;
>  
>  	dev_info(dev, "s_dv_preset(preset = %d)\n", preset->preset);
> -	data = hdmiphy_find_conf(preset->preset, ctx->conf_tab);
> +
> +	pixclk = hdmiphy_preset_to_pixclk(preset->preset);

Just nitpicking.
The pixclk might be 0 is the preset is not supported hdmiphy.
For some platforms not all frequencies are supported.
Anyway, if pixclk is 0 then hdmiphy_find_conf will detect it.

> +	data = hdmiphy_find_conf(pixclk, ctx->conf_tab);
> +	if (!data) {
> +		dev_err(dev, "format not supported\n");
> +		return -EINVAL;
> +	}
> +
> +	/* storing configuration to the device */
> +	memcpy(buffer, data, 32);
> +	ret = i2c_master_send(client, buffer, 32);
> +	if (ret != 32) {
> +		dev_err(dev, "failed to configure HDMIPHY via I2C\n");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int hdmiphy_s_dv_timings(struct v4l2_subdev *sd,
> +	struct v4l2_dv_timings *timings)
> +{
> +	const u8 *data;
> +	u8 buffer[32];
> +	int ret;
> +	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct device *dev = &client->dev;
> +	unsigned long pixclk = timings->bt.pixelclock;
> +
> +	dev_info(dev, "s_dv_timings\n");

Using test against V4L2_DV_FL_REDUCED_FPS and 74250000 looks little hacky to me.
Why there is no such a check for 148500000 and 27000000 (REDUCED -> INCREASED?).
Maybe it will be better to past both timings->bt.pixelclock and timings->bt.flags
as parameters for hdmiphy_find_conf function. The hdmiphy_find_conf could
perform pixclk adjustment or some fallback policy based on the flags.

> +	if ((timings->bt.flags & V4L2_DV_FL_REDUCED_FPS) && pixclk == 74250000)
> +		pixclk = 74176000;
> +	data = hdmiphy_find_conf(pixclk, ctx->conf_tab);
>  	if (!data) {
>  		dev_err(dev, "format not supported\n");
>  		return -EINVAL;
> @@ -271,6 +300,7 @@ static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
>  
>  static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
>  	.s_dv_preset = hdmiphy_s_dv_preset,
> +	.s_dv_timings = hdmiphy_s_dv_timings,
>  	.s_stream =  hdmiphy_s_stream,
>  };
>  
> 

