Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:31362 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758183Ab1BRBWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:22:12 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1M4ml023573
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:22:07 GMT
Subject: [PATCH 13/13] lirc_zilog: Update TODO list based on work completed
 and revised plans
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:22:17 -0500
Message-ID: <1297992137.9399.29.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Update the TODO.lirc_zilog based on what has been completed.  Also revised
the development plan for lirc_zilog to not try and split Tx/Rx for one IR
transceiver unit between lirc_zilog and ir-kbd-i2c, since that would be a
ref-counting nightmare.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/TODO.lirc_zilog |   51 ++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/lirc/TODO.lirc_zilog b/drivers/staging/lirc/TODO.lirc_zilog
index 2d0263f..a97800a 100644
--- a/drivers/staging/lirc/TODO.lirc_zilog
+++ b/drivers/staging/lirc/TODO.lirc_zilog
@@ -1,34 +1,33 @@
-1. Both ir-kbd-i2c and lirc_zilog provide support for RX events.
-The 'tx_only' lirc_zilog module parameter will allow ir-kbd-i2c
-and lirc_zilog to coexist in the kernel, if the user requires such a set-up.
-However the IR unit will not work well without coordination between the
-two modules.  A shared mutex, for transceiver access locking, needs to be
-supplied by bridge drivers, in struct IR_i2_init_data, to both ir-kbd-i2c
-and lirc_zilog, before they will coexist usefully.  This should be fixed
-before moving out of staging.
-
-2. References and locking need careful examination.  For cx18 and ivtv PCI
-cards, which are not easily "hot unplugged", the imperfect state of reference
-counting and locking is acceptable if not correct.  For USB connected units
-like HD PVR, PVR USB2, HVR-1900, and HVR1950, the likelyhood of an Ooops on
-unplug is probably great.  Proper reference counting and locking needs to be
-implemented before this module is moved out of staging.
-
-3. The binding between hdpvr and lirc_zilog is currently disabled,
-due to an OOPS reported a few years ago when both the hdpvr and cx18
-drivers were loaded in his system. More details can be seen at:
-	http://www.mail-archive.com/linux-media@vger.kernel.org/msg09163.html
-More tests need to be done, in order to fix the reported issue.
-
-4. In addition to providing a shared mutex for transceiver access
-locking, bridge drivers, if able, should provide a chip reset() callback
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
 to lirc_zilog via struct IR_i2c_init_data.  cx18 and ivtv already have routines
-to perform Z8 chip resets via GPIO manipulations.  This will allow lirc_zilog
+to perform Z8 chip resets via GPIO manipulations.  This would allow lirc_zilog
 to bring the chip back to normal when it hangs, in the same places the
 original lirc_pvr150 driver code does.  This is not strictly needed, so it
 is not required to move lirc_zilog out of staging.
 
-5. Both lirc_zilog and ir-kbd-i2c support the Zilog Z8 for IR, as programmed
+Note: Both lirc_zilog and ir-kbd-i2c support the Zilog Z8 for IR, as programmed
 and installed on Hauppauge products.  When working on either module, developers
 must consider at least the following bridge drivers which mention an IR Rx unit
 at address 0x71 (indicative of a Z8):
-- 
1.7.2.1



