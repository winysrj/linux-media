Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:37062 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbeAEMEB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 07:04:01 -0500
Subject: Re: [PATCH] media: staging: tegra-vde: select DMA_SHARED_BUFFER
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <20180105094343.2813148-1-arnd@arndb.de>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <481fe121-8937-81a5-40d5-d8fe8a0036dd@gmail.com>
Date: Fri, 5 Jan 2018 15:03:56 +0300
MIME-Version: 1.0
In-Reply-To: <20180105094343.2813148-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.01.2018 12:43, Arnd Bergmann wrote:
> Without CONFIG_DMA_SHARED_BUFFER we run into a link error for the
> dma_buf_* APIs:
> 
> ERROR: "dma_buf_map_attachment" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
> ERROR: "dma_buf_attach" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
> ERROR: "dma_buf_get" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
> ERROR: "dma_buf_put" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
> ERROR: "dma_buf_detach" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
> ERROR: "dma_buf_unmap_attachment" [drivers/staging/media/tegra-vde/tegra-vde.ko] undefined!
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/staging/media/tegra-vde/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/tegra-vde/Kconfig b/drivers/staging/media/tegra-vde/Kconfig
> index ec3ddddebdaa..5c4914674468 100644
> --- a/drivers/staging/media/tegra-vde/Kconfig
> +++ b/drivers/staging/media/tegra-vde/Kconfig
> @@ -1,6 +1,7 @@
>  config TEGRA_VDE
>  	tristate "NVIDIA Tegra Video Decoder Engine driver"
>  	depends on ARCH_TEGRA || COMPILE_TEST
> +	select DMA_SHARED_BUFFER
>  	select SRAM
>  	help
>  	    Say Y here to enable support for the NVIDIA Tegra video decoder
> 

Thanks!

Acked-by: Dmitry Osipenko <digetx@gmail.com>
