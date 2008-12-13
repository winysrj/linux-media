Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBDLunLe023309
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 16:56:49 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBDLuYk7026552
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 16:56:35 -0500
Date: Sat, 13 Dec 2008 22:56:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20081210074457.5727.59206.sendpatchset@rx1.opensource.se>
Message-ID: <Pine.LNX.4.64.0812132252090.10954@axis700.grange>
References: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
	<20081210074457.5727.59206.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 03/03] sh_mobile_ceu: add NV16 and NV61 support
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

On Wed, 10 Dec 2008, Magnus Damm wrote:

> From: Magnus Damm <damm@igel.co.jp>
> 
> This patch adds NV16/NV61 support to the sh_mobile_ceu driver.

I guess I cannot apply / push this patch befor your NV16 / NV61 is 
applied, or shall I pull that patch too, Mauro?

Thanks
Guennadi

> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  drivers/media/video/sh_mobile_ceu_camera.c |   22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> --- 0021/drivers/media/video/sh_mobile_ceu_camera.c
> +++ work/drivers/media/video/sh_mobile_ceu_camera.c	2008-12-10 00:12:02.000000000 +0900
> @@ -180,6 +180,8 @@ static void sh_mobile_ceu_capture(struct
>  	switch (icd->current_fmt->fourcc) {
>  	case V4L2_PIX_FMT_NV12:
>  	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
>  		phys_addr += (icd->width * icd->height);
>  		ceu_write(pcdev, CDACR, phys_addr);
>  	}
> @@ -412,6 +414,9 @@ static int sh_mobile_ceu_set_bus_param(s
>  	case V4L2_PIX_FMT_NV12:
>  	case V4L2_PIX_FMT_NV21:
>  		yuv_lineskip = 1; /* skip for NV12/21, no skip for NV16/61 */
> +		/* fall-through */
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
>  		yuv_mode = 1;
>  		switch (pcdev->camera_fmt->fourcc) {
>  		case V4L2_PIX_FMT_UYVY:
> @@ -431,8 +436,9 @@ static int sh_mobile_ceu_set_bus_param(s
>  		}
>  	}
>  
> -	if (icd->current_fmt->fourcc == V4L2_PIX_FMT_NV21)
> -		value ^= 0x00000100; /* swap U, V to change from NV12->NV21 */
> +	if ((icd->current_fmt->fourcc == V4L2_PIX_FMT_NV21) ||
> +	    (icd->current_fmt->fourcc == V4L2_PIX_FMT_NV61))
> +		value ^= 0x00000100; /* swap U, V to change from NV1x->NVx1 */
>  
>  	value |= (common_flags & SOCAM_VSYNC_ACTIVE_LOW) ? (1 << 1) : 0;
>  	value |= (common_flags & SOCAM_HSYNC_ACTIVE_LOW) ? (1 << 0) : 0;
> @@ -514,6 +520,18 @@ static const struct soc_camera_data_form
>  		.fourcc		= V4L2_PIX_FMT_NV21,
>  		.colorspace	= V4L2_COLORSPACE_JPEG,
>  	},
> +	{
> +		.name		= "NV16",
> +		.depth		= 16,
> +		.fourcc		= V4L2_PIX_FMT_NV16,
> +		.colorspace	= V4L2_COLORSPACE_JPEG,
> +	},
> +	{
> +		.name		= "NV61",
> +		.depth		= 16,
> +		.fourcc		= V4L2_PIX_FMT_NV61,
> +		.colorspace	= V4L2_COLORSPACE_JPEG,
> +	},
>  };
>  
>  static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
> 
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
