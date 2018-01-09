Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52631 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756583AbeAIH3m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 02:29:42 -0500
Subject: Re: [PATCH v2] v4l: doc: Clarify v4l2_mbus_fmt height definition
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Archit Taneja <architt@codeaurora.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1515434106-18747-1-git-send-email-kieran.bingham@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <33ac89f1-c7c3-041c-c772-a90d8a40a0db@xs4all.nl>
Date: Tue, 9 Jan 2018 08:29:37 +0100
MIME-Version: 1.0
In-Reply-To: <1515434106-18747-1-git-send-email-kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/08/2018 06:55 PM, Kieran Bingham wrote:
> The v4l2_mbus_fmt width and height corresponds directly with the
> v4l2_pix_format definitions, yet the differences in documentation make
> it ambiguous what to do in the event of field heights.
> 
> Clarify this using the same text as is provided for the v4l2_pix_format
> which is explicit on the matter, and by matching the terminology of
> 'image height' rather than the misleading 'frame height'.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

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
> 
