Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35985 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbbDVTfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2015 15:35:15 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: andy@silverblocksystems.net, awalls@md.metrocast.net,
	linux-media@vger.kernel.org
Cc: luto@amacapital.net, mst@redhat.com, linux-kernel@vger.kernel.org,
	linux-fbdev@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Juergen Gross <jgross@suse.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Antonino Daplas <adaplas@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Stefan Bader <stefan.bader@canonical.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <syrjala@sci.fi>,
	Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
	Borislav Petkov <bp@suse.de>, Davidlohr Bueso <dbueso@suse.de>,
	konrad.wilk@oracle.com, ville.syrjala@linux.intel.com,
	david.vrabel@citrix.com, jbeulich@suse.com, toshi.kani@hp.com,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	ivtv-devel@ivtvdriver.org, xen-devel@lists.xensource.com
Subject: [PATCH] [media] ivtv: use arch_phys_wc_add() and require PAT disabled
Date: Wed, 22 Apr 2015 12:33:02 -0700
Message-Id: <1429731182-6974-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We are burrying direct access to MTRR code support on
x86 in order to take advantage of PAT. In the future we
also want to make the default behaviour of ioremap_nocache()
to use strong UC, use of mtrr_add() on those systems
would make write-combining void.

In order to help both enable us to later make strong
UC default and in order to phase out direct MTRR access
code port the driver over to arch_phys_wc_add() and
annotate that the device driver requires systems to
boot with PAT disabled, with the nopat kernel parameter.

This is a worthy comprmise given that the hardware is
really rare these days, and perhaps only some lost souls
in some third world country are expected to be using this
feature of the device driver.

Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Suresh Siddha <sbsiddha@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Juergen Gross <jgross@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Stefan Bader <stefan.bader@canonical.com>
Cc: Ville Syrjälä <syrjala@sci.fi>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: david.vrabel@citrix.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: Roger Pau Monné <roger.pau@citrix.com>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: ivtv-devel@ivtvdriver.org
Cc: linux-media@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/media/pci/ivtv/Kconfig  |  3 +++
 drivers/media/pci/ivtv/ivtvfb.c | 59 +++++++++++++++++------------------------
 2 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/drivers/media/pci/ivtv/Kconfig b/drivers/media/pci/ivtv/Kconfig
index dd6ee57e..b2a7f88 100644
--- a/drivers/media/pci/ivtv/Kconfig
+++ b/drivers/media/pci/ivtv/Kconfig
@@ -57,5 +57,8 @@ config VIDEO_FB_IVTV
 	  This is used in the Hauppauge PVR-350 card. There is a driver
 	  homepage at <http://www.ivtvdriver.org>.
 
+	  If you have this hardware you will need to boot with PAT disabled
+	  on your x86 systems, use the nopat kernel parameter.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called ivtvfb.
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 9ff1230..552408b 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -44,8 +44,8 @@
 #include <linux/ivtvfb.h>
 #include <linux/slab.h>
 
-#ifdef CONFIG_MTRR
-#include <asm/mtrr.h>
+#ifdef CONFIG_X86_64
+#include <asm/pat.h>
 #endif
 
 #include "ivtv-driver.h"
@@ -155,12 +155,11 @@ struct osd_info {
 	/* Buffer size */
 	u32 video_buffer_size;
 
-#ifdef CONFIG_MTRR
 	/* video_base rounded down as required by hardware MTRRs */
 	unsigned long fb_start_aligned_physaddr;
 	/* video_base rounded up as required by hardware MTRRs */
 	unsigned long fb_end_aligned_physaddr;
-#endif
+	int wc_cookie;
 
 	/* Store the buffer offset */
 	int set_osd_coords_x;
@@ -1099,6 +1098,8 @@ static int ivtvfb_init_vidmode(struct ivtv *itv)
 static int ivtvfb_init_io(struct ivtv *itv)
 {
 	struct osd_info *oi = itv->osd_info;
+	/* Find the largest power of two that maps the whole buffer */
+	int size_shift = 31;
 
 	mutex_lock(&itv->serialize_lock);
 	if (ivtv_init_on_first_open(itv)) {
@@ -1120,6 +1121,7 @@ static int ivtvfb_init_io(struct ivtv *itv)
 	oi->video_buffer_size = 1704960;
 
 	oi->video_pbase = itv->base_addr + IVTV_DECODER_OFFSET + oi->video_rbase;
+	/* XXX: split this for PAT */
 	oi->video_vbase = itv->dec_mem + oi->video_rbase;
 
 	if (!oi->video_vbase) {
@@ -1132,29 +1134,16 @@ static int ivtvfb_init_io(struct ivtv *itv)
 			oi->video_pbase, oi->video_vbase,
 			oi->video_buffer_size / 1024);
 
-#ifdef CONFIG_MTRR
-	{
-		/* Find the largest power of two that maps the whole buffer */
-		int size_shift = 31;
-
-		while (!(oi->video_buffer_size & (1 << size_shift))) {
-			size_shift--;
-		}
-		size_shift++;
-		oi->fb_start_aligned_physaddr = oi->video_pbase & ~((1 << size_shift) - 1);
-		oi->fb_end_aligned_physaddr = oi->video_pbase + oi->video_buffer_size;
-		oi->fb_end_aligned_physaddr += (1 << size_shift) - 1;
-		oi->fb_end_aligned_physaddr &= ~((1 << size_shift) - 1);
-		if (mtrr_add(oi->fb_start_aligned_physaddr,
-			oi->fb_end_aligned_physaddr - oi->fb_start_aligned_physaddr,
-			     MTRR_TYPE_WRCOMB, 1) < 0) {
-			IVTVFB_INFO("disabled mttr\n");
-			oi->fb_start_aligned_physaddr = 0;
-			oi->fb_end_aligned_physaddr = 0;
-		}
-	}
-#endif
-
+	while (!(oi->video_buffer_size & (1 << size_shift)))
+		size_shift--;
+	size_shift++;
+	oi->fb_start_aligned_physaddr = oi->video_pbase & ~((1 << size_shift) - 1);
+	oi->fb_end_aligned_physaddr = oi->video_pbase + oi->video_buffer_size;
+	oi->fb_end_aligned_physaddr += (1 << size_shift) - 1;
+	oi->fb_end_aligned_physaddr &= ~((1 << size_shift) - 1);
+	oi->wc_cookie = arch_phys_wc_add(oi->fb_start_aligned_physaddr,
+					 oi->fb_end_aligned_physaddr -
+					 oi->fb_start_aligned_physaddr);
 	/* Blank the entire osd. */
 	memset_io(oi->video_vbase, 0, oi->video_buffer_size);
 
@@ -1172,14 +1161,7 @@ static void ivtvfb_release_buffers (struct ivtv *itv)
 
 	/* Release pseudo palette */
 	kfree(oi->ivtvfb_info.pseudo_palette);
-
-#ifdef CONFIG_MTRR
-	if (oi->fb_end_aligned_physaddr) {
-		mtrr_del(-1, oi->fb_start_aligned_physaddr,
-			oi->fb_end_aligned_physaddr - oi->fb_start_aligned_physaddr);
-	}
-#endif
-
+	arch_phys_wc_del(oi->wc_cookie);
 	kfree(oi);
 	itv->osd_info = NULL;
 }
@@ -1190,6 +1172,13 @@ static int ivtvfb_init_card(struct ivtv *itv)
 {
 	int rc;
 
+#ifdef CONFIG_X86_64
+	if (WARN(pat_enabled,
+		 "ivtv needs PAT disabled, boot with nopat kernel parameter\n")) {
+		return EINVAL;
+	}
+#endif
+
 	if (itv->osd_info) {
 		IVTVFB_ERR("Card %d already initialised\n", ivtvfb_card_id);
 		return -EBUSY;
-- 
2.3.2.209.gd67f9d5.dirty

