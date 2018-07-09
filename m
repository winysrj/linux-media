Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34866 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932601AbeGINBa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 09:01:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 06/12] media.h: add MEDIA_ENT_F_DV_ENCODER
Date: Mon, 09 Jul 2018 16:02:03 +0300
Message-ID: <1733775.3jbjugDgYd@avalon>
In-Reply-To: <20180629114331.7617-7-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <20180629114331.7617-7-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday, 29 June 2018 14:43:25 EEST Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add a new function for digital video encoders such as HDMI transmitters.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/media/uapi/mediactl/media-types.rst | 7 +++++++
>  include/uapi/linux/media.h                        | 3 ++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/uapi/mediactl/media-types.rst
> b/Documentation/media/uapi/mediactl/media-types.rst index
> c11b0c7e890b..e90d4d0a7f8b 100644
> --- a/Documentation/media/uapi/mediactl/media-types.rst
> +++ b/Documentation/media/uapi/mediactl/media-types.rst
> @@ -206,6 +206,13 @@ Types and flags used to represent the media graph
> elements and output it in some digital video standard, with appropriate
> timing signals.
> 
> +    *  -  ``MEDIA_ENT_F_DV_ENCODER``
> +       -  Digital video encoder. The basic function of the video encoder is
> +	  to accept digital video from some digital video standard with
> +	  appropriate timing signals (usually a parallel video bus with sync
> +	  signals) and output this to a digital video output connector such
> +	  as HDMI or DisplayPort.

This is slightly vague in my opinion, but not worse than the definition of 
MEDIA_ENT_F_DV_DECODER, so I'm fine with it.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  ..  tabularcolumns:: |p{5.5cm}|p{12.0cm}|
> 
>  .. _media-entity-flag:
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 99f5e0978ebb..6f594fa238c2 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -90,10 +90,11 @@ struct media_device_info {
>  #define MEDIA_ENT_F_LENS			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
> 
>  /*
> - * Video decoder functions
> + * Video decoder/encoder functions
>   */
>  #define MEDIA_ENT_F_ATV_DECODER			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
>  #define MEDIA_ENT_F_DV_DECODER			(MEDIA_ENT_F_BASE + 0x6001)
> +#define MEDIA_ENT_F_DV_ENCODER			(MEDIA_ENT_F_BASE + 0x6002)
> 
>  /*
>   * Digital TV, analog TV, radio and/or software defined radio tuner
> functions.

-- 
Regards,

Laurent Pinchart
