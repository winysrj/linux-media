Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33575 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdHCOch (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Aug 2017 10:32:37 -0400
Received: by mail-lf0-f45.google.com with SMTP id d17so6907103lfe.0
        for <linux-media@vger.kernel.org>; Thu, 03 Aug 2017 07:32:36 -0700 (PDT)
Date: Thu, 3 Aug 2017 16:32:34 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        sakari.ailus@iki.fi, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH] media: i2c: adv748x: Store the pixel rate ctrl on CSI
 objects
Message-ID: <20170803143234.GU1382@bigcity.dyn.berto.se>
References: <1501768223-23654-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1501768223-23654-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On 2017-08-03 14:50:23 +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The current implementation has to search the list of controls for the
> pixel rate control, each time it is set.  This can be optimised easily
> by storing the ctrl pointer in the CSI/TX object, and referencing that
> directly.
> 
> While at it, fix up a missing blank line also highlighted in review
> comments.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

It won't apply cleanly to the media-tree since there already is a commit 
there which cleans-up the unused variable in dv748x_csi2_init_controls()

Apart from that:

Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> Small enhancement and fixup as suggested by Sakari, after driver acceptance.
> 
> Niklas, with my current 8 Camera set up - I can't fully test this change.
> Could you give it a spin if you get chance please?
> 
>  drivers/media/i2c/adv748x/adv748x-afe.c  |  1 +
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 15 +++++++--------
>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
>  3 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> index b33ccfc08708..134d981d69d3 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -262,6 +262,7 @@ static int adv748x_afe_g_input_status(struct v4l2_subdev *sd, u32 *status)
>  	ret = adv748x_afe_status(afe, status, NULL);
>  
>  	mutex_unlock(&state->mutex);
> +
>  	return ret;
>  }
>  
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index b4fee7f52d6a..609d960c0749 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -223,13 +223,12 @@ static const struct v4l2_subdev_ops adv748x_csi2_ops = {
>  
>  int adv748x_csi2_set_pixelrate(struct v4l2_subdev *sd, s64 rate)
>  {
> -	struct v4l2_ctrl *ctrl;
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
>  
> -	ctrl = v4l2_ctrl_find(sd->ctrl_handler, V4L2_CID_PIXEL_RATE);
> -	if (!ctrl)
> +	if (!tx->pixel_rate)
>  		return -EINVAL;
>  
> -	return v4l2_ctrl_s_ctrl_int64(ctrl, rate);
> +	return v4l2_ctrl_s_ctrl_int64(tx->pixel_rate, rate);
>  }
>  
>  static int adv748x_csi2_s_ctrl(struct v4l2_ctrl *ctrl)
> @@ -248,12 +247,12 @@ static const struct v4l2_ctrl_ops adv748x_csi2_ctrl_ops = {
>  
>  static int adv748x_csi2_init_controls(struct adv748x_csi2 *tx)
>  {
> -	struct v4l2_ctrl *ctrl;
> -
>  	v4l2_ctrl_handler_init(&tx->ctrl_hdl, 1);
>  
> -	ctrl = v4l2_ctrl_new_std(&tx->ctrl_hdl, &adv748x_csi2_ctrl_ops,
> -				 V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
> +	tx->pixel_rate = v4l2_ctrl_new_std(&tx->ctrl_hdl,
> +					   &adv748x_csi2_ctrl_ops,
> +					   V4L2_CID_PIXEL_RATE, 1, INT_MAX,
> +					   1, 1);
>  
>  	tx->sd.ctrl_handler = &tx->ctrl_hdl;
>  	if (tx->ctrl_hdl.error) {
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index cc4151b5b31e..6789e2f3bc8c 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -97,6 +97,7 @@ struct adv748x_csi2 {
>  
>  	struct media_pad pads[ADV748X_CSI2_NR_PADS];
>  	struct v4l2_ctrl_handler ctrl_hdl;
> +	struct v4l2_ctrl *pixel_rate;
>  	struct v4l2_subdev sd;
>  };
>  
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
