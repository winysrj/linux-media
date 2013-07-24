Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:48257 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3GXV0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 17:26:36 -0400
Message-ID: <51F04688.6090900@gmail.com>
Date: Wed, 24 Jul 2013 23:26:32 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 3/5] v4l: Add media format codes for ARGB8888 and AYUV8888
 on 32-bit busses
References: <1374072882-14598-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1374072882-14598-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1374072882-14598-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/17/2013 04:54 PM, Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart<laurent.pinchart+renesas@ideasonboard.com>
>
> ---
>   Documentation/DocBook/media/v4l/subdev-formats.xml | 609 +++++++++------------
>   Documentation/DocBook/media_api.tmpl               |   6 +
>   include/uapi/linux/v4l2-mediabus.h                 |   6 +-
>   3 files changed, 254 insertions(+), 367 deletions(-)
>
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 0c2b1f2..9100674 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -97,31 +97,39 @@
[...]
> +	<row id="V4L2-MBUS-FMT-ARGB888-1X24">
> +	<entry>V4L2_MBUS_FMT_ARGB888_1X24</entry>

This should be V4L2_MBUS_FMT_ARGB888_1X32, right ?

Fix this correction feel free to add:

  Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>	

> +	<entry>0x100d</entry>
> +	<entry></entry>
[...]
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 6ee63d0..a960125 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -37,7 +37,7 @@
>   enum v4l2_mbus_pixelcode {
>   	V4L2_MBUS_FMT_FIXED = 0x0001,
>
> -	/* RGB - next is 0x100d */
> +	/* RGB - next is 0x100e */
>   	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
>   	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
>   	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
> @@ -50,8 +50,9 @@ enum v4l2_mbus_pixelcode {
>   	V4L2_MBUS_FMT_RGB888_1X24 = 0x100a,
>   	V4L2_MBUS_FMT_RGB888_2X12_BE = 0x100b,
>   	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
> +	V4L2_MBUS_FMT_ARGB8888_1X32 = 0x100d,
>
> -	/* YUV (including grey) - next is 0x2017 */
> +	/* YUV (including grey) - next is 0x2018 */
>   	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
>   	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
>   	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
> @@ -74,6 +75,7 @@ enum v4l2_mbus_pixelcode {
>   	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
>   	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
>   	V4L2_MBUS_FMT_YUV10_1X30 = 0x2016,
> +	V4L2_MBUS_FMT_AYUV8_1X32 = 0x2017,
>
>   	/* Bayer - next is 0x3019 */
>   	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,

Thanks,
Sylwester
