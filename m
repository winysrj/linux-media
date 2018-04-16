Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52754 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbeDPQhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 12:37:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/9] media: staging: atomisp: reenable warnings for I2C
Date: Mon, 16 Apr 2018 12:37:05 -0400
Message-Id: <6eae1b4e17d452c6e01d779e3923c0d0ea7935da.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When atomisp got merged, there were so many warnings with W=1
that we simply disabled the ones that were causing troubles.

Since then, several changes got applied to atomisp, and the
number of warnings are a way smaller than it used to be.

So, let's reenable warnings there and fix the issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/Makefile        | 7 -------
 drivers/staging/media/atomisp/i2c/ov5693/Makefile | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/Makefile b/drivers/staging/media/atomisp/i2c/Makefile
index 99ea35c043fd..8d022986e199 100644
--- a/drivers/staging/media/atomisp/i2c/Makefile
+++ b/drivers/staging/media/atomisp/i2c/Makefile
@@ -16,10 +16,3 @@ obj-$(CONFIG_VIDEO_ATOMISP_MSRLIST_HELPER) += atomisp-libmsrlisthelper.o
 #
 
 obj-$(CONFIG_VIDEO_ATOMISP_LM3554) += atomisp-lm3554.o
-
-# HACK! While this driver is in bad shape, don't enable several warnings
-#       that would be otherwise enabled with W=1
-ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
-ccflags-y += $(call cc-disable-warning, unused-const-variable)
-ccflags-y += $(call cc-disable-warning, missing-prototypes)
-ccflags-y += $(call cc-disable-warning, missing-declarations)
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Makefile b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
index aa6be85c5a60..3275f2be229e 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Makefile
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
@@ -1,9 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_VIDEO_ATOMISP_OV5693) += atomisp-ov5693.o
-
-# HACK! While this driver is in bad shape, don't enable several warnings
-#       that would be otherwise enabled with W=1
-ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
-ccflags-y += $(call cc-disable-warning, unused-const-variable)
-ccflags-y += $(call cc-disable-warning, missing-prototypes)
-ccflags-y += $(call cc-disable-warning, missing-declarations)
-- 
2.14.3
