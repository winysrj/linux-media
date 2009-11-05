Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2434 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbZKEOp2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 09:45:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 4/9] v4l: Add a 10-bit monochrome and missing 8- and 10-bit Bayer fourcc codes
Date: Thu, 5 Nov 2009 15:45:27 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange> <Pine.LNX.4.64.0910301405590.4378@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910301405590.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051545.27931.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 30 October 2009 15:01:14 Guennadi Liakhovetski wrote:
> The 16-bit monochrome fourcc code has been previously abused for a 10-bit
> format, add a new 10-bit code instead. Also add missing 8- and 10-bit Bayer
> fourcc codes for completeness.

I'm fairly certain that you also have to document these new formats in the
DocBook documentation. Run 'make spec' to verify this.

Regards,

	Hans

> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/linux/videodev2.h |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index b59e78c..9b240d5 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -294,6 +294,7 @@ struct v4l2_pix_format {
>  
>  /* Grey formats */
>  #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Greyscale     */
> +#define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
>  #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
>  
>  /* Palette formats */
> @@ -329,7 +330,11 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
>  #define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
>  #define V4L2_PIX_FMT_SGRBG8  v4l2_fourcc('G', 'R', 'B', 'G') /*  8  GRGR.. BGBG.. */
> -#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10bit raw bayer */
> +#define V4L2_PIX_FMT_SRGGB8  v4l2_fourcc('R', 'G', 'G', 'B') /*  8  RGRG.. GBGB.. */
> +#define V4L2_PIX_FMT_SBGGR10 v4l2_fourcc('B', 'G', '1', '0') /* 10  BGBG.. GRGR.. */
> +#define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0') /* 10  GBGB.. RGRG.. */
> +#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10  GRGR.. BGBG.. */
> +#define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0') /* 10  RGRG.. GBGB.. */
>  	/* 10bit raw bayer DPCM compressed to 8 bits */
>  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
>  	/*



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
