Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-00272701.pphosted.com ([67.231.145.144]:43202 "EHLO
        mx0a-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932139AbeCKT1h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 15:27:37 -0400
Date: Sun, 11 Mar 2018 14:27:28 -0500
From: Nick French <naf@ou.edu>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2] media: ivtv: add parameter to enable ivtvfb on x86 PAT
 systems
Message-ID: <20180311192728.GA4076@tivo.lan>
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
write-combined caching, and document the reasons the driver
cannot be easily updated to support wc caching on all systems.

Signed-off-by: Nick French <naf@ou.edu>
---
Changes in v2:
 - Add wording to Kconfig parameter to memorialize the reasoning
   this driver cannot easily be upgraded to use ioremap_wc()

 drivers/media/pci/ivtv/Kconfig  | 23 ++++++++++++++++++++---
 drivers/media/pci/ivtv/ivtvfb.c | 19 +++++++++++++++++--
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ivtv/Kconfig b/drivers/media/pci/ivtv/Kconfig
index c72cbbd2d40c..e5ebf7ca145c 100644
--- a/drivers/media/pci/ivtv/Kconfig
+++ b/drivers/media/pci/ivtv/Kconfig
@@ -70,8 +70,25 @@ config VIDEO_FB_IVTV
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
+	  With PAT enabled, the cx23415 framebuffer driver does not
+	  utilize write-combined caching on the framebuffer memory.
+	  For this reason, the driver will by default disable itself
+	  when initializied on a kernel with PAT enabled (i.e. not
+	  using the nopat kernel parameter).
+
+	  The driver is not easily upgradable to the PAT-aware
+	  ioremap_wc() API since the firmware hides the address
+	  ranges that should be marked write-combined from the driver.
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
