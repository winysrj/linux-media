Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:17998 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaKCSPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 13:15:12 -0500
Date: Mon, 03 Nov 2014 16:15:04 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] video: add RGB444_1X12 and RGB565_1X16 bus formats
Message-id: <20141103161504.582921ac.m.chehab@samsung.com>
In-reply-to: <1411999363-28770-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411999363-28770-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Sep 2014 16:02:40 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> escreveu:

> Add RGB444 format using a 12 bits bus and RGB565 using a 16 bits bus.
> 
> These formats will later be used by atmel-hlcdc driver.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Not sure if it is too late, but this patch were hidden somewere on my
queue... so:

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> ---
>  include/uapi/linux/v4l2-mediabus.h    | 2 ++
>  include/uapi/linux/video-bus-format.h | 4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 7b0a06c..05336d6 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -33,6 +33,8 @@ enum v4l2_mbus_pixelcode {
>  	VIDEO_BUS_TO_V4L2_MBUS(RGB888_2X12_BE),
>  	VIDEO_BUS_TO_V4L2_MBUS(RGB888_2X12_LE),
>  	VIDEO_BUS_TO_V4L2_MBUS(ARGB8888_1X32),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB444_1X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB565_1X16),
>  
>  	VIDEO_BUS_TO_V4L2_MBUS(Y8_1X8),
>  	VIDEO_BUS_TO_V4L2_MBUS(UV8_1X8),
> diff --git a/include/uapi/linux/video-bus-format.h b/include/uapi/linux/video-bus-format.h
> index 4abbd5d..f85f7ee 100644
> --- a/include/uapi/linux/video-bus-format.h
> +++ b/include/uapi/linux/video-bus-format.h
> @@ -34,7 +34,7 @@
>  enum video_bus_format {
>  	VIDEO_BUS_FMT_FIXED = 0x0001,
>  
> -	/* RGB - next is 0x100e */
> +	/* RGB - next is 0x1010 */
>  	VIDEO_BUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
>  	VIDEO_BUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
>  	VIDEO_BUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
> @@ -48,6 +48,8 @@ enum video_bus_format {
>  	VIDEO_BUS_FMT_RGB888_2X12_BE = 0x100b,
>  	VIDEO_BUS_FMT_RGB888_2X12_LE = 0x100c,
>  	VIDEO_BUS_FMT_ARGB8888_1X32 = 0x100d,
> +	VIDEO_BUS_FMT_RGB444_1X12 = 0x100e,
> +	VIDEO_BUS_FMT_RGB565_1X16 = 0x100f,
>  
>  	/* YUV (including grey) - next is 0x2024 */
>  	VIDEO_BUS_FMT_Y8_1X8 = 0x2001,
