Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-00272701.pphosted.com ([208.86.201.61]:55066 "EHLO
        mx0b-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751161AbeCKAbs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 19:31:48 -0500
Date: Sat, 10 Mar 2018 18:15:08 -0600
From: Nick French <naf@ou.edu>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] media: ivtv: add parameter to enable ivtvfb on x86 PAT
 systems
Message-ID: <20180311001508.GA13581@tivo.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ivtvfb was previously disabled for x86 PAT-enabled systems
by commit 1bf1735b4780 ("x86/mm/pat, drivers/media/ivtv:
Use arch_phys_wc_add() and require PAT disabled") as a
workaround to abstract MTRR code away from device drivers.

The driver is not easily upgradable to the PAT-aware
ioremap_wc() API since the firmware hides the address
ranges that should be marked write-combined from the driver.
However, since a write-combined cache on the framebuffer
is only a performance enhancement not a requirement for
the framebuffer to function, completely disabling the driver
in this configuration is not necessary.

Add force_pat module parameter and a corresponding kernel
configuration parameter to optionally force initialization
on PAT-enabled x86 systems with a warning about the lack of
write-combined caching.

Signed-off-by: Nick French <naf@ou.edu>
---
 drivers/media/pci/ivtv/Kconfig  | 19 ++++++++++++++++---
 drivers/media/pci/ivtv/ivtvfb.c | 19 +++++++++++++++++--
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ivtv/Kconfig b/drivers/media/pci/ivtv/Kconfig
index c72cbbd2d40c..9c63370ed721 100644
--- a/drivers/media/pci/ivtv/Kconfig
+++ b/drivers/media/pci/ivtv/Kconfig
@@ -70,8 +70,21 @@ config VIDEO_FB_IVTV
 	  This is used in the Hauppauge PVR-350 card. There is a driver
 	  homepage at <http://www.ivtvdriver.org>.
 
-	  In order to use this module, you will need to boot with PAT disabled
-	  on x86 systems, using the nopat kernel parameter.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called ivtvfb.
+
+config VIDEO_FB_IVTV_FORCE_PAT
+	bool "force cx23415 frambuffer init with x86 PAT enabled"
+	depends on VIDEO_FB_IVTV && X86_PAT
+	default n
+	---help---
+	  With PAT enabled, the cx23415 framebuffer driver is not able to
+	  utilize write-combined caching on the framebuffer memory.
+	  The default behaviour is to disable the framebuffer completely
+	  when it detects PAT is enabled in the kernel (i.e. not using
+	  the nopat kernel parameter)
+
+	  With this setting enabled, the framebuffer will initialize on
+	  PAT-enabled systems but the framebuffer memory will be uncached.
+
+	  If unsure, say N.
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 621b2f613d81..5df74721aa19 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -55,6 +55,7 @@
 /* card parameters */
 static int ivtvfb_card_id = -1;
 static int ivtvfb_debug = 0;
+static bool ivtvfb_force_pat = IS_ENABLED(CONFIG_VIDEO_FB_IVTV_FORCE_PAT);
 static bool osd_laced;
 static int osd_depth;
 static int osd_upper;
@@ -64,6 +65,7 @@ static int osd_xres;
 
 module_param(ivtvfb_card_id, int, 0444);
 module_param_named(debug,ivtvfb_debug, int, 0644);
+module_param_named(force_pat, ivtvfb_force_pat, bool, 0644);
 module_param(osd_laced, bool, 0444);
 module_param(osd_depth, int, 0444);
 module_param(osd_upper, int, 0444);
@@ -79,6 +81,9 @@ MODULE_PARM_DESC(debug,
 		 "Debug level (bitmask). Default: errors only\n"
 		 "\t\t\t(debug = 3 gives full debugging)");
 
+MODULE_PARM_DESC(force_pat,
+		 "Force initialization on x86 PAT-enabled systems (bool).\n");
+
 /* Why upper, left, xres, yres, depth, laced ? To match terminology used
    by fbset.
    Why start at 1 for left & upper coordinate ? Because X doesn't allow 0 */
@@ -1169,8 +1174,18 @@ static int ivtvfb_init_card(struct ivtv *itv)
 
 #ifdef CONFIG_X86_64
 	if (pat_enabled()) {
-		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
-		return -ENODEV;
+		if (ivtvfb_force_pat) {
+			pr_info("PAT is enabled. Write-combined framebuffer "
+				"caching will be disabled. To enable caching, "
+				"boot with nopat kernel parameter\n");
+		} else {
+			pr_warn("ivtvfb needs PAT disabled for write-combined "
+				"framebuffer caching. Boot with nopat kernel "
+				"parameter to use caching, or use the "
+				"force_pat module parameter to run with "
+				"caching disabled\n");
+			return -ENODEV;
+		}
 	}
 #endif
 
-- 
2.13.6
