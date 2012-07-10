Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49790 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2GJMpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 08:45:36 -0400
Date: Tue, 10 Jul 2012 14:45:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org
Subject: Re: [PATCH] media: mx2_camera: Don't modify non volatile parameters
 in try_fmt.
In-Reply-To: <1341923936-18503-1-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1207101444470.29825@axis700.grange>
References: <1341923936-18503-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Jul 2012, Javier Martin wrote:

> ---
>  drivers/media/video/mx2_camera.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index d5355de..4a96989 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -1370,6 +1370,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
>  	__u32 pixfmt = pix->pixelformat;
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct mx2_camera_dev *pcdev = ici->priv;
> +	struct mx2_fmt_cfg *emma_prp;
>  	unsigned int width_limit;
>  	int ret;
>  
> @@ -1432,7 +1433,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
>  		__func__, pcdev->s_width, pcdev->s_height);
>  
>  	/* If the sensor does not support image size try PrP resizing */
> -	pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
> +	emma_prp = mx27_emma_prp_get_format(xlate->code,
>  						   xlate->host_fmt->fourcc);
>  
>  	memset(pcdev->resizing, 0, sizeof(pcdev->resizing));

You forgot to update this:

	if ((mf.width != pix->width || mf.height != pix->height) &&
		pcdev->emma_prp->cfg.in_fmt == PRP_CNTL_DATA_IN_YUV422) {

		^^^^^^^^^^^^^^^^^^^^

		if (mx2_emmaprp_resize(pcdev, &mf, pix, false) < 0)
			dev_dbg(icd->parent, "%s: can't resize\n", __func__);
	}

> -- 
> 1.7.9.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
