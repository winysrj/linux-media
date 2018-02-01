Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53091 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbeBAQ46 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Feb 2018 11:56:58 -0500
Date: Thu, 1 Feb 2018 17:56:44 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH] media: ov5640: fix virtual_channel parameter permissions
Message-ID: <20180201165644.GA17660@w540>
References: <1517491054-12048-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1517491054-12048-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thu, Feb 01, 2018 at 02:17:34PM +0100, Hugues Fruchet wrote:
> Fix module_param(virtual_channel) permissions.
> This problem was detected by checkpatch:
> $ scripts/checkpatch.pl -f drivers/media/i2c/ov5640.c
> ERROR: Use 4 digit octal (0777) not decimal permissions
> #131: FILE: drivers/media/i2c/ov5640.c:131:
> +module_param(virtual_channel, int, 0);
>
> Also explicitly set initial value to 0 for default value
> and add an error trace in case of virtual_channel not in
> the valid range of values.
>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 696a28b..906f202 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -127,8 +127,8 @@ struct ov5640_pixfmt {
>   * FIXME: remove this when a subdev API becomes available
>   * to set the MIPI CSI-2 virtual channel.
>   */
> -static unsigned int virtual_channel;
> -module_param(virtual_channel, int, 0);
> +static unsigned int virtual_channel = 0;
> +module_param(virtual_channel, int, 0444);

Parameter type is unsigned int, please use uint here.
As also checkpatch reports, it is not necessary to initialize static
variables to 0.

>  MODULE_PARM_DESC(virtual_channel,
>  		 "MIPI CSI-2 virtual channel (0..3), default 0");
>
> @@ -1358,11 +1358,15 @@ static int ov5640_binning_on(struct ov5640_dev *sensor)
>
>  static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
>  {
> +	struct i2c_client *client = sensor->i2c_client;
>  	u8 temp, channel = virtual_channel;
>  	int ret;
>
> -	if (channel > 3)
> +	if (channel > 3) {
> +		dev_err(&client->dev, "%s: wrong virtual_channel parameter value, expected (0..3), got %d\n",

I understand you don't want to break error messages to 80 columns to
ease grep for errors, but you can break the line after "client->dev"
to make this less painful for the eyes.

Thanks
   j

> +			__func__, channel);
>  		return -EINVAL;
> +	}
>
>  	ret = ov5640_read_reg(sensor, OV5640_REG_DEBUG_MODE, &temp);
>  	if (ret)
> --
> 1.9.1
>
