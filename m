Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:37490 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758089AbeAHWiF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 17:38:05 -0500
Received: by mail-lf0-f67.google.com with SMTP id f3so13825924lfe.4
        for <linux-media@vger.kernel.org>; Mon, 08 Jan 2018 14:38:04 -0800 (PST)
Date: Mon, 8 Jan 2018 23:38:02 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Archit Taneja <architt@codeaurora.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] v4l: doc: Clarify v4l2_mbus_fmt height definition
Message-ID: <20180108223802.GF23075@bigcity.dyn.berto.se>
References: <1515434106-18747-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1515434106-18747-1-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your patch.

On 2018-01-08 17:55:24 +0000, Kieran Bingham wrote:
> The v4l2_mbus_fmt width and height corresponds directly with the
> v4l2_pix_format definitions, yet the differences in documentation make
> it ambiguous what to do in the event of field heights.
> 
> Clarify this using the same text as is provided for the v4l2_pix_format
> which is explicit on the matter, and by matching the terminology of
> 'image height' rather than the misleading 'frame height'.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> v2:
>  - Duplicated explicit text from v4l2_pix_format rather than
>    referencing it.
> 
>  Documentation/media/uapi/v4l/subdev-formats.rst | 8 ++++++--
>  include/uapi/linux/v4l2-mediabus.h              | 4 ++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
> index b1eea44550e1..9fcabe7f9367 100644
> --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> @@ -16,10 +16,14 @@ Media Bus Formats
>  
>      * - __u32
>        - ``width``
> -      - Image width, in pixels.
> +      - Image width in pixels.
>      * - __u32
>        - ``height``
> -      - Image height, in pixels.
> +      - Image height in pixels. If ``field`` is one of ``V4L2_FIELD_TOP``,
> +	``V4L2_FIELD_BOTTOM`` or ``V4L2_FIELD_ALTERNATE`` then height
> +	refers to the number of lines in the field, otherwise it refers to
> +	the number of lines in the frame (which is twice the field height
> +	for interlaced formats).
>      * - __u32
>        - ``code``
>        - Format code, from enum
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 6e20de63ec59..123a231001a8 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -18,8 +18,8 @@
>  
>  /**
>   * struct v4l2_mbus_framefmt - frame format on the media bus
> - * @width:	frame width
> - * @height:	frame height
> + * @width:	image width
> + * @height:	image height
>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>   * @field:	used interlacing type (from enum v4l2_field)
>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
