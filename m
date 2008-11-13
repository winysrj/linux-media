Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAD83Xda002626
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 03:03:33 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAD83Kpc009158
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 03:03:20 -0500
Date: Thu, 13 Nov 2008 09:03:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20081113074219.6786.65651.sendpatchset@rx1.opensource.se>
Message-ID: <Pine.LNX.4.64.0811130853510.4620@axis700.grange>
References: <20081113074219.6786.65651.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] video: nv12/nv21 support for the sh_mobile_ceu driver
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

On Thu, 13 Nov 2008, Magnus Damm wrote:

> From: Magnus Damm <damm@igel.co.jp>
> 
> This patch adds nv12/nv21 mode support to the SuperH Mobile CEU driver.
> These modes are translated by the hardware, and added to the list of
> available modes if the connected camera can output one of the supported
> input modes. Other modes are just handled using data transfer as usual.
> 
> The hardware also supports nv16/nv61 which is trivial to add on top of this.

Heh, you realise, that you're walking on burning coal, don't you?:-) So, 
you'll appreciate, if I postpone this patch until the API reasonably 
stabilises, and it is very likely you'll have to redo this?

Just a couple of points I came across while skipping over this patch:

> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Depends on the VYUY fourcc.
>  I suspect that this change may conflict with at least 4 other patches. =)
> 
>  drivers/media/video/sh_mobile_ceu_camera.c |  165 +++++++++++++++++++++++++---
>  1 file changed, 150 insertions(+), 15 deletions(-)
> 
> --- 0001/drivers/media/video/sh_mobile_ceu_camera.c
> +++ work/drivers/media/video/sh_mobile_ceu_camera.c	2008-11-13 16:13:06.000000000 +0900
> @@ -97,6 +97,10 @@ struct sh_mobile_ceu_dev {
>  	struct videobuf_buffer *active;
>  
>  	struct sh_mobile_ceu_info *pdata;
> +
> +	const struct soc_camera_data_format *camera_formats;
> +	int camera_num_formats;
> +	unsigned int camera_fourcc;

These formats are assigned dynamically and are camera-dependent, right? 
Even though SH camera host probably is not supposed to handle more than 
one camera at a time, I wouldn't do this. This is what I added a 
void *host_priv to struct soc_camera_device for - for host-private 
per-camera data (see patch 3/5 that still waits moderator's approval:-().

>  };
>  
>  static void ceu_write(struct sh_mobile_ceu_dev *priv,
> @@ -156,6 +160,9 @@ static void free_buffer(struct videobuf_
>  
>  static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  {
> +	struct soc_camera_device *icd = pcdev->icd;
> +	unsigned long phys_addr;
> +
>  	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~1);
>  	ceu_write(pcdev, CETCR, ~ceu_read(pcdev, CETCR) & 0x0317f313);
>  	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | 1);
> @@ -164,11 +171,21 @@ static void sh_mobile_ceu_capture(struct
>  
>  	ceu_write(pcdev, CETCR, 0x0317f313 ^ 0x10);
>  
> -	if (pcdev->active) {
> -		pcdev->active->state = VIDEOBUF_ACTIVE;
> -		ceu_write(pcdev, CDAYR, videobuf_to_dma_contig(pcdev->active));
> -		ceu_write(pcdev, CAPSR, 0x1); /* start capture */
> +	if (!pcdev->active)
> +		return;
> +
> +	phys_addr = videobuf_to_dma_contig(pcdev->active);
> +	ceu_write(pcdev, CDAYR, phys_addr);
> +
> +	switch (icd->current_fmt->fourcc) {
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		phys_addr += (icd->width * icd->height);
> +		ceu_write(pcdev, CDACR, phys_addr);
>  	}
> +
> +	pcdev->active->state = VIDEOBUF_ACTIVE;
> +	ceu_write(pcdev, CAPSR, 0x1); /* start capture */
>  }
>  
>  static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
> @@ -295,6 +312,9 @@ static int sh_mobile_ceu_add_device(stru
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>  	struct sh_mobile_ceu_dev *pcdev = ici->priv;
>  	int ret = -EBUSY;
> +	const struct soc_camera_data_format *format;
> +	struct soc_camera_data_format *fmt;
> +	int k, yuv_mode_possible;
>  
>  	mutex_lock(&camera_lock);
>  
> @@ -314,6 +334,60 @@ static int sh_mobile_ceu_add_device(stru
>  		msleep(1);
>  
>  	pcdev->icd = icd;
> +
> +	/* check if we can enable NVxx modes and
> +	 * remember the last supported camera fourcc mode
> +	 */
> +
> +	format = NULL;
> +	yuv_mode_possible = 0;
> +	for (k = 0; k < icd->num_formats; k++) {
> +		format = &icd->formats[k];
> +
> +		switch (format->fourcc) {
> +		case V4L2_PIX_FMT_UYVY:
> +		case V4L2_PIX_FMT_VYUY:
> +		case V4L2_PIX_FMT_YUYV:
> +		case V4L2_PIX_FMT_YVYU:
> +			yuv_mode_possible = 1;
> +			pcdev->camera_fourcc = format->fourcc;
> +			break;
> +		}
> +	}
> +
> +	/* override list with translated yuv formats if possible */
> +	if (yuv_mode_possible && format) {
> +		k = icd->num_formats + 2; /* camera formats + NV12 + NV21 */
> +
> +		fmt = kzalloc(sizeof(*icd->formats) * k, GFP_KERNEL);
> +		if (fmt) {
> +			pcdev->camera_formats = icd->formats;
> +			pcdev->camera_num_formats = icd->num_formats;
> +
> +			memcpy(fmt, icd->formats,
> +			       icd->num_formats * sizeof(*fmt));

No! Never write to icd->formats! And even less so in a host driver. It is 
for a reason it is marked "const".

> +
> +			icd->formats = fmt;

And never overload it.

> +			icd->num_formats = k;
> +			icd->current_fmt = &icd->formats[0];
> +
> +			fmt += pcdev->camera_num_formats;
> +			fmt->fourcc = V4L2_PIX_FMT_NV12;
> +			fmt->name = "NV12";
> +			fmt->depth = 12;
> +			fmt->colorspace = format->colorspace;
> +
> +			fmt++;
> +			fmt->fourcc = V4L2_PIX_FMT_NV21;
> +			fmt->name = "NV21";
> +			fmt->depth = 12;
> +			fmt->colorspace = format->colorspace;
> +		} else {
> +			dev_err(&icd->dev, "Unable to add NVxx formats.\n");
> +			ici->ops->remove(icd);
> +			ret = -ENOMEM;
> +		}
> +	}
>  err:
>  	mutex_unlock(&camera_lock);
>  
> @@ -342,6 +416,16 @@ static void sh_mobile_ceu_remove_device(
>  	}
>  	spin_unlock_irqrestore(&pcdev->lock, flags);
>  
> +	/* restore formats */
> +	if (pcdev->camera_num_formats) {
> +		icd->current_fmt = &pcdev->camera_formats[0];
> +		kfree(icd->formats);

And never free it! Yes, I realise that you're freeing not the original 
->formats data, but what you have assigned to it above.

All in all - please, wait a bit, it shall all become clearer shortly.

> +		icd->formats = pcdev->camera_formats;
> +		icd->num_formats = pcdev->camera_num_formats;
> +		pcdev->camera_formats = NULL;
> +		pcdev->camera_num_formats = 0;
> +	}
> +
>  	icd->ops->release(icd);
>  
>  	dev_info(&icd->dev,
> @@ -358,6 +442,7 @@ static int sh_mobile_ceu_set_bus_param(s
>  	struct sh_mobile_ceu_dev *pcdev = ici->priv;
>  	int ret, buswidth, width, cfszr_width, cdwdr_width;
>  	unsigned long camera_flags, common_flags, value;
> +	int yuv_mode, yuv_lineskip;
>  
>  	camera_flags = icd->ops->query_bus_param(icd);
>  	common_flags = soc_camera_bus_param_compatible(camera_flags,
> @@ -383,7 +468,35 @@ static int sh_mobile_ceu_set_bus_param(s
>  	ceu_write(pcdev, CRCNTR, 0);
>  	ceu_write(pcdev, CRCMPR, 0);
>  
> -	value = 0x00000010;
> +	value = 0x00000010; /* data fetch by default */
> +	yuv_mode = yuv_lineskip = 0;
> +
> +	switch (icd->current_fmt->fourcc) {
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		yuv_lineskip = 1; /* skip for NV12/21, no skip for NV16/61 */
> +		yuv_mode = 1;
> +		switch (pcdev->camera_fourcc) {
> +		case V4L2_PIX_FMT_UYVY:
> +			value = 0x00000000; /* Cb0, Y0, Cr0, Y1 */
> +			break;
> +		case V4L2_PIX_FMT_VYUY:
> +			value = 0x00000100; /* Cr0, Y0, Cb0, Y1 */
> +			break;
> +		case V4L2_PIX_FMT_YUYV:
> +			value = 0x00000200; /* Y0, Cb0, Y1, Cr0 */
> +			break;
> +		case V4L2_PIX_FMT_YVYU:
> +			value = 0x00000300; /* Y0, Cr0, Y1, Cb0 */
> +			break;
> +		default:
> +			BUG();
> +		}
> +	}
> +
> +	if (icd->current_fmt->fourcc == V4L2_PIX_FMT_NV21)
> +		value ^= 0x00000100; /* swap U, V to change from NV12->NV21 */
> +
>  	value |= (common_flags & SOCAM_VSYNC_ACTIVE_LOW) ? (1 << 1) : 0;
>  	value |= (common_flags & SOCAM_HSYNC_ACTIVE_LOW) ? (1 << 0) : 0;
>  	value |= (buswidth == 16) ? (1 << 12) : 0;
> @@ -394,16 +507,22 @@ static int sh_mobile_ceu_set_bus_param(s
>  
>  	mdelay(1);
>  
> -	width = icd->width * (icd->current_fmt->depth / 8);
> -	width = (buswidth == 16) ? width / 2 : width;
> -	cfszr_width = (buswidth == 8) ? width / 2 : width;
> -	cdwdr_width = (buswidth == 16) ? width * 2 : width;
> +	if (yuv_mode) {
> +		width = icd->width * 2;
> +		width = (buswidth == 16) ? width / 2 : width;
> +		cfszr_width = cdwdr_width = icd->width;
> +	} else {
> +		width = icd->width * ((icd->current_fmt->depth + 7) >> 3);
> +		width = (buswidth == 16) ? width / 2 : width;
> +		cfszr_width = (buswidth == 8) ? width / 2 : width;
> +		cdwdr_width = (buswidth == 16) ? width * 2 : width;
> +	}
>  
>  	ceu_write(pcdev, CAMOR, 0);
>  	ceu_write(pcdev, CAPWR, (icd->height << 16) | width);
> -	ceu_write(pcdev, CFLCR, 0); /* data fetch mode - no scaling */
> +	ceu_write(pcdev, CFLCR, 0); /* no scaling */
>  	ceu_write(pcdev, CFSZR, (icd->height << 16) | cfszr_width);
> -	ceu_write(pcdev, CLFCR, 0); /* data fetch mode - no lowpass filter */
> +	ceu_write(pcdev, CLFCR, 0); /* no lowpass filter */
>  
>  	/* A few words about byte order (observed in Big Endian mode)
>  	 *
> @@ -417,14 +536,16 @@ static int sh_mobile_ceu_set_bus_param(s
>  	 * using 7 we swap the data bytes to match the incoming order:
>  	 * D0, D1, D2, D3, D4, D5, D6, D7
>  	 */
> -	ceu_write(pcdev, CDOCR, 0x00000017);
> +	value = 0x00000017;
> +	if (yuv_lineskip)
> +		value &= ~0x00000010; /* convert 4:2:2 -> 4:2:0 */
> +
> +	ceu_write(pcdev, CDOCR, value);
>  
>  	ceu_write(pcdev, CDWDR, cdwdr_width);
>  	ceu_write(pcdev, CFWCR, 0); /* keep "datafetch firewall" disabled */
>  
>  	/* not in bundle mode: skip CBDSR, CDAYR2, CDACR2, CDBYR2, CDBCR2 */
> -	/* in data fetch mode: no need for CDACR, CDBYR, CDBCR */
> -
>  	return 0;
>  }
>  
> @@ -447,7 +568,21 @@ static int sh_mobile_ceu_try_bus_param(s
>  static int sh_mobile_ceu_set_fmt_cap(struct soc_camera_device *icd,
>  				     __u32 pixfmt, struct v4l2_rect *rect)
>  {
> -	return icd->ops->set_fmt_cap(icd, pixfmt, rect);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct sh_mobile_ceu_dev *pcdev = ici->priv;
> +	__u32 camera_fourcc;
> +
> +	/* for NVxx modes configure camera with fourcc determined earlier */
> +	switch (pixfmt) {
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		camera_fourcc = pcdev->camera_fourcc;
> +		break;
> +	default:
> +		camera_fourcc = pixfmt;
> +	}
> +
> +	return icd->ops->set_fmt_cap(icd, camera_fourcc, rect);
>  }
>  
>  static int sh_mobile_ceu_try_fmt_cap(struct soc_camera_device *icd,
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
