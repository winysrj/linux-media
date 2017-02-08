Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41723 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbdBHOQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 09:16:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: evgeni.raikhel@gmail.com
Cc: linux-media@vger.kernel.org, guennadi.liakhovetski@intel.com,
        eliezer.tamir@intel.com, sergey.dorodnicov@intel.com,
        eraikhel <evgeni.raikhel@intel.com>
Subject: Re: [PATCH v2 1/2] Documentation: Intel SR300 Depth camera INZI format
Date: Wed, 08 Feb 2017 15:39:36 +0200
Message-ID: <3382430.7k761HOSQl@avalon>
In-Reply-To: <1486542864-5832-1-git-send-email-evgeni.raikhel@intel.com>
References: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com> <1486542864-5832-1-git-send-email-evgeni.raikhel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Evgeni,

Thank you for the patch.

On Wednesday 08 Feb 2017 10:34:23 evgeni.raikhel@gmail.com wrote:
> From: eraikhel <evgeni.raikhel@intel.com>
> 
> Provide the frame structure and data layout of V4L2-PIX-FMT-INZI
> format utilized by Intel SR300 Depth camera.
> 
> Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
> ---
>  Documentation/media/uapi/v4l/depth-formats.rst |  1 +
>  Documentation/media/uapi/v4l/pixfmt-inzi.rst   | 81 +++++++++++++++++++++++
>  include/uapi/linux/videodev2.h                 |  1 +

You should also add the format description string to v4l_fill_fmtdesc() in 
drivers/media/v4l2-core/v4l2-ioctl.c. Maybe something like "Planar 10-bit IR 
and 16-bit Depth" ?

>  3 files changed, 83 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst
> 
> diff --git a/Documentation/media/uapi/v4l/depth-formats.rst
> b/Documentation/media/uapi/v4l/depth-formats.rst index
> 82f183870aae..c755be0e4d2a 100644
> --- a/Documentation/media/uapi/v4l/depth-formats.rst
> +++ b/Documentation/media/uapi/v4l/depth-formats.rst
> @@ -13,3 +13,4 @@ Depth data provides distance to points, mapped onto the
> image plane
>      :maxdepth: 1
> 
>      pixfmt-z16
> +    pixfmt-inzi

I'd keep the formats alphabetically sorted.

The rest looks good to me. With these two small issues fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> diff --git a/Documentation/media/uapi/v4l/pixfmt-inzi.rst
> b/Documentation/media/uapi/v4l/pixfmt-inzi.rst new file mode 100644
> index 000000000000..9849e799f205
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
> @@ -0,0 +1,81 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _V4L2-PIX-FMT-INZI:
> +
> +**************************
> +V4L2_PIX_FMT_INZI ('INZI')
> +**************************
> +
> +Infrared 10-bit linked with Depth 16-bit images
> +
> +
> +Description
> +===========
> +
> +Proprietary multi-planar format used by Intel SR300 Depth cameras, comprise
> of
> +Infrared image followed by Depth data. The pixel definition is 32-bpp,
> +with the Depth and Infrared Data split into separate continuous planes of
> +identical dimensions.
> +
> +
> +
> +The first plane - Infrared data - is stored according to
> +:ref:`V4L2_PIX_FMT_Y10 <V4L2-PIX-FMT-Y10>` greyscale format.
> +Each pixel is 16-bit cell, with actual data stored in the 10 LSBs
> +with values in range 0 to 1023.
> +The six remaining MSBs are padded with zeros.
> +
> +
> +The second plane provides 16-bit per-pixel Depth data arranged in
> +:ref:`V4L2-PIX-FMT-Z16 <V4L2-PIX-FMT-Z16>` format.
> +
> +
> +**Frame Structure.**
> +Each cell is a 16-bit word with more significant data stored at higher
> +memory address (byte order is little-endian).
> +
> +.. raw:: latex
> +
> +    \newline\newline\begin{adjustbox}{width=\columnwidth}
> +
> +.. tabularcolumns:: |p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 1
> +    :widths:    1 1 1 1 1 1
> +
> +    * - Ir\ :sub:`0,0`
> +      - Ir\ :sub:`0,1`
> +      - Ir\ :sub:`0,2`
> +      - ...
> +      - ...
> +      - ...
> +    * - :cspan:`5` ...
> +    * - :cspan:`5` Infrared Data
> +    * - :cspan:`5` ...
> +    * - ...
> +      - ...
> +      - ...
> +      - Ir\ :sub:`n-1,n-3`
> +      - Ir\ :sub:`n-1,n-2`
> +      - Ir\ :sub:`n-1,n-1`
> +    * - Depth\ :sub:`0,0`
> +      - Depth\ :sub:`0,1`
> +      - Depth\ :sub:`0,2`
> +      - ...
> +      - ...
> +      - ...
> +    * - :cspan:`5` ...
> +    * - :cspan:`5` Depth Data
> +    * - :cspan:`5` ...
> +    * - ...
> +      - ...
> +      - ...
> +      - Depth\ :sub:`n-1,n-3`
> +      - Depth\ :sub:`n-1,n-2`
> +      - Depth\ :sub:`n-1,n-1`
> +
> +.. raw:: latex
> +
> +    \end{adjustbox}\newline\newline
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 46e8a2e369f9..04263c59b93f 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -662,6 +662,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale
> 12-bit L/R interleaved */ #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z',
> '1', '6', ' ') /* Depth data 16-bit */ #define V4L2_PIX_FMT_MT21C   
> v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
> +#define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel
> Infrared 10-bit linked with Depth 16-bit */
> 
>  /* SDR formats - used only for Software Defined Radio devices */
>  #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8
> */

-- 
Regards,

Laurent Pinchart

