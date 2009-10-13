Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9D9RZrE021654
	for <video4linux-list@redhat.com>; Tue, 13 Oct 2009 05:27:35 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n9D9RKPE014773
	for <video4linux-list@redhat.com>; Tue, 13 Oct 2009 05:27:20 -0400
Date: Tue, 13 Oct 2009 11:27:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uab0d9hue.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0910131112090.5089@axis700.grange>
References: <uab0d9hue.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 3/4] soc-camera: sh_mobile_ceu: Add
 V4L2_FIELD_INTERLACED_BT/TB support
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 30 Sep 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |   75 +++++++++++++++++++---------
>  1 files changed, 52 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 65ac474..3e15114 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -104,7 +104,8 @@ struct sh_mobile_ceu_dev {
>  
>  	u32 cflcr;
>  
> -	unsigned int is_interlaced:1;
> +	enum v4l2_field field;
> +
>  	unsigned int image_mode:1;
>  	unsigned int is_16bit:1;
>  };
> @@ -208,6 +209,8 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  {
>  	struct soc_camera_device *icd = pcdev->icd;
>  	dma_addr_t phys_addr_top, phys_addr_bottom;
> +	unsigned long top1, top2;
> +	unsigned long bottom1, bottom2;
>  
>  	/* The hardware is _very_ picky about this sequence. Especially
>  	 * the CEU_CETCR_MAGIC value. It seems like we need to acknowledge
> @@ -222,11 +225,23 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  	if (!pcdev->active)
>  		return;
>  
> +	if (V4L2_FIELD_INTERLACED_BT == pcdev->field) {
> +		top1	= CDBYR;
> +		top2	= CDBCR;
> +		bottom1	= CDAYR;
> +		bottom2	= CDACR;
> +	} else {
> +		top1	= CDAYR;
> +		top2	= CDACR;
> +		bottom1	= CDBYR;
> +		bottom2	= CDBCR;
> +	}
> +
>  	phys_addr_top = videobuf_to_dma_contig(pcdev->active);
> -	ceu_write(pcdev, CDAYR, phys_addr_top);
> -	if (pcdev->is_interlaced) {
> +	ceu_write(pcdev, top1, phys_addr_top);
> +	if (V4L2_FIELD_NONE != pcdev->field) {
>  		phys_addr_bottom = phys_addr_top + icd->user_width;
> -		ceu_write(pcdev, CDBYR, phys_addr_bottom);
> +		ceu_write(pcdev, bottom1, phys_addr_bottom);
>  	}
>  
>  	switch (icd->current_fmt->fourcc) {
> @@ -236,11 +251,10 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  	case V4L2_PIX_FMT_NV61:
>  		phys_addr_top += icd->user_width *
>  			icd->user_height;
> -		ceu_write(pcdev, CDACR, phys_addr_top);
> -		if (pcdev->is_interlaced) {
> -			phys_addr_bottom = phys_addr_top +
> -				icd->user_width;
> -			ceu_write(pcdev, CDBCR, phys_addr_bottom);
> +		ceu_write(pcdev, top2, phys_addr_top);
> +		if (V4L2_FIELD_NONE != pcdev->field) {
> +			phys_addr_bottom = phys_addr_top + icd->user_width;
> +			ceu_write(pcdev, bottom2, phys_addr_bottom);
>  		}
>  	}
>  
> @@ -519,7 +533,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
>  
>  	height = out_height;
>  	in_height = rect->height;
> -	if (pcdev->is_interlaced) {
> +	if (V4L2_FIELD_NONE != pcdev->field) {
>  		height /= 2;
>  		in_height /= 2;
>  		top_offset /= 2;
> @@ -646,7 +660,19 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
>  	ceu_write(pcdev, CAMCR, value);
>  
>  	ceu_write(pcdev, CAPCR, 0x00300000);
> -	ceu_write(pcdev, CAIFR, pcdev->is_interlaced ? 0x101 : 0);
> +
> +	switch (pcdev->field) {
> +	case V4L2_FIELD_INTERLACED_TB:
> +		value = 0x101;
> +		break;
> +	case V4L2_FIELD_INTERLACED_BT:
> +		value = 0x102;
> +		break;
> +	default:
> +		value = 0;
> +		break;
> +	}
> +	ceu_write(pcdev, CAIFR, value);
>  
>  	sh_mobile_ceu_set_rect(icd, icd->user_width, icd->user_height);
>  	mdelay(1);
> @@ -1265,7 +1291,8 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
>  	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  
>  	ret = client_scale(icd, cam_rect, rect, ceu_rect, &f,
> -			   pcdev->image_mode && !pcdev->is_interlaced);
> +			   pcdev->image_mode &&
> +			   V4L2_FIELD_NONE == pcdev->field);
>  
>  	dev_geo(dev, "6-9: %d\n", ret);
>  
> @@ -1323,18 +1350,20 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
>  	unsigned int scale_cam_h, scale_cam_v;
>  	u16 scale_v, scale_h;
>  	int ret;
> -	bool is_interlaced, image_mode;
> +	bool image_mode;
> +	enum v4l2_field field;
>  
>  	switch (pix->field) {
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_NONE:
> +		field = pix->field;
> +		break;
>  	case V4L2_FIELD_INTERLACED:
> -		is_interlaced = true;
> +		field = V4L2_FIELD_INTERLACED_TB;
>  		break;
> -	case V4L2_FIELD_ANY:
>  	default:
> -		pix->field = V4L2_FIELD_NONE;
> -		/* fall-through */
> -	case V4L2_FIELD_NONE:
> -		is_interlaced = false;
> +		field = pix->field = V4L2_FIELD_NONE;
>  		break;
>  	}

Even easier

	switch (pix->field) {
	default:
		pix->field = V4L2_FIELD_NONE;
		/* fall-through */
	case V4L2_FIELD_INTERLACED_TB:
	case V4L2_FIELD_INTERLACED_BT:
	case V4L2_FIELD_NONE:
		field = pix->field;
		break;
	case V4L2_FIELD_INTERLACED:
		field = V4L2_FIELD_INTERLACED_TB;
		break;
	}


>  
> @@ -1402,7 +1431,8 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
>  
>  	/* 5. - 9. */
>  	ret = client_scale(icd, cam_rect, &cam_subrect, &ceu_rect, &cam_f,
> -			   image_mode && !is_interlaced);
> +			   image_mode &&
> +			   V4L2_FIELD_NONE == field);
>  
>  	dev_geo(dev, "5-9: client scale %d\n", ret);
>  
> @@ -1441,7 +1471,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
>  	cam->camera_fmt = xlate->cam_fmt;
>  	cam->ceu_rect = ceu_rect;
>  
> -	pcdev->is_interlaced = is_interlaced;
> +	pcdev->field = field;
>  	pcdev->image_mode = image_mode;
>  
>  	return 0;
> @@ -1568,8 +1598,7 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
>  				       &sh_mobile_ceu_videobuf_ops,
>  				       icd->dev.parent, &pcdev->lock,
>  				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -				       pcdev->is_interlaced ?
> -				       V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE,
> +				       pcdev->field,
>  				       sizeof(struct sh_mobile_ceu_buffer),
>  				       icd);
>  }
> -- 
> 1.6.0.4
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
