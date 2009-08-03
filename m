Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n73Bbwus019990
	for <video4linux-list@redhat.com>; Mon, 3 Aug 2009 07:37:58 -0400
Received: from mail-ew0-f208.google.com (mail-ew0-f208.google.com
	[209.85.219.208])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n73BbhYJ009779
	for <video4linux-list@redhat.com>; Mon, 3 Aug 2009 07:37:43 -0400
Received: by ewy4 with SMTP id 4so1004881ewy.3
	for <video4linux-list@redhat.com>; Mon, 03 Aug 2009 04:37:42 -0700 (PDT)
Message-ID: <4A76CB7C.10401@gmail.com>
Date: Mon, 03 Aug 2009 19:35:24 +0800
From: Eric Miao <eric.y.miao@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <200908031031.00676.marek.vasut@gmail.com>
In-Reply-To: <200908031031.00676.marek.vasut@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Marek Vasut <marek.vasut@gmail.com>, video4linux-list@redhat.com,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
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

Marek Vasut wrote:
> Hi!
> 
> Eric, would you mind applying ?
> 
> From 4dcbff010e996f4c6e5761b3c19f5d863ab51b39 Mon Sep 17 00:00:00 2001
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Mon, 3 Aug 2009 10:27:57 +0200
> Subject: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
> 
> Those formats are requiered on widely used OmniVision OV96xx cameras.
> Those formats are nothing more then endian-swapped RGB555 and RGB565.
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

Guennadi,

Would be better if this gets merged by you, thanks.

> ---
>  drivers/media/video/pxa_camera.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c 
> b/drivers/media/video/pxa_camera.c
> index 46e0d8a..de0fc8a 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -1222,6 +1222,8 @@ static int required_buswidth(const struct 
> soc_camera_data_format *fmt)
>  	case V4L2_PIX_FMT_YVYU:
>  	case V4L2_PIX_FMT_RGB565:
>  	case V4L2_PIX_FMT_RGB555:
> +	case V4L2_PIX_FMT_RGB565X:
> +	case V4L2_PIX_FMT_RGB555X:
>  		return 8;
>  	default:
>  		return fmt->depth;
> @@ -1260,6 +1262,8 @@ static int pxa_camera_get_formats(struct 
> soc_camera_device *icd, int idx,
>  	case V4L2_PIX_FMT_YVYU:
>  	case V4L2_PIX_FMT_RGB565:
>  	case V4L2_PIX_FMT_RGB555:
> +	case V4L2_PIX_FMT_RGB565X:
> +	case V4L2_PIX_FMT_RGB555X:
>  		formats++;
>  		if (xlate) {
>  			xlate->host_fmt = icd->formats + idx;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
