Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53407 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752974AbdEQRc7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 13:32:59 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] [media] staging: remove todo and replace with lirc_zilog todo
Date: Wed, 17 May 2017 18:32:54 +0100
Message-Id: <94bd97fab3433f240916593521e4797dfc4cdf0f.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc_zilog driver is the last remaining lirc driver, so the existing
todo is no longer relevant.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/TODO            | 47 ++++++++++++++++++++++--------
 drivers/staging/media/lirc/TODO.lirc_zilog | 36 -----------------------
 2 files changed, 35 insertions(+), 48 deletions(-)
 delete mode 100644 drivers/staging/media/lirc/TODO.lirc_zilog

diff --git a/drivers/staging/media/lirc/TODO b/drivers/staging/media/lirc/TODO
index cbea5d8..a97800a 100644
--- a/drivers/staging/media/lirc/TODO
+++ b/drivers/staging/media/lirc/TODO
@@ -1,13 +1,36 @@
-- All drivers should either be ported to ir-core, or dropped entirely
-  (see drivers/media/IR/mceusb.c vs. lirc_mceusb.c in lirc cvs for an
-  example of a previously completed port).
-
-- lirc_bt829 uses registers on a Mach64 VT, which has a separate kernel
-  framebuffer driver (atyfb) and userland X driver (mach64).  It can't
-  simply be converted to a normal PCI driver, but ideally it should be
-  coordinated with the other drivers.
-
-Please send patches to:
-Jarod Wilson <jarod@wilsonet.com>
-Greg Kroah-Hartman <greg@kroah.com>
+1. Both ir-kbd-i2c and lirc_zilog provide support for RX events for
+the chips supported by lirc_zilog.  Before moving lirc_zilog out of staging:
+
+a. ir-kbd-i2c needs a module parameter added to allow the user to tell
+   ir-kbd-i2c to ignore Z8 IR units.
+
+b. lirc_zilog should provide Rx key presses to the rc core like ir-kbd-i2c
+   does.
+
+
+2. lirc_zilog module ref-counting need examination.  It has not been
+verified that cdev and lirc_dev will take the proper module references on
+lirc_zilog to prevent removal of lirc_zilog when the /dev/lircN device node
+is open.
+
+(The good news is ref-counting of lirc_zilog internal structures appears to be
+complete.  Testing has shown the cx18 module can be unloaded out from under
+irw + lircd + lirc_dev, with the /dev/lirc0 device node open, with no adverse
+effects.  The cx18 module could then be reloaded and irw properly began
+receiving button presses again and ir_send worked without error.)
+
+
+3. Bridge drivers, if able, should provide a chip reset() callback
+to lirc_zilog via struct IR_i2c_init_data.  cx18 and ivtv already have routines
+to perform Z8 chip resets via GPIO manipulations.  This would allow lirc_zilog
+to bring the chip back to normal when it hangs, in the same places the
+original lirc_pvr150 driver code does.  This is not strictly needed, so it
+is not required to move lirc_zilog out of staging.
+
+Note: Both lirc_zilog and ir-kbd-i2c support the Zilog Z8 for IR, as programmed
+and installed on Hauppauge products.  When working on either module, developers
+must consider at least the following bridge drivers which mention an IR Rx unit
+at address 0x71 (indicative of a Z8):
+
+	ivtv cx18 hdpvr pvrusb2 bt8xx cx88 saa7134
 
diff --git a/drivers/staging/media/lirc/TODO.lirc_zilog b/drivers/staging/media/lirc/TODO.lirc_zilog
deleted file mode 100644
index a97800a..0000000
--- a/drivers/staging/media/lirc/TODO.lirc_zilog
+++ /dev/null
@@ -1,36 +0,0 @@
-1. Both ir-kbd-i2c and lirc_zilog provide support for RX events for
-the chips supported by lirc_zilog.  Before moving lirc_zilog out of staging:
-
-a. ir-kbd-i2c needs a module parameter added to allow the user to tell
-   ir-kbd-i2c to ignore Z8 IR units.
-
-b. lirc_zilog should provide Rx key presses to the rc core like ir-kbd-i2c
-   does.
-
-
-2. lirc_zilog module ref-counting need examination.  It has not been
-verified that cdev and lirc_dev will take the proper module references on
-lirc_zilog to prevent removal of lirc_zilog when the /dev/lircN device node
-is open.
-
-(The good news is ref-counting of lirc_zilog internal structures appears to be
-complete.  Testing has shown the cx18 module can be unloaded out from under
-irw + lircd + lirc_dev, with the /dev/lirc0 device node open, with no adverse
-effects.  The cx18 module could then be reloaded and irw properly began
-receiving button presses again and ir_send worked without error.)
-
-
-3. Bridge drivers, if able, should provide a chip reset() callback
-to lirc_zilog via struct IR_i2c_init_data.  cx18 and ivtv already have routines
-to perform Z8 chip resets via GPIO manipulations.  This would allow lirc_zilog
-to bring the chip back to normal when it hangs, in the same places the
-original lirc_pvr150 driver code does.  This is not strictly needed, so it
-is not required to move lirc_zilog out of staging.
-
-Note: Both lirc_zilog and ir-kbd-i2c support the Zilog Z8 for IR, as programmed
-and installed on Hauppauge products.  When working on either module, developers
-must consider at least the following bridge drivers which mention an IR Rx unit
-at address 0x71 (indicative of a Z8):
-
-	ivtv cx18 hdpvr pvrusb2 bt8xx cx88 saa7134
-
-- 
2.9.4
