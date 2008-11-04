Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA4MgVc1027379
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 17:42:32 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA4MeG4G025555
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 17:40:16 -0500
Date: Tue, 4 Nov 2008 23:40:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1225835978-14548-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0811042329330.8208@axis700.grange>
References: <87bpwvyx19.fsf@free.fr>
	<1225835978-14548-1-git-send-email-robert.jarzmik@free.fr>
	<1225835978-14548-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: add all yuv format combinations.
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

On Tue, 4 Nov 2008, Robert Jarzmik wrote:

Re-added Antonio and Mike to cc.

> The Micron mt9m111 offers 4 byte orders for YCbCr
> output. This patchs adds all possible outputs capabilities
> to the mt9m111 driver.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Ok, yes, this is exactly what I wanted to see. Have you also tested it? Or 
do we have to ask Antonio to test it? Next time, when you send several 
patches of which some depend on others, please put them in a patch-series 
- if this patch is applied first mt9m111 will not compile. I will take 
them in the right order this time and I _think_ this should be enough to 
also guarantee, that they go upstream in the same order.

Would you also like to make the third patch - updating pxa-camera with the 
three further YCbCr formats and adding a comment, that although the docs 
only claim support for UYUV the others can be used too, as long as we 
don't use post-processing. Can you also test other formats?

Thanks
Guennadi

> ---
>  drivers/media/video/mt9m111.c |   24 +++++++++++++++++++++++-
>  1 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index da0b2d5..9b9b377 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -128,9 +128,14 @@
>  	.colorspace = _colorspace }
>  #define RGB_FMT(_name, _depth, _fourcc) \
>  	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_SRGB)
> +#define JPG_FMT(_name, _depth, _fourcc) \
> +	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_JPEG)
>  
>  static const struct soc_camera_data_format mt9m111_colour_formats[] = {
> -	COL_FMT("YCrYCb 8 bit", 8, V4L2_PIX_FMT_YUYV, V4L2_COLORSPACE_JPEG),
> +	JPG_FMT("CbYCrY 16 bit", 16, V4L2_PIX_FMT_UYVY),
> +	JPG_FMT("CrYCbY 16 bit", 16, V4L2_PIX_FMT_VYUY),
> +	JPG_FMT("YCbYCr 16 bit", 16, V4L2_PIX_FMT_YUYV),
> +	JPG_FMT("YCrYCb 16 bit", 16, V4L2_PIX_FMT_YVYU),
>  	RGB_FMT("RGB 565", 16, V4L2_PIX_FMT_RGB565),
>  	RGB_FMT("RGB 555", 16, V4L2_PIX_FMT_RGB555),
>  	RGB_FMT("Bayer (sRGB) 10 bit", 10, V4L2_PIX_FMT_SBGGR16),
> @@ -438,7 +443,24 @@ static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
>  	case V4L2_PIX_FMT_RGB565:
>  		ret = mt9m111_setfmt_rgb565(icd);
>  		break;
> +	case V4L2_PIX_FMT_UYVY:
> +		mt9m111->swap_yuv_y_chromas = 0;
> +		mt9m111->swap_yuv_cb_cr = 0;
> +		ret = mt9m111_setfmt_yuv(icd);
> +		break;
> +	case V4L2_PIX_FMT_VYUY:
> +		mt9m111->swap_yuv_y_chromas = 0;
> +		mt9m111->swap_yuv_cb_cr = 1;
> +		ret = mt9m111_setfmt_yuv(icd);
> +		break;
>  	case V4L2_PIX_FMT_YUYV:
> +		mt9m111->swap_yuv_y_chromas = 1;
> +		mt9m111->swap_yuv_cb_cr = 0;
> +		ret = mt9m111_setfmt_yuv(icd);
> +		break;
> +	case V4L2_PIX_FMT_YVYU:
> +		mt9m111->swap_yuv_y_chromas = 1;
> +		mt9m111->swap_yuv_cb_cr = 1;
>  		ret = mt9m111_setfmt_yuv(icd);
>  		break;
>  	default:
> -- 
> 1.5.6.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
