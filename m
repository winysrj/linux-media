Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36968 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFTMmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 08:42:32 -0400
Received: by mail-wm0-f51.google.com with SMTP id d73so19023808wma.0
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 05:42:31 -0700 (PDT)
Subject: Re: [GIT PULL FOR v4.13] Add qcom venus driver
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <9a84a004-ebdc-fba7-2cee-b91857788599@xs4all.nl>
 <20170620085951.11e5c8dd@vento.lan>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <5ecc833a-e59b-475b-d001-39367b52f46e@linaro.org>
Date: Tue, 20 Jun 2017 15:42:28 +0300
MIME-Version: 1.0
In-Reply-To: <20170620085951.11e5c8dd@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 06/20/2017 02:59 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 16 Jun 2017 10:19:46 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Mauro,
>>
>> Second attempt to add the venus driver.
>>
>> Regards,
>>
>> 	Hans
>>
>> The following changes since commit acec3630155763c170c7ae6508cf973355464508:
>>
>>    [media] s3c-camif: fix arguments position in a function call (2017-06-13 14:21:24 -0300)
>>
>> are available in the git repository at:
>>
>>    git://linuxtv.org/hverkuil/media_tree.git venus
>>
>> for you to fetch changes up to 3bf1c3aacb172db8fcbd25c62b042fc265c5a494:
>>
>>    media: venus: enable building with COMPILE_TEST (2017-06-16 09:59:36 +0200)
>>
>> ----------------------------------------------------------------
>> Stanimir Varbanov (19):
>>        media: v4l2-mem2mem: extend m2m APIs for more accurate buffer management
>>        doc: DT: venus: binding document for Qualcomm video driver
>>        MAINTAINERS: Add Qualcomm Venus video accelerator driver
>>        media: venus: adding core part and helper functions
>>        media: venus: vdec: add video decoder files
>>        media: venus: venc: add video encoder files
>>        media: venus: hfi: add Host Firmware Interface (HFI)
>>        media: venus: hfi: add Venus HFI files
>>        media: venus: enable building of Venus video driver
>>        media: venus: hfi: fix mutex unlock
>>        media: venus: hfi_cmds: fix variable dereferenced before check
>>        media: venus: helpers: fix variable dereferenced before check
>>        media: venus: hfi_venus: fix variable dereferenced before check
>>        media: venus: hfi_msgs: fix set but not used variables
>>        media: venus: vdec: fix compile error in vdec_close
>>        media: venus: venc: fix compile error in venc_close
>>        media: venus: vdec: add support for min buffers for capture
>>        media: venus: update firmware path with linux-firmware place
> 
> 
>>        media: venus: enable building with COMPILE_TEST
> 
> It is too early for this patch. I merged from 4.12-rc6, and it
> still complains about those missing symbols:
> 
> WARNING: "qcom_scm_is_available" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
> WARNING: "qcom_scm_pas_shutdown" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
> WARNING: "qcom_scm_set_remote_state" [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
> 
> Probably, some patch is needed somewhere to replace those functions
> by stubs if not the right arch, in order to make it build with
> COMPILE_TEST.
> 
> For now, I'm excluding this patch on today's pull.

It seems that the patch for the qcom_scm will be delayed, so I have to
fix this in the Venus Kconfig, which doesn't seem too bad because we
want to allow compile test for the venus driver itself not for its
dependencies.

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f9bbba5c5dd6..b7381a4722e2 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -468,7 +468,8 @@ config VIDEO_QCOM_VENUS
        tristate "Qualcomm Venus V4L2 encoder/decoder driver"
        depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
        depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
-       select QCOM_MDT_LOADER
+       select QCOM_MDT_LOADER if (ARM || ARM64)
+       select QCOM_SCM if (ARM || ARM64)
        select VIDEOBUF2_DMA_SG
        select V4L2_MEM2MEM_DEV
        ---help---

So if you are fine with the above change I can cook a patch?

-- 
regards,
Stan
