Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:55505 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726389AbeIFOLG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 10:11:06 -0400
Subject: Re: [PATCH 1/2] CNF4 fourcc for 4 bit-per-pixel packed confidence
 information
To: dorodnic@gmail.com, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
References: <1536220267-22347-1-git-send-email-sergey.dorodnicov@intel.com>
 <1536220267-22347-2-git-send-email-sergey.dorodnicov@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6660d6be-7db5-5723-3268-761ed710f661@xs4all.nl>
Date: Thu, 6 Sep 2018 11:36:24 +0200
MIME-Version: 1.0
In-Reply-To: <1536220267-22347-2-git-send-email-sergey.dorodnicov@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergey,

Some review comments:

On 09/06/18 09:51, dorodnic@gmail.com wrote:
> From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> 
> Adding new fourcc CNF4 for 4 bit-per-pixel packed confidence information
> provided by Intel RealSense depth cameras. Every two consecutive pixels
> are packed into a single byte (little-endian).
> 
> Signed-off-by: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
> ---
>  Documentation/media/uapi/v4l/depth-formats.rst |  1 +
>  Documentation/media/uapi/v4l/pixfmt-cnf4.rst   | 30 ++++++++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
>  include/uapi/linux/videodev2.h                 |  1 +
>  4 files changed, 33 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-cnf4.rst
> 
> diff --git a/Documentation/media/uapi/v4l/depth-formats.rst b/Documentation/media/uapi/v4l/depth-formats.rst
> index d1641e9..9533348 100644
> --- a/Documentation/media/uapi/v4l/depth-formats.rst
> +++ b/Documentation/media/uapi/v4l/depth-formats.rst
> @@ -14,3 +14,4 @@ Depth data provides distance to points, mapped onto the image plane
>  
>      pixfmt-inzi
>      pixfmt-z16
> +    pixfmt-cnf4
> diff --git a/Documentation/media/uapi/v4l/pixfmt-cnf4.rst b/Documentation/media/uapi/v4l/pixfmt-cnf4.rst
> new file mode 100644
> index 0000000..d24fc1a
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-cnf4.rst
> @@ -0,0 +1,30 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _V4L2-PIX-FMT-CNF4:
> +
> +******************************
> +V4L2_PIX_FMT_CNF4 ('CNF4')
> +******************************
> +
> +Sensor confidence information as a 4 bits per pixel packed array

Confidence in what? I'll take a wild guess and say that it is about depth
confidence, but I don't think you actually say this anywhere :-)

> +
> +Description
> +===========
> +
> +Proprietary format used by Intel RealSense Depth cameras containing sensor
> +confidence information in range 0-15 with 0 indicating that the sensor was
> +unable to resolve any signal and 15 indicating maximum level of confidence for
> +the specific sensor (actual error margins might change from sensor to sensor).
> +
> +Every two consecutive pixels are packed into a single byte (bit order is
> +little-endian).

Luckily, the bit order is always little-endian, so that doesn't help.

It's better to be specific here: bits 0-3 refer to the confidence value for the pixel
at position X, bits 407 refer to the pixel at position X+1, where X is even.

> +
> +**Bit-packed representation.**
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths: 64 64
> +
> +    * - Y'\ :sub:`01[3:0]`\ (bits 3--0) Y'\ :sub:`00[3:0]`\ (bits 7--4)
> +      - Y'\ :sub:`03[3:0]`\ (bits 3--0) Y'\ :sub:`02[3:0]`\ (bits 7--4)
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 54afc9c..eff296d 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1189,6 +1189,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  	case V4L2_PIX_FMT_Y12I:		descr = "Interleaved 12-bit Greyscale"; break;
>  	case V4L2_PIX_FMT_Z16:		descr = "16-bit Depth"; break;
>  	case V4L2_PIX_FMT_INZI:		descr = "Planar 10:16 Greyscale Depth"; break;
> +	case V4L2_PIX_FMT_CNF4:		descr = "4-bit Confidence (Packed)"; break;

This should probably become "4-bit Depth Confidence (Packed)".

>  	case V4L2_PIX_FMT_PAL8:		descr = "8-bit Palette"; break;
>  	case V4L2_PIX_FMT_UV8:		descr = "8-bit Chrominance UV 4-4"; break;
>  	case V4L2_PIX_FMT_YVU410:	descr = "Planar YVU 4:1:0"; break;
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 5d1a368..a47f603 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -676,6 +676,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
>  #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
>  #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */
> +#define V4L2_PIX_FMT_CNF4     v4l2_fourcc('C', 'N', 'F', '4') /* Intel 4-bit packed confidence information */

again, be explicit: "depth confidence"

>  
>  /* 10bit raw bayer packed, 32 bytes for every 25 pixels, last LSB 6 bits unused */
>  #define V4L2_PIX_FMT_IPU3_SBGGR10	v4l2_fourcc('i', 'p', '3', 'b') /* IPU3 packed 10-bit BGGR bayer */
> 

Regards,

	Hans
