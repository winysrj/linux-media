Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38646 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdGVSwl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 14:52:41 -0400
Subject: Re: [PATCH] [media] imx: add VIDEO_V4L2_SUBDEV_API dependency
To: Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20170721162144.3339864-1-arnd@arndb.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <eb12f9cd-46f6-47ae-0306-6d7a6efaa56d@gmail.com>
Date: Sat, 22 Jul 2017 11:52:38 -0700
MIME-Version: 1.0
In-Reply-To: <20170721162144.3339864-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>

On 07/21/2017 09:21 AM, Arnd Bergmann wrote:
> Without this, I get a build error:
> 
> drivers/staging/media/imx/imx-media-vdic.c: In function '__vdic_get_fmt':
> drivers/staging/media/imx/imx-media-vdic.c:554:10: error: implicit declaration of function 'v4l2_subdev_get_try_format'; did you mean 'v4l2_subdev_notify_event'? [-Werror=implicit-function-declaration]
> 
> Fixes: e130291212df ("[media] media: Add i.MX media core driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/staging/media/imx/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
> index 7eff50bcea39..719508fcb0e9 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -1,6 +1,7 @@
>   config VIDEO_IMX_MEDIA
>   	tristate "i.MX5/6 V4L2 media core driver"
>   	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
> +	depends on VIDEO_V4L2_SUBDEV_API
>   	select V4L2_FWNODE
>   	---help---
>   	  Say yes here to enable support for video4linux media controller
> 
