Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49105 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753282AbdCFOY5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:24:57 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 28/29] drivers: convert sbd_duart.map_guard from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:15 +0200
Message-Id: <1488810076-3754-29-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/tty/serial/sb1250-duart.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/sb1250-duart.c b/drivers/tty/serial/sb1250-duart.c
index 771f361..041625c 100644
--- a/drivers/tty/serial/sb1250-duart.c
+++ b/drivers/tty/serial/sb1250-duart.c
@@ -41,7 +41,7 @@
 #include <linux/tty_flip.h>
 #include <linux/types.h>
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <asm/io.h>
 #include <asm/war.h>
 
@@ -103,7 +103,7 @@ struct sbd_port {
 struct sbd_duart {
 	struct sbd_port		sport[2];
 	unsigned long		mapctrl;
-	atomic_t		map_guard;
+	refcount_t		map_guard;
 };
 
 #define to_sport(uport) container_of(uport, struct sbd_port, port)
@@ -654,15 +654,13 @@ static void sbd_release_port(struct uart_port *uport)
 {
 	struct sbd_port *sport = to_sport(uport);
 	struct sbd_duart *duart = sport->duart;
-	int map_guard;
 
 	iounmap(sport->memctrl);
 	sport->memctrl = NULL;
 	iounmap(uport->membase);
 	uport->membase = NULL;
 
-	map_guard = atomic_add_return(-1, &duart->map_guard);
-	if (!map_guard)
+	if(refcount_dec_and_test(&duart->map_guard))
 		release_mem_region(duart->mapctrl, DUART_CHANREG_SPACING);
 	release_mem_region(uport->mapbase, DUART_CHANREG_SPACING);
 }
@@ -698,7 +696,6 @@ static int sbd_request_port(struct uart_port *uport)
 {
 	const char *err = KERN_ERR "sbd: Unable to reserve MMIO resource\n";
 	struct sbd_duart *duart = to_sport(uport)->duart;
-	int map_guard;
 	int ret = 0;
 
 	if (!request_mem_region(uport->mapbase, DUART_CHANREG_SPACING,
@@ -706,11 +703,11 @@ static int sbd_request_port(struct uart_port *uport)
 		printk(err);
 		return -EBUSY;
 	}
-	map_guard = atomic_add_return(1, &duart->map_guard);
-	if (map_guard == 1) {
+	refcount_inc(&duart->map_guard);
+	if (refcount_read(&duart->map_guard) == 1) {
 		if (!request_mem_region(duart->mapctrl, DUART_CHANREG_SPACING,
 					"sb1250-duart")) {
-			atomic_add(-1, &duart->map_guard);
+			refcount_dec(&duart->map_guard);
 			printk(err);
 			ret = -EBUSY;
 		}
@@ -718,8 +715,7 @@ static int sbd_request_port(struct uart_port *uport)
 	if (!ret) {
 		ret = sbd_map_port(uport);
 		if (ret) {
-			map_guard = atomic_add_return(-1, &duart->map_guard);
-			if (!map_guard)
+			if (refcount_dec_and_test(&duart->map_guard))
 				release_mem_region(duart->mapctrl,
 						   DUART_CHANREG_SPACING);
 		}
-- 
2.7.4
