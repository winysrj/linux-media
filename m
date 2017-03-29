Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:30441 "EHLO
        epoutp01.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755244AbdC2J4U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 05:56:20 -0400
Subject: Re: [PATCH RFC] [media] m5mols: add missing dependency on
 VIDEO_IR_I2C
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <42bdc11f-8202-c54c-a25c-5ac33b6bddae@samsung.com>
Date: Wed, 29 Mar 2017 11:56:08 +0200
MIME-version: 1.0
In-reply-to: <1481607848-24053-1-git-send-email-hofrat@osadl.org>
Content-type: text/plain; charset="windows-1252"; format="flowed"
Content-transfer-encoding: 7bit
References: <1481607848-24053-1-git-send-email-hofrat@osadl.org>
        <CGME20170329095611epcas1p38e8a9d321864202ce47de1d99ba578ce@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2016 06:44 AM, Nicholas Mc Guire wrote:
> The Depends on: tag in Kconfig for CONFIG_VIDEO_M5MOLS does not list
> VIDEO_IR_I2C so Kconfig displays the dependencies needed so the M-5MOLS
> driver can not be found.
>
> Fixes: commit cb7a01ac324b ("[media] move i2c files into drivers/media/i2c")
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
>
> searching for VIDEO_M5MOLS in menuconfig currently shows the following
> dependencies
>  Depends on: MEDIA_SUPPORT [=m] && I2C [=y] && VIDEO_V4L2 [=m] && \
>              VIDEO_V4L2_SUBDEV_API [=y] && MEDIA_CAMERA_SUPPORT [=y]
> but as the default settings include MEDIA_SUBDRV_AUTOSELECT=y the
> "I2C module for IR" submenu (CONFIG_VIDEO_IR_I2C) is not displayed
> adding the VIDEO_IR_I2C to the dependency list makes this clear

>  drivers/media/i2c/m5mols/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/m5mols/Kconfig b/drivers/media/i2c/m5mols/Kconfig
> index dc8c250..6847a1b 100644
> --- a/drivers/media/i2c/m5mols/Kconfig
> +++ b/drivers/media/i2c/m5mols/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_M5MOLS
>  	tristate "Fujitsu M-5MOLS 8MP sensor support"
> -	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on I2C && VIDEO_IR_I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API

There should be no need to enable the "I2C module for IR" to use m5mols driver, 
so the bug fix needs to be somewhere else.

-- 
Thanks,
Sylwester
