Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42929 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbcB2CVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 21:21:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH for v4.5] media.h: increase the spacing between function ranges
Date: Mon, 29 Feb 2016 04:21:39 +0200
Message-ID: <11122122.4xDoxEiLJr@avalon>
In-Reply-To: <56BC9AA7.3040102@xs4all.nl>
References: <56BC9AA7.3040102@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 11 February 2016 15:28:55 Hans Verkuil wrote:
> Each function range is quite narrow and especially for connectors this
> will pose a problem. Increase the function ranges while we still can and
> move the connector range to the end so that range is practically limitless.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

It looks like this got applied without taking Sakari's comments into account. 
Furthermore, I believe the IDs you use below will be confusing, as the base is 
a hex value and the offset a decimal value. It would making debugging much 
easier if both used hex values.

> ---
>  include/uapi/linux/media.h | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index c9eb42a..a300a33 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -72,21 +72,11 @@ struct media_device_info {
>  #define MEDIA_ENT_F_DTV_NET_DECAP	(MEDIA_ENT_F_BASE + 4)
> 
>  /*
> - * Connectors
> - */
> -/* It is a responsibility of the entity drivers to add connectors and links
> */ -#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 21)
> -#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 22)
> -#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 23)
> -/* For internal test signal generators and other debug connectors */
> -#define MEDIA_ENT_F_CONN_TEST		(MEDIA_ENT_F_BASE + 24)
> -
> -/*
>   * I/O entities
>   */
> -#define MEDIA_ENT_F_IO_DTV  		(MEDIA_ENT_F_BASE + 31)
> -#define MEDIA_ENT_F_IO_VBI  		(MEDIA_ENT_F_BASE + 32)
> -#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 33)
> +#define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 1001)
> +#define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 1002)
> +#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 1003)
> 
>  /*
>   * Analog TV IF-PLL decoders
> @@ -94,8 +84,18 @@ struct media_device_info {
>   * It is a responsibility of the master/bridge drivers to create links
>   * for MEDIA_ENT_F_IF_VID_DECODER and MEDIA_ENT_F_IF_AUD_DECODER.
>   */
> -#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 41)
> -#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 42)
> +#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 2001)
> +#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 2002)
> +
> +/*
> + * Connectors
> + */
> +/* It is a responsibility of the entity drivers to add connectors and links
> */ +#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 10001)
> +#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 10002)
> +#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
> +/* For internal test signal generators and other debug connectors */
> +#define MEDIA_ENT_F_CONN_TEST		(MEDIA_ENT_F_BASE + 10004)
> 
>  /*
>   * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and

-- 
Regards,

Laurent Pinchart

