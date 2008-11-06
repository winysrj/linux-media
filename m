Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA6NqMZO024912
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 18:52:22 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA6Nq9Ex010746
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 18:52:10 -0500
Date: Fri, 7 Nov 2008 00:52:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1226012656-17334-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0811070040130.8681@axis700.grange>
References: <1226012656-17334-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] pxa_camera: Fix YUV format handling.
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

On Fri, 7 Nov 2008, Robert Jarzmik wrote:

> Allows all YUV formats on pxa interface. Even if PXA capture
> interface expects data in UYVY format, we allow all formats

Here you call it UYVY, and I agree with it, however, in the comment in the 
patch you call it VYUY, which, I think is less natural.

> considering the pxa bus is not making any translation.
> 
> For the special YUV planar format, we translate the pixel
> format asked to the sensor to VYUY, which is the bus byte

Now again VYUY... In your patch for mt9m111 you do

+	case V4L2_PIX_FMT_UYVY:
+		mt9m111->swap_yuv_y_chromas = 0;
+		mt9m111->swap_yuv_cb_cr = 0;

i.e., you call mt9m111's default format "UYVY", and again, I think, this 
is logical. If both datasheets are correct, this is also the format 
expected by the PXA, so, you should translate YUV planar to UYVY. Have you 
tested it?

And one more comment below.

> order necessary (out of the sensor) for the pxa to make the
> correct translation.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/video/pxa_camera.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index eb6be58..863e0df 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -862,7 +862,15 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>  	case V4L2_PIX_FMT_YUV422P:
>  		pcdev->channels = 3;
>  		cicr1 |= CICR1_YCBCR_F;
> +		/*
> +		 * Normally, pxa bus wants as input VYUY format.
> +		 * We allow all YUV formats, as no translation is used, and the
> +		 * YUV stream is just passed through without any transformation.
> +		 */

Do I understand it right from the pxa270 datasheet, that UYVY would be the 
only possible format if it were used for overlay2? Then I would mention 
this here as well.

> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
>  	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
>  		cicr1 |= CICR1_COLOR_SP_VAL(2);
>  		break;
>  	case V4L2_PIX_FMT_RGB555:
> @@ -907,6 +915,13 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>  static int pxa_camera_set_fmt_cap(struct soc_camera_device *icd,
>  				  __u32 pixfmt, struct v4l2_rect *rect)
>  {
> +	/*
> +	 * The YUV 4:2:2 planar format is translated by the pxa assuming its
> +	 * input (ie. camera device output) is VYUV.
> +	 * We fix the pixel format asked to the camera device.
> +	 */
> +	if (pixfmt == V4L2_PIX_FMT_YUV422P)
> +		pixfmt = V4L2_PIX_FMT_VYUY;
>  	return icd->ops->set_fmt_cap(icd, pixfmt, rect);
>  }
>  
> -- 
> 1.5.6.5
> 

So, let's just get the naming consistent. Are you also planning to update 
your "Add new pixel format VYUY 16 bits wide" patch as requested by Hans 
Verkuil? Then you could put all these patches in a patch series to make it 
easier to manage them:-)

Also, I would _at the very least_ give credit to Antonio Ospite for 
reporting the problem and suggesting a first fix in your patch for 
mt9m111. Eventually we would also like to have a Tested-by from him.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
