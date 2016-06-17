Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49573 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbcFQHLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 03:11:37 -0400
Subject: Re: [PATCH 1/6] [media] s5p-mfc: set capablity bus_info as required
 by VIDIOC_QUERYCAP
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
 <1466113235-25909-2-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5763A2A3.7000401@xs4all.nl>
Date: Fri, 17 Jun 2016 09:11:31 +0200
MIME-Version: 1.0
In-Reply-To: <1466113235-25909-2-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 11:40 PM, Javier Martinez Canillas wrote:
> The driver doesn't set the struct v4l2_capability bus_info field so the
> v4l2-compliance tool reports the following errors for VIDIOC_QUERYCAP:
> 
> Required ioctls:
>                 VIDIOC_QUERYCAP returned 0 (Success)
>                 fail: v4l2-compliance.cpp(304): string empty
>                 fail: v4l2-compliance.cpp(528): check_ustring(vcap.bus_info, sizeof(vcap.bus_info))
>         test VIDIOC_QUERYCAP: FAIL
> 
> This patch fixes by setting the field in VIDIOC_QUERYCAP ioctl handler:
> 
> Required ioctls:
>                 VIDIOC_QUERYCAP returned 0 (Success)
>         test VIDIOC_QUERYCAP: OK
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
> 
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 3 ++-
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index f2d6376ce618..4a40df22fd63 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -267,7 +267,8 @@ static int vidioc_querycap(struct file *file, void *priv,
>  
>  	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
>  	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
> -	cap->bus_info[0] = 0;
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(&dev->plat_dev->dev));
>  	/*
>  	 * This is only a mem-to-mem video device. The capture and output
>  	 * device capability flags are left only for backward compatibility
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 034b5c1d35a1..dd466ea6429e 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -945,7 +945,8 @@ static int vidioc_querycap(struct file *file, void *priv,
>  
>  	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
>  	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
> -	cap->bus_info[0] = 0;
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(&dev->plat_dev->dev));
>  	/*
>  	 * This is only a mem-to-mem video device. The capture and output
>  	 * device capability flags are left only for backward compatibility
> 
