Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56958 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751449AbdEPMCq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 08:02:46 -0400
Date: Tue, 16 May 2017 15:02:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com
Subject: Re: [PATCH 2/3] [media] doc-rst: add IPU3 raw10 bayer pixel format
 definitions
Message-ID: <20170516120205.GO3227@valkosipuli.retiisi.org.uk>
References: <cover.1493479141.git.yong.zhi@intel.com>
 <edf6dbb7b690a363558e8b70b22eacd3854bae38.1493479141.git.yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edf6dbb7b690a363558e8b70b22eacd3854bae38.1493479141.git.yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Sat, Apr 29, 2017 at 06:34:35PM -0500, Yong Zhi wrote:
> The formats added by this patch are:
> 
>     V4L2_PIX_FMT_IPU3_SBGGR10
>     V4L2_PIX_FMT_IPU3_SGBRG10
>     V4L2_PIX_FMT_IPU3_SGRBG10
>     V4L2_PIX_FMT_IPU3_SRGGB10
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  Documentation/media/uapi/v4l/pixfmt-rgb.rst        |  1 +
>  .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         | 61 ++++++++++++++++++++++
>  2 files changed, 62 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> index b0f3513..6900d5c 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
> @@ -16,5 +16,6 @@ RGB Formats
>      pixfmt-srggb10p
>      pixfmt-srggb10alaw8
>      pixfmt-srggb10dpcm8
> +    pixfmt-srggb10-ipu3
>      pixfmt-srggb12
>      pixfmt-srggb16
> diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> new file mode 100644
> index 0000000..8a82f30
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> @@ -0,0 +1,61 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _V4L2_PIX_FMT_IPU3_SBGGR10:
> +.. _V4L2_PIX_FMT_IPU3_SGBRG10:
> +.. _V4L2_PIX_FMT_IPU3_SGRBG10:
> +.. _V4L2_PIX_FMT_IPU3_SRGGB10:
> +
> +**********************************************************************************************************************************************
> +V4L2_PIX_FMT_IPU3_SBGGR10 ('ip3b'), V4L2_PIX_FMT_IPU3_SGBRG10 ('ip3g'), V4L2_PIX_FMT_IPU3_SGRBG10 ('ip3G'), V4L2_PIX_FMT_IPU3_SRGGB10 ('ip3r')
> +**********************************************************************************************************************************************
> +
> +10-bit Bayer formats
> +
> +Description
> +===========
> +
> +These four pixel formats are raw sRGB / Bayer formats with 10 bits per
> +sample with every 25 pixels packed to 32 bytes leaving 6 most significant 
> +bits padding in the last byte. The format is little endian.
> +
> +In other respects this format is similar to :ref:`V4L2-PIX-FMT-SRGGB10`.
> +
> +**Byte Order.**
> +Each cell is one byte.
> +
> +.. raw:: latex
> +
> +    \newline\newline\begin{adjustbox}{width=\columnwidth}
> +
> +.. tabularcolumns:: |p{1.3cm}|p{1.0cm}|p{10.9cm}|p{10.9cm}|p{10.9cm}|p{1.0cm}|
> +
> +.. flat-table::
> +
> +    * - start + 0:
> +      - B\ :sub:`00low`
> +      - G\ :sub:`01low` \ (bits 7--2) B\ :sub:`00high`\ (bits 1--0)
> +      - B\ :sub:`02low` \ (bits 7--4) G\ :sub:`01high`\ (bits 3--0)
> +      - G\ :sub:`03low` \ (bits 7--6) B\ :sub:`02high`\ (bits 5--0)
> +      - G\ :sub:`03high`
> +    * - start + 5:
> +      - G\ :sub:`10low`
> +      - R\ :sub:`11low` \ (bits 7--2) G\ :sub:`10high`\ (bits 1--0)
> +      - G\ :sub:`12low` \ (bits 7--4) R\ :sub:`11high`\ (bits 3--0)
> +      - R\ :sub:`13low` \ (bits 7--6) G\ :sub:`12high`\ (bits 5--0)
> +      - R\ :sub:`13high`
> +    * - start + 10:
> +      - B\ :sub:`20low`
> +      - G\ :sub:`21low` \ (bits 7--2) B\ :sub:`20high`\ (bits 1--0)
> +      - B\ :sub:`22low` \ (bits 7--4) G\ :sub:`21high`\ (bits 3--0)
> +      - G\ :sub:`23low` \ (bits 7--6) B\ :sub:`22high`\ (bits 5--0)
> +      - G\ :sub:`23high`
> +    * - start + 15:
> +      - G\ :sub:`30low`
> +      - R\ :sub:`31low` \ (bits 7--2) G\ :sub:`30high`\ (bits 1--0)
> +      - G\ :sub:`32low` \ (bits 7--4) R\ :sub:`31high`\ (bits 3--0)
> +      - R\ :sub:`33low` \ (bits 7--6) G\ :sub:`32high`\ (bits 5--0)
> +      - R\ :sub:`33high`

Could you extend the example a bit, so that it includes the end of the
current and the beginning of the next 25-pixel (32 byte) chunk? Perhaps a
4x8 or a 8x4 pixel image?

> +
> +.. raw:: latex
> +
> +    \end{adjustbox}\newline\newline

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
