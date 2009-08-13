Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43425 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756003AbZHMUCa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 16:02:30 -0400
Date: Thu, 13 Aug 2009 22:02:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC][PATCH] v4l2: Add other RAW Bayer 10bit component orders
In-Reply-To: <A24693684029E5489D1D202277BE89444A7839B7@dlee02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0908132155370.4836@axis700.grange>
References: <A24693684029E5489D1D202277BE89444A7839B7@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 13 Aug 2009, Aguirre Rodriguez, Sergio Alberto wrote:

> From: Sergio Aguirre <saaguirre@ti.com>
> 
> This helps clarifying different pattern orders for RAW Bayer 10 bit
> cases.
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  include/linux/videodev2.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 9e66c50..8aa6255 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -327,6 +327,9 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0')
>  /* 10bit raw bayer DPCM compressed to 8 bits */
>  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> +#define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0')
> +#define V4L2_PIX_FMT_SBGGR10 v4l2_fourcc('B', 'G', '1', '0')
> +#define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0')
>  #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */

To be honest, I don't have a clear picture of all available fourcc formats 
and what exactly they mean, including Bayer codes. But - I suspect, these 
are uncompressed formats, right? i.e., also extended to 16 bits? So, 
shouldn't your additional formats go a couple lines higher in the file 
after

/*
 * 10bit raw bayer, expanded to 16 bits
 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
 */
#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0')

And besides, the above comment seems not quite correct - there should be 6 
'x' bits in each colour instead of 4, shouldn't there? You might want to 
fix this while at it. And also please comment your formats with colour 
order, however "obvious" they are:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
