Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40807 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2APOBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 09:01:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 09/23] v4l: Add DPCM compressed formats
Date: Mon, 16 Jan 2012 15:01:50 +0100
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
References: <4F0DFE92.80102@iki.fi> <1326317220-15339-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1326317220-15339-9-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161501.51287.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Wednesday 11 January 2012 22:26:46 Sakari Ailus wrote:
> Add three other colour orders for 10-bit to 8-bit DPCM compressed formats.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
>  .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   29
> ++++++++++++++++++++ Documentation/DocBook/media/v4l/pixfmt.xml         | 
>   1 +
>  include/linux/videodev2.h                          |    3 ++
>  4 files changed, 34 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml index
> 7b27409..c1c62a9 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> @@ -1,4 +1,4 @@
> -    <refentry>
> +    <refentry id="pixfmt-srggb10">
>        <refmeta>
>  	<refentrytitle>V4L2_PIX_FMT_SRGGB10 ('RG10'),
>  	 V4L2_PIX_FMT_SGRBG10 ('BA10'),
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml new file mode
> 100644
> index 0000000..985440c
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> @@ -0,0 +1,29 @@
> +    <refentry>
> +      <refmeta>
> +	<refentrytitle>
> +	 V4L2_PIX_FMT_SRGGB10DPCM8 ('bBA8'),
> +	 V4L2_PIX_FMT_SGBRG10DPCM8 ('bGA8'),
> +	 V4L2_PIX_FMT_SGRBG10DPCM8 ('BD10'),
> +	 V4L2_PIX_FMT_SBGGR10DPCM8 ('bRA8'),

Could you briefly explain the rationale behind the FOURCCs in the patch commit 
message ? Manjunath needs similar FOURCCs for A-law compression, what should 
he use ?

> +	 </refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +	<refname
> id="V4L2-PIX-FMT-SRGGB10DPCM8"><constant>V4L2_PIX_FMT_SRGGB10DPCM8</consta
> nt></refname> +	<refname
> id="V4L2-PIX-FMT-SGRBG10DPCM8"><constant>V4L2_PIX_FMT_SGRBG10DPCM8</consta
> nt></refname> +	<refname
> id="V4L2-PIX-FMT-SGBRG10DPCM8"><constant>V4L2_PIX_FMT_SGBRG10DPCM8</consta
> nt></refname> +	<refname
> id="V4L2-PIX-FMT-SBGGR10DPCM8"><constant>V4L2_PIX_FMT_SBGGR10DPCM8</consta
> nt></refname> +	<refpurpose>10-bit Bayer formats compressed to 8
> bits</refpurpose> +      </refnamediv>
> +      <refsect1>
> +	<title>Description</title>
> +
> +	<para>The following four pixel formats are raw sRGB / Bayer
> +	formats with 10 bits per colour compressed to 8 bits each,
> +	using the DPCM. DPCM, differential pulse-code modulation, is

s/the DPCM/DPCM/ ?

> +	lossy. Each colour component consumes 8 bits of memory. In
> +	other respects this format is similar to
> +	<xref linkend="pixfmt-srggb10">.</xref></para>
> +
> +      </refsect1>
> +    </refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml
> b/Documentation/DocBook/media/v4l/pixfmt.xml index 2ff6b77..9b06c7b 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -673,6 +673,7 @@ access the palette, this must be done with ioctls of
> the Linux framebuffer API.< &sub-srggb8;
>      &sub-sbggr16;
>      &sub-srggb10;
> +    &sub-srggb10dpcm8;
>      &sub-srggb12;
>    </section>
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index c9d07c7..c5bf1db 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -365,7 +365,10 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR..
> BGBG.. */ #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /*
> 12  RGRG.. GBGB.. */ /* 10bit raw bayer DPCM compressed to 8 bits */
> +#define V4L2_PIX_FMT_SBGGR10DPCM8 v4l2_fourcc('b', 'B', 'A', '8')
> +#define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('b', 'G', 'A', '8')
>  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> +#define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('b', 'R', 'A', '8')
>  	/*
>  	 * 10bit raw bayer, expanded to 16 bits
>  	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...

-- 
Regards,

Laurent Pinchart
