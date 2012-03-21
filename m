Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38472 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2CUMIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 08:08:10 -0400
Received: by obbeh20 with SMTP id eh20so666112obb.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 05:08:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332330278-349-1-git-send-email-sakari.ailus@iki.fi>
References: <CA+V-a8uNqKERJd-vvBCw0GLgDuFcC_5seXZ9pdf_eN1xyC_xZA@mail.gmail.com>
	<1332330278-349-1-git-send-email-sakari.ailus@iki.fi>
Date: Wed, 21 Mar 2012 17:38:09 +0530
Message-ID: <CA+V-a8swyp3X2noQQ2+P2ViK2t49ar_dwUWDp4sGjeqHyzQoYA@mail.gmail.com>
Subject: Re: [PATCH v5.5 14/40] v4l: Add DPCM compressed raw bayer pixel formats
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 21, 2012 at 5:14 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> Add three other colour orders for 10-bit to 8-bit DPCM compressed raw
> bayer
> pixel formats.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
> ---
>  Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
>  .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   29
> ++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
>  include/linux/videodev2.h                          |    3 ++
>  4 files changed, 34 insertions(+), 1 deletions(-)
>  create mode 100644
> Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> index 7b27409..c1c62a9 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> @@ -1,4 +1,4 @@
> -    <refentry>
> +    <refentry id="pixfmt-srggb10">
>       <refmeta>
>        <refentrytitle>V4L2_PIX_FMT_SRGGB10 ('RG10'),
>         V4L2_PIX_FMT_SGRBG10 ('BA10'),
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> new file mode 100644
> index 0000000..5b2b03c
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> @@ -0,0 +1,29 @@
> +    <refentry>
> +      <refmeta>
> +       <refentrytitle>
> +        V4L2_PIX_FMT_SBGGR10DPCM8 ('bBA8'),
> +        V4L2_PIX_FMT_SGBRG10DPCM8 ('bGA8'),
> +        V4L2_PIX_FMT_SGRBG10DPCM8 ('BD10'),
> +        V4L2_PIX_FMT_SRGGB10DPCM8 ('bRA8'),
> +        </refentrytitle>
> +       &manvol;
> +      </refmeta>
> +      <refnamediv>
> +       <refname
> id="V4L2-PIX-FMT-SBGGR10DPCM8"><constant>V4L2_PIX_FMT_SBGGR10DPCM8</constant></refname>
> +       <refname
> id="V4L2-PIX-FMT-SGBRG10DPCM8"><constant>V4L2_PIX_FMT_SGBRG10DPCM8</constant></refname>
> +       <refname
> id="V4L2-PIX-FMT-SGRBG10DPCM8"><constant>V4L2_PIX_FMT_SGRBG10DPCM8</constant></refname>
> +       <refname
> id="V4L2-PIX-FMT-SRGGB10DPCM8"><constant>V4L2_PIX_FMT_SRGGB10DPCM8</constant></refname>
> +       <refpurpose>10-bit Bayer formats compressed to 8 bits</refpurpose>
> +      </refnamediv>
> +      <refsect1>
> +       <title>Description</title>
> +
> +       <para>The following four pixel formats are raw sRGB / Bayer
> formats
> +       with 10 bits per colour compressed to 8 bits each, using DPCM
> +       compression. DPCM, differential pulse-code modulation, is lossy.
> +       Each colour component consumes 8 bits of memory. In other respects
> +       this format is similar to <xref
> +       linkend="pixfmt-srggb10">.</xref></para>
> +
> +      </refsect1>
> +    </refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml
> b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 31eaae2..74d4fcd 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -673,6 +673,7 @@ access the palette, this must be done with ioctls of
> the Linux framebuffer API.<
>     &sub-srggb8;
>     &sub-sbggr16;
>     &sub-srggb10;
> +    &sub-srggb10dpcm8;
>     &sub-srggb12;
>   </section>
>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 0805259..dbc0d77 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -378,7 +378,10 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12
>  GRGR.. BGBG.. */
>  #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12
>  RGRG.. GBGB.. */
>        /* 10bit raw bayer DPCM compressed to 8 bits */
> +#define V4L2_PIX_FMT_SBGGR10DPCM8 v4l2_fourcc('b', 'B', 'A', '8')
> +#define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('b', 'G', 'A', '8')
>  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> +#define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('b', 'R', 'A', '8')
>        /*
>         * 10bit raw bayer, expanded to 16 bits
>         * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
> --
> 1.7.2.5
>
