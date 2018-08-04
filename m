Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:42306 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726588AbeHDNnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 09:43:13 -0400
Subject: Re: [PATCH v6 2/8] media: v4l: Add definition for Allwinner's
 MB32-tiled NV12 format
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
 <20180725100256.22833-3-paul.kocialkowski@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4628cfe1-e42f-67ad-20b3-078c6a96d6ed@xs4all.nl>
Date: Sat, 4 Aug 2018 13:42:40 +0200
MIME-Version: 1.0
In-Reply-To: <20180725100256.22833-3-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2018 12:02 PM, Paul Kocialkowski wrote:
> This introduces support for Allwinner's MB32-tiled NV12 format, where
> each plane is divided into macroblocks of 32x32 pixels. Hence, the size
> of each plane has to be aligned to 32 bytes. The pixels inside each
> macroblock are coded as they would be if the macroblock was a single
> plane, line after line.
> 
> The MB32-tiled NV12 format is used by the video engine on Allwinner
> platforms: it is the default format for decoded frames (and the only one
> available in the oldest supported platforms).
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  Documentation/media/uapi/v4l/pixfmt-reserved.rst | 15 ++++++++++++++-
>  drivers/media/v4l2-core/v4l2-ioctl.c             |  1 +
>  include/uapi/linux/videodev2.h                   |  1 +
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> index 38af1472a4b4..9a68b6a787bf 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
> @@ -243,7 +243,20 @@ please make a proposal on the linux-media mailing list.
>  	It is an opaque intermediate format and the MDP hardware must be
>  	used to convert ``V4L2_PIX_FMT_MT21C`` to ``V4L2_PIX_FMT_NV12M``,
>  	``V4L2_PIX_FMT_YUV420M`` or ``V4L2_PIX_FMT_YVU420``.
> -
> +    * .. _V4L2-PIX-FMT-MB32-NV12:
> +
> +      - ``V4L2_PIX_FMT_MB32_NV12``
> +      - 'MN12'
> +      - Two-planar NV12-based format used by the Allwinner video engine
> +        hardware, with 32x32 tiles for the luminance plane and 32x64 tiles
> +        for the chrominance plane. Each tile is a linear pixel data
> +        representation within its own bounds. Each tile follows the previous
> +        one linearly (as in, from left to right, top to bottom).

as in, -> as in:

> +
> +        The frame dimensions are aligned to match an integer number of
> +        tiles, resulting in 32-aligned resolutions for the luminance plane
> +        and 16-aligned resolutions for the chrominance plane (with 2x2
> +        subsampling).
>  
>  .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
>  
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 68e914b83a03..7e1c200de10d 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1331,6 +1331,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  		case V4L2_PIX_FMT_SE401:	descr = "GSPCA SE401"; break;
>  		case V4L2_PIX_FMT_S5C_UYVY_JPG:	descr = "S5C73MX interleaved UYVY/JPEG"; break;
>  		case V4L2_PIX_FMT_MT21C:	descr = "Mediatek Compressed Format"; break;
> +		case V4L2_PIX_FMT_MB32_NV12:	descr = "Allwinner tiled NV12 format"; break;

"Allwinner Tiled NV12 Format"

If it is Allwinner specific, then that should be in the PIX_FMT name as well:
something like V4L2_PIX_FMT_ALLWINNER_MB32_NV12 or perhaps SUNXI_MB32_NV12.

On the other hand, you could also see this as a variant of e.g. V4L2_PIX_FMT_NV12MT
or V4L2_PIX_FMT_NV12MT_16X16. In that case it is not necessarily Allwinner specific
since other devices might choose this format. You can go either way, as long
as it is consistent.

>  		default:
>  			WARN(1, "Unknown pixelformat 0x%08x\n", fmt->pixelformat);
>  			if (fmt->description[0])
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index d171361ed9b3..453d27142e31 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -670,6 +670,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
>  #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
>  #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */
> +#define V4L2_PIX_FMT_MB32_NV12 v4l2_fourcc('M', 'N', '1', '2') /* Allwinner tiled NV12 format */
>  
>  /* 10bit raw bayer packed, 32 bytes for every 25 pixels, last LSB 6 bits unused */
>  #define V4L2_PIX_FMT_IPU3_SBGGR10	v4l2_fourcc('i', 'p', '3', 'b') /* IPU3 packed 10-bit BGGR bayer */
> 

Regards,

	Hans
