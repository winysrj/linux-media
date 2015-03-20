Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36857 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbbCTXx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 19:53:58 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de,
	hpa@zytor.com, jgross@suse.com, JBeulich@suse.com, bp@suse.de,
	suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com,
	airlied@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
	x86@kernel.org, xen-devel@lists.xenproject.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Ingo Molnar <mingo@elte.hu>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Antonino Daplas <adaplas@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	konrad.wilk@oracle.com, ville.syrjala@linux.intel.com,
	david.vrabel@citrix.com, jbeulich@suse.com, toshi.kani@hp.com,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	xen-devel@lists.xensource.com
Subject: [PATCH v1 15/47] [media] media: ivtv: use __arch_phys_wc_add()
Date: Fri, 20 Mar 2015 16:18:05 -0700
Message-Id: <1426893517-2511-16-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1426893517-2511-1-git-send-email-mcgrof@do-not-panic.com>
References: <1426893517-2511-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Sadly this driver requires a bit of work in order
to use ioremap_wc() on the range currently used
for MTRR write-combining. We'd need to ensure two
ioremap() calls are done. Annotate this.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
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
Cc: venkatesh.pallipadi@intel.com
Cc: Stefan Bader <stefan.bader@canonical.com>
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
 drivers/media/pci/ivtv/ivtvfb.c | 51 +++++++++++------------------------------
 1 file changed, 14 insertions(+), 37 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 9ff1230..ceefa6f 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -44,10 +44,6 @@
 #include <linux/ivtvfb.h>
 #include <linux/slab.h>
 
-#ifdef CONFIG_MTRR
-#include <asm/mtrr.h>
-#endif
-
 #include "ivtv-driver.h"
 #include "ivtv-cards.h"
 #include "ivtv-i2c.h"
@@ -155,12 +151,11 @@ struct osd_info {
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
@@ -1099,6 +1094,8 @@ static int ivtvfb_init_vidmode(struct ivtv *itv)
 static int ivtvfb_init_io(struct ivtv *itv)
 {
 	struct osd_info *oi = itv->osd_info;
+	/* Find the largest power of two that maps the whole buffer */
+	int size_shift = 31;
 
 	mutex_lock(&itv->serialize_lock);
 	if (ivtv_init_on_first_open(itv)) {
@@ -1132,29 +1129,16 @@ static int ivtvfb_init_io(struct ivtv *itv)
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
+	oi->wc_cookie = __arch_phys_wc_add(oi->fb_start_aligned_physaddr,
+					   oi->fb_end_aligned_physaddr -
+					   oi->fb_start_aligned_physaddr);
 	/* Blank the entire osd. */
 	memset_io(oi->video_vbase, 0, oi->video_buffer_size);
 
@@ -1172,14 +1156,7 @@ static void ivtvfb_release_buffers (struct ivtv *itv)
 
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
-- 
2.3.2.209.gd67f9d5.dirty

