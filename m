Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f196.google.com ([209.85.216.196]:36342 "EHLO
	mail-qc0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbbFKUr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 16:47:28 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: bp@suse.de
Cc: mchehab@osg.samsung.com, tomi.valkeinen@ti.com,
	bhelgaas@google.com, luto@amacapital.net,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Doug Ledford <dledford@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Roland Dreier <roland@purestorage.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Juergen Gross <jgross@suse.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@redhat.com>,
	Antonino Daplas <adaplas@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <syrjala@sci.fi>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	konrad.wilk@oracle.com, ville.syrjala@linux.intel.com,
	jbeulich@suse.com, toshi.kani@hp.com,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	infinipath@intel.com, linux-fbdev@vger.kernel.org,
	xen-devel@lists.xensource.com
Subject: [PATCH v7 3/3] IB/ipath: use arch_phys_wc_add() and require PAT disabled
Date: Thu, 11 Jun 2015 13:19:54 -0700
Message-Id: <1434053994-2196-4-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1434053994-2196-1-git-send-email-mcgrof@do-not-panic.com>
References: <1434053994-2196-1-git-send-email-mcgrof@do-not-panic.com>
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

This is a worthy compromise given that the ipath device
driver powers the old HTX bus cards that only work in
AMD systems, while the newer IB/qib device driver
powers all PCI-e cards. The ipath device driver is
obsolete, hardware hard to find and because of this
this its a reasonable compromise to make to require
users of ipath to boot with nopat.

Acked-by: Doug Ledford <dledford@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Suresh Siddha <sbsiddha@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Juergen Gross <jgross@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Ville Syrjälä <syrjala@sci.fi>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Stefan Bader <stefan.bader@canonical.com>
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: Roger Pau Monné <roger.pau@citrix.com>
Cc: infinipath@intel.com
Cc: linux-rdma@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/infiniband/hw/ipath/Kconfig           |  3 ++
 drivers/infiniband/hw/ipath/ipath_driver.c    | 18 +++++++----
 drivers/infiniband/hw/ipath/ipath_kernel.h    |  4 +--
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c | 43 ++++++---------------------
 4 files changed, 26 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/Kconfig b/drivers/infiniband/hw/ipath/Kconfig
index 1d9bb11..8fe54ff 100644
--- a/drivers/infiniband/hw/ipath/Kconfig
+++ b/drivers/infiniband/hw/ipath/Kconfig
@@ -9,3 +9,6 @@ config INFINIBAND_IPATH
 	as IP-over-InfiniBand as well as with userspace applications
 	(in conjunction with InfiniBand userspace access).
 	For QLogic PCIe QLE based cards, use the QIB driver instead.
+
+	If you have this hardware you will need to boot with PAT disabled
+	on your x86-64 systems, use the nopat kernel parameter.
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index bd0caed..2d7e503 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -42,6 +42,9 @@
 #include <linux/bitmap.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#ifdef CONFIG_X86_64
+#include <asm/pat.h>
+#endif
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
@@ -395,6 +398,14 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	unsigned long long addr;
 	u32 bar0 = 0, bar1 = 0;
 
+#ifdef CONFIG_X86_64
+	if (WARN(pat_enabled(),
+		 "ipath needs PAT disabled, boot with nopat kernel parameter\n")) {
+		ret = -ENODEV;
+		goto bail;
+	}
+#endif
+
 	dd = ipath_alloc_devdata(pdev);
 	if (IS_ERR(dd)) {
 		ret = PTR_ERR(dd);
@@ -542,6 +553,7 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dd->ipath_kregbase = __ioremap(addr, len,
 		(_PAGE_NO_CACHE|_PAGE_WRITETHRU));
 #else
+	/* XXX: split this properly to enable on PAT */
 	dd->ipath_kregbase = ioremap_nocache(addr, len);
 #endif
 
@@ -587,12 +599,8 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = ipath_enable_wc(dd);
 
-	if (ret) {
-		ipath_dev_err(dd, "Write combining not enabled "
-			      "(err %d): performance may be poor\n",
-			      -ret);
+	if (ret)
 		ret = 0;
-	}
 
 	ipath_verify_pioperf(dd);
 
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index e08db70..f0f9471 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -463,9 +463,7 @@ struct ipath_devdata {
 	/* offset in HT config space of slave/primary interface block */
 	u8 ipath_ht_slave_off;
 	/* for write combining settings */
-	unsigned long ipath_wc_cookie;
-	unsigned long ipath_wc_base;
-	unsigned long ipath_wc_len;
+	int wc_cookie;
 	/* ref count for each pkey */
 	atomic_t ipath_pkeyrefs[4];
 	/* shadow copy of struct page *'s for exp tid pages */
diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
index 70c1f3a..7b6e4c8 100644
--- a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
+++ b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
@@ -37,7 +37,6 @@
  */
 
 #include <linux/pci.h>
-#include <asm/mtrr.h>
 #include <asm/processor.h>
 
 #include "ipath_kernel.h"
@@ -122,27 +121,14 @@ int ipath_enable_wc(struct ipath_devdata *dd)
 	}
 
 	if (!ret) {
-		int cookie;
-		ipath_cdbg(VERBOSE, "Setting mtrr for chip to WC "
-			   "(addr %llx, len=0x%llx)\n",
-			   (unsigned long long) pioaddr,
-			   (unsigned long long) piolen);
-		cookie = mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
-		if (cookie < 0) {
-			{
-				dev_info(&dd->pcidev->dev,
-					 "mtrr_add()  WC for PIO bufs "
-					 "failed (%d)\n",
-					 cookie);
-				ret = -EINVAL;
-			}
-		} else {
-			ipath_cdbg(VERBOSE, "Set mtrr for chip to WC, "
-				   "cookie is %d\n", cookie);
-			dd->ipath_wc_cookie = cookie;
-			dd->ipath_wc_base = (unsigned long) pioaddr;
-			dd->ipath_wc_len = (unsigned long) piolen;
-		}
+		dd->wc_cookie = arch_phys_wc_add(pioaddr, piolen);
+		if (dd->wc_cookie < 0) {
+			ipath_dev_err(dd, "Seting mtrr failed on PIO buffers\n");
+			ret = -ENODEV;
+		} else if (dd->wc_cookie == 0)
+			ipath_cdbg(VERBOSE, "Set mtrr for chip to WC not needed\n");
+		else
+			ipath_cdbg(VERBOSE, "Set mtrr for chip to WC\n");
 	}
 
 	return ret;
@@ -154,16 +140,5 @@ int ipath_enable_wc(struct ipath_devdata *dd)
  */
 void ipath_disable_wc(struct ipath_devdata *dd)
 {
-	if (dd->ipath_wc_cookie) {
-		int r;
-		ipath_cdbg(VERBOSE, "undoing WCCOMB on pio buffers\n");
-		r = mtrr_del(dd->ipath_wc_cookie, dd->ipath_wc_base,
-			     dd->ipath_wc_len);
-		if (r < 0)
-			dev_info(&dd->pcidev->dev,
-				 "mtrr_del(%lx, %lx, %lx) failed: %d\n",
-				 dd->ipath_wc_cookie, dd->ipath_wc_base,
-				 dd->ipath_wc_len, r);
-		dd->ipath_wc_cookie = 0; /* even on failure */
-	}
+	arch_phys_wc_del(dd->wc_cookie);
 }
-- 
2.3.2.209.gd67f9d5.dirty

