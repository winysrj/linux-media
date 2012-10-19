Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59328 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2JSNY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 09:24:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?ISO-8859-1?Q?Beno=EEt_Th=E9baudeau?=
	<benoit.thebaudeau@advansee.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Christoph Fritz <chf.fritz@googlemail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Alex Gershgorin <alexg@meprolight.com>,
	Liu Ying <Ying.Liu@freescale.com>
Subject: Re: [RFC] media: mx3: Add support for missing video formats
Date: Fri, 19 Oct 2012 15:25:15 +0200
Message-ID: <4395759.IItbMJZE6z@avalon>
In-Reply-To: <1556117578.7042626.1350477684664.JavaMail.root@advansee.com>
References: <1556117578.7042626.1350477684664.JavaMail.root@advansee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benoît,

On Wednesday 17 October 2012 14:41:24 Benoît Thébaudeau wrote:
> Hi all,
> 
> This is an RFC for a patch completing full video capture support on i.MX3x.
> 
> It adds missing video formats and automatic format associations according to
> the underlying sensor capabilities.
> 
> It also fixes a spurious IPU interrupt issue that I have encountered on
> i.MX31 with earlier kernel versions. This might already have been fixed by
> some of the changes that occurred in the IPU driver since then, but I still
> have to test if my fix is still useful or not. Anyway, this should of
> course be split away to a separate patch.
> 
> This patch has been successfully tested with i.MX35 and MT9M131, as well as
> some not yet mainline OmniVision sensor drivers, using all
> sensor-and-SoC-supported formats.
> 
> This patch still has to be rebased against the latest kernel and refactored
> in the following way:
>  1. Media formats.
>  2. IPU formats.
>  3. IPU spurious interrupt fix (if still required).
>  4. mx3_camera formats.
> 
> Comments are welcome, especially regarding possible conflicts with other IPU
> users.
> 
> Best regards,
> Benoît
> 
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: <linux-media@vger.kernel.org>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: <linux-arm-kernel@lists.infradead.org>
> Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
> ---
>  .../arch/arm/plat-mxc/include/mach/ipu.h           |   16 +-
>  .../drivers/dma/ipu/ipu_idmac.c                    |  241 ++++++++++++++---
>  .../drivers/media/video/mx3_camera.c               |  264 +++++++++++------
>  .../drivers/media/video/soc_mediabus.c             |  276 ++++++++++++-----
>  .../include/linux/v4l2-mediabus.h                  |   11 +-
>  .../include/media/soc_mediabus.h                   |   30 ++-

Could you please split this patch in 3 patches ? The first one should add the 
missing formats in include/linux/v4l2-mediabus.h, the second one in 
drivers/media/video/soc_mediabus.c and include/media/soc_mediabus.h, and the 
third one would include the mx3 changes. That will make review easier.

Please also update Documentation/DocBook/media/v4l/subdev-formats.xml with a 
description of the new media bus formats.

>  6 files changed, 626 insertions(+), 212 deletions(-)

[snip]

> diff --git linux-3.4.5.orig/include/linux/v4l2-mediabus.h
> linux-3.4.5/include/linux/v4l2-mediabus.h index 5ea7f75..57a9fc9 100644
> --- linux-3.4.5.orig/include/linux/v4l2-mediabus.h
> +++ linux-3.4.5/include/linux/v4l2-mediabus.h
> @@ -37,7 +37,8 @@
>  enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_FIXED = 0x0001,
> 
> -	/* RGB - next is 0x1009 */
> +	/* RGB - next is 0x100c */
> +	V4L2_MBUS_FMT_RGB332_1X8 = 0x1009,
>  	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
>  	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
>  	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
> @@ -46,8 +47,10 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_BGR565_2X8_LE = 0x1006,
>  	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
>  	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
> +	V4L2_MBUS_FMT_RGB24_3X8_BE = 0x100a,
> +	V4L2_MBUS_FMT_RGB24_3X8_LE = 0x100b,

I think I would call those V4L2_MBUS_FMT_RGB24_3X8 and V4L2_MBUS_FMT_BGR24_3X8 
instead.

> -	/* YUV (including grey) - next is 0x2014 */
> +	/* YUV (including grey) - next is 0x2015 */
>  	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
>  	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
>  	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
> @@ -65,10 +68,11 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_VYUY8_1X16 = 0x2010,
>  	V4L2_MBUS_FMT_YUYV8_1X16 = 0x2011,
>  	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
> +	V4L2_MBUS_FMT_Y16_1X16 = 0x2014,
>  	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
>  	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
> 
> -	/* Bayer - next is 0x3015 */
> +	/* Bayer - next is 0x3016 */
>  	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
>  	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
>  	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
> @@ -89,6 +93,7 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
>  	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
>  	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
> +	V4L2_MBUS_FMT_SBGGR16_1X16 = 0x3015,

What about the other 3 Bayer patterns ?

>  	/* JPEG compressed formats - next is 0x4002 */
>  	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,

-- 
Regards,

Laurent Pinchart

