Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43323 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbcB2KfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 05:35:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH for 4.5] media.h: use hex values for the range offsets, move connectors base up.
Date: Mon, 29 Feb 2016 12:35:24 +0200
Message-ID: <7005747.SQRvpaCij5@avalon>
In-Reply-To: <56D3FB27.7000202@xs4all.nl>
References: <56D3FB27.7000202@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 29 February 2016 09:02:47 Hans Verkuil wrote:
> Make the base offset hexadecimal to simplify debugging since the base
> addresses are hex too.

This is much better, it will help debugging.

Before applying the patch, though, I wonder whether 4096 functions by 
categories isn't a bit overkill. Have you given that any thought, or did you 
select 1000/0x1000 just for convenience ?

> The offsets for connectors is also changed to start after the 'reserved'
> range 0x10000-0x2ffff.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 95e126e..79960ae 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -66,17 +66,17 @@ struct media_device_info {
>  /*
>   * DVB entities
>   */
> -#define MEDIA_ENT_F_DTV_DEMOD		(MEDIA_ENT_F_BASE + 1)
> -#define MEDIA_ENT_F_TS_DEMUX		(MEDIA_ENT_F_BASE + 2)
> -#define MEDIA_ENT_F_DTV_CA		(MEDIA_ENT_F_BASE + 3)
> -#define MEDIA_ENT_F_DTV_NET_DECAP	(MEDIA_ENT_F_BASE + 4)
> +#define MEDIA_ENT_F_DTV_DEMOD		(MEDIA_ENT_F_BASE + 0x00001)
> +#define MEDIA_ENT_F_TS_DEMUX		(MEDIA_ENT_F_BASE + 0x00002)
> +#define MEDIA_ENT_F_DTV_CA		(MEDIA_ENT_F_BASE + 0x00003)
> +#define MEDIA_ENT_F_DTV_NET_DECAP	(MEDIA_ENT_F_BASE + 0x00004)
> 
>  /*
>   * I/O entities
>   */
> -#define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 1001)
> -#define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 1002)
> -#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 1003)
> +#define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 0x01001)
> +#define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 0x01002)
> +#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 0x01003)
> 
>  /*
>   * Analog TV IF-PLL decoders
> @@ -84,23 +84,23 @@ struct media_device_info {
>   * It is a responsibility of the master/bridge drivers to create links
>   * for MEDIA_ENT_F_IF_VID_DECODER and MEDIA_ENT_F_IF_AUD_DECODER.
>   */
> -#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 2001)
> -#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 2002)
> +#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 0x02001)
> +#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 0x02002)
> 
>  /*
>   * Audio Entity Functions
>   */
> -#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 3000)
> -#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 3001)
> -#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 3002)
> +#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 0x03000)
> +#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 0x03001)
> +#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03002)
> 
>  /*
>   * Connectors
>   */
>  /* It is a responsibility of the entity drivers to add connectors and links
> */ -#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 10001)
> -#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 10002)
> -#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
> +#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 0x30001)
> +#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 0x30002)
> +#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 0x30003)
> 
>  /*
>   * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and

-- 
Regards,

Laurent Pinchart

