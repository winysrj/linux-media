Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:51237 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753226AbZKQK5J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 05:57:09 -0500
Message-ID: <4B028185.8030809@panicking.kicks-ass.org>
Date: Tue, 17 Nov 2009 11:57:09 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [RFC, PATCH] gspca: implement vidioc_enum_frameintervals
References: <20091117114147.09889427.ospite@studenti.unina.it>
In-Reply-To: <20091117114147.09889427.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Antonio Ospite wrote:
> Hi,
> 
> gspca does not implement vidioc_enum_frameintervals yet, so even if a
> camera can support multiple frame rates (or frame intervals) there is
> still no way to enumerate them from userspace.
> 
> The following is just a quick and dirty implementation to show the
> problem and to have something to base the discussion on. In the patch
> there is also a working example of use with the ov534 subdriver.
> 
> Someone with a better knowledge of gspca and v4l internals can suggest
> better solutions.
> 
> The tests has been done using 'luvcview -L', the output before the
> patch:
>     $ luvcview -d /dev/video1 -L
>     luvcview 0.2.6
> 
>     SDL information:
>       Video driver: x11
>       A window manager is available
>     Device information:
>       Device path:  /dev/video1
>     { pixelformat = 'YUYV', description = 'YUYV' }
>     { discrete: width = 320, height = 240 }
> 	    Time interval between frame:
>     1/40, 1/30, { discrete: width = 640, height = 480 }
> 	    Time interval between frame:
> 
> 
> And the output after it:
>     $ luvcview -d /dev/video1 -L
>     luvcview 0.2.6
> 
>     SDL information:
>       Video driver: x11
>       A window manager is available
>     Device information:
>       Device path:  /dev/video1
>     { pixelformat = 'YUYV', description = 'YUYV' }
>     { discrete: width = 320, height = 240 }
> 	    Time interval between frame: 1/125, 1/100, 1/75, 1/60, 1/50, 1/40, 1/30,
>     { discrete: width = 640, height = 480 }
> 	    Time interval between frame: 1/60, 1/50, 1/40, 1/30, 1/15, 
> 
> Thanks,
>    Antonio
> 
> diff -r 182b5f8fa160 linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Sun Nov 15 10:05:30 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.c	Tue Nov 17 11:39:21 2009 +0100
> @@ -995,6 +995,37 @@
>  	return -EINVAL;
>  }
>  
> +static int vidioc_enum_frameintervals(struct file *filp, void *priv,
> +				      struct v4l2_frmivalenum *fival)
> +{
> +	struct gspca_dev *gspca_dev = priv;
> +	int mode = wxh_to_mode(gspca_dev, fival->width, fival->height);
> +	int i;
> +	__u32 index = 0;
> +
> +	if (gspca_dev->cam.mode_framerates == NULL ||
> +			gspca_dev->cam.mode_framerates[mode].nrates == 0)
> +		return -EINVAL;
> +
> +	/* FIXME: Needed? */
> +	if (fival->pixel_format !=
> +			gspca_dev->cam.cam_mode[mode].pixelformat)
> +		return -EINVAL;
> +
> +	for (i = 0; i < gspca_dev->cam.mode_framerates[mode].nrates; i++) {
> +		if (fival->index == index) {
> +			fival->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +			fival->discrete.numerator = 1;
> +			fival->discrete.denominator =
> +				gspca_dev->cam.mode_framerates[mode].rates[i];
> +			return 0;
> +		}
> +		index++;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  static void gspca_release(struct video_device *vfd)
>  {
>  	struct gspca_dev *gspca_dev = container_of(vfd, struct gspca_dev, vdev);
> @@ -1987,6 +2018,7 @@
>  	.vidioc_g_parm		= vidioc_g_parm,
>  	.vidioc_s_parm		= vidioc_s_parm,
>  	.vidioc_enum_framesizes = vidioc_enum_framesizes,
> +	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.vidioc_g_register	= vidioc_g_register,
>  	.vidioc_s_register	= vidioc_s_register,
> diff -r 182b5f8fa160 linux/drivers/media/video/gspca/gspca.h
> --- a/linux/drivers/media/video/gspca/gspca.h	Sun Nov 15 10:05:30 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.h	Tue Nov 17 11:39:21 2009 +0100
> @@ -45,11 +45,17 @@
>  /* image transfers */
>  #define MAX_NURBS 4		/* max number of URBs */
>  
> +struct framerates {
> +	int *rates;
> +	int nrates;
> +};
> +
>  /* device information - set at probe time */
>  struct cam {
>  	int bulk_size;		/* buffer size when image transfer by bulk */
>  	const struct v4l2_pix_format *cam_mode;	/* size nmodes */
>  	char nmodes;
> +	const struct framerates *mode_framerates; /* size nmode, like cam_mode */
>  	__u8 bulk_nurbs;	/* number of URBs in bulk mode
>  				 * - cannot be > MAX_NURBS
>  				 * - when 0 and bulk_size != 0 means

I think that the best thing is to slip in two patches. One is related to the gspa main
and the other is a change on a driver.

> diff -r 182b5f8fa160 linux/drivers/media/video/gspca/ov534.c
> --- a/linux/drivers/media/video/gspca/ov534.c	Sun Nov 15 10:05:30 2009 +0100
> +++ b/linux/drivers/media/video/gspca/ov534.c	Tue Nov 17 11:39:21 2009 +0100
> @@ -287,6 +287,20 @@
>  	 .priv = 0},
>  };
>  
> +static int qvga_rates[] = {125, 100, 75, 60, 50, 40, 30};
> +static int vga_rates[] = {60, 50, 40, 30, 15};
> +
> +static const struct framerates ov772x_framerates[] = {
> +	{ /* 320x240 */
> +		.rates = qvga_rates,
> +		.nrates = ARRAY_SIZE(qvga_rates),
> +	},
> +	{ /* 640x480 */
> +		.rates = vga_rates,
> +		.nrates = ARRAY_SIZE(vga_rates),
> +	},
> +};
> +
>  static const struct v4l2_pix_format ov965x_mode[] = {
>  	{320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
>  	 .bytesperline = 320,
> @@ -1411,6 +1425,7 @@
>  	if (sd->sensor == SENSOR_OV772X) {
>  		cam->cam_mode = ov772x_mode;
>  		cam->nmodes = ARRAY_SIZE(ov772x_mode);
> +		cam->mode_framerates = ov772x_framerates;
>  
>  		cam->bulk = 1;
>  		cam->bulk_size = 16384;
> 
> 

Michael
