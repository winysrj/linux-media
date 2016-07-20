Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40248 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbcGTHh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 03:37:26 -0400
Subject: Re: [PATCH v2 01/10] v4l: of: add "newavmode" property for Analog
 Devices codecs
To: Steve Longerbeam <slongerbeam@gmail.com>, lars@metafoo.de
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-2-git-send-email-steve_longerbeam@mentor.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1d7e9b86-a4c9-8223-d8bd-8f4b9effcce8@xs4all.nl>
Date: Wed, 20 Jul 2016 09:37:20 +0200
MIME-Version: 1.0
In-Reply-To: <1468973017-17647-2-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2016 02:03 AM, Steve Longerbeam wrote:
> This patch adds a "newavmode" boolean property as part of the v4l2 endpoint
> properties. This indicates an Analog Devices decoder is generating EAV/SAV
> codes to suit Analog Devices encoders.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
>  drivers/media/v4l2-core/v4l2-of.c                            | 4 ++++
>  include/media/v4l2-mediabus.h                                | 5 +++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 9cd2a36..6f2df51 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -88,6 +88,8 @@ Optional endpoint properties
>  - field-even-active: field signal level during the even field data transmission.
>  - pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
>    signal.
> +- newavmode: a boolean property to indicate an Analog Devices decoder is
> +  operating in NEWAVMODE. Valid for BT.656 busses only.

This property is adv7180 specific and does not belong here.

Add this to Documentation/devicetree/bindings/media/i2c/adv7180.txt instead.

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

>  - sync-on-green-active: active state of Sync-on-green (SoG) signal, 0/1 for
>    LOW/HIGH respectively.
>  - data-lanes: an array of physical data lane indexes. Position of an entry
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index 93b3368..719a7d1 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -109,6 +109,10 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
>  			V4L2_MBUS_DATA_ACTIVE_LOW;
>  
> +	if (endpoint->bus_type == V4L2_MBUS_BT656 &&
> +	    of_get_property(node, "newavmode", &v))
> +		flags |= V4L2_MBUS_NEWAVMODE;
> +
>  	if (of_get_property(node, "slave-mode", &v))
>  		flags |= V4L2_MBUS_SLAVE;
>  	else
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 34cc99e..0bd5f0e 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -43,6 +43,11 @@
>  /* Active state of Sync-on-green (SoG) signal, 0/1 for LOW/HIGH respectively. */
>  #define V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH	(1 << 12)
>  #define V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW		(1 << 13)
> +/*
> + * BT.656 specific flags
> + */
> +/* Analog Device's NEWAVMODE */
> +#define V4L2_MBUS_NEWAVMODE			(1 << 14)
>  
>  /* Serial flags */
>  /* How many lanes the client can use */
> 
