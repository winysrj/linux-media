Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40553
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934973AbcIFRG7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 13:06:59 -0400
Date: Tue, 6 Sep 2016 14:06:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 2/4] v4l: Define a pixel format for the R-Car VSP1
 1-D histogram engine
Message-ID: <20160906140651.214e6f01@vento.lan>
In-Reply-To: <1471436430-26245-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471436430-26245-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
        <1471436430-26245-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Em Wed, 17 Aug 2016 15:20:28 +0300
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> The format is used on the R-Car VSP1 video queues that carry
> 1-D histogram statistics data.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Changes since v1:
> 
> - Rebased on top of the DocBook to reST conversion
> 
>  Documentation/media/uapi/v4l/meta-formats.rst      |  15 ++
>  .../media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst        | 170 +++++++++++++++++++++
>  Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
>  include/uapi/linux/videodev2.h                     |   3 +
>  5 files changed, 190 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/meta-formats.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
> 
> diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
> new file mode 100644
> index 000000000000..05ab91e12f10
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/meta-formats.rst
> @@ -0,0 +1,15 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _meta-formats:
> +
> +****************
> +Metadata Formats
> +****************
> +
> +These formats are used for the :ref:`metadata` interface only.
> +
> +
> +.. toctree::
> +    :maxdepth: 1
> +
> +    pixfmt-meta-vsp1-hgo
> diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst b/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
> new file mode 100644
> index 000000000000..e935e4525b10
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
> @@ -0,0 +1,170 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _v4l2-meta-fmt-vsp1-hgo:
> +
> +*******************************
> +V4L2_META_FMT_VSP1_HGO ('VSPH')
> +*******************************
> +
> +*man V4L2_META_FMT_VSP1_HGO(2)*

Just remove it. This is some trash that came from the conversions.
I have a set of patches removing it on the existing man pages.

> +
> +Renesas R-Car VSP1 1-D Histogram Data
> +
> +
> +Description
> +===========
> +
> +This format describes histogram data generated by the Renesas R-Car VSP1 1-D
> +Histogram (HGO) engine.
> +
> +The VSP1 HGO is a histogram computation engine that can operate on RGB, YCrCb
> +or HSV data. It operates on a possibly cropped and subsampled input image and
> +computes the minimum, maximum and sum of all pixels as well as per-channel
> +histograms.
> +
> +The HGO can compute histograms independently per channel, on the maximum of the
> +three channels (RGB data only) or on the Y channel only (YCbCr only). It can
> +additionally output the histogram with 64 or 256 bins, resulting in four
> +possible modes of operation.
> +
> +- In *64 bins normal mode*, the HGO operates on the three channels independently
> +  to compute three 64-bins histograms. RGB, YCbCr and HSV image formats are
> +  supported.
> +- In *64 bins maximum mode*, the HGO operates on the maximum of the (R, G, B)
> +  channels to compute a single 64-bins histogram. Only the RGB image format is
> +  supported.
> +- In *256 bins normal mode*, the HGO operates on the Y channel to compute a
> +  single 256-bins histogram. Only the YCbCr image format is supported.
> +- In *256 bins maximum mode*, the HGO operates on the maximum of the (R, G, B)
> +  channels to compute a single 256-bins histogram. Only the RGB image format is
> +  supported.

As they all share the same FOURCC format, according with the documentation,
how the user is supposed to switch between those modes? Or is it depend on
the video format? In any case, please add some explanation, and cross-refs
if needed.

> +
> +**Byte Order.**
> +All data is stored in memory in little endian format. Each cell in the tables
> +contains one byte.
> +
> +.. flat-table:: VSP1 HGO Data - 64 Bins, Normal Mode (792 bytes)
> +    :header-rows:  2
> +    :stub-columns: 0
> +
> +    * - Offset
> +      - :cspan:`4` Memory
> +    * -
> +      - [31:24]
> +      - [23:16]
> +      - [15:8]
> +      - [7:0]
> +    * - 0
> +      - -
> +      - R/Cr/H max [7:0]
> +      - -
> +      - R/Cr/H min [7:0]
> +    * - 4
> +      - -
> +      - G/Y/S max [7:0]
> +      - -
> +      - G/Y/S min [7:0]
> +    * - 8
> +      - -
> +      - B/Cb/V max [7:0]
> +      - -
> +      - B/Cb/V min [7:0]
> +    * - 12
> +      - :cspan:`4` R/Cr/H sum [31:0]
> +    * - 16
> +      - :cspan:`4` G/Y/S sum [31:0]
> +    * - 20
> +      - :cspan:`4` B/Cb/V sum [31:0]
> +    * - 24
> +      - :cspan:`4` R/Cr/H bin 0 [31:0]
> +    * -
> +      - :cspan:`4` ...
> +    * - 276
> +      - :cspan:`4` R/Cr/H bin 63 [31:0]
> +    * - 280
> +      - :cspan:`4` G/Y/S bin 0 [31:0]
> +    * -
> +      - :cspan:`4` ...
> +    * - 532
> +      - :cspan:`4` G/Y/S bin 63 [31:0]
> +    * - 536
> +      - :cspan:`4` B/Cb/V bin 0 [31:0]
> +    * -
> +      - :cspan:`4` ...
> +    * - 788
> +      - :cspan:`4` B/Cb/V bin 63 [31:0]
> +
> +.. flat-table:: VSP1 HGO Data - 64 Bins, Max Mode (264 bytes)
> +    :header-rows:  2
> +    :stub-columns: 0
> +
> +    * - Offset
> +      - :cspan:`4` Memory
> +    * -
> +      - [31:24]
> +      - [23:16]
> +      - [15:8]
> +      - [7:0]
> +    * - 0
> +      - -
> +      - max(R,G,B) max [7:0]
> +      - -
> +      - max(R,G,B) min [7:0]
> +    * - 4
> +      - :cspan:`4` max(R,G,B) sum [31:0]
> +    * - 8
> +      - :cspan:`4` max(R,G,B) bin 0 [31:0]
> +    * -
> +      - :cspan:`4` ...
> +    * - 260
> +      - :cspan:`4` max(R,G,B) bin 63 [31:0]
> +
> +.. flat-table:: VSP1 HGO Data - 256 Bins, Normal Mode (1032 bytes)
> +    :header-rows:  2
> +    :stub-columns: 0
> +
> +    * - Offset
> +      - :cspan:`4` Memory
> +    * -
> +      - [31:24]
> +      - [23:16]
> +      - [15:8]
> +      - [7:0]
> +    * - 0
> +      - -
> +      - Y max [7:0]
> +      - -
> +      - Y min [7:0]
> +    * - 4
> +      - :cspan:`4` Y sum [31:0]
> +    * - 8
> +      - :cspan:`4` Y bin 0 [31:0]
> +    * -
> +      - :cspan:`4` ...
> +    * - 1028
> +      - :cspan:`4` Y bin 255 [31:0]
> +
> +.. flat-table:: VSP1 HGO Data - 256 Bins, Max Mode (1032 bytes)
> +    :header-rows:  2
> +    :stub-columns: 0
> +
> +    * - Offset
> +      - :cspan:`4` Memory
> +    * -
> +      - [31:24]
> +      - [23:16]
> +      - [15:8]
> +      - [7:0]
> +    * - 0
> +      - -
> +      - max(R,G,B) max [7:0]
> +      - -
> +      - max(R,G,B) min [7:0]
> +    * - 4
> +      - :cspan:`4` max(R,G,B) sum [31:0]
> +    * - 8
> +      - :cspan:`4` max(R,G,B) bin 0 [31:0]
> +    * -
> +      - :cspan:`4` ...
> +    * - 1028
> +      - :cspan:`4` max(R,G,B) bin 255 [31:0]
> diff --git a/Documentation/media/uapi/v4l/pixfmt.rst b/Documentation/media/uapi/v4l/pixfmt.rst
> index 81222a99f7ce..e3738a2eb05f 100644
> --- a/Documentation/media/uapi/v4l/pixfmt.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt.rst
> @@ -32,4 +32,5 @@ see also :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`.)
>      depth-formats
>      pixfmt-013
>      sdr-formats
> +    meta-formats
>      pixfmt-reserved
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 0afa07bfea35..8425f0b8ebfb 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1265,6 +1265,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
>  	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
>  	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
> +	case V4L2_META_FMT_VSP1_HGO:	descr = "R-Car VSP1 1-D Histogram"; break;
>  
>  	default:
>  		/* Compressed formats */
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index d1ac0250a966..05b97c2067d4 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -637,6 +637,9 @@ struct v4l2_pix_format {
>  #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
>  #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
>  
> +/* Meta-data formats */
> +#define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car VSP1 Histogram */
> +
>  /* priv field value to indicates that subsequent fields are valid. */
>  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
>  



Thanks,
Mauro
