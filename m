Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40858 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbeIFR6o (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 13:58:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 3/5] media: ov5640: fix wrong binning value in exposure calculation
Date: Thu, 06 Sep 2018 16:23:20 +0300
Message-ID: <2226862.sn8GYFLbj6@avalon>
In-Reply-To: <1534155586-26974-4-git-send-email-hugues.fruchet@st.com>
References: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com> <1534155586-26974-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

Thank you for the patch.

On Monday, 13 August 2018 13:19:44 EEST Hugues Fruchet wrote:
> ov5640_set_mode_exposure_calc() is checking binning value but
> binning value read is buggy, fix this.
> Rename ov5640_binning_on() to ov5640_get_binning() as per other
> similar functions.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>

Reiewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/ov5640.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 7c569de..9fb17b5 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1349,7 +1349,7 @@ static int ov5640_set_ae_target(struct ov5640_dev
> *sensor, int target) return ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL1F,
> fast_low); }
> 
> -static int ov5640_binning_on(struct ov5640_dev *sensor)
> +static int ov5640_get_binning(struct ov5640_dev *sensor)
>  {
>  	u8 temp;
>  	int ret;
> @@ -1357,8 +1357,8 @@ static int ov5640_binning_on(struct ov5640_dev
> *sensor) ret = ov5640_read_reg(sensor, OV5640_REG_TIMING_TC_REG21, &temp);
> if (ret)
>  		return ret;
> -	temp &= 0xfe;
> -	return temp ? 1 : 0;
> +
> +	return temp & BIT(0);
>  }
> 
>  static int ov5640_set_binning(struct ov5640_dev *sensor, bool enable)
> @@ -1468,7 +1468,7 @@ static int ov5640_set_mode_exposure_calc(struct
> ov5640_dev *sensor, if (ret < 0)
>  		return ret;
>  	prev_shutter = ret;
> -	ret = ov5640_binning_on(sensor);
> +	ret = ov5640_get_binning(sensor);
>  	if (ret < 0)
>  		return ret;
>  	if (ret && mode->id != OV5640_MODE_720P_1280_720 &&


-- 
Regards,

Laurent Pinchart
