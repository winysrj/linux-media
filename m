Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35537 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752744AbdHNXPx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 19:15:53 -0400
Subject: Re: [PATCH] [media] staging/imx: always select VIDEOBUF2_DMA_CONTIG
To: Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20170807104929.3651892-1-arnd@arndb.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <09143fe9-7034-4bd0-eb7b-9c896f7acf30@gmail.com>
Date: Mon, 14 Aug 2017 16:15:50 -0700
MIME-Version: 1.0
In-Reply-To: <20170807104929.3651892-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks,

Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Steve

On 08/07/2017 03:49 AM, Arnd Bergmann wrote:
> I ran into a rare build error during randconfig testing:
>
> drivers/staging/media/imx/imx-media-capture.o: In function `capture_stop_streaming':
> imx-media-capture.c:(.text+0x224): undefined reference to `vb2_buffer_done'
> drivers/staging/media/imx/imx-media-capture.o: In function `imx_media_capture_device_register':
> imx-media-capture.c:(.text+0xe60): undefined reference to `vb2_queue_init'
> imx-media-capture.c:(.text+0xfa0): undefined reference to `vb2_dma_contig_memops'
>
> While VIDEOBUF2_DMA_CONTIG was already selected by the camera driver,
> it wasn't necessarily there with just the base driver enabled.
> This moves the 'select' statement to the top-level option to make
> sure it's always available.
>
> Fixes: 64b5a49df486 ("[media] media: imx: Add Capture Device Interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/staging/media/imx/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
> index 719508fcb0e9..2be921cd0d55 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -2,6 +2,7 @@ config VIDEO_IMX_MEDIA
>   	tristate "i.MX5/6 V4L2 media core driver"
>   	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
>   	depends on VIDEO_V4L2_SUBDEV_API
> +	select VIDEOBUF2_DMA_CONTIG
>   	select V4L2_FWNODE
>   	---help---
>   	  Say yes here to enable support for video4linux media controller
> @@ -13,7 +14,6 @@ menu "i.MX5/6 Media Sub devices"
>   config VIDEO_IMX_CSI
>   	tristate "i.MX5/6 Camera Sensor Interface driver"
>   	depends on VIDEO_IMX_MEDIA && VIDEO_DEV && I2C
> -	select VIDEOBUF2_DMA_CONTIG
>   	default y
>   	---help---
>   	  A video4linux camera sensor interface driver for i.MX5/6.
