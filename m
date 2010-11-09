Return-path: <mchehab@pedra>
Received: from tango.tkos.co.il ([62.219.50.35]:51768 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0KIFYC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 00:24:02 -0500
Date: Tue, 9 Nov 2010 07:23:42 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] soc-camera: Compile fixes for mx2-camera
Message-ID: <20101109052342.GA29441@jasper.tkos.co.il>
References: <1289249565-18346-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289249565-18346-1-git-send-email-s.hauer@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sascha,

On Mon, Nov 08, 2010 at 09:52:45PM +0100, Sascha Hauer wrote:
> mx2-camera got broken during the last merge window. This patch
> fixes this and removes some unused variables.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
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

What is this needed for? The driver seems to build without this hunk.

Other than that:

Acked-by: Baruch Siach <baruch@tkos.co.il>

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

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
