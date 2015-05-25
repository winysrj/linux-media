Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59047 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbbEYPCk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 11:02:40 -0400
Date: Mon, 25 May 2015 17:02:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, hverkuil@xs4all.nl,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 13/20] media: soc_camera: v4l2-compliance fixes for
 querycap
In-Reply-To: <1432139980-12619-14-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1505251701020.26358@axis700.grange>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
 <1432139980-12619-14-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

On Wed, 20 May 2015, William Towle wrote:

> Fill in bus_info field and zero reserved field.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>

If you're the author and the submitter of this patch, why is Rob's Sob 
here needed? Or is he the author?

Thanks
Guennadi

> Reviewed-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index fd7497e..583c5e6 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -954,6 +954,8 @@ static int soc_camera_querycap(struct file *file, void  *priv,
>  	WARN_ON(priv != file->private_data);
>  
>  	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
> +	strlcpy(cap->bus_info, "platform:soc_camera", sizeof(cap->bus_info));
> +	memset(cap->reserved, 0, sizeof(cap->reserved));
>  	return ici->ops->querycap(ici, cap);
>  }
>  
> -- 
> 1.7.10.4
> 
