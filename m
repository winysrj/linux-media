Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38210 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751145AbeCIKe5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 05:34:57 -0500
Date: Fri, 9 Mar 2018 12:34:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH 03/12] media: ov5640: Don't force the auto exposure state
 at start time
Message-ID: <20180309103453.vaz2oy2hanipyqek@valkosipuli.retiisi.org.uk>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
 <20180302143500.32650-4-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302143500.32650-4-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 02, 2018 at 03:34:51PM +0100, Maxime Ripard wrote:
> The sensor needs to have the auto exposure stopped while changing mode.
> However, when the new mode is set, the driver will force the auto exposure
> on, disregarding whether the control has been changed or not.
> 
> Bypass the controls code entirely to do that, and only use the control
> value cached when restoring the auto exposure mode.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/media/i2c/ov5640.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index e6a23eb55c1d..0d8f979416cc 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1579,7 +1579,9 @@ static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
>  	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
>  	if (ret)
>  		return ret;
> -	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, V4L2_EXPOSURE_AUTO);
> +
> +	return __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp,
> +				  sensor->ctrls.auto_exp->val);
>  }
>  
>  static int ov5640_set_mode(struct ov5640_dev *sensor,
> @@ -1596,7 +1598,8 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
>  	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 0);
>  	if (ret)
>  		return ret;
> -	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_exp, V4L2_EXPOSURE_MANUAL);
> +
> +	ret = ov5640_set_exposure(sensor, V4L2_EXPOSURE_MANUAL);
>  	if (ret)
>  		return ret;
>  

The s_ctrl callback won't be called if the control framework still has the
same value set. I think you could store the value manually, and retain
__v4l2_ctrl_s_ctrl() call in ov5640_set_mode().

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
