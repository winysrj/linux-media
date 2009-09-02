Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55755 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZIBNbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2009 09:31:14 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
Date: Wed, 2 Sep 2009 08:35:04 -0500
Subject: RE: [PATCH 1/3] v4l: Add a 10-bit monochrome and missing 8- and
 10-bit Bayer fourcc codes
Message-ID: <A24693684029E5489D1D202277BE89444BFBAF90@dlee02.ent.ti.com>
References: <Pine.LNX.4.64.0909021416520.6326@axis700.grange>
 <Pine.LNX.4.64.0909021429000.6326@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909021429000.6326@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



From: linux-media-owner@vger.kernel.org [mailto:linux-media-
owner@vger.kernel.org] On Behalf Of Guennadi Liakhovetski
Sent: Wednesday, September 02, 2009 7:34 AM
> 
> The 16-bit monochrome fourcc code has been previously abused for a 10-bit
> format, add a new 10-bit code instead. Also add missing 8- and 10-bit
> Bayer
> fourcc codes for completeness.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Indeed, this is not directly related to the image-bus API, but I'd like to
> have these codes available for completeness and also to stop abusing
> 16-bit codes for 10-bit formats.
> 
>  include/linux/videodev2.h |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 9d9a615..ffea559 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -293,6 +293,7 @@ struct v4l2_pix_format {
> 
>  /* Grey formats */
>  #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8
> Greyscale     */
> +#define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10
> Greyscale     */
>  #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16
> Greyscale     */
> 
>  /* Palette formats */
> @@ -328,7 +329,11 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8
> BGBG.. GRGR.. */
>  #define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G', 'B', 'R', 'G') /*  8
> GBGB.. RGRG.. */
>  #define V4L2_PIX_FMT_SGRBG8  v4l2_fourcc('G', 'R', 'B', 'G') /*  8
> GRGR.. BGBG.. */
> -#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10bit raw
> bayer */
> +#define V4L2_PIX_FMT_SRGGB8  v4l2_fourcc('R', 'G', 'G', 'B') /*  8
> RGRG.. GBGB.. */
> +#define V4L2_PIX_FMT_SBGGR10 v4l2_fourcc('B', 'G', '1', '0') /* 10
> BGBG.. GRGR.. */
> +#define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0') /* 10
> GBGB.. RGRG.. */
> +#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10
> GRGR.. BGBG.. */
> +#define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0') /* 10
> RGRG.. GBGB.. */

I tried adding these same RAW Bayer 10-bit codes, but I missed documentation changes. (Perhaphs you should do the same)

Actually, you responded on that thread :)
	http://www.spinics.net/lists/linux-media/msg08882.html

I had to postpone that patch, since I'm currently being dragged to some internal high priority issues. But if you can do it, I'm ok with that :)

Regards,
Sergio

>  	/* 10bit raw bayer DPCM compressed to 8 bits */
>  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
>  	/*
> --
> 1.6.2.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

