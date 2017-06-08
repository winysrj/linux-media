Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58446
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751392AbdFHQww (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 12:52:52 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, devel@driverdev.osuosl.org
Subject: [PATCH] atomisp: use correct dialect to disable warnings
Date: Thu,  8 Jun 2017 13:52:25 -0300
Message-Id: <e2fe6ef4b5af0220d19a4de809518bf9c9ebee7d.1496940726.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a Macro that checks if gcc supports a warning before
disabling it. Use it, in order to avoid warnings when building
with older gcc versions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/Makefile        | 6 ++++--
 drivers/staging/media/atomisp/i2c/imx/Makefile    | 6 ++++--
 drivers/staging/media/atomisp/i2c/ov5693/Makefile | 6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/Makefile b/drivers/staging/media/atomisp/i2c/Makefile
index a1afca6ec31f..be13fab92175 100644
--- a/drivers/staging/media/atomisp/i2c/Makefile
+++ b/drivers/staging/media/atomisp/i2c/Makefile
@@ -21,5 +21,7 @@ obj-$(CONFIG_VIDEO_LM3554) += lm3554.o
 
 # HACK! While this driver is in bad shape, don't enable several warnings
 #       that would be otherwise enabled with W=1
-ccflags-y += -Wno-unused-but-set-variable -Wno-missing-prototypes \
-	     -Wno-unused-const-variable -Wno-missing-declarations
+ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
+ccflags-y += $(call cc-disable-warning, unused-const-variable)
+ccflags-y += $(call cc-disable-warning, missing-prototypes)
+ccflags-y += $(call cc-disable-warning, missing-declarations)
diff --git a/drivers/staging/media/atomisp/i2c/imx/Makefile b/drivers/staging/media/atomisp/i2c/imx/Makefile
index 0eceb7374bec..b6578f09546e 100644
--- a/drivers/staging/media/atomisp/i2c/imx/Makefile
+++ b/drivers/staging/media/atomisp/i2c/imx/Makefile
@@ -7,5 +7,7 @@ obj-$(CONFIG_VIDEO_OV8858)     += ov8858_driver.o
 
 # HACK! While this driver is in bad shape, don't enable several warnings
 #       that would be otherwise enabled with W=1
-ccflags-y += -Wno-unused-but-set-variable -Wno-missing-prototypes \
-             -Wno-unused-const-variable -Wno-missing-declarations
+ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
+ccflags-y += $(call cc-disable-warning, unused-const-variable)
+ccflags-y += $(call cc-disable-warning, missing-prototypes)
+ccflags-y += $(call cc-disable-warning, missing-declarations)
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Makefile b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
index fd2ef2e3c31e..4e3833aaec05 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Makefile
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
@@ -2,5 +2,7 @@ obj-$(CONFIG_VIDEO_OV5693) += ov5693.o
 
 # HACK! While this driver is in bad shape, don't enable several warnings
 #       that would be otherwise enabled with W=1
-ccflags-y += -Wno-unused-but-set-variable -Wno-missing-prototypes \
-             -Wno-unused-const-variable -Wno-missing-declarations
+ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
+ccflags-y += $(call cc-disable-warning, unused-const-variable)
+ccflags-y += $(call cc-disable-warning, missing-prototypes)
+ccflags-y += $(call cc-disable-warning, missing-declarations)
-- 
2.9.4
