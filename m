Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39476
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753712AbdERIpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 04:45:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH] [media] atomisp: don't treat warnings as errors
Date: Thu, 18 May 2017 05:45:25 -0300
Message-Id: <dd8245f445f5e751b38126140b6ba1723f06c60b.1495097103.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
2.9.3
