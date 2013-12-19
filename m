Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3237 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab3LSIs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 03:48:57 -0500
Message-ID: <52B2B2D5.5090400@xs4all.nl>
Date: Thu, 19 Dec 2013 09:48:21 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v4 1/7] v4l: add device type for Software Defined
 Radio
References: <1387425606-7458-1-git-send-email-crope@iki.fi> <1387425606-7458-2-git-send-email-crope@iki.fi>
In-Reply-To: <1387425606-7458-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/19/2013 05:00 AM, Antti Palosaari wrote:
> Add new V4L device type VFL_TYPE_SDR for Software Defined Radio.
> It is registered as /dev/swradio0 (/dev/sdr0 was already reserved).
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c | 5 +++++
>  include/media/v4l2-dev.h           | 3 ++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 1cc1749..6a1e6a8 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -767,6 +767,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
>   *	%VFL_TYPE_RADIO - A radio card
>   *
>   *	%VFL_TYPE_SUBDEV - A subdevice
> + *
> + *	%VFL_TYPE_SDR - Software Defined Radio
>   */
>  int __video_register_device(struct video_device *vdev, int type, int nr,
>  		int warn_if_nr_in_use, struct module *owner)
> @@ -806,6 +808,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>  	case VFL_TYPE_SUBDEV:
>  		name_base = "v4l-subdev";
>  		break;
> +	case VFL_TYPE_SDR:
> +		name_base = "swradio";

I would add a small comment here explaining why "sdr" is a bad name to
use.

After that you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> +		break;
>  	default:
>  		printk(KERN_ERR "%s called with unknown type: %d\n",
>  		       __func__, type);
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index c768c9f..eec6e46 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -24,7 +24,8 @@
>  #define VFL_TYPE_VBI		1
>  #define VFL_TYPE_RADIO		2
>  #define VFL_TYPE_SUBDEV		3
> -#define VFL_TYPE_MAX		4
> +#define VFL_TYPE_SDR		4
> +#define VFL_TYPE_MAX		5
>  
>  /* Is this a receiver, transmitter or mem-to-mem? */
>  /* Ignored for VFL_TYPE_SUBDEV. */
> 

