Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58017 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059AbbHYO2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 10:28:24 -0400
Message-ID: <55DC7AE2.6010103@xs4all.nl>
Date: Tue, 25 Aug 2015 16:25:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	g.liakhovetski@gmx.de, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org
Subject: Re: [PATCH] rcar_vin: propagate querystd() error upstream
References: <1650569.JYNQd5Bi8T@wasted.cogentembedded.com>
In-Reply-To: <1650569.JYNQd5Bi8T@wasted.cogentembedded.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/15 23:02, Sergei Shtylyov wrote:
> rcar_vin_set_fmt() defaults to  PAL when the subdevice's querystd() method call
> fails (e.g. due to I2C error).  This doesn't work very well when a camera being
> used  outputs NTSC which has different order of fields and resolution.  Let  us
> stop  pretending and return the actual error (which would prevent video capture
> on at least Renesas Henninger/Porter board where I2C seems particularly buggy).
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> The patch is against the 'media_tree.git' repo's 'fixes' branch.
> 
>  drivers/media/platform/soc_camera/rcar_vin.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> ===================================================================
> --- media_tree.orig/drivers/media/platform/soc_camera/rcar_vin.c
> +++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1592,7 +1592,7 @@ static int rcar_vin_set_fmt(struct soc_c
>  		/* Query for standard if not explicitly mentioned _TB/_BT */
>  		ret = v4l2_subdev_call(sd, video, querystd, &std);

Ouch, this should never be done like this.

Instead the decision should be made using the last set std, never by querying.
So querystd should be replaced by g_std in the v4l2_subdev_call above.

The only place querystd can be called is in the QUERYSTD ioctl, all other
ioctls should use the last set standard.

Regards,

	Hans

>  		if (ret < 0)
> -			std = V4L2_STD_625_50;
> +			return ret;
>  
>  		field = std & V4L2_STD_625_50 ? V4L2_FIELD_INTERLACED_TB :
>  						V4L2_FIELD_INTERLACED_BT;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
