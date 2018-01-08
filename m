Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49452 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756537AbeAHPN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 10:13:56 -0500
Date: Mon, 8 Jan 2018 17:13:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Archit Taneja <architt@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l: doc: clarify v4l2_mbus_fmt height definition
Message-ID: <20180108151353.zn2ee2tbdq2yragp@valkosipuli.retiisi.org.uk>
References: <1515422746-5971-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515422746-5971-1-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Mon, Jan 08, 2018 at 02:45:49PM +0000, Kieran Bingham wrote:
> The v4l2_mbus_fmt width and height corresponds directly with the
> v4l2_pix_format definitions, yet the differences in documentation make
> it ambiguous what to do in the event of field heights.
> 
> Clarify this by referencing the v4l2_pix_format which is explicit on the
> matter, and by matching the terminology of 'image height' rather than
> the misleading 'frame height'.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  Documentation/media/uapi/v4l/subdev-formats.rst | 6 ++++--
>  include/uapi/linux/v4l2-mediabus.h              | 4 ++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
> index b1eea44550e1..a2a00202b430 100644
> --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> @@ -16,10 +16,12 @@ Media Bus Formats
>  
>      * - __u32
>        - ``width``
> -      - Image width, in pixels.
> +      - Image width in pixels. See struct
> +	:c:type:`v4l2_pix_format`.
>      * - __u32
>        - ``height``
> -      - Image height, in pixels.
> +      - Image height in pixels. See struct
> +	:c:type:`v4l2_pix_format`.
>      * - __u32
>        - ``code``
>        - Format code, from enum
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 6e20de63ec59..6b34108d0338 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -18,8 +18,8 @@
>  
>  /**
>   * struct v4l2_mbus_framefmt - frame format on the media bus
> - * @width:	frame width
> - * @height:	frame height
> + * @width:	image width
> + * @height:	image height (see struct v4l2_pix_format)

Hmm. This is the media bus format and it has no direct relation to
v4l2_pix_format. So no, I can't see what would be the point in making such
a reference.

>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>   * @field:	used interlacing type (from enum v4l2_field)
>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
