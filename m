Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754063AbdERNvv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 13/13] staging: media: atomisp: don't treat warnings as errors
Date: Thu, 18 May 2017 15:50:22 +0200
Message-Id: <20170518135022.6069-14-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Several atomisp files use:
	 ccflags-y += -Werror

As, on media, our usual procedure is to use W=1, and atomisp
has *a lot* of warnings with such flag enabled,like:

./drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/system_local.h:62:26: warning: 'DDR_BASE' defined but not used [-Wunused-const-variable=]

At the end, it causes our build to fail, impacting our workflow.

So, remove this crap. If one wants to force -Werror, he
can still build with it enabled by passing a parameter to
make.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/i2c/Makefile          | 2 --
 drivers/staging/media/atomisp/i2c/imx/Makefile      | 2 --
 drivers/staging/media/atomisp/i2c/ov5693/Makefile   | 2 --
 drivers/staging/media/atomisp/pci/atomisp2/Makefile | 2 +-
 4 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/Makefile b/drivers/staging/media/atomisp/i2c/Makefile
index 8ea01904c0ea..466517c7c8e6 100644
--- a/drivers/staging/media/atomisp/i2c/Makefile
+++ b/drivers/staging/media/atomisp/i2c/Makefile
@@ -19,5 +19,3 @@ obj-$(CONFIG_VIDEO_AP1302)     += ap1302.o
 
 obj-$(CONFIG_VIDEO_LM3554) += lm3554.o
 
-ccflags-y += -Werror
-
diff --git a/drivers/staging/media/atomisp/i2c/imx/Makefile b/drivers/staging/media/atomisp/i2c/imx/Makefile
index 1d7f7ab94cac..6b13a3a66e49 100644
--- a/drivers/staging/media/atomisp/i2c/imx/Makefile
+++ b/drivers/staging/media/atomisp/i2c/imx/Makefile
@@ -4,5 +4,3 @@ imx1x5-objs := imx.o drv201.o ad5816g.o dw9714.o dw9719.o dw9718.o vcm.o otp.o o
 
 ov8858_driver-objs := ../ov8858.o dw9718.o vcm.o
 obj-$(CONFIG_VIDEO_OV8858)     += ov8858_driver.o
-
-ccflags-y += -Werror
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Makefile b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
index fceb9e9b881b..c9c0e1245858 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Makefile
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
@@ -1,3 +1 @@
 obj-$(CONFIG_VIDEO_OV5693) += ov5693.o
-
-ccflags-y += -Werror
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index 3fa7c1c1479f..f126a89a08e9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -351,5 +351,5 @@ DEFINES := -DHRT_HW -DHRT_ISP_CSS_CUSTOM_HOST -DHRT_USE_VIR_ADDRS -D__HOST__
 DEFINES += -DATOMISP_POSTFIX=\"css2400b0_v21\" -DISP2400B0
 DEFINES += -DSYSTEM_hive_isp_css_2400_system -DISP2400
 
-ccflags-y += $(INCLUDES) $(DEFINES) -fno-common -Werror
+ccflags-y += $(INCLUDES) $(DEFINES) -fno-common
 
-- 
2.13.0
