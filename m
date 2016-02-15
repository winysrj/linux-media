Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49996 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752893AbcBOLKV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 06:10:21 -0500
Date: Mon, 15 Feb 2016 13:10:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH for v4.5] media.h: increase the spacing between function
 ranges
Message-ID: <20160215111017.GJ32612@valkosipuli.retiisi.org.uk>
References: <56BC9AA7.3040102@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56BC9AA7.3040102@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Feb 11, 2016 at 03:28:55PM +0100, Hans Verkuil wrote:
> Each function range is quite narrow and especially for connectors this
> will pose a problem. Increase the function ranges while we still can and
> move the connector range to the end so that range is practically limitless.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
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
> -/* It is a responsibility of the entity drivers to add connectors and links */
> -#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 21)
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
> +/* It is a responsibility of the entity drivers to add connectors and links */
> +#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 10001)
> +#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 10002)
> +#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
> +/* For internal test signal generators and other debug connectors */
> +#define MEDIA_ENT_F_CONN_TEST		(MEDIA_ENT_F_BASE + 10004)
> 
>  /*
>   * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and

We have MEDIA_ENT_F_BASE used for all of these at the moment while we have
plenty of room in the 32-bit space. How about adding a new base for each
group, after MEDIA_ENT_F_OLD_SUBDEV_BASE? Each range would have 2^16 items.

What do you think?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
