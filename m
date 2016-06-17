Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49573 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbcFQHMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 03:12:18 -0400
Subject: Re: [PATCH 2/6] [media] s5p-mfc: improve v4l2_capability driver and
 card fields
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
 <1466113235-25909-3-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5763A2CD.2040006@xs4all.nl>
Date: Fri, 17 Jun 2016 09:12:13 +0200
MIME-Version: 1.0
In-Reply-To: <1466113235-25909-3-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 11:40 PM, Javier Martinez Canillas wrote:
> According to the V4L2 documentation the driver and card fields should be
> used to identify the driver and the device but the s5p-mfc driver fills
> those field using the platform device name, which in turn is the name of
> the device DT node.
> 
> So not only the filled information isn't correct but also the same values
> are used in all the fields for both the encoder and decoder video devices.
> 
> Before this patch:
> 
> Driver Info (not using libv4l2):
>         Driver name   : 11000000.codec
>         Card type     : 11000000.codec
>         Bus info      : platform:11000000.codec
>         Driver version: 4.7.0
> 
> Driver Info (not using libv4l2):
>         Driver name   : 11000000.codec
>         Card type     : 11000000.codec
>         Bus info      : platform:11000000.codec
>         Driver version: 4.7.0
> 
> After this patch:
> 
> Driver Info (not using libv4l2):
>         Driver name   : s5p-mfc
>         Card type     : s5p-mfc-dec
>         Bus info      : platform:11000000.codec
>         Driver version: 4.7.0
> 
> Driver Info (not using libv4l2):
>         Driver name   : s5p-mfc
>         Card type     : s5p-mfc-enc
>         Bus info      : platform:11000000.codec
>         Driver version: 4.7.0
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

Hans

> ---
> 
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        | 1 -
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 4 ++--
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 4 ++--
>  4 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 6ee620ee8cd5..a936f89fa54a 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -35,7 +35,6 @@
>  #include "s5p_mfc_cmd.h"
>  #include "s5p_mfc_pm.h"
>  
> -#define S5P_MFC_NAME		"s5p-mfc"
>  #define S5P_MFC_DEC_NAME	"s5p-mfc-dec"
>  #define S5P_MFC_ENC_NAME	"s5p-mfc-enc"
>  
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index 9eb2481ec292..a10dcd244ff0 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -25,6 +25,8 @@
>  #include "regs-mfc.h"
>  #include "regs-mfc-v8.h"
>  
> +#define S5P_MFC_NAME		"s5p-mfc"
> +
>  /* Definitions related to MFC memory */
>  
>  /* Offset base used to differentiate between CAPTURE and OUTPUT
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 4a40df22fd63..5793b0d8ee0c 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -265,8 +265,8 @@ static int vidioc_querycap(struct file *file, void *priv,
>  {
>  	struct s5p_mfc_dev *dev = video_drvdata(file);
>  
> -	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
> -	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
> +	strncpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver) - 1);
> +	strncpy(cap->card, dev->vfd_dec->name, sizeof(cap->card) - 1);
>  	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
>  		 dev_name(&dev->plat_dev->dev));
>  	/*
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index dd466ea6429e..1220559d4874 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -943,8 +943,8 @@ static int vidioc_querycap(struct file *file, void *priv,
>  {
>  	struct s5p_mfc_dev *dev = video_drvdata(file);
>  
> -	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
> -	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
> +	strncpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver) - 1);
> +	strncpy(cap->card, dev->vfd_enc->name, sizeof(cap->card) - 1);
>  	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
>  		 dev_name(&dev->plat_dev->dev));
>  	/*
> 
