Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60970 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2HNLdI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 07:33:08 -0400
Received: by vbbff1 with SMTP id ff1so206522vbb.19
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 04:33:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502A2E39.6070205@samsung.com>
References: <1344919923-16764-1-git-send-email-sachin.kamat@linaro.org>
	<502A2E39.6070205@samsung.com>
Date: Tue, 14 Aug 2012 17:03:07 +0530
Message-ID: <CAK9yfHx=Hc=Z4vbdxL=AO51aiJyAwDa51bOi-V0tJQ0PUvhX1w@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-fimc: Make FIMC-Lite dependent on S5P-FIMC
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 14 August 2012 16:23, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> On 08/14/2012 06:52 AM, Sachin Kamat wrote:
>> FIMC-Lite driver accesses functions which are defined in files
>> attached to S5P_FIMC. Without this patch, if only FIMC-Lite is
>> selected, following errors are observed for missing symbols:
>>
>> drivers/built-in.o: In function `fimc_md_create_links':
>> fimc-mdevice.c:641: undefined reference to `fimc_sensor_notify'
>> drivers/built-in.o: In function `fimc_md_link_notify':
>> fimc-mdevice.c:838: undefined reference to `fimc_ctrls_delete'
>> fimc-mdevice.c:854: undefined reference to `fimc_capture_ctrls_create'
>> drivers/built-in.o: In function `fimc_md_init':
>> fimc-mdevice.c:1018: undefined reference to `fimc_register_driver'
>> drivers/built-in.o: In function `fimc_md_exit':
>> fimc-mdevice.c:1028: undefined reference to `fimc_unregister_driver'
>> make: *** [vmlinux] Error 1
>
> Hmm, when you select CONFIG_VIDEO_EXYNOS_FIMC_LITE only fimc-mdevice.c
> shouldn't be build. That what's in the Makefile [1]:
>
> 1 s5p-fimc-objs := fimc-core.o fimc-reg.o fimc-m2m.o fimc-capture.o fimc-mdevice.o
> 2 exynos-fimc-lite-objs += fimc-lite-reg.o fimc-lite.o
> 3 s5p-csis-objs := mipi-csis.o
> 4
> 5 obj-$(CONFIG_VIDEO_S5P_MIPI_CSIS)       += s5p-csis.o
> 6 obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)    += exynos-fimc-lite.o
> 7 obj-$(CONFIG_VIDEO_S5P_FIMC)            += s5p-fimc.o
>
>
> Only following 3 symbols should be missing:
>
> - fimc_pipeline_initialize
> - fimc_pipeline_s_stream
> - fimc_pipeline_shutdown
>
> I'm getting following errors instead:
>
> drivers/built-in.o: In function `buffer_queue':
> /home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:414: undefined reference to `fimc_pipeline_s_stream'
> drivers/built-in.o: In function `fimc_lite_resume':
> /home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:1518: undefined reference to `fimc_pipeline_initialize'
> drivers/built-in.o: In function `fimc_lite_reinit':
> /home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:196: undefined reference to `fimc_pipeline_s_stream'
> drivers/built-in.o: In function `fimc_lite_suspend':
> /home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:1544: undefined reference to `fimc_pipeline_shutdown'
> drivers/built-in.o: In function `start_streaming':
> /home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:310: undefined reference to `fimc_pipeline_s_stream'
> drivers/built-in.o: In function `fimc_lite_close':
> /home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:496: undefined reference to `fimc_pipeline_shutdown'
> drivers/built-in.o: In function `fimc_lite_open':
> /home/snawrocki/dev/linux-opensource-release/kernel/drivers/media/video/s5p-fimc/fimc-lite.c:469: undefined reference to `fimc_pipeline_initialize'

Sorry for the confusion created due to the wrong copy of error
messages. In fact I too get the same errors as mentioned by you. I was
just playing around with the Makefile to see if including
fimc-mdevice.o solved the problem (commit messsage errors were due to
this).




>
>
> Anyway, the current approach of exporting the pipeline control
> functions seems wrong, since we wouldn't be able to build s5p-fimc
> and exynos-gsc drivers and link them into common kernel image.
>
> It must be possible to build FIMC-LITE with s5p-fimc or exynos-gsc
> driver, or best as a standalone module. I think I will try to add
> some pipeline ops for the FIMC-LITE module, that would be initialized
> when it gets registered to selected media device (s5p-fimc or
> exynos-gsc in future).

Sounds good.

>
> So this patch doesn't seem a right solution to me.

Right. This patch was more from the point of view of bringing this
issue to notice and possibly providing a quick fix (workaround).

I'll try to address
> this issue. And I'm wonderin why you're getting those different errors.
My mistake :)

>
> Regards,
> Sylwester
>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/video/s5p-fimc/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-fimc/Kconfig b/drivers/media/video/s5p-fimc/Kconfig
>> index a564f7e..17a1f8d 100644
>> --- a/drivers/media/video/s5p-fimc/Kconfig
>> +++ b/drivers/media/video/s5p-fimc/Kconfig
>> @@ -35,7 +35,7 @@ if ARCH_EXYNOS
>>
>>  config VIDEO_EXYNOS_FIMC_LITE
>>       tristate "EXYNOS FIMC-LITE camera interface driver"
>> -     depends on I2C
>> +     depends on I2C && VIDEO_S5P_FIMC
>>       select VIDEOBUF2_DMA_CONTIG
>>       help
>>         This is a V4L2 driver for Samsung EXYNOS4/5 SoC FIMC-LITE camera
>
> [1] http://git.linuxtv.org/media_tree.git/blob/31ce54f6aeb70ecf1b8e758236955dfad1b1e398:/drivers/media/video/s5p-fimc/Makefile



-- 
With warm regards,
Sachin
