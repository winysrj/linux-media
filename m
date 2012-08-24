Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2HXLWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 07:22:23 -0400
Date: Fri, 24 Aug 2012 13:22:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH 2/3] mt9v022: fix the V4L2_CID_EXPOSURE control
In-Reply-To: <1345799431-29426-3-git-send-email-agust@denx.de>
Message-ID: <Pine.LNX.4.64.1208241320330.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
 <1345799431-29426-3-git-send-email-agust@denx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Aug 2012, Anatolij Gustschin wrote:

> Since the MT9V022_TOTAL_SHUTTER_WIDTH register is controlled in manual
> mode by V4L2_CID_EXPOSURE control, it shouldn't be written directly in
> mt9v022_s_crop(). In manual mode this register should be set to the
> V4L2_CID_EXPOSURE control value. Changing this register directly and
> outside of the actual control function means that the register value
> is not in sync with the corresponding control value. Thus, the following
> problem is observed:
> 
>     - setting this control initially succeeds
>     - VIDIOC_S_CROP ioctl() overwrites the MT9V022_TOTAL_SHUTTER_WIDTH
>       register
>     - setting this control to the same value again doesn't
>       result in setting the register since the control value
>       was previously cached and doesn't differ
> 
> Fix it by always setting the register to the controlled value, when
> in manual mode.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
>  drivers/media/i2c/soc_camera/mt9v022.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
> index d13c8c4..d26c071 100644
> --- a/drivers/media/i2c/soc_camera/mt9v022.c
> +++ b/drivers/media/i2c/soc_camera/mt9v022.c
> @@ -274,9 +274,9 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  		if (ret & 1) /* Autoexposure */
>  			ret = reg_write(client, mt9v022->reg->max_total_shutter_width,
>  					rect.height + mt9v022->y_skip_top + 43);
> -		else
> -			ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
> -					rect.height + mt9v022->y_skip_top + 43);
> +		else /* Set to the manually controlled value */
> +			ret = v4l2_ctrl_s_ctrl(mt9v022->exposure,
> +					       mt9v022->exposure->val);

But why do we have to write it here at all then? Autoexposure can be off 
only if the user has set exposure manually, using V4L2_CID_EXPOSURE_AUTO. 
In this case MT9V022_TOTAL_SHUTTER_WIDTH already contains the correct 
value. Why do we have to set it again? Maybe just adding a comment, 
explaining the above, would suffice?

>  	}
>  	/* Setup frame format: defaults apart from width and height */
>  	if (!ret)
> -- 
> 1.7.1

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
