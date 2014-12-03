Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33756 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLCMvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 07:51:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/3] Add YUV8_1X24 media bus format
Date: Wed, 03 Dec 2014 14:51:49 +0200
Message-ID: <1452926.3Sn5YqOv4B@avalon>
In-Reply-To: <1417602500-29152-2-git-send-email-p.zabel@pengutronix.de>
References: <1417602500-29152-1-git-send-email-p.zabel@pengutronix.de> <1417602500-29152-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Wednesday 03 December 2014 11:28:19 Philipp Zabel wrote:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 37 +++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |  3 +-
>  2 files changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
> b/Documentation/DocBook/media/v4l/subdev-formats.xml index f163767..9afb846
> 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -2933,6 +2933,43 @@
>  	      <entry>u<subscript>1</subscript></entry>
>  	      <entry>u<subscript>0</subscript></entry>
>  	    </row>
> +	    <row id="MEDIA-BUS-FMT-YUV8-1X24">
> +	      <entry>MEDIA_BUS_FMT_YUV8_1X24</entry>
> +	      <entry>0x2024</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	    </row>
>  	    <row id="MEDIA-BUS-FMT-YUV10-1X30">
>  	      <entry>MEDIA_BUS_FMT_YUV10_1X30</entry>
>  	      <entry>0x2016</entry>
> diff --git a/include/uapi/linux/media-bus-format.h
> b/include/uapi/linux/media-bus-format.h index 6d7f0c7..977316e 100644
> --- a/include/uapi/linux/media-bus-format.h
> +++ b/include/uapi/linux/media-bus-format.h
> @@ -55,7 +55,7 @@
>  #define MEDIA_BUS_FMT_RGB888_LVDS_JEIDA		0x1012
>  #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
> 
> -/* YUV (including grey) - next is	0x2024 */
> +/* YUV (including grey) - next is	0x2025 */
>  #define MEDIA_BUS_FMT_Y8_1X8			0x2001
>  #define MEDIA_BUS_FMT_UV8_1X8			0x2015
>  #define MEDIA_BUS_FMT_UYVY8_1_5X8		0x2002
> @@ -81,6 +81,7 @@
>  #define MEDIA_BUS_FMT_VYUY10_1X20		0x201b
>  #define MEDIA_BUS_FMT_YUYV10_1X20		0x200d
>  #define MEDIA_BUS_FMT_YVYU10_1X20		0x200e
> +#define MEDIA_BUS_FMT_YUV8_1X24			0x2024
>  #define MEDIA_BUS_FMT_YUV10_1X30		0x2016
>  #define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
>  #define MEDIA_BUS_FMT_UYVY12_2X12		0x201c

-- 
Regards,

Laurent Pinchart

