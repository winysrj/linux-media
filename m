Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37722 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbdF0TqB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 15:46:01 -0400
Received: by mail-wm0-f54.google.com with SMTP id i127so37431268wma.0
        for <linux-media@vger.kernel.org>; Tue, 27 Jun 2017 12:46:00 -0700 (PDT)
Subject: Re: [PATCH 3/3] [media] venus: fix compile-test build on non-qcom ARM
 platform
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20170627150310.719212-1-arnd@arndb.de>
 <20170627150310.719212-3-arnd@arndb.de>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <f8c63e5a-a650-c564-378a-fbe769f2a26d@linaro.org>
Date: Tue, 27 Jun 2017 22:45:58 +0300
MIME-Version: 1.0
In-Reply-To: <20170627150310.719212-3-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On 27.06.2017 18:02, Arnd Bergmann wrote:
> If QCOM_MDT_LOADER is enabled, but ARCH_QCOM is not, we run into
> a build error:
> 
> ERROR: "qcom_mdt_load" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
> ERROR: "qcom_mdt_get_size" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!

Ahh, thanks for the fix, these two will also pursuing me in my dreams.

> 
> This changes the 'select' statement again, so we only try to enable
> those symbols when the drivers will actually get built.
> 
> Fixes: 76724b30f222 ("[media] media: venus: enable building with COMPILE_TEST")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

> ---
>   drivers/media/platform/Kconfig | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index cb2f31cd0088..635c53e61f8a 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -475,8 +475,8 @@ config VIDEO_QCOM_VENUS
>   	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
>   	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
>   	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
> -	select QCOM_MDT_LOADER if (ARM || ARM64)
> -	select QCOM_SCM if (ARM || ARM64)
> +	select QCOM_MDT_LOADER if ARCH_QCOM
> +	select QCOM_SCM if ARCH_QCOM
>   	select VIDEOBUF2_DMA_SG
>   	select V4L2_MEM2MEM_DEV
>   	---help---
> 

regards,
Stan
