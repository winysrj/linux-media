Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:41188 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbeIFSGt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 14:06:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 1/5] media: ov5640: fix exposure regression
Date: Thu, 06 Sep 2018 16:31:22 +0300
Message-ID: <9486616.rRIMQl6ReX@avalon>
In-Reply-To: <1534155586-26974-2-git-send-email-hugues.fruchet@st.com>
References: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com> <1534155586-26974-2-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

Thank you for the patch.

On Monday, 13 August 2018 13:19:42 EEST Hugues Fruchet wrote:
> fixes: bf4a4b518c20 ("media: ov5640: Don't force the auto exposure state at
> start time").
> 
> Symptom was black image when capturing HD or 5Mp picture
> due to manual exposure set to 1 while it was intended to
> set autoexposure to "manual", fix this.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/ov5640.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 1ecbb7a..4b9da8b 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -938,6 +938,12 @@ static int ov5640_load_regs(struct ov5640_dev *sensor,
>  	return ret;
>  }
> 
> +static int ov5640_set_autoexposure(struct ov5640_dev *sensor, bool on)
> +{
> +	return ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
> +			      BIT(0), on ? 0 : BIT(0));
> +}
> +
>  /* read exposure, in number of line periods */
>  static int ov5640_get_exposure(struct ov5640_dev *sensor)
>  {
> @@ -1593,7 +1599,7 @@ static int ov5640_set_mode_exposure_calc(struct
> ov5640_dev *sensor, */
>  static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
>  				  const struct ov5640_mode_info *mode,
> -				  s32 exposure)
> +				  bool auto_exp)
>  {
>  	int ret;
> 
> @@ -1610,7 +1616,8 @@ static int ov5640_set_mode_direct(struct ov5640_dev
> *sensor, if (ret)
>  		return ret;
> 
> -	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, exposure);
> +	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, auto_exp ?
> +				  V4L2_EXPOSURE_AUTO : V4L2_EXPOSURE_MANUAL);
>  }
> 
>  static int ov5640_set_mode(struct ov5640_dev *sensor,
> @@ -1618,7 +1625,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
>  {
>  	const struct ov5640_mode_info *mode = sensor->current_mode;
>  	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
> -	s32 exposure;
> +	bool auto_exp =  sensor->ctrls.auto_exp->val == V4L2_EXPOSURE_AUTO;
>  	int ret;
> 
>  	dn_mode = mode->dn_mode;
> @@ -1629,8 +1636,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
>  	if (ret)
>  		return ret;
> 
> -	exposure = sensor->ctrls.auto_exp->val;
> -	ret = ov5640_set_exposure(sensor, V4L2_EXPOSURE_MANUAL);
> +	ret = ov5640_set_autoexposure(sensor, false);
>  	if (ret)
>  		return ret;
> 
> @@ -1646,7 +1652,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
>  		 * change inside subsampling or scaling
>  		 * download firmware directly
>  		 */
> -		ret = ov5640_set_mode_direct(sensor, mode, exposure);
> +		ret = ov5640_set_mode_direct(sensor, mode, auto_exp);
>  	}
> 
>  	if (ret < 0)

-- 
Regards,

Laurent Pinchart
