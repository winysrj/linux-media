Return-path: <linux-media-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51437 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbaFIK3d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jun 2014 06:29:33 -0400
Message-ID: <1402309768.17674.6.camel@jlt4.sipsolutions.net>
Subject: Re: non-working UVC device 058f:5608
From: Johannes Berg <johannes@sipsolutions.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Mathias Nyman <mathias.nyman@intel.com>
Date: Mon, 09 Jun 2014 12:29:28 +0200
In-Reply-To: <1402309657.17674.5.camel@jlt4.sipsolutions.net>
References: <1402177903.8442.9.camel@jlt4.sipsolutions.net>
	 <1404177.cR0nfxENUh@avalon> <1402299186.4148.3.camel@jlt4.sipsolutions.net>
	 <17531102.o7hyOUhSH7@avalon>
	 <1402307959.17674.3.camel@jlt4.sipsolutions.net>
	 <1402309657.17674.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2014-06-09 at 12:27 +0200, Johannes Berg wrote:

> Here we go - log + tracing:
> log: http://p.sipsolutions.net/d5926c43d531e3af.txt
> trace: http://johannes.sipsolutions.net/files/xhci.trace.dat.xz

Oh, and this was the kernel diff to commit
963649d735c8b6eb0f97e82c54f02426ff3f1f45:

diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
index eb009a4..00621cb 100644
--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -20,6 +20,8 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define DEBUG
+
 #include "xhci.h"
 
 #define XHCI_INIT_VALUE 0x0
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 6231ce6..70b09cd 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -20,6 +20,8 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define DEBUG
+
 
 #include <linux/slab.h>
 #include <asm/unaligned.h>
@@ -287,7 +289,7 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 		if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue) {
 			struct xhci_command *command;
 			command = xhci_alloc_command(xhci, false, false,
-						     GFP_NOIO);
+						     GFP_ATOMIC);
 			if (!command) {
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				xhci_free_command(xhci, cmd);
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 8056d90..2ceed51 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -20,6 +20,8 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define DEBUG
+
 #include <linux/usb.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
index 1eefc98..4b289d6 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -7,6 +7,8 @@
  * version 2 as published by the Free Software Foundation.
  */
 
+#define DEBUG
+
 #include <linux/io.h>
 #include <linux/mbus.h>
 #include <linux/of.h>
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index e20520f..aae5dc9 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -20,6 +20,8 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define DEBUG
+
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/module.h>
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 29d8adb..2149b0c 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -11,6 +11,8 @@
  * version 2 as published by the Free Software Foundation.
  */
 
+#define DEBUG
+
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d67ff71..a7eda28 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -64,6 +64,8 @@
  *   endpoint rings; it generates events on the event ring for these.
  */
 
+#define DEBUG
+
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include "xhci.h"
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2b8d9a2..fd350b7 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -20,6 +20,8 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define DEBUG
+
 #include <linux/pci.h>
 #include <linux/irq.h>
 #include <linux/log2.h>


johannes

