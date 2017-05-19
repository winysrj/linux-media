Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46428
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750814AbdESMKN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 08:10:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH v2 1/6] [media] atomisp: disable several warnings when W=1
Date: Fri, 19 May 2017 09:09:59 -0300
Message-Id: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The atomisp currently produce hundreds of warnings when W=1.

It is a known fact that this driver is currently in bad
shape, and there are lot of things to be done here.

We don't want to be bothered by those "minor" stuff for now,
while the driver doesn't receive a major cleanup. So,
disable those warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/Makefile          | 4 ++++
 drivers/staging/media/atomisp/i2c/imx/Makefile      | 5 +++++
 drivers/staging/media/atomisp/i2c/ov5693/Makefile   | 5 +++++
 drivers/staging/media/atomisp/pci/atomisp2/Makefile | 6 ++++++
 4 files changed, 20 insertions(+)

diff --git a/drivers/staging/media/atomisp/i2c/Makefile b/drivers/staging/media/atomisp/i2c/Makefile
index 466517c7c8e6..a1afca6ec31f 100644
--- a/drivers/staging/media/atomisp/i2c/Makefile
+++ b/drivers/staging/media/atomisp/i2c/Makefile
@@ -19,3 +19,7 @@ obj-$(CONFIG_VIDEO_AP1302)     += ap1302.o
 
 obj-$(CONFIG_VIDEO_LM3554) += lm3554.o
 
+# HACK! While this driver is in bad shape, don't enable several warnings
+#       that would be otherwise enabled with W=1
+ccflags-y += -Wno-unused-but-set-variable -Wno-missing-prototypes \
+	     -Wno-unused-const-variable -Wno-missing-declarations
diff --git a/drivers/staging/media/atomisp/i2c/imx/Makefile b/drivers/staging/media/atomisp/i2c/imx/Makefile
index 6b13a3a66e49..0eceb7374bec 100644
--- a/drivers/staging/media/atomisp/i2c/imx/Makefile
+++ b/drivers/staging/media/atomisp/i2c/imx/Makefile
@@ -4,3 +4,8 @@ imx1x5-objs := imx.o drv201.o ad5816g.o dw9714.o dw9719.o dw9718.o vcm.o otp.o o
 
 ov8858_driver-objs := ../ov8858.o dw9718.o vcm.o
 obj-$(CONFIG_VIDEO_OV8858)     += ov8858_driver.o
+
+# HACK! While this driver is in bad shape, don't enable several warnings
+#       that would be otherwise enabled with W=1
+ccflags-y += -Wno-unused-but-set-variable -Wno-missing-prototypes \
+             -Wno-unused-const-variable -Wno-missing-declarations
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Makefile b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
index c9c0e1245858..fd2ef2e3c31e 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Makefile
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
@@ -1 +1,6 @@
 obj-$(CONFIG_VIDEO_OV5693) += ov5693.o
+
+# HACK! While this driver is in bad shape, don't enable several warnings
+#       that would be otherwise enabled with W=1
+ccflags-y += -Wno-unused-but-set-variable -Wno-missing-prototypes \
+             -Wno-unused-const-variable -Wno-missing-declarations
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index f126a89a08e9..68a9ab1c3b61 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -353,3 +353,9 @@ DEFINES += -DSYSTEM_hive_isp_css_2400_system -DISP2400
 
 ccflags-y += $(INCLUDES) $(DEFINES) -fno-common
 
+# HACK! While this driver is in bad shape, don't enable several warnings
+#       that would be otherwise enabled with W=1
+ccflags-y += -Wno-unused-const-variable -Wno-missing-prototypes \
+	     -Wno-unused-but-set-variable -Wno-missing-declarations \
+	     -Wno-suggest-attribute=format -Wno-missing-prototypes \
+	     -Wno-implicit-fallthrough
-- 
2.9.3
