Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40290 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXc2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:32:28 -0400
Subject: [PATCH 14/49] rc-core: rename dev->scanmask to dev->scancode_mask
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:32:26 +0200
Message-ID: <20140403233226.27099.88029.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We already have dev->scancode_filter and dev->scancode_wakeup_filter
so rename dev->scanmask to dev->scancode_mask for consistency.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/pci/cx88/cx88-input.c       |    2 +-
 drivers/media/pci/ttpci/budget-ci.c       |    2 +-
 drivers/media/rc/rc-main.c                |    4 ++--
 drivers/media/usb/cx231xx/cx231xx-input.c |    2 +-
 drivers/media/usb/tm6000/tm6000-input.c   |    2 +-
 include/media/rc-core.h                   |    5 +++--
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 93ff6a7..3f1342c 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -478,7 +478,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	dev->priv = core;
 	dev->open = cx88_ir_open;
 	dev->close = cx88_ir_close;
-	dev->scanmask = hardware_mask;
+	dev->scancode_mask = hardware_mask;
 
 	if (ir->sampling) {
 		dev->driver_type = RC_DRIVER_IR_RAW;
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index 41ce7de..1feeeff 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -234,7 +234,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 		break;
 	}
 	if (!budget_ci->ir.full_rc5)
-		dev->scanmask = 0xff;
+		dev->scancode_mask = 0xff;
 
 	error = rc_register_device(dev);
 	if (error) {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 287191b..2788102 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -287,8 +287,8 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 	 * IR tables from other remotes. So, we support specifying a mask to
 	 * indicate the valid bits of the scancodes.
 	 */
-	if (dev->scanmask)
-		entry->scancode &= dev->scanmask;
+	if (dev->scancode_mask)
+		entry->scancode &= dev->scancode_mask;
 
 	/*
 	 * First check if we already have a mapping for this command.
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index adcdd92..05f0434 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -91,7 +91,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	dev->init_data.get_key = get_key_isdbt;
 	dev->init_data.ir_codes = cx231xx_boards[dev->model].rc_map_name;
 	/* The i2c micro-controller only outputs the cmd part of NEC protocol */
-	dev->init_data.rc_dev->scanmask = 0xff;
+	dev->init_data.rc_dev->scancode_mask = 0xff;
 	dev->init_data.rc_dev->driver_name = "cx231xx";
 	dev->init_data.type = RC_BIT_NEC;
 	info.addr = 0x30;
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 8a519f5..26b2ebb 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -443,7 +443,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	/* input setup */
 	rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC;
 	/* Neded, in order to support NEC remotes with 24 or 32 bits */
-	rc->scanmask = 0xffff;
+	rc->scancode_mask = 0xffff;
 	rc->priv = ir;
 	rc->change_protocol = tm6000_ir_change_protocol;
 	if (dev->int_in.endp) {
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index e6784e8..5a082e7 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -98,11 +98,12 @@ enum rc_filter_type {
  * @enabled_wakeup_protocols: bitmask with the enabled RC_BIT_* wakeup protocols
  * @scancode_filter: scancode filter
  * @scancode_wakeup_filter: scancode wakeup filters
- * @scanmask: some hardware decoders are not capable of providing the full
+ * @scancode_mask: some hardware decoders are not capable of providing the full
  *	scancode to the application. As this is a hardware limit, we can't do
  *	anything with it. Yet, as the same keycode table can be used with other
  *	devices, a mask is provided to allow its usage. Drivers should generally
  *	leave this field in blank
+ * @users: number of current users of the device
  * @priv: driver-specific data
  * @keylock: protects the remaining members of the struct
  * @keypressed: whether a key is currently pressed
@@ -157,8 +158,8 @@ struct rc_dev {
 	u64				enabled_wakeup_protocols;
 	struct rc_scancode_filter	scancode_filter;
 	struct rc_scancode_filter	scancode_wakeup_filter;
+	u32				scancode_mask;
 	u32				users;
-	u32				scanmask;
 	void				*priv;
 	spinlock_t			keylock;
 	bool				keypressed;

