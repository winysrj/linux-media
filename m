Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbeGYMu5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 08:50:57 -0400
Date: Wed, 25 Jul 2018 08:39:36 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Tom aan de Wiel <tom.aandewiel@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/5] media.h: add encoder/decoder functions for codecs
Message-ID: <20180725083936.74190211@coco.lan>
In-Reply-To: <20180720082736.8977-2-hverkuil@xs4all.nl>
References: <20180720082736.8977-1-hverkuil@xs4all.nl>
        <20180720082736.8977-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 20 Jul 2018 10:27:32 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add MEDIA_ENT_F_PROC_VIDEO_EN/DECODER to be used for the encoder
> and decoder entities of codec hardware.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/media/uapi/mediactl/media-types.rst | 11 +++++++++++
>  include/uapi/linux/media.h                        |  2 ++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
> index 96910cf2eaaa..5bb933c42879 100644
> --- a/Documentation/media/uapi/mediactl/media-types.rst
> +++ b/Documentation/media/uapi/mediactl/media-types.rst
> @@ -37,6 +37,8 @@ Types and flags used to represent the media graph elements
>  .. _MEDIA-ENT-F-PROC-VIDEO-LUT:
>  .. _MEDIA-ENT-F-PROC-VIDEO-SCALER:
>  .. _MEDIA-ENT-F-PROC-VIDEO-STATISTICS:
> +.. _MEDIA-ENT-F-PROC-VIDEO-ENCODER:
> +.. _MEDIA-ENT-F-PROC-VIDEO-DECODER:
>  .. _MEDIA-ENT-F-VID-MUX:
>  .. _MEDIA-ENT-F-VID-IF-BRIDGE:
>  .. _MEDIA-ENT-F-DTV-DECODER:
> @@ -188,6 +190,15 @@ Types and flags used to represent the media graph elements
>  	  received on its sink pad and outputs the statistics data on
>  	  its source pad.
>  
> +    *  -  ``MEDIA_ENT_F_PROC_VIDEO_ENCODER``
> +       -  Video (MPEG, HEVC, VPx, etc.) encoder. An entity capable of
> +          compressing video frames must have one sink pad and one source pad.

I guess a dot is missing here:

          compressing video frames. Must have one sink pad and one source pad.


> +
> +    *  -  ``MEDIA_ENT_F_PROC_VIDEO_DECODER``
> +       -  Video (MPEG, HEVC, VPx, etc.) decoder. An entity capable of
> +          decompressing a compressed video stream into uncompressed video
> +	  frames must have one sink pad and one source pad.

Same here:
	  frames. Must have one sink pad and one source pad.


If you're ok with that, I can fix it when applying the patch.

> +
>      *  -  ``MEDIA_ENT_F_VID_MUX``
>         - Video multiplexer. An entity capable of multiplexing must have at
>           least two sink pads and one source pad, and must pass the video
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 86c7dcc9cba3..9004d0c5560c 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -132,6 +132,8 @@ struct media_device_info {
>  #define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
>  #define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
>  #define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
> +#define MEDIA_ENT_F_PROC_VIDEO_ENCODER		(MEDIA_ENT_F_BASE + 0x4007)
> +#define MEDIA_ENT_F_PROC_VIDEO_DECODER		(MEDIA_ENT_F_BASE + 0x4008)
>  
>  /*
>   * Switch and bridge entity functions



Thanks,
Mauro
