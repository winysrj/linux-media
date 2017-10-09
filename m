Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:51628 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751894AbdJILAa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:00:30 -0400
Subject: Re: [PATCH 08/24] media: v4l2-dev: document VFL_DIR_* direction
 defines
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <150e771ce68cc38453ddc77f55d5ff9f9142e34a.1507544011.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e9d3d05e-c826-59ec-d38f-63a5e8b798e4@xs4all.nl>
Date: Mon, 9 Oct 2017 13:00:29 +0200
MIME-Version: 1.0
In-Reply-To: <150e771ce68cc38453ddc77f55d5ff9f9142e34a.1507544011.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 12:19, Mauro Carvalho Chehab wrote:
> The V4L_DIR_* direction flags document the direction for a
> V4L2 device node. Convert them to enum and document.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  include/media/v4l2-dev.h | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index f182b47dfd71..87dac58c7799 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -40,11 +40,21 @@ enum vfl_devnode_type {
>  };
>  #define VFL_TYPE_MAX VFL_TYPE_TOUCH
>  
> -/* Is this a receiver, transmitter or mem-to-mem? */
> -/* Ignored for VFL_TYPE_SUBDEV. */
> -#define VFL_DIR_RX		0
> -#define VFL_DIR_TX		1
> -#define VFL_DIR_M2M		2
> +/**
> + * enum  vfl_direction - Identifies if a &struct video_device corresponds
> + *	to a receiver, a transmitter or a mem-to-mem device.
> + *
> + * @VFL_DIR_RX:		device is a receiver.
> + * @VFL_DIR_TX:		device is a transmitter.
> + * @VFL_DIR_M2M:	device is a memory to memory device.
> + *
> + * Note: Ignored if &enum vfl_devnode_type is %VFL_TYPE_SUBDEV.
> + */
> +enum vfl_devnode_direction {
> +	VFL_DIR_RX,
> +	VFL_DIR_TX,
> +	VFL_DIR_M2M,
> +};
>  
>  struct v4l2_ioctl_callbacks;
>  struct video_device;
> @@ -249,7 +259,7 @@ struct video_device
>  	/* device info */
>  	char name[32];
>  	enum vfl_devnode_type vfl_type;
> -	int vfl_dir;
> +	enum vfl_devnode_direction vfl_dir;
>  	int minor;
>  	u16 num;
>  	unsigned long flags;
> 
