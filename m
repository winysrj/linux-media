Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n887T2Vp030163
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 03:29:02 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n887Sk27006714
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 03:28:47 -0400
Date: Tue, 8 Sep 2009 09:28:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ubplmw6mi.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0909080907380.4550@axis700.grange>
References: <ubplmw6mi.wl%morimoto.kuninori@renesas.com>
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

Hello Morimoto-san

On Tue, 8 Sep 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |   52 ++++++++++++++++++++++-----
>  1 files changed, 42 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 3e7a148..92812e5 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -104,7 +104,10 @@ struct sh_mobile_ceu_dev {
>  
>  	u32 cflcr;
>  
> -	unsigned int is_interlaced:1;
> +	unsigned int is_interlaced;
> +#define TOP_ITL 1	/* 1: interlace top field start */
> +#define BTM_ITL 2	/* 2: interlace bottom field start */

I think, it would be better to use

+	enum v4l2_field field;

and then use V4L2_FIELD_NONE, V4L2_FIELD_SEQ_TB, and V4L2_FIELD_SEQ_BT. 
You'd have to replace all tests like "if (pcdev->is_interlaced)" with "if 
(pcdev->is_interlaced != V4L2_FIELD_NONE)

> +
>  	unsigned int image_mode:1;
>  	unsigned int is_16bit:1;
>  };
> @@ -247,6 +250,8 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  {
>  	struct soc_camera_device *icd = pcdev->icd;
>  	dma_addr_t phys_addr_top, phys_addr_bottom;
> +	unsigned long top1, top2;
> +	unsigned long bottom1, bottom2;
>  	u32 status;
>  	int ret = 0;
>  
> @@ -275,11 +280,23 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  	if (!pcdev->active)
>  		return ret;
>  
> +	if (BTM_ITL == pcdev->is_interlaced) {
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
> +	ceu_write(pcdev, top1, phys_addr_top);
>  	if (pcdev->is_interlaced) {
>  		phys_addr_bottom = phys_addr_top + icd->user_width;
> -		ceu_write(pcdev, CDBYR, phys_addr_bottom);
> +		ceu_write(pcdev, bottom1, phys_addr_bottom);
>  	}
>  
>  	switch (icd->current_fmt->fourcc) {
> @@ -289,11 +306,10 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  	case V4L2_PIX_FMT_NV61:
>  		phys_addr_top += icd->user_width *
>  			icd->user_height;
> -		ceu_write(pcdev, CDACR, phys_addr_top);
> +		ceu_write(pcdev, top2, phys_addr_top);
>  		if (pcdev->is_interlaced) {
> -			phys_addr_bottom = phys_addr_top +
> -				icd->user_width;
> -			ceu_write(pcdev, CDBCR, phys_addr_bottom);
> +			phys_addr_bottom = phys_addr_top + icd->user_width;
> +			ceu_write(pcdev, bottom2, phys_addr_bottom);
>  		}
>  	}
>  
> @@ -706,7 +722,19 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
>  	ceu_write(pcdev, CAMCR, value);
>  
>  	ceu_write(pcdev, CAPCR, 0x00300000);
> -	ceu_write(pcdev, CAIFR, pcdev->is_interlaced ? 0x101 : 0);
> +
> +	switch (pcdev->is_interlaced) {
> +	case TOP_ITL:
> +		value = 0x101;
> +		break;
> +	case BTM_ITL:
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
> @@ -1388,14 +1416,18 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
>  
>  	switch (pix->field) {
>  	case V4L2_FIELD_INTERLACED:
> -		is_interlaced = true;
> +	case V4L2_FIELD_INTERLACED_TB:
> +		is_interlaced = TOP_ITL;
> +		break;
> +	case V4L2_FIELD_INTERLACED_BT:
> +		is_interlaced = BTM_ITL;
>  		break;
>  	case V4L2_FIELD_ANY:
>  	default:
>  		pix->field = V4L2_FIELD_NONE;
>  		/* fall-through */
>  	case V4L2_FIELD_NONE:
> -		is_interlaced = false;
> +		is_interlaced = 0;
>  		break;
>  	}

Then you'd rewrite this as

	enum v4l2_field is_interlaced;

	switch (pix->field) {
	case V4L2_FIELD_INTERLACED_TB:
	case V4L2_FIELD_INTERLACED_BT:
	case V4L2_FIELD_NONE:
		is_interlaced = pix->field;
		break;
	case V4L2_FIELD_INTERLACED:
		is_interlaced = V4L2_FIELD_INTERLACED_TB;
		break;
	case V4L2_FIELD_ANY:
	default:
		pix->field = V4L2_FIELD_NONE;
		is_interlaced = V4L2_FIELD_NONE;
 	}


>  
> -- 
> 1.6.0.4
> 

Also, you forgot to patch this:

	videobuf_queue_dma_contig_init(q,
				       &sh_mobile_ceu_videobuf_ops,
				       icd->dev.parent, &pcdev->lock,
				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
				       pcdev->is_interlaced ?
				       V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE,
				       sizeof(struct sh_mobile_ceu_buffer),
				       icd);

which with my proposal would become just

	videobuf_queue_dma_contig_init(q,
				       &sh_mobile_ceu_videobuf_ops,
				       icd->dev.parent, &pcdev->lock,
				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
				       pcdev->field,
				       sizeof(struct sh_mobile_ceu_buffer),
				       icd);

Also, see my comment to [PATCH 0/4].

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
