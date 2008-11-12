Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACLKmed018733
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 16:20:48 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mACLJe5J024523
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 16:19:41 -0500
Date: Wed, 12 Nov 2008 22:19:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-10-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0811122216520.9188@axis700.grange>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-9-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-10-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 09/13] pxa_camera: use the translation framework
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

Hi Robert,

a detailed review will follow, I will need some time for it. Just a couple 
of quick notes to this one:

On Wed, 12 Nov 2008, Robert Jarzmik wrote:

> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

no, this one is not from me:-)

> 
> Use the newly created translation framework for pxa camera
> host.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/video/pxa_camera.c |   89 ++++++++++++++++++++++----------------
>  1 files changed, 52 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 56aeb07..3e7ce6f 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c

[snip]

> +static struct soc_camera_format_translate pxa_pixfmt_translations[] = {
> +	{ JPG_FMT("CbYCrY 16 bit", 16, V4L2_PIX_FMT_UYVY), V4L2_PIX_FMT_UYVY },
> +	{ JPG_FMT("CrYCbY 16 bit", 16, V4L2_PIX_FMT_VYUY), V4L2_PIX_FMT_VYUY },
> +	{ JPG_FMT("YCbYCr 16 bit", 16, V4L2_PIX_FMT_YUYV), V4L2_PIX_FMT_YUYV },
> +	{ JPG_FMT("YCrYCb 16 bit", 16, V4L2_PIX_FMT_YVYU), V4L2_PIX_FMT_YVYU },
> +	{ JPG_FMT("YUV planar", 16, V4L2_PIX_FMT_YUV422P), V4L2_PIX_FMT_UYVY },
> +	{ RGB_FMT("RGB 555", 16, V4L2_PIX_FMT_RGB555), V4L2_PIX_FMT_RGB555 },
> +	{ RGB_FMT("RGB 565", 16, V4L2_PIX_FMT_RGB565), V4L2_PIX_FMT_RGB565 },
> +	LAST_FMT_TRANSLATION
> +};
> +
>  /* Should be allocated dynamically too, but we have only one. */
>  static struct soc_camera_host pxa_soc_camera_host = {
>  	.drv_name		= PXA_CAM_DRV_NAME,
>  	.ops			= &pxa_soc_camera_host_ops,
> +	.translate_fmt		= pxa_pixfmt_translations,
>  };

Do I understand it right, that with this all Bayer and monochrome formats 
will stop working with pxa? If so - not good. Remember what we discussed 
about a default "pass-through" case?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
