Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38125 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752061AbdHNR5t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 13:57:49 -0400
Subject: Re: [PATCH] [media] media: imx: depends on V4L2 sub-device userspace
 API
To: Cihangir Akturk <cakturk@gmail.com>
Cc: p.zabel@pengutronix.de, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1502708457-13344-1-git-send-email-cakturk@gmail.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <5ac43a35-f7ec-7ffc-3e6e-c0af8f4ac497@gmail.com>
Date: Mon, 14 Aug 2017 10:57:46 -0700
MIME-Version: 1.0
In-Reply-To: <1502708457-13344-1-git-send-email-cakturk@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akturk, this has already been fixed, see

4560cb4a0c ("media: imx: add VIDEO_V4L2_SUBDEV_API dependency").

Steve

On 08/14/2017 04:00 AM, Cihangir Akturk wrote:
> This driver uses various v4l2_subdev_get_try_*() functions provided by
> V4L2 sub-device userspace API. Current configuration of Kconfig file
> allows us to enable VIDEO_IMX_MEDIA without enabling this API. This
> breaks the build of driver.
>
> Depend on VIDEO_V4L2_SUBDEV_API to fix this issue.
>
> Signed-off-by: Cihangir Akturk <cakturk@gmail.com>
> ---
>   drivers/staging/media/imx/Kconfig | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
> index 7eff50b..d8c3890 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -1,6 +1,7 @@
>   config VIDEO_IMX_MEDIA
>   	tristate "i.MX5/6 V4L2 media core driver"
> -	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
> +	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && \
> +		ARCH_MXC && IMX_IPUV3_CORE
>   	select V4L2_FWNODE
>   	---help---
>   	  Say yes here to enable support for video4linux media controller
