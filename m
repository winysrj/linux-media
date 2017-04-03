Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36202 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751194AbdDCI64 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 04:58:56 -0400
Subject: Re: [PATCH v4 1/2] Documentation: Intel SR300 Depth camera INZI
 format
To: evgeni.raikhel@intel.com, linux-media@vger.kernel.org
References: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com>
 <1488498200-8014-1-git-send-email-evgeni.raikhel@intel.com>
 <1488498200-8014-2-git-send-email-evgeni.raikhel@intel.com>
Cc: laurent.pinchart@ideasonboard.com, guennadi.liakhovetski@intel.com,
        eliezer.tamir@intel.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b9accfe8-07b1-80d9-c5c7-8686559cc6b7@xs4all.nl>
Date: Mon, 3 Apr 2017 10:58:51 +0200
MIME-Version: 1.0
In-Reply-To: <1488498200-8014-2-git-send-email-evgeni.raikhel@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2017 12:43 AM, evgeni.raikhel@intel.com wrote:
> From: eraikhel <evgeni.raikhel@intel.com>
> 
> Provide the frame structure and data layout of V4L2-PIX-FMT-INZI
> format utilized by Intel SR300 Depth camera.
> 
> Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/media/uapi/v4l/depth-formats.rst |  1 +
>  Documentation/media/uapi/v4l/pixfmt-inzi.rst   | 81 ++++++++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
>  include/uapi/linux/videodev2.h                 |  1 +
>  4 files changed, 84 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst
> 
> diff --git a/Documentation/media/uapi/v4l/depth-formats.rst b/Documentation/media/uapi/v4l/depth-formats.rst
> index 82f183870aae..d1641e9687a6 100644
> --- a/Documentation/media/uapi/v4l/depth-formats.rst
> +++ b/Documentation/media/uapi/v4l/depth-formats.rst
> @@ -12,4 +12,5 @@ Depth data provides distance to points, mapped onto the image plane
>  .. toctree::
>      :maxdepth: 1
>  
> +    pixfmt-inzi
>      pixfmt-z16
> diff --git a/Documentation/media/uapi/v4l/pixfmt-inzi.rst b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
> new file mode 100644
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
> +Proprietary multi-planar format used by Intel SR300 Depth cameras, comprise of
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
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 0c3f238a2e76..93e8f42b0d63 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1131,6 +1131,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  	case V4L2_PIX_FMT_Y8I:		descr = "Interleaved 8-bit Greyscale"; break;
>  	case V4L2_PIX_FMT_Y12I:		descr = "Interleaved 12-bit Greyscale"; break;
>  	case V4L2_PIX_FMT_Z16:		descr = "16-bit Depth"; break;
> +	case V4L2_PIX_FMT_INZI:		descr = "Planar 10:16 Greyscale Depth"; break;
>  	case V4L2_PIX_FMT_PAL8:		descr = "8-bit Palette"; break;
>  	case V4L2_PIX_FMT_UV8:		descr = "8-bit Chrominance UV 4-4"; break;
>  	case V4L2_PIX_FMT_YVU410:	descr = "Planar YVU 4:1:0"; break;
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 45184a2ef66c..fbf59637d577 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -661,6 +661,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale 12-bit L/R interleaved */
>  #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
>  #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
> +#define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */
>  
>  /* SDR formats - used only for Software Defined Radio devices */
>  #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
> 
