Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59256 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731113AbeGSN5y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 09:57:54 -0400
Date: Thu, 19 Jul 2018 16:14:45 +0300
From: sakari.ailus@iki.fi
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Tom aan de Wiel <tom.aandewiel@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/5] media.h: add encoder/decoder functions for codecs
Message-ID: <20180719131445.pc6udhlrsp3cydrh@lanttu.localdomain>
References: <20180719121353.20021-1-hverkuil@xs4all.nl>
 <20180719121353.20021-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719121353.20021-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Jul 19, 2018 at 02:13:49PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add MEDIA_ENT_F_PROC_VIDEO_EN/DECODER to be used for the encoder
> and decoder entities of codec hardware.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/media/uapi/mediactl/media-types.rst | 11 +++++++++++
>  include/uapi/linux/media.h                        |  2 ++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
> index 96910cf2eaaa..8aea7661e243 100644
> --- a/Documentation/media/uapi/mediactl/media-types.rst
> +++ b/Documentation/media/uapi/mediactl/media-types.rst
> @@ -40,6 +40,8 @@ Types and flags used to represent the media graph elements
>  .. _MEDIA-ENT-F-VID-MUX:
>  .. _MEDIA-ENT-F-VID-IF-BRIDGE:
>  .. _MEDIA-ENT-F-DTV-DECODER:
> +.. _MEDIA-ENT-F-PROC-VIDEO-ENCODER:
> +.. _MEDIA-ENT-F-PROC-VIDEO-DECODER:
>  
>  .. cssclass:: longtable
>  
> @@ -188,6 +190,15 @@ Types and flags used to represent the media graph elements
>  	  received on its sink pad and outputs the statistics data on
>  	  its source pad.
>  
> +    *  -  ``MEDIA_ENT_F_PROC_VIDEO_ENCODER``
> +       -  Video (MPEG, HEVC, VPx, etc.) encoder. An entity capable of
> +          compressing video frames must have one sink pad and one source pad.
> +
> +    *  -  ``MEDIA_ENT_F_PROC_VIDEO_DECODER``
> +       -  Video (MPEG, HEVC, VPx, etc.) decoder. An entity capable of
> +          decompressing a compressed video stream into uncompressed video
> +	  frames must have one sink pad and one source pad.
> +

It'd be nice to keep the same ordering in the two lists (this one and the
one above).

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

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
> -- 
> 2.17.0
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
