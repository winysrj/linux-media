Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2KSWBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 17:01:43 -0500
Date: Mon, 19 Nov 2012 23:01:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Fabio Estevam <festevam@gmail.com>
cc: mchehab@infradead.org, hans.verkuil@cisco.com,
	javier.martin@vista-silicon.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] [media] soc_camera: mx3_camera: Constify v4l2_crop
In-Reply-To: <1353223611-18960-1-git-send-email-festevam@gmail.com>
Message-ID: <Pine.LNX.4.64.1211192300290.17178@axis700.grange>
References: <1353223611-18960-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio

On Sun, 18 Nov 2012, Fabio Estevam wrote:

> Since commit 4f996594ce ([media] v4l2: make vidioc_s_crop const), set_crop 
> should receive a 'const struct v4l2_crop *' argument type.
> 
> Adapt to this new format and get rid of the following build warning:

Thanks for the patches, both mx2-camera and mx3-camera, as well as all 
other soc-camera drivers, are already fixed in the mainline:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/54807

Thanks
Guennadi

> 
> drivers/media/platform/soc_camera/mx3_camera.c:1134: warning: initialization from incompatible pointer type
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/media/platform/soc_camera/mx3_camera.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
> index 64d39b1..ae04395 100644
> --- a/drivers/media/platform/soc_camera/mx3_camera.c
> +++ b/drivers/media/platform/soc_camera/mx3_camera.c
> @@ -799,17 +799,17 @@ static inline void stride_align(__u32 *width)
>   * default g_crop and cropcap from soc_camera.c
>   */
>  static int mx3_camera_set_crop(struct soc_camera_device *icd,
> -			       struct v4l2_crop *a)
> +			       const struct v4l2_crop *a)
>  {
> -	struct v4l2_rect *rect = &a->c;
> +	struct v4l2_rect rect = a->c;
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct mx3_camera_dev *mx3_cam = ici->priv;
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	struct v4l2_mbus_framefmt mf;
>  	int ret;
>  
> -	soc_camera_limit_side(&rect->left, &rect->width, 0, 2, 4096);
> -	soc_camera_limit_side(&rect->top, &rect->height, 0, 2, 4096);
> +	soc_camera_limit_side(&rect.left, &rect.width, 0, 2, 4096);
> +	soc_camera_limit_side(&rect.top, &rect.height, 0, 2, 4096);
>  
>  	ret = v4l2_subdev_call(sd, video, s_crop, a);
>  	if (ret < 0)
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
