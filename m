Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13011 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2HNKxr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 06:53:47 -0400
Received: from eusync1.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8Q00I6HRMJQA80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 11:54:19 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M8Q006FARLLND10@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 11:53:46 +0100 (BST)
Message-id: <502A2E39.6070205@samsung.com>
Date: Tue, 14 Aug 2012 12:53:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Subject: Re: [PATCH] [media] s5p-fimc: Make FIMC-Lite dependent on S5P-FIMC
References: <1344919923-16764-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1344919923-16764-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 08/14/2012 06:52 AM, Sachin Kamat wrote:
> FIMC-Lite driver accesses functions which are defined in files
> attached to S5P_FIMC. Without this patch, if only FIMC-Lite is
> selected, following errors are observed for missing symbols:
> 
> drivers/built-in.o: In function `fimc_md_create_links':
> fimc-mdevice.c:641: undefined reference to `fimc_sensor_notify'
> drivers/built-in.o: In function `fimc_md_link_notify':
> fimc-mdevice.c:838: undefined reference to `fimc_ctrls_delete'
> fimc-mdevice.c:854: undefined reference to `fimc_capture_ctrls_create'
> drivers/built-in.o: In function `fimc_md_init':
> fimc-mdevice.c:1018: undefined reference to `fimc_register_driver'
> drivers/built-in.o: In function `fimc_md_exit':
> fimc-mdevice.c:1028: undefined reference to `fimc_unregister_driver'
> make: *** [vmlinux] Error 1

Hmm, when you select CONFIG_VIDEO_EXYNOS_FIMC_LITE only fimc-mdevice.c
shouldn't be build. That what's in the Makefile [1]:

1 s5p-fimc-objs := fimc-core.o fimc-reg.o fimc-m2m.o fimc-capture.o fimc-mdevice.o
2 exynos-fimc-lite-objs += fimc-lite-reg.o fimc-lite.o
3 s5p-csis-objs := mipi-csis.o
4 
5 obj-$(CONFIG_VIDEO_S5P_MIPI_CSIS)       += s5p-csis.o
6 obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)    += exynos-fimc-lite.o
7 obj-$(CONFIG_VIDEO_S5P_FIMC)            += s5p-fimc.o


Only following 3 symbols should be missing:

- fimc_pipeline_initialize
- fimc_pipeline_s_stream
- fimc_pipeline_shutdown

I'm getting following errors instead:

drivers/built-in.o: In function `buffer_queue':
/home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:414: undefined reference to `fimc_pipeline_s_stream'
drivers/built-in.o: In function `fimc_lite_resume':
/home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:1518: undefined reference to `fimc_pipeline_initialize'
drivers/built-in.o: In function `fimc_lite_reinit':
/home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:196: undefined reference to `fimc_pipeline_s_stream'
drivers/built-in.o: In function `fimc_lite_suspend':
/home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:1544: undefined reference to `fimc_pipeline_shutdown'
drivers/built-in.o: In function `start_streaming':
/home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:310: undefined reference to `fimc_pipeline_s_stream'
drivers/built-in.o: In function `fimc_lite_close':
/home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:496: undefined reference to `fimc_pipeline_shutdown'
drivers/built-in.o: In function `fimc_lite_open':
/home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:469: undefined reference to `fimc_pipeline_initialize'


Anyway, the current approach of exporting the pipeline control
functions seems wrong, since we wouldn't be able to build s5p-fimc
and exynos-gsc drivers and link them into common kernel image.

It must be possible to build FIMC-LITE with s5p-fimc or exynos-gsc
driver, or best as a standalone module. I think I will try to add
some pipeline ops for the FIMC-LITE module, that would be initialized
when it gets registered to selected media device (s5p-fimc or 
exynos-gsc in future).

So this patch doesn't seem a right solution to me. I'll try to address
this issue. And I'm wonderin why you're getting those different errors.

Regards,
Sylwester

> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/video/s5p-fimc/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-fimc/Kconfig b/drivers/media/video/s5p-fimc/Kconfig
> index a564f7e..17a1f8d 100644
> --- a/drivers/media/video/s5p-fimc/Kconfig
> +++ b/drivers/media/video/s5p-fimc/Kconfig
> @@ -35,7 +35,7 @@ if ARCH_EXYNOS
>  
>  config VIDEO_EXYNOS_FIMC_LITE
>  	tristate "EXYNOS FIMC-LITE camera interface driver"
> -	depends on I2C
> +	depends on I2C && VIDEO_S5P_FIMC
>  	select VIDEOBUF2_DMA_CONTIG
>  	help
>  	  This is a V4L2 driver for Samsung EXYNOS4/5 SoC FIMC-LITE camera

[1] http://git.linuxtv.org/media_tree.git/blob/31ce54f6aeb70ecf1b8e758236955dfad1b1e398:/drivers/media/video/s5p-fimc/Makefile
