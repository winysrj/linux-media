Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36907 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0EKJdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 05:33:42 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 11 May 2010 15:03:36 +0530
Subject: RE: [PATCH 4/6] [RFC] tvp514x: add missing newlines
Message-ID: <19F8576C6E063C45BE387C64729E7394044E404BD9@dbde02.ent.ti.com>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
 <18b63854577e200bf55309c88c1e0cab90dcd65a.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <18b63854577e200bf55309c88c1e0cab90dcd65a.1273413060.git.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Sunday, May 09, 2010 7:27 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav
> Subject: [PATCH 4/6] [RFC] tvp514x: add missing newlines
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/tvp514x.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> index 8c1609f..4e22621 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -610,7 +610,7 @@ static int tvp514x_s_std(struct v4l2_subdev *sd,
> v4l2_std_id std_id)
>  	decoder->tvp514x_regs[REG_VIDEO_STD].val =
>  		decoder->std_list[i].video_std;
> 
> -	v4l2_dbg(1, debug, sd, "Standard set to: %s",
> +	v4l2_dbg(1, debug, sd, "Standard set to: %s\n",
>  			decoder->std_list[i].standard.name);
>  	return 0;
>  }
> @@ -782,7 +782,7 @@ tvp514x_queryctrl(struct v4l2_subdev *sd, struct
> v4l2_queryctrl *qctrl)
>  		return err;
>  	}
> 
> -	v4l2_dbg(1, debug, sd, "Query Control:%s: Min - %d, Max - %d, Def -
> %d",
> +	v4l2_dbg(1, debug, sd, "Query Control:%s: Min - %d, Max - %d, Def -
> %d\n",
>  			qctrl->name, qctrl->minimum, qctrl->maximum,
>  			qctrl->default_value);
> 
> @@ -839,7 +839,7 @@ tvp514x_g_ctrl(struct v4l2_subdev *sd, struct
> v4l2_control *ctrl)
>  		return -EINVAL;
>  	}
> 
> -	v4l2_dbg(1, debug, sd, "Get Control: ID - %d - %d",
> +	v4l2_dbg(1, debug, sd, "Get Control: ID - %d - %d\n",
>  			ctrl->id, ctrl->value);
>  	return 0;
>  }
> @@ -939,7 +939,7 @@ tvp514x_s_ctrl(struct v4l2_subdev *sd, struct
> v4l2_control *ctrl)
>  		return err;
>  	}
> 
> -	v4l2_dbg(1, debug, sd, "Set Control: ID - %d - %d",
> +	v4l2_dbg(1, debug, sd, "Set Control: ID - %d - %d\n",
>  			ctrl->id, ctrl->value);
> 
>  	return err;
> @@ -1008,7 +1008,7 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct
> v4l2_format *f)
>  	pix->priv = 0;
> 
>  	v4l2_dbg(1, debug, sd, "Try FMT: bytesperline - %d"
> -			"Width - %d, Height - %d",
> +			"Width - %d, Height - %d\n",
>  			pix->bytesperline,
>  			pix->width, pix->height);
>  	return 0;
> @@ -1070,7 +1070,7 @@ tvp514x_g_fmt_cap(struct v4l2_subdev *sd, struct
> v4l2_format *f)
>  	f->fmt.pix = decoder->pix;
> 
>  	v4l2_dbg(1, debug, sd, "Current FMT: bytesperline - %d"
> -			"Width - %d, Height - %d",
> +			"Width - %d, Height - %d\n",
>  			decoder->pix.bytesperline,
>  			decoder->pix.width, decoder->pix.height);
>  	return 0;
[Hiremath, Vaibhav] 

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Tested-by: Vaibhav Hiremath <hvaibhav@ti.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>


Thanks,
Vaibhav

> --
> 1.6.4.2

