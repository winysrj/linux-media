Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51833
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751403AbdFGLbj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 07:31:39 -0400
Date: Wed, 7 Jun 2017 08:31:30 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v9 9/9] media: venus: enable building of Venus video
 driver
Message-ID: <20170607083123.23308e47@vento.lan>
In-Reply-To: <1494344161-28131-10-git-send-email-stanimir.varbanov@linaro.org>
References: <1494344161-28131-1-git-send-email-stanimir.varbanov@linaro.org>
        <1494344161-28131-10-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  9 May 2017 18:36:01 +0300
Stanimir Varbanov <stanimir.varbanov@linaro.org> escreveu:

> This adds Venus driver Makefile and changes v4l2 platform
> Makefile/Kconfig in order to enable building of the driver.
> 
> Note that in this initial version the COMPILE_TEST-ing is not
> supported because the drivers specific to ARM builds are still
> in process of enabling the aforementioned compile testing.

Not sure what you're meaning here. Almost all media drivers for
ARM platforms build with COMPILE_TEST. The exceptions are some legacy 
drivers that were added before COMPILE_TEST and rely on some weird
arch-specific functions (like arch-specific DMA functions like on OMAP3).

It is really important to make it build with COMPILE_TEST, as the
Coverity instance we use on Kernel works only for the code that builds
on x86. Also, on my test environment, I only do per-patch builds for
i386. So, if some patch breaks the build, I won't detect until too
late.

Btw, on a quick test, enabling compile-test on it built the driver
(I didn't make a full build - just a partial modules-only build - so
 maybe it might depend on some qualcomm-specific symbols).

Building it with W=1 and gcc7 produced the following warnings:


drivers/media/platform/qcom/venus/hfi.c:171 hfi_core_ping() warn: inconsistent returns 'mutex:&core->lock'.
  Locked on:   line 159
  Unlocked on: line 171
drivers/media/platform/qcom/venus/hfi_cmds.c:415 pkt_session_set_property_1x() warn: variable dereferenced before check 'pkt' (see line 412)
drivers/media/platform/qcom/venus/hfi_cmds.c:1177 pkt_session_set_property_3xx() warn: variable dereferenced before check 'pkt' (see line 1174)
drivers/media/platform/qcom/venus/helpers.c:157 load_per_instance() warn: variable dereferenced before check 'inst' (see line 153)
drivers/media/platform/qcom/venus/hfi_venus.c:998 venus_isr_thread() warn: variable dereferenced before check 'hdev' (see line 994)
drivers/media/platform/qcom/venus/hfi_msgs.c: In function 'init_done_read_prop':
drivers/media/platform/qcom/venus/hfi_msgs.c:465:40: warning: variable 'domain' set but not used [-Wunused-but-set-variable]
  u32 rem_bytes, num_props, codecs = 0, domain = 0;
                                        ^~~~~~
drivers/media/platform/qcom/venus/hfi_msgs.c:465:28: warning: variable 'codecs' set but not used [-Wunused-but-set-variable]
  u32 rem_bytes, num_props, codecs = 0, domain = 0;
                            ^~~~~~
drivers/media/platform/qcom/venus/venc.c:1150 venc_close() error: dereferencing freed memory 'inst'
drivers/media/platform/qcom/venus/vdec.c:1022 vdec_close() error: dereferencing freed memory 'inst'


Please check.

Thanks,
Mauro

[PATCH] venus: enable building with COMPILE_TEST

We want all media drivers to build with COMPILE_TEST, as the
Coverity instance we use on Kernel works only for x86. Also,
our test workflow relies on it, in order to identify git
bisect breakages.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 017e42ce0ff9..0898f63fa451 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -467,7 +467,7 @@ config VIDEO_TI_VPE_DEBUG
 config VIDEO_QCOM_VENUS
 	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
-	depends on ARCH_QCOM && IOMMU_DMA
+	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select QCOM_MDT_LOADER
 	select VIDEOBUF2_DMA_SG
 	select V4L2_MEM2MEM_DEV
