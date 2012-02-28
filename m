Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:59896 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab2B1BX1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 20:23:27 -0500
Received: from pannekake.samfundet.no ([2001:700:300:1800::dddd] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1S2BTX-0000A1-D2
	for linux-media@vger.kernel.org; Tue, 28 Feb 2012 02:03:33 +0100
Received: from sesse by pannekake.samfundet.no with local (Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1S2BTW-0004wp-T5
	for linux-media@vger.kernel.org; Tue, 28 Feb 2012 02:03:31 +0100
Date: Tue, 28 Feb 2012 02:03:30 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Various nits, fixes and hacks for mantis CA support on SMP
Message-ID: <20120228010330.GA25786@uio.no>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

This patch, against 3.3-rc4, is basically a conglomerate of patches that
together seem to make CA support on mantis working and stable, even on SMP
systems. (I'm using a Terratec Cinergy DVB-S2 card with a Conax CAM, with
mumudvb as userspace.) There are a few fixes from this mailing list and some
of my own; the end result is too ugly to include, and there are still things
I don't understand at all, but I hope it can be useful for some.

Below is the list of what the patch does:

 - I've followed the instructions from some post on this mailing list
   to enable CAM support in the first place (mantis_set_direction move
   to mantis_pci.c, uncomment mantis_ca_init).

 - The MANTIS_GPIF_STATUS fix from http://patchwork.linuxtv.org/patch/8776/.
   Not that it seems to change a lot for me, but it makes sense.

 - I've fixed a ton of SMP-related bugs. Basically a lot of the members of
   mantis_ca were accessed from several threads without a mutex, which is a
   big no-no; I've mostly changed to using atomic operations here, although
   I also added some locks were it made sense (e.g. when resetting the CAM).
   The ca_lock is replaced by a more general int_stat_lock, which ideally
   is held when banging on MANTIS_INT_STAT. (I have no hardware
   documentation, so I'm afraid I don't really know the specifics here.)

 - mantis_hif_write_wait() would never clear MANTIS_SBUF_OPDONE_BIT,
   leading to a lot of operations never actually waiting for the callback.
   I've added many such fixes, as well as debugging output when the
   bit is in a surprising state (e.g., MANTIS_SBUF_OPDONE_BIT set before the
   beginning of an operation, where it really should be cleared).

 - Some operations check for timeout by testing if wait_event_timeout()
   return -ERESTARTSYS. However, wait_event_timeout() can can never
   do this; the return value for timeout is zero. I've fixed this
   (well, I seemingly forgot one; have to do that in the next version :-) ).
   Unfortunately, this make the problems in the next point a _lot_ worse,
   since timeouts are now actually percolated up the stack.

 - As others have noticed, sometimes, especially during DMA transfers,
   the IRQ0 flag is never properly set and thus reads never return.
   (The typical case for this is when we've just done a write and the
   en50221 thread is waiting for the CAM status word to signal STATUSREG_DA;
   if this doesn't happen in a reasonable amount of time, the upstream
   libdvben50221.so will report errors back to mumudvb.) I have no idea why
   this happens more often on SMP systems than on UMP systems, but they
   really seem to do. I haven't found any reasonable workaround for reliable
   polling either, so I'm making a hack -- if there's nothing returned in two
   milliseconds, the read is simply assumed to have completed. This is an
   unfortunate hack, but in practice it's identical to the previous behavior
   except with a shorter timeout.

 - A hack to fix a mutex issue in the DVB layer; dvb_usercopy(), which is
   called on all ioctls, not only copies data to and from userspace,
   but also takes a lock on the file descriptor, which means that only one ioctl 
   can run at a time. This means that if one thread of mumudvb is busy trying
   to get, say, the SNR from the frontend (which can hang due to the issue
   above), the CAM thread's ioctl(fd, CA_GET_SLOT_INFO, ...) will hang,
   even though it doesn't need to communicate with the hardware at all.
   This obviously requires a better fix, but I don't know the generic DVB
   layer well enough to say what it is. Maybe it's some sort of remnant
   of from when all ioctl()s took the BKL. Note that on UMP kernels without
   preemption, mutex_lock is to the best of my knowledge a no-op, so these
   delay issues would not show up on non-SMP.

 - Tiny cleanups: Removed some unused mmread()s and structure members.
   Some debugging messages have been made more specific or clearer
   (e.g. reads say what address they're from, the I2C subsystem reports
   if there were any timeouts, the interrupt handler properly clears
   the RISC status word so it isn't shown as <Unknown>).

I'm still not happy with the bit-banging on the I2C interface (as opposed to
dealing with it in the interrupt handler); I long suspected it for causing
the IRQ0 problems, especially as they seem to have a sort-of similar issue
with I2CDONE/I2CRACk never being set, but it seem the DMA transfers is really
what causes it somehow, so I've left it alone.

Anyway, if there are specific pieces people want me to split out for
mainline, I'd be happy to do that and add the required Signed-Off-By lines
etc. Let me know.

/* Steinar */
-- 
Homepage: http://www.sesse.net/

--IS0zKkzwUGydFO0o
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="mantis-ca-various-hacks.diff"

diff -ur orig/linux-3.3-rc4/drivers/media/dvb/dvb-core/dvbdev.c linux-3.3-rc4/drivers/media/dvb/dvb-core/dvbdev.c
--- orig/linux-3.3-rc4/drivers/media/dvb/dvb-core/dvbdev.c	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/dvb-core/dvbdev.c	2012-02-28 00:35:15.824921790 +0100
@@ -417,10 +417,10 @@
 	}
 
 	/* call driver */
-	mutex_lock(&dvbdev_mutex);
+//	mutex_lock(&dvbdev_mutex);
 	if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
 		err = -EINVAL;
-	mutex_unlock(&dvbdev_mutex);
+//	mutex_unlock(&dvbdev_mutex);
 
 	if (err < 0)
 		goto out;
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_ca.c linux-3.3-rc4/drivers/media/dvb/mantis/mantis_ca.c
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_ca.c	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_ca.c	2012-02-26 18:10:44.984296151 +0100
@@ -34,6 +34,7 @@
 #include "mantis_link.h"
 #include "mantis_hif.h"
 #include "mantis_reg.h"
+#include "mantis_pci.h"
 
 #include "mantis_ca.h"
 
@@ -95,11 +96,25 @@
 	struct mantis_pci *mantis = ca->ca_priv;
 
 	dprintk(MANTIS_DEBUG, 1, "Slot(%d): Slot RESET", slot);
+	mutex_lock(&mantis->int_stat_lock);
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Slot(%d): Reset operation done before it started!", slot);
+	}
 	udelay(500); /* Wait.. */
 	mmwrite(0xda, MANTIS_PCMCIA_RESET); /* Leading edge assert */
 	udelay(500);
 	mmwrite(0x00, MANTIS_PCMCIA_RESET); /* Trailing edge deassert */
 	msleep(1000);
+
+	if (wait_event_timeout(ca->hif_opdone_wq,
+			       test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event),
+			       msecs_to_jiffies(500)) == -ERESTARTSYS) {
+
+		dprintk(MANTIS_ERROR, 1, "Slot(%d): Reset timeout!", slot);
+	} else {
+		dprintk(MANTIS_DEBUG, 1, "Slot(%d): Reset complete", slot);
+	}
+	mutex_unlock(&mantis->int_stat_lock);
 	dvb_ca_en50221_camready_irq(&ca->en50221, 0);
 
 	return 0;
@@ -111,6 +126,7 @@
 	struct mantis_pci *mantis = ca->ca_priv;
 
 	dprintk(MANTIS_DEBUG, 1, "Slot(%d): Slot shutdown", slot);
+	mantis_set_direction(mantis, 0);  /* Disable TS through CAM */
 
 	return 0;
 }
@@ -121,7 +137,7 @@
 	struct mantis_pci *mantis = ca->ca_priv;
 
 	dprintk(MANTIS_DEBUG, 1, "Slot(%d): TS control", slot);
-/*	mantis_set_direction(mantis, 1); */ /* Enable TS through CAM */
+	mantis_set_direction(mantis, 1);  /* Enable TS through CAM */
 
 	return 0;
 }
@@ -172,8 +188,6 @@
 	ca->en50221.poll_slot_status	= mantis_slot_status;
 	ca->en50221.data		= ca;
 
-	mutex_init(&ca->ca_lock);
-
 	init_waitqueue_head(&ca->hif_data_wq);
 	init_waitqueue_head(&ca->hif_opdone_wq);
 	init_waitqueue_head(&ca->hif_write_wq);
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_cards.c linux-3.3-rc4/drivers/media/dvb/mantis/mantis_cards.c
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_cards.c	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_cards.c	2012-02-28 00:44:39.252853492 +0100
@@ -73,7 +73,7 @@
 
 static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 {
-	u32 stat = 0, mask = 0, lstat = 0;
+	u32 stat = 0, mask = 0;
 	u32 rst_stat = 0, rst_mask = 0;
 
 	struct mantis_pci *mantis;
@@ -88,19 +88,9 @@
 
 	stat = mmread(MANTIS_INT_STAT);
 	mask = mmread(MANTIS_INT_MASK);
-	lstat = stat & ~MANTIS_INT_RISCSTAT;
 	if (!(stat & mask))
 		return IRQ_NONE;
 
-	rst_mask  = MANTIS_GPIF_WRACK  |
-		    MANTIS_GPIF_OTHERR |
-		    MANTIS_SBUF_WSTO   |
-		    MANTIS_GPIF_EXTIRQ;
-
-	rst_stat  = mmread(MANTIS_GPIF_STATUS);
-	rst_stat &= rst_mask;
-	mmwrite(rst_stat, MANTIS_GPIF_STATUS);
-
 	mantis->mantis_int_stat = stat;
 	mantis->mantis_int_mask = mask;
 	dprintk(MANTIS_DEBUG, 0, "\n-- Stat=<%02x> Mask=<%02x> --", stat, mask);
@@ -109,6 +99,15 @@
 	}
 	if (stat & MANTIS_INT_IRQ0) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[1]);
+
+		rst_mask  = MANTIS_GPIF_WRACK  |
+			MANTIS_GPIF_OTHERR |
+			MANTIS_SBUF_WSTO   |
+			MANTIS_GPIF_EXTIRQ;
+
+		rst_stat  = mmread(MANTIS_GPIF_STATUS);
+		mmwrite(rst_stat & rst_mask, MANTIS_GPIF_STATUS);
+
 		mantis->gpif_status = rst_stat;
 		wake_up(&ca->hif_write_wq);
 		schedule_work(&ca->hif_evm_work);
@@ -142,7 +141,8 @@
 		wake_up(&mantis->i2c_wq);
 	}
 	mmwrite(stat, MANTIS_INT_STAT);
-	stat &= ~(MANTIS_INT_RISCEN   | MANTIS_INT_I2CDONE |
+	stat &= ~(MANTIS_INT_RISCSTAT |
+	          MANTIS_INT_RISCEN   | MANTIS_INT_I2CDONE |
 		  MANTIS_INT_I2CRACK  | MANTIS_INT_PCMCIA7 |
 		  MANTIS_INT_PCMCIA6  | MANTIS_INT_PCMCIA5 |
 		  MANTIS_INT_PCMCIA4  | MANTIS_INT_PCMCIA3 |
@@ -179,6 +179,7 @@
 	config			= (struct mantis_hwconfig *) pci_id->driver_data;
 	config->irq_handler	= &mantis_irq_handler;
 	mantis->hwconfig	= config;
+	mutex_init(&mantis->int_stat_lock);
 
 	err = mantis_pci_init(mantis);
 	if (err) {
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_common.h linux-3.3-rc4/drivers/media/dvb/mantis/mantis_common.h
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_common.h	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_common.h	2012-02-26 18:09:36.904298348 +0100
@@ -161,9 +161,10 @@
 	 /*	A12 A13 A14		*/
 	u32			gpio_status;
 
-	u32			gpif_status;
+	volatile unsigned long	gpif_status;
 
 	struct mantis_ca	*mantis_ca;
+	struct mutex		int_stat_lock;
 
 	wait_queue_head_t	uart_wq;
 	struct work_struct	uart_work;
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_core.c linux-3.3-rc4/drivers/media/dvb/mantis/mantis_core.c
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_core.c	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_core.c	2012-02-22 13:10:59.449330922 +0100
@@ -213,23 +213,3 @@
 	udelay(100);
 }
 
-/* direction = 0 , no CI passthrough ; 1 , CI passthrough */
-void mantis_set_direction(struct mantis_pci *mantis, int direction)
-{
-	u32 reg;
-
-	reg = mmread(0x28);
-	dprintk(verbose, MANTIS_DEBUG, 1, "TS direction setup");
-	if (direction == 0x01) {
-		/* to CI */
-		reg |= 0x04;
-		mmwrite(reg, 0x28);
-		reg &= 0xff - 0x04;
-		mmwrite(reg, 0x28);
-	} else {
-		reg &= 0xff - 0x04;
-		mmwrite(reg, 0x28);
-		reg |= 0x04;
-		mmwrite(reg, 0x28);
-	}
-}
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_dvb.c linux-3.3-rc4/drivers/media/dvb/mantis/mantis_dvb.c
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_dvb.c	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_dvb.c	2012-02-22 13:10:59.449330922 +0100
@@ -239,6 +239,8 @@
 				mantis->fe = NULL;
 				goto err5;
 			}
+
+			mantis_ca_init(mantis);
 		}
 	}
 
@@ -274,7 +276,6 @@
 	int err;
 
 	if (mantis->fe) {
-		/* mantis_ca_exit(mantis); */
 		err = mantis_frontend_shutdown(mantis);
 		if (err != 0)
 			dprintk(MANTIS_ERROR, 1, "Frontend exit while POWER ON! <%d>", err);
@@ -282,6 +283,7 @@
 		dvb_frontend_detach(mantis->fe);
 	}
 
+	mantis_ca_exit(mantis);
 	tasklet_kill(&mantis->tasklet);
 	dvb_net_release(&mantis->dvbnet);
 
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_evm.c linux-3.3-rc4/drivers/media/dvb/mantis/mantis_evm.c
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_evm.c	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_evm.c	2012-02-27 00:25:26.504654570 +0100
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 
+#include <linux/atomic.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
@@ -41,10 +42,7 @@
 	struct mantis_ca *ca = container_of(work, struct mantis_ca, hif_evm_work);
 	struct mantis_pci *mantis = ca->ca_priv;
 
-	u32 gpif_stat, gpif_mask;
-
-	gpif_stat = mmread(MANTIS_GPIF_STATUS);
-	gpif_mask = mmread(MANTIS_GPIF_IRQCFG);
+	u32 gpif_stat = mmread(MANTIS_GPIF_STATUS);
 
 	if (gpif_stat & MANTIS_GPIF_DETSTAT) {
 		if (gpif_stat & MANTIS_CARD_PLUGIN) {
@@ -66,13 +64,13 @@
 		}
 	}
 
-	if (mantis->gpif_status & MANTIS_GPIF_EXTIRQ)
+	if (gpif_stat & MANTIS_GPIF_EXTIRQ)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Ext IRQ", mantis->num);
 
-	if (mantis->gpif_status & MANTIS_SBUF_WSTO)
+	if (gpif_stat & MANTIS_SBUF_WSTO)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Smart Buffer Timeout", mantis->num);
 
-	if (mantis->gpif_status & MANTIS_GPIF_OTHERR)
+	if (gpif_stat & MANTIS_GPIF_OTHERR)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Alignment Error", mantis->num);
 
 	if (gpif_stat & MANTIS_SBUF_OVFLW)
@@ -87,10 +85,13 @@
 	if (gpif_stat & MANTIS_SBUF_EMPTY)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Smart Buffer Empty", mantis->num);
 
-	if (gpif_stat & MANTIS_SBUF_OPDONE) {
+	if (gpif_stat & MANTIS_SBUF_OPDONE)
 		dprintk(MANTIS_DEBUG, 1, "Event Mgr: Adapter(%d) Slot(0): Smart Buffer operation complete", mantis->num);
-		ca->sbuf_status = MANTIS_SBUF_DATA_AVAIL;
-		ca->hif_event = MANTIS_SBUF_OPDONE;
+
+	if (gpif_stat & MANTIS_SBUF_OPDONE) {
+		if (test_and_set_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+			dprintk(MANTIS_NOTICE, 1, "Operation done, but SBUF_OPDONE bit was already set!");
+		}
 		wake_up(&ca->hif_opdone_wq);
 	}
 }
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_hif.c linux-3.3-rc4/drivers/media/dvb/mantis/mantis_hif.c
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_hif.c	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_hif.c	2012-02-28 01:11:12.884867698 +0100
@@ -22,6 +22,7 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 
+#include <linux/atomic.h>
 #include <linux/interrupt.h>
 #include <asm/io.h>
 
@@ -44,44 +45,51 @@
 	struct mantis_pci *mantis = ca->ca_priv;
 	int rc = 0;
 
+	/*
+	 * HACK: Sometimes, especially during DMA transfers, and especially on
+	 * SMP systems (!), the IRQ-0 flag is never set, or at least we don't get it
+	 * (could it be that we're clearing it?). Thus, simply wait for 2 ms and then
+	 * assume we got an answer even if we didn't. This works around lots of CA
+	 * timeouts. The code with 500 ms wait and -EREMOTEIO is technically the
+	 * correct one, though.
+	 */
+#if 1
 	if (wait_event_timeout(ca->hif_opdone_wq,
-			       ca->hif_event & MANTIS_SBUF_OPDONE,
-			       msecs_to_jiffies(500)) == -ERESTARTSYS) {
+			       test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event),
+			       msecs_to_jiffies(2)) == 0) {
+
+		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Smart buffer operation timeout ! (ignoring)", mantis->num);
+	}
+#else
+	if (wait_event_timeout(ca->hif_opdone_wq,
+			       test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event),
+			       msecs_to_jiffies(500)) == 0) {
 
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Smart buffer operation timeout !", mantis->num);
 		rc = -EREMOTEIO;
 	}
+#endif
 	dprintk(MANTIS_DEBUG, 1, "Smart Buffer Operation complete");
-	ca->hif_event &= ~MANTIS_SBUF_OPDONE;
 	return rc;
 }
 
 static int mantis_hif_write_wait(struct mantis_ca *ca)
 {
 	struct mantis_pci *mantis = ca->ca_priv;
-	u32 opdone = 0, timeout = 0;
 	int rc = 0;
 
 	if (wait_event_timeout(ca->hif_write_wq,
-			       mantis->gpif_status & MANTIS_GPIF_WRACK,
-			       msecs_to_jiffies(500)) == -ERESTARTSYS) {
+			       test_and_clear_bit(MANTIS_GPIF_WRACK_BIT, &mantis->gpif_status),
+			       msecs_to_jiffies(500)) == 0) {
 
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Write ACK timed out !", mantis->num);
 		rc = -EREMOTEIO;
 	}
 	dprintk(MANTIS_DEBUG, 1, "Write Acknowledged");
-	mantis->gpif_status &= ~MANTIS_GPIF_WRACK;
-	while (!opdone) {
-		opdone = (mmread(MANTIS_GPIF_STATUS) & MANTIS_SBUF_OPDONE);
-		udelay(500);
-		timeout++;
-		if (timeout > 100) {
-			dprintk(MANTIS_ERROR, 1, "Adater(%d) Slot(0): Write operation timed out!", mantis->num);
-			rc = -ETIMEDOUT;
-			break;
-		}
+	if (mantis_hif_sbuf_opdone_wait(ca) != 0) {
+		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): Write operation timeout !", mantis->num);
+		rc = -ETIMEDOUT;
 	}
-	dprintk(MANTIS_DEBUG, 1, "HIF Write success");
 	return rc;
 }
 
@@ -91,8 +99,12 @@
 	struct mantis_pci *mantis = ca->ca_priv;
 	u32 hif_addr = 0, data, count = 4;
 
-	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF Mem Read", mantis->num);
-	mutex_lock(&ca->ca_lock);
+	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF Mem Read of 0x%x", mantis->num, addr);
+	mutex_lock(&mantis->int_stat_lock);
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Adapter(%d) Slot(0): Read operation done before it started!", mantis->num);
+	}
+
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAIOM;
 	hif_addr |=  MANTIS_HIF_STATUS;
@@ -100,17 +112,17 @@
 
 	mmwrite(hif_addr, MANTIS_GPIF_BRADDR);
 	mmwrite(count, MANTIS_GPIF_BRBYTES);
-	udelay(20);
+	udelay(100);
 	mmwrite(hif_addr | MANTIS_GPIF_HIFRDWRN, MANTIS_GPIF_ADDR);
 
 	if (mantis_hif_sbuf_opdone_wait(ca) != 0) {
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): GPIF Smart Buffer operation failed", mantis->num);
-		mutex_unlock(&ca->ca_lock);
+		mutex_unlock(&mantis->int_stat_lock);
 		return -EREMOTEIO;
 	}
 	data = mmread(MANTIS_GPIF_DIN);
-	mutex_unlock(&ca->ca_lock);
-	dprintk(MANTIS_DEBUG, 1, "Mem Read: 0x%02x", data);
+	mutex_unlock(&mantis->int_stat_lock);
+	dprintk(MANTIS_DEBUG, 1, "Mem Read: 0x%02x from 0x%02x", data, addr);
 	return (data >> 24) & 0xff;
 }
 
@@ -121,7 +133,10 @@
 	u32 hif_addr = 0;
 
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF Mem Write", mantis->num);
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Adapter(%d) Slot(0): Write operation done before it started!", mantis->num);
+	}
 	hif_addr &= ~MANTIS_GPIF_HIFRDWRN;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_PCMCIAIOM;
@@ -134,11 +149,11 @@
 
 	if (mantis_hif_write_wait(ca) != 0) {
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): HIF Smart Buffer operation failed", mantis->num);
-		mutex_unlock(&ca->ca_lock);
+		mutex_unlock(&mantis->int_stat_lock);
 		return -EREMOTEIO;
 	}
 	dprintk(MANTIS_DEBUG, 1, "Mem Write: (0x%02x to 0x%02x)", data, addr);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	return 0;
 }
@@ -148,8 +163,11 @@
 	struct mantis_pci *mantis = ca->ca_priv;
 	u32 data, hif_addr = 0;
 
-	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF I/O Read", mantis->num);
-	mutex_lock(&ca->ca_lock);
+	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF I/O Read of 0x%x", mantis->num, addr);
+	mutex_lock(&mantis->int_stat_lock);
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Adapter(%d) Slot(0): I/O read operation done before it started!", mantis->num);
+	}
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr |=  MANTIS_GPIF_PCMCIAIOM;
 	hif_addr |=  MANTIS_HIF_STATUS;
@@ -162,13 +180,13 @@
 
 	if (mantis_hif_sbuf_opdone_wait(ca) != 0) {
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): HIF Smart Buffer operation failed", mantis->num);
-		mutex_unlock(&ca->ca_lock);
+		mutex_unlock(&mantis->int_stat_lock);
 		return -EREMOTEIO;
 	}
 	data = mmread(MANTIS_GPIF_DIN);
-	dprintk(MANTIS_DEBUG, 1, "I/O Read: 0x%02x", data);
+	dprintk(MANTIS_DEBUG, 1, "I/O Read: 0x%02x from 0x%02x", data, addr);
 	udelay(50);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	return (u8) data;
 }
@@ -179,7 +197,10 @@
 	u32 hif_addr = 0;
 
 	dprintk(MANTIS_DEBUG, 1, "Adapter(%d) Slot(0): Request HIF I/O Write", mantis->num);
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
+	if (test_and_clear_bit(MANTIS_SBUF_OPDONE_BIT, &ca->hif_event)) {
+		dprintk(MANTIS_NOTICE, 1, "Adapter(%d) Slot(0): I/O write operation done before it started!", mantis->num);
+	}
 	hif_addr &= ~MANTIS_GPIF_PCMCIAREG;
 	hif_addr &= ~MANTIS_GPIF_HIFRDWRN;
 	hif_addr |=  MANTIS_GPIF_PCMCIAIOM;
@@ -191,11 +212,11 @@
 
 	if (mantis_hif_write_wait(ca) != 0) {
 		dprintk(MANTIS_ERROR, 1, "Adapter(%d) Slot(0): HIF Smart Buffer operation failed", mantis->num);
-		mutex_unlock(&ca->ca_lock);
+		mutex_unlock(&mantis->int_stat_lock);
 		return -EREMOTEIO;
 	}
 	dprintk(MANTIS_DEBUG, 1, "I/O Write: (0x%02x to 0x%02x)", data, addr);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 	udelay(50);
 
 	return 0;
@@ -210,7 +231,7 @@
 	slot[0].slave_cfg = 0x70773028;
 	dprintk(MANTIS_ERROR, 1, "Adapter(%d) Initializing Mantis Host Interface", mantis->num);
 
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
 	irqcfg = mmread(MANTIS_GPIF_IRQCFG);
 	irqcfg = MANTIS_MASK_BRRDY	|
 		 MANTIS_MASK_WRACK	|
@@ -220,7 +241,7 @@
 		 MANTIS_MASK_OVFLW;
 
 	mmwrite(irqcfg, MANTIS_GPIF_IRQCFG);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	return 0;
 }
@@ -231,9 +252,9 @@
 	u32 irqcfg;
 
 	dprintk(MANTIS_ERROR, 1, "Adapter(%d) Exiting Mantis Host Interface", mantis->num);
-	mutex_lock(&ca->ca_lock);
+	mutex_lock(&mantis->int_stat_lock);
 	irqcfg = mmread(MANTIS_GPIF_IRQCFG);
 	irqcfg &= ~MANTIS_MASK_BRRDY;
 	mmwrite(irqcfg, MANTIS_GPIF_IRQCFG);
-	mutex_unlock(&ca->ca_lock);
+	mutex_unlock(&mantis->int_stat_lock);
 }
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_i2c.c linux-3.3-rc4/drivers/media/dvb/mantis/mantis_i2c.c
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_i2c.c	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_i2c.c	2012-02-28 00:45:59.556855037 +0100
@@ -38,6 +38,7 @@
 static int mantis_i2c_read(struct mantis_pci *mantis, const struct i2c_msg *msg)
 {
 	u32 rxd, i, stat, trials;
+	u32 timeouts = 0;
 
 	dprintk(MANTIS_INFO, 0, "        %s:  Address=[0x%02x] <R>[ ",
 		__func__, msg->addr);
@@ -51,6 +52,8 @@
 		if (i == (msg->len - 1))
 			rxd &= ~MANTIS_I2C_STOP;
 
+		//mutex_lock(&mantis->int_stat_lock);
+
 		mmwrite(MANTIS_INT_I2CDONE, MANTIS_INT_STAT);
 		mmwrite(rxd, MANTIS_I2CDATA_CTL);
 
@@ -60,6 +63,9 @@
 			if (stat & MANTIS_INT_I2CDONE)
 				break;
 		}
+		if (trials == TRIALS) {
+			++timeouts;
+		}
 
 		dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
 
@@ -69,14 +75,23 @@
 			if (stat & MANTIS_INT_I2CRACK)
 				break;
 		}
+		if (trials == TRIALS) {
+			++timeouts;
+		}
 
 		dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
 
 		rxd = mmread(MANTIS_I2CDATA_CTL);
 		msg->buf[i] = (u8)((rxd >> 8) & 0xFF);
 		dprintk(MANTIS_INFO, 0, "%02x ", msg->buf[i]);
+
+		//mutex_unlock(&mantis->int_stat_lock);
+	}
+	if (timeouts) {
+		dprintk(MANTIS_INFO, 0, "] %d timeouts\n", timeouts);
+	} else {
+		dprintk(MANTIS_INFO, 0, "]\n");
 	}
-	dprintk(MANTIS_INFO, 0, "]\n");
 
 	return 0;
 }
@@ -85,6 +100,7 @@
 {
 	int i;
 	u32 txd = 0, stat, trials;
+	u32 timeouts = 0;
 
 	dprintk(MANTIS_INFO, 0, "        %s: Address=[0x%02x] <W>[ ",
 		__func__, msg->addr);
@@ -99,6 +115,8 @@
 		if (i == (msg->len - 1))
 			txd &= ~MANTIS_I2C_STOP;
 
+		//mutex_lock(&mantis->int_stat_lock);
+
 		mmwrite(MANTIS_INT_I2CDONE, MANTIS_INT_STAT);
 		mmwrite(txd, MANTIS_I2CDATA_CTL);
 
@@ -108,6 +126,9 @@
 			if (stat & MANTIS_INT_I2CDONE)
 				break;
 		}
+		if (trials == TRIALS) {
+			++timeouts;
+		}
 
 		dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
 
@@ -117,10 +138,19 @@
 			if (stat & MANTIS_INT_I2CRACK)
 				break;
 		}
+		if (trials == TRIALS) {
+			++timeouts;
+		}
 
 		dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
+
+		//mutex_unlock(&mantis->int_stat_lock);
+	}
+	if (timeouts) {
+		dprintk(MANTIS_INFO, 0, "] %d timeouts\n", timeouts);
+	} else {
+		dprintk(MANTIS_INFO, 0, "]\n");
 	}
-	dprintk(MANTIS_INFO, 0, "]\n");
 
 	return 0;
 }
@@ -154,6 +184,8 @@
 			txd = msgs[i].addr << 25 | (0x1 << 24)
 						 | (msgs[i].buf[0] << 16)
 						 | MANTIS_I2C_RATE_3;
+		
+			//mutex_lock(&mantis->int_stat_lock);
 
 			mmwrite(txd, MANTIS_I2CDATA_CTL);
 			/* wait for xfer completion */
@@ -183,6 +215,8 @@
 				break;
 			}
 			i += 2; /* Write/Read operation in one go */
+
+			//mutex_unlock(&mantis->int_stat_lock);
 		}
 
 		if (i < num) {
@@ -241,12 +275,14 @@
 
 	dprintk(MANTIS_DEBUG, 1, "Initializing I2C ..");
 
+	mutex_lock(&mantis->int_stat_lock);
 	intstat = mmread(MANTIS_INT_STAT);
 	intmask = mmread(MANTIS_INT_MASK);
 	mmwrite(intstat, MANTIS_INT_STAT);
 	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
 	intmask = mmread(MANTIS_INT_MASK);
 	mmwrite((intmask & ~MANTIS_INT_I2CDONE), MANTIS_INT_MASK);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	return 0;
 }
@@ -257,8 +293,10 @@
 	u32 intmask;
 
 	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
+	mutex_lock(&mantis->int_stat_lock);
 	intmask = mmread(MANTIS_INT_MASK);
 	mmwrite((intmask & ~MANTIS_INT_I2CDONE), MANTIS_INT_MASK);
+	mutex_unlock(&mantis->int_stat_lock);
 
 	dprintk(MANTIS_DEBUG, 1, "Removing I2C adapter");
 	return i2c_del_adapter(&mantis->adapter);
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_link.h linux-3.3-rc4/drivers/media/dvb/mantis/mantis_link.h
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_link.h	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_link.h	2012-02-26 18:08:27.372300884 +0100
@@ -25,12 +25,6 @@
 #include <linux/workqueue.h>
 #include "dvb_ca_en50221.h"
 
-enum mantis_sbuf_status {
-	MANTIS_SBUF_DATA_AVAIL		= 1,
-	MANTIS_SBUF_DATA_EMPTY		= 2,
-	MANTIS_SBUF_DATA_OVFLW		= 3
-};
-
 struct mantis_slot {
 	u32				timeout;
 	u32				slave_cfg;
@@ -48,20 +42,17 @@
 
 	struct work_struct		hif_evm_work;
 
-	u32				hif_event;
+	volatile unsigned long 		hif_event;
 	wait_queue_head_t		hif_opdone_wq;
 	wait_queue_head_t		hif_brrdyw_wq;
 	wait_queue_head_t		hif_data_wq;
 	wait_queue_head_t		hif_write_wq; /* HIF Write op */
 
-	enum mantis_sbuf_status		sbuf_status;
-
 	enum mantis_slot_state		slot_state;
 
 	void				*ca_priv;
 
 	struct dvb_ca_en50221		en50221;
-	struct mutex			ca_lock;
 };
 
 /* CA */
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_pci.c linux-3.3-rc4/drivers/media/dvb/mantis/mantis_pci.c
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_pci.c	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_pci.c	2012-02-26 03:19:11.017293980 +0100
@@ -97,6 +97,7 @@
 	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency);
 	mantis->latency = latency;
 	mantis->revision = pdev->revision;
+	mantis_set_direction(mantis, 0);
 
 	dprintk(MANTIS_ERROR, 0, "    Mantis Rev %d [%04x:%04x], ",
 		mantis->revision,
@@ -110,6 +111,7 @@
 		mantis->mantis_addr,
 		mantis->mmio);
 
+	mmwrite(0x00, MANTIS_INT_MASK);
 	err = request_irq(pdev->irq,
 			  config->irq_handler,
 			  IRQF_SHARED,
@@ -165,6 +167,27 @@
 }
 EXPORT_SYMBOL_GPL(mantis_pci_exit);
 
+/* direction = 0 , no CI passthrough ; 1 , CI passthrough */
+void mantis_set_direction(struct mantis_pci *mantis, int direction)
+{
+	u32 reg;
+
+	reg = mmread(0x28);
+	dprintk(MANTIS_DEBUG, 1, "TS direction setup");
+	if (direction == 0x01) {
+		/* to CI */
+		reg |= 0x04;
+		mmwrite(reg, 0x28);
+		reg &= 0xff - 0x04;
+		mmwrite(reg, 0x28);
+	} else {
+		reg &= 0xff - 0x04;
+		mmwrite(reg, 0x28);
+		reg |= 0x04;
+		mmwrite(reg, 0x28);
+	}
+}
+
 MODULE_DESCRIPTION("Mantis PCI DTV bridge driver");
 MODULE_AUTHOR("Manu Abraham");
 MODULE_LICENSE("GPL");
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_pci.h linux-3.3-rc4/drivers/media/dvb/mantis/mantis_pci.h
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_pci.h	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_pci.h	2012-02-22 13:10:59.449330922 +0100
@@ -24,4 +24,6 @@
 extern int mantis_pci_init(struct mantis_pci *mantis);
 extern void mantis_pci_exit(struct mantis_pci *mantis);
 
+void mantis_set_direction(struct mantis_pci *mantis, int direction);
+
 #endif /* __MANTIS_PCI_H */
diff -ur orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_reg.h linux-3.3-rc4/drivers/media/dvb/mantis/mantis_reg.h
--- orig/linux-3.3-rc4/drivers/media/dvb/mantis/mantis_reg.h	2012-02-19 00:53:33.000000000 +0100
+++ linux-3.3-rc4/drivers/media/dvb/mantis/mantis_reg.h	2012-02-25 18:07:25.834640939 +0100
@@ -152,11 +152,13 @@
 
 #define MANTIS_GPIF_STATUS		0x9c
 #define MANTIS_SBUF_KILLOP		(0x01 << 15)
-#define MANTIS_SBUF_OPDONE		(0x01 << 14)
+#define MANTIS_SBUF_OPDONE_BIT		14
+#define MANTIS_SBUF_OPDONE		(0x01 << MANTIS_SBUF_OPDONE_BIT)
 #define MANTIS_SBUF_EMPTY		(0x01 << 13)
 #define MANTIS_GPIF_DETSTAT		(0x01 <<  9)
 #define MANTIS_GPIF_INTSTAT		(0x01 <<  8)
-#define MANTIS_GPIF_WRACK		(0x01 <<  7)
+#define MANTIS_GPIF_WRACK_BIT		7
+#define MANTIS_GPIF_WRACK		(0x01 <<  MANTIS_GPIF_WRACK_BIT)
 #define MANTIS_GPIF_BRRDY		(0x01 <<  6)
 #define MANTIS_SBUF_OVFLW		(0x01 <<  5)
 #define MANTIS_GPIF_OTHERR		(0x01 <<  4)

--IS0zKkzwUGydFO0o--
