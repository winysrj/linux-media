Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:45172 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab0FOGhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jun 2010 02:37:14 -0400
Message-ID: <4C171F8C.9040004@maxwell.research.nokia.com>
Date: Tue, 15 Jun 2010 09:37:00 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add 12 bit RAW Bayer Pattern pixel format support in
 V4L2
References: <33AB447FBD802F4E932063B962385B351E895A6A@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351E895A6A@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zhang, Xiaolin wrote:
> From 54079deb89764a9399c95098e4c3830c88d24a5c Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Tue, 18 May 2010 18:02:24 +0800
> Subject: [PATCH] Add 12 bit RAW Bayer Pattern pixel format support.

Hi Xiaolin,

> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> ---
>  Documentation/DocBook/v4l/videodev2.h.xml |   10 +++++++++-
>  include/linux/videodev2.h                 |    4 ++++
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
> index 0683259..649ef9e 100644
> --- a/Documentation/DocBook/v4l/videodev2.h.xml
> +++ b/Documentation/DocBook/v4l/videodev2.h.xml
> @@ -330,7 +330,15 @@ struct <link linkend="v4l2-pix-format">v4l2_pix_format</link> {
>  #define <link linkend="V4L2-PIX-FMT-SBGGR8">V4L2_PIX_FMT_SBGGR8</link>  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
>  #define <link linkend="V4L2-PIX-FMT-SGBRG8">V4L2_PIX_FMT_SGBRG8</link>  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
>  #define <link linkend="V4L2-PIX-FMT-SGRBG8">V4L2_PIX_FMT_SGRBG8</link>  v4l2_fourcc('G', 'R', 'B', 'G') /*  8  GRGR.. BGBG.. */
> -#define <link linkend="V4L2-PIX-FMT-SGRBG10">V4L2_PIX_FMT_SGRBG10</link> v4l2_fourcc('B', 'A', '1', '0') /* 10bit raw bayer */
> +#define <link linkend="V4L2-PIX-FMT-SGRBG8">V4L2_PIX_FMT_SRGGB8</link>  v4l2_fourcc('R', 'G', 'G', 'B') /*  8  RGRG.. GBGB.. */
> +#define <link linkend="V4L2-PIX-FMT-SBGGR10">V4L2_PIX_FMT_SBGGR10</link>  v4l2_fourcc('B', 'G', '1', '0') /*  10  BGBG.. GRGR.. */
> +#define <link linkend="V4L2-PIX-FMT-SGBRG10">V4L2_PIX_FMT_SGBRG10</link>  v4l2_fourcc('G', 'B', '1', '0') /*  10  GBGB.. RGRG.. */
> +#define <link linkend="V4L2-PIX-FMT-SGRBG10">V4L2_PIX_FMT_SGRBG10</link>  v4l2_fourcc('B', 'A', '1', '0') /*  10  GRGR.. BGBG.. */
> +#define <link linkend="V4L2-PIX-FMT-SGRBG10">V4L2_PIX_FMT_SRGGB10</link>  v4l2_fourcc('R', 'G', '1', '0') /*  10  RGRG.. GBGB.. */
> +#define <link linkend="V4L2-PIX-FMT-SBGGR12">V4L2_PIX_FMT_SBGGR12</link>  v4l2_fourcc('B', 'G', '1', '2') /*  12  BGBG.. GRGR.. */
> +#define <link linkend="V4L2-PIX-FMT-SGBRG12">V4L2_PIX_FMT_SGBRG12</link>  v4l2_fourcc('G', 'B', '1', '2') /*  12  GBGB.. RGRG.. */
> +#define <link linkend="V4L2-PIX-FMT-SGRBG12">V4L2_PIX_FMT_SGRBG12</link>  v4l2_fourcc('B', 'A', '1', '2') /*  12  GRGR.. BGBG.. */
> +#define <link linkend="V4L2-PIX-FMT-SGRBG12">V4L2_PIX_FMT_SRGGB12</link>  v4l2_fourcc('R', 'G', '1', '2') /*  12  RGRG.. GBGB.. */
>          /* 10bit raw bayer DPCM compressed to 8 bits */
>  #define <link linkend="V4L2-PIX-FMT-SGRBG10DPCM8">V4L2_PIX_FMT_SGRBG10DPCM8</link> v4l2_fourcc('B', 'D', '1', '0')
>          /*

How about arranging the 12 bit modes after the 10 bit ones?

> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 3793d16..202092a 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -335,6 +335,10 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0') /* 10  GBGB.. RGRG.. */
>  #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10  GRGR.. BGBG.. */
>  #define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0') /* 10  RGRG.. GBGB.. */
> +#define V4L2_PIX_FMT_SBGGR12 v4l2_fourcc('B', 'G', '1', '2') /* 12  BGBG.. GRGR.. */
> +#define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
> +#define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
> +#define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
>  	/* 10bit raw bayer DPCM compressed to 8 bits */
>  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
>  	/*

Same here.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
