Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:33194 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab0GJUtj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 16:49:39 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id BBDC88C5C3
	for <linux-media@vger.kernel.org>; Sat, 10 Jul 2010 23:49:37 +0300 (EEST)
Received: from tammi.koti (a88-114-153-83.elisa-laajakaista.fi [88.114.153.83])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id 908F0402E
	for <linux-media@vger.kernel.org>; Sat, 10 Jul 2010 23:49:36 +0300 (EEST)
Message-ID: <4C38DCE0.6050204@kolumbus.fi>
Date: Sat, 10 Jul 2010 23:49:36 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Mantis driver patch: use interrupt for I2C traffic instead of busy
 registry polling
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi

Here is a maybe too ugly patch for direct inclusion:
The code should be reworked to be nicer first.
This seems to work though.

What do you think the idea?

Problem:

I figured out that Mantis I2C read and write functions do busy waiting,
by reading via PCI bus a 32 bit word about 350 times in a tight loop.

I suspected that PCI DMA transfer from Mantis card to
CPU memory might get disturbed (FRTG DMA error message by Mantis)
because this heavy polling might cause the RISC processor's
DMA transfer to slow down so much, that there
comes glitches into the DVB stream (some internal FIFO gets full).

So that's why I wrote this patch: by reducing PCI bus contention,
the RISC DMA transfer should be more robust.

The heavy I2C command seems to be that dvb_core checks whether FE_LOCK 
still holds.
I think that DVB card's I2C transfers aren't so performance critical,
that the heavy PCI contention by polling is justified. Or is it?

I looked at saa7146_i2c.c from Linux kernel, how to use 
wait_event_interruptible_timeout.
Signed-off-by: Marko M Ristola <marko.ristola@kolumbus.fi>

Regards,
Marko Ristola

diff --git a/drivers/media/dvb/mantis/mantis_cards.c 
b/drivers/media/dvb/mantis/mantis_cards.c
index cf4b39f..56c5c30 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -58,7 +58,7 @@ static int devs;

  #define DRIVER_NAME    "Mantis"

-static char *label[10] = {
+static char *label[11] = {
      "DMA",
      "IRQ-0",
      "IRQ-1",
@@ -68,6 +68,7 @@ static char *label[10] = {
      "PPERR",
      "FTRGT",
      "RISCI",
+    "I2CDONE",
      "RACK"
  };

@@ -137,8 +138,15 @@ static irqreturn_t mantis_irq_handler(int irq, void 
*dev_id)
          mantis->finished_block = (stat & MANTIS_INT_RISCSTAT) >> 28;
          tasklet_schedule(&mantis->tasklet);
      }
-    if (stat & MANTIS_INT_I2CDONE) {
-        dprintk(MANTIS_DEBUG, 0, "<%s>", label[9]);
+    if (stat & (MANTIS_INT_I2CDONE | MANTIS_INT_I2CRACK)) {
+        if (stat & MANTIS_INT_I2CDONE) {
+            dprintk(MANTIS_DEBUG, 0, "<%s>", label[9]);
+            mantis->i2c_status |= MANTIS_INT_I2CDONE;
+        }
+        if (stat & MANTIS_INT_I2CRACK) {
+            dprintk(MANTIS_DEBUG, 0, "<%s>", label[10]);
+            mantis->i2c_status |= MANTIS_INT_I2CRACK;
+        }
          wake_up(&mantis->i2c_wq);
      }
      mmwrite(stat, MANTIS_INT_STAT);
diff --git a/drivers/media/dvb/mantis/mantis_common.h 
b/drivers/media/dvb/mantis/mantis_common.h
index d0b645a..3773ad0 100644
--- a/drivers/media/dvb/mantis/mantis_common.h
+++ b/drivers/media/dvb/mantis/mantis_common.h
@@ -77,7 +77,8 @@

  enum mantis_i2c_mode {
      MANTIS_PAGE_MODE = 0,
-    MANTIS_BYTE_MODE,
+    MANTIS_BYTE_MODE = 1,
+    MANTIS_IRQ_PAGE_MODE = 2,
  };

  struct mantis_pci;
@@ -136,6 +137,7 @@ struct mantis_pci {

      struct i2c_adapter    adapter;
      int            i2c_rc;
+    int            i2c_status;
      wait_queue_head_t    i2c_wq;
      struct mutex        i2c_lock;

diff --git a/drivers/media/dvb/mantis/mantis_i2c.c 
b/drivers/media/dvb/mantis/mantis_i2c.c
index 7870bcf..76de8f8 100644
--- a/drivers/media/dvb/mantis/mantis_i2c.c
+++ b/drivers/media/dvb/mantis/mantis_i2c.c
@@ -38,6 +38,8 @@
  static int mantis_i2c_read(struct mantis_pci *mantis, const struct 
i2c_msg *msg)
  {
      u32 rxd, i, stat, trials;
+    u32 intstat;
+    long timeout;

      dprintk(MANTIS_INFO, 0, "        %s:  Address=[0x%02x] <R>[ ",
          __func__, msg->addr);
@@ -51,27 +53,53 @@ static int mantis_i2c_read(struct mantis_pci 
*mantis, const struct i2c_msg *msg)
          if (i == (msg->len - 1))
              rxd &= ~MANTIS_I2C_STOP;

-        mmwrite(MANTIS_INT_I2CDONE, MANTIS_INT_STAT);
+        mantis->i2c_status = 0;
+        intstat = MANTIS_INT_I2CDONE | MANTIS_INT_I2CRACK;
+        mmwrite(intstat, MANTIS_INT_STAT);
          mmwrite(rxd, MANTIS_I2CDATA_CTL);

          /* wait for xfer completion */
-        for (trials = 0; trials < TRIALS; trials++) {
-            stat = mmread(MANTIS_INT_STAT);
-            if (stat & MANTIS_INT_I2CDONE)
-                break;
+        if (mantis->hwconfig->i2c_mode == MANTIS_IRQ_PAGE_MODE) {
+            timeout = HZ / 64;
+            timeout = wait_event_interruptible_timeout(mantis->i2c_wq, 
mantis->i2c_status & MANTIS_INT_I2CDONE, timeout);
+            if (timeout == -ERESTARTSYS) {
+                dprintk(MANTIS_DEBUG, 1, "Mantis I2C read: got 
-ERESTARTSYS.\n");
+                return -ERESTARTSYS;
+            } if (timeout == 0L) {
+                dprintk(MANTIS_DEBUG, 1, "Mantis I2C read: waiting 
I2CDONE failed.\n");
+                return -EIO;
+            }
+            dprintk(MANTIS_TMG, 0, "I2CDONE: time remained %ld/%d 
jiffies\n", timeout, HZ / 64);
+        } else {
+            for (trials = 0; trials < TRIALS; trials++) {
+                stat = mmread(MANTIS_INT_STAT);
+                if (stat & MANTIS_INT_I2CDONE)
+                    break;
+            }
+            dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
          }

-        dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
-
          /* wait for xfer completion */
-        for (trials = 0; trials < TRIALS; trials++) {
-            stat = mmread(MANTIS_INT_STAT);
-            if (stat & MANTIS_INT_I2CRACK)
-                break;
-        }
-
-        dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
+        if (mantis->hwconfig->i2c_mode == MANTIS_IRQ_PAGE_MODE) {
+            timeout = HZ / 64;
+            timeout = wait_event_interruptible_timeout(mantis->i2c_wq, 
mantis->i2c_status & MANTIS_INT_I2CRACK, timeout);
+            if (timeout == -ERESTARTSYS) {
+                dprintk(MANTIS_DEBUG, 1, "Mantis I2C read: got 
-ERESTARTSYS.\n");
+                return -ERESTARTSYS;
+            } if (timeout == 0L) {
+                dprintk(MANTIS_DEBUG, 1, "Mantis I2C read: waiting 
I2CRACK failed.\n");
+                return -EIO;
+            }
+            dprintk(MANTIS_TMG, 0, "I2CRACK: time remained %ld/%d 
jiffies\n", timeout, HZ / 64);
+        } else {
+            for (trials = 0; trials < TRIALS; trials++) {
+                stat = mmread(MANTIS_INT_STAT);
+                if (stat & MANTIS_INT_I2CRACK)
+                    break;
+            }

+            dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
+        }
          rxd = mmread(MANTIS_I2CDATA_CTL);
          msg->buf[i] = (u8)((rxd >> 8) & 0xFF);
          dprintk(MANTIS_INFO, 0, "%02x ", msg->buf[i]);
@@ -85,6 +113,8 @@ static int mantis_i2c_write(struct mantis_pci 
*mantis, const struct i2c_msg *msg
  {
      int i;
      u32 txd = 0, stat, trials;
+    u32 intstat;
+    long timeout;

      dprintk(MANTIS_INFO, 0, "        %s: Address=[0x%02x] <W>[ ",
          __func__, msg->addr);
@@ -99,26 +129,54 @@ static int mantis_i2c_write(struct mantis_pci 
*mantis, const struct i2c_msg *msg
          if (i == (msg->len - 1))
              txd &= ~MANTIS_I2C_STOP;

-        mmwrite(MANTIS_INT_I2CDONE, MANTIS_INT_STAT);
+        mantis->i2c_status = 0;
+        intstat = MANTIS_INT_I2CDONE | MANTIS_INT_I2CRACK;
+        mmwrite(intstat, MANTIS_INT_STAT);
          mmwrite(txd, MANTIS_I2CDATA_CTL);

          /* wait for xfer completion */
-        for (trials = 0; trials < TRIALS; trials++) {
-            stat = mmread(MANTIS_INT_STAT);
-            if (stat & MANTIS_INT_I2CDONE)
-                break;
-        }
+        if (mantis->hwconfig->i2c_mode == MANTIS_IRQ_PAGE_MODE) {
+            timeout = HZ / 64;
+            timeout = wait_event_interruptible_timeout(mantis->i2c_wq, 
mantis->i2c_status & MANTIS_INT_I2CDONE, timeout);
+            if (timeout == -ERESTARTSYS) {
+                dprintk(MANTIS_DEBUG, 1, "Mantis I2C write: got 
-ERESTARTSYS.\n");
+                return -ERESTARTSYS;
+            } if (timeout == 0L) {
+                dprintk(MANTIS_DEBUG, 1, "Mantis I2C write: waiting 
I2CDONE failed.\n");
+                return -EIO;
+            }
+            dprintk(MANTIS_TMG, 0, "I2CDONE: time remained %ld/%d 
jiffies\n", timeout, HZ / 64);
+        } else {
+            for (trials = 0; trials < TRIALS; trials++) {
+                stat = mmread(MANTIS_INT_STAT);
+                if (stat & MANTIS_INT_I2CDONE)
+                    break;
+            }

-        dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
+            dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
+        }

          /* wait for xfer completion */
-        for (trials = 0; trials < TRIALS; trials++) {
-            stat = mmread(MANTIS_INT_STAT);
-            if (stat & MANTIS_INT_I2CRACK)
-                break;
-        }
+        if (mantis->hwconfig->i2c_mode == MANTIS_IRQ_PAGE_MODE) {
+            timeout = HZ / 64;
+            timeout = wait_event_interruptible_timeout(mantis->i2c_wq, 
mantis->i2c_status & MANTIS_INT_I2CRACK, timeout);
+            if (timeout == -ERESTARTSYS) {
+                dprintk(MANTIS_DEBUG, 1, "Mantis I2C write: got 
-ERESTARTSYS.\n");
+                return -ERESTARTSYS;
+            } if (timeout == 0L) {
+                dprintk(MANTIS_DEBUG, 1, "Mantis I2C write: waiting 
I2CRACK failed.\n");
+                return -EIO;
+            }
+            dprintk(MANTIS_TMG, 0, "I2CRACK: time remained %ld/%d 
jiffies\n", timeout, HZ / 64);
+        } else {
+            for (trials = 0; trials < TRIALS; trials++) {
+                stat = mmread(MANTIS_INT_STAT);
+                if (stat & MANTIS_INT_I2CRACK)
+                    break;
+            }

-        dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
+            dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
+        }
      }
      dprintk(MANTIS_INFO, 0, "]\n");

@@ -245,9 +303,17 @@ int __devinit mantis_i2c_init(struct mantis_pci 
*mantis)
      intstat = mmread(MANTIS_INT_STAT);
      intmask = mmread(MANTIS_INT_MASK);
      mmwrite(intstat, MANTIS_INT_STAT);
-    dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
-    intmask = mmread(MANTIS_INT_MASK);
-    mmwrite((intmask & ~MANTIS_INT_I2CDONE), MANTIS_INT_MASK);
+    if (mantis->hwconfig->i2c_mode == MANTIS_IRQ_PAGE_MODE) {
+        dprintk(MANTIS_DEBUG, 1, "Enabling I2C interrupt");
+        intmask = mmread(MANTIS_INT_MASK);
+        intmask |= MANTIS_INT_I2CDONE;
+        intmask |= MANTIS_INT_I2CRACK;
+        mmwrite(intmask, MANTIS_INT_MASK);
+    } else {
+        dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
+        intmask = mmread(MANTIS_INT_MASK);
+        mmwrite((intmask & ~MANTIS_INT_I2CDONE), MANTIS_INT_MASK);
+    }

      return 0;
  }
diff --git a/drivers/media/dvb/mantis/mantis_vp2033.c 
b/drivers/media/dvb/mantis/mantis_vp2033.c
index 10ce817..77fc21f 100644
--- a/drivers/media/dvb/mantis/mantis_vp2033.c
+++ b/drivers/media/dvb/mantis/mantis_vp2033.c
@@ -184,4 +184,5 @@ struct mantis_hwconfig vp2033_config = {
      .frontend_init    = vp2033_frontend_init,
      .power        = GPIF_A12,
      .reset        = GPIF_A13,
+    .i2c_mode    = MANTIS_IRQ_PAGE_MODE,
  };

