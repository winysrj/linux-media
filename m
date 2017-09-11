Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35243 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbdIKSu2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 14:50:28 -0400
Date: Mon, 11 Sep 2017 20:50:26 +0200
From: Vincent Hervieux <vincent.hervieux@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@llwyncelyn.cymru, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, rvarsha016@gmail.com,
        dan.carpenter@oracle.com, fengguang.wu@intel.com,
        daeseok.youn@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, vincent.hervieux@gmail.com
Subject: [PATCH 1/2] staging: atomisp: add menu entries to choose between
 ATOMISP_2400 and ATOMISP_2401.
Message-ID: <d7f3632c989a2af3279cc2ce5b71d7f77f01a623.1505142435.git.vincent.hervieux@gmail.com>
References: <cover.1505142435.git.vincent.hervieux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1505142435.git.vincent.hervieux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/staging/media/atomisp/pci/Kconfig          | 23 ++++++++++++++++++++++
 .../staging/media/atomisp/pci/atomisp2/Makefile    | 10 +++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/Kconfig b/drivers/staging/media/atomisp/pci/Kconfig
index a72421431c7a..e3e00ade1d38 100644
--- a/drivers/staging/media/atomisp/pci/Kconfig
+++ b/drivers/staging/media/atomisp/pci/Kconfig
@@ -11,3 +11,26 @@ config VIDEO_ATOMISP
           camera imaging subsystem.
           To compile this driver as a module, choose M here: the
           module will be called atomisp
+
+choice
+        prompt "Intel Atom Image Signal Processor Driver Type"
+        depends on VIDEO_ATOMISP
+        default VIDEO_ATOMISP_ISP2400
+        help
+          Intel Atom Image Signal Processor Driver actually doesn't support
+          dynamically all SoC.
+          So need to choose at compilation time which SoC it can support.
+          Please refer to staging TODO for more details.
+
+config VIDEO_ATOMISP_ISP2400
+        bool "ISP2400"
+        help
+          Atom ISP for Merrifield, Baytrail SoC.
+
+config VIDEO_ATOMISP_ISP2401
+        bool "ISP2401"
+        help
+          Atom ISP for Anniedale (Merrifield+ / Moorefield), Cherrytrail SoC.
+
+endchoice
+
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index 2bd98f0667ec..27ac23c0c18d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -155,7 +155,7 @@ atomisp-objs += \
 	hmm/hmm_dynamic_pool.o \
 	hrt/hive_isp_css_mm_hrt.o \
 	atomisp_v4l2.o
-	
+
 # These will be needed when clean merge CHT support nicely into the driver
 # Keep them here handy for when we get to that point
 #
@@ -347,8 +347,16 @@ DEFINES := -DHRT_HW -DHRT_ISP_CSS_CUSTOM_HOST -DHRT_USE_VIR_ADDRS -D__HOST__
 #DEFINES += -DPUNIT_CAMERA_BUSY
 #DEFINES += -DUSE_KMEM_CACHE
 
+ifeq ($(CONFIG_VIDEO_ATOMISP_ISP2400),y)
+# Merrifield, Baytrail
 DEFINES += -DATOMISP_POSTFIX=\"css2400b0_v21\" -DISP2400B0
 DEFINES += -DSYSTEM_hive_isp_css_2400_system -DISP2400
+endif
+ifeq ($(CONFIG_VIDEO_ATOMISP_ISP2401),y)
+# Anniedale (Merrifield+ / Moorefield), Cherrytrail
+DEFINES += -DATOMISP_POSTFIX=\"css2401a0_v21\" -DISP2401A0
+DEFINES += -DSYSTEM_hive_isp_css_2400_system -DISP2401 -DISP2401_NEW_INPUT_SYSTEM
+endif
 
 ccflags-y += $(INCLUDES) $(DEFINES) -fno-common
 
-- 
2.11.0
