Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:35783 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752034Ab0KHVTo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Nov 2010 16:19:44 -0500
Date: Mon, 8 Nov 2010 22:19:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH] soc-camera: Compile fixes for mx2-camera
In-Reply-To: <1289249565-18346-1-git-send-email-s.hauer@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1011082218300.29934@axis700.grange>
References: <1289249565-18346-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sascha

On Mon, 8 Nov 2010, Sascha Hauer wrote:

> mx2-camera got broken during the last merge window. This patch
> fixes this and removes some unused variables.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

applied together with your mx3 dma-type check and pushed for 2.6.37-rc2.

Thanks
Guennadi

> ---
>  drivers/media/video/mx2_camera.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 4a27862..072bd2d 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -31,6 +31,7 @@
>  
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-dev.h>
> +#include <media/videobuf-core.h>
>  #include <media/videobuf-dma-contig.h>
>  #include <media/soc_camera.h>
>  #include <media/soc_mediabus.h>
> @@ -903,8 +904,6 @@ static int mx2_camera_set_crop(struct soc_camera_device *icd,
>  static int mx2_camera_set_fmt(struct soc_camera_device *icd,
>  			       struct v4l2_format *f)
>  {
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> -	struct mx2_camera_dev *pcdev = ici->priv;
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	const struct soc_camera_format_xlate *xlate;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
> @@ -943,8 +942,6 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
>  static int mx2_camera_try_fmt(struct soc_camera_device *icd,
>  				  struct v4l2_format *f)
>  {
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> -	struct mx2_camera_dev *pcdev = ici->priv;
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	const struct soc_camera_format_xlate *xlate;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
> @@ -1024,13 +1021,13 @@ static int mx2_camera_querycap(struct soc_camera_host *ici,
>  	return 0;
>  }
>  
> -static int mx2_camera_reqbufs(struct soc_camera_file *icf,
> +static int mx2_camera_reqbufs(struct soc_camera_device *icd,
>  			      struct v4l2_requestbuffers *p)
>  {
>  	int i;
>  
>  	for (i = 0; i < p->count; i++) {
> -		struct mx2_buffer *buf = container_of(icf->vb_vidq.bufs[i],
> +		struct mx2_buffer *buf = container_of(icd->vb_vidq.bufs[i],
>  						      struct mx2_buffer, vb);
>  		INIT_LIST_HEAD(&buf->vb.queue);
>  	}
> @@ -1151,9 +1148,9 @@ err_out:
>  
>  static unsigned int mx2_camera_poll(struct file *file, poll_table *pt)
>  {
> -	struct soc_camera_file *icf = file->private_data;
> +	struct soc_camera_device *icd = file->private_data;
>  
> -	return videobuf_poll_stream(file, &icf->vb_vidq, pt);
> +	return videobuf_poll_stream(file, &icd->vb_vidq, pt);
>  }
>  
>  static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
> -- 
> 1.7.2.3
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
