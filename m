Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45802 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaB1XRl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 18:17:41 -0500
Received: by mail-wi0-f174.google.com with SMTP id f8so1352472wiw.13
        for <linux-media@vger.kernel.org>; Fri, 28 Feb 2014 15:17:40 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 2/5] rc: abstract access to allowed/enabled protocols
Date: Fri, 28 Feb 2014 23:17:03 +0000
Message-Id: <1393629426-31341-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The allowed and enabled protocol masks need to be expanded to be per
filter type in order to support wakeup filter protocol selection. To
ease that process abstract access to the rc_dev::allowed_protos and
rc_dev::enabled_protocols members with inline functions.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Bruno Prémont" <bonbons@linux-vserver.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Sean Young <sean@mess.org>
Cc: "David Härdeman" <david@hardeman.nu>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "Antti Seppälä" <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org
---
 drivers/hid/hid-picolcd_cir.c               |  2 +-
 drivers/media/common/siano/smsir.c          |  2 +-
 drivers/media/i2c/ir-kbd-i2c.c              |  4 ++--
 drivers/media/pci/cx23885/cx23885-input.c   |  2 +-
 drivers/media/pci/cx88/cx88-input.c         |  2 +-
 drivers/media/rc/ati_remote.c               |  2 +-
 drivers/media/rc/ene_ir.c                   |  2 +-
 drivers/media/rc/fintek-cir.c               |  2 +-
 drivers/media/rc/gpio-ir-recv.c             |  4 ++--
 drivers/media/rc/iguanair.c                 |  2 +-
 drivers/media/rc/imon.c                     |  7 ++++---
 drivers/media/rc/ir-jvc-decoder.c           |  2 +-
 drivers/media/rc/ir-lirc-codec.c            |  2 +-
 drivers/media/rc/ir-mce_kbd-decoder.c       |  2 +-
 drivers/media/rc/ir-nec-decoder.c           |  2 +-
 drivers/media/rc/ir-raw.c                   |  2 +-
 drivers/media/rc/ir-rc5-decoder.c           |  6 +++---
 drivers/media/rc/ir-rc5-sz-decoder.c        |  2 +-
 drivers/media/rc/ir-rc6-decoder.c           |  6 +++---
 drivers/media/rc/ir-sanyo-decoder.c         |  2 +-
 drivers/media/rc/ir-sharp-decoder.c         |  2 +-
 drivers/media/rc/ir-sony-decoder.c          | 10 +++++-----
 drivers/media/rc/ite-cir.c                  |  2 +-
 drivers/media/rc/mceusb.c                   |  2 +-
 drivers/media/rc/nuvoton-cir.c              |  2 +-
 drivers/media/rc/rc-loopback.c              |  2 +-
 drivers/media/rc/redrat3.c                  |  2 +-
 drivers/media/rc/st_rc.c                    |  2 +-
 drivers/media/rc/streamzap.c                |  2 +-
 drivers/media/rc/ttusbir.c                  |  2 +-
 drivers/media/rc/winbond-cir.c              |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |  2 +-
 drivers/media/usb/dvb-usb/dvb-usb-remote.c  |  2 +-
 drivers/media/usb/em28xx/em28xx-input.c     |  8 ++++----
 drivers/media/usb/tm6000/tm6000-input.c     |  2 +-
 include/media/rc-core.h                     | 22 ++++++++++++++++++++++
 36 files changed, 73 insertions(+), 50 deletions(-)

diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index 59d5eb1..cf1a9f1 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -114,7 +114,7 @@ int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
 
 	rdev->priv             = data;
 	rdev->driver_type      = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos   = RC_BIT_ALL;
+	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
 	rdev->open             = picolcd_cir_open;
 	rdev->close            = picolcd_cir_close;
 	rdev->input_name       = data->hdev->name;
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index b8c5cad..6d7c0c8 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -88,7 +88,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 	dev->priv = coredev;
 	dev->driver_type = RC_DRIVER_IR_RAW;
-	dev->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(dev, RC_BIT_ALL);
 	dev->map_name = sms_get_board(board_id)->rc_codes;
 	dev->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 99ee456..c8fe135 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -431,8 +431,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 * Initialize the other fields of rc_dev
 	 */
 	rc->map_name       = ir->ir_codes;
-	rc->allowed_protos = rc_type;
-	rc->enabled_protocols = rc_type;
+	rc_set_allowed_protocols(rc, rc_type);
+	rc_set_enabled_protocols(rc, rc_type);
 	if (!rc->driver_name)
 		rc->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 8a49e7c..097d0a0 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -346,7 +346,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	}
 	rc->dev.parent = &dev->pci->dev;
 	rc->driver_type = driver_type;
-	rc->allowed_protos = allowed_protos;
+	rc_set_allowed_protocols(rc, allowed_protos);
 	rc->priv = kernel_ir;
 	rc->open = cx23885_input_ir_open;
 	rc->close = cx23885_input_ir_close;
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index f29e18c..f991696 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -469,7 +469,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		dev->timeout = 10 * 1000 * 1000; /* 10 ms */
 	} else {
 		dev->driver_type = RC_DRIVER_SCANCODE;
-		dev->allowed_protos = rc_type;
+		rc_set_allowed_protocols(dev, rc_type);
 	}
 
 	ir->core = core;
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 4d6a63f..2df7c55 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -784,7 +784,7 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
 
 	rdev->priv = ati_remote;
 	rdev->driver_type = RC_DRIVER_SCANCODE;
-	rdev->allowed_protos = RC_BIT_OTHER;
+	rc_set_allowed_protocols(rdev, RC_BIT_OTHER);
 	rdev->driver_name = "ati_remote";
 
 	rdev->open = ati_remote_rc_open;
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index c1444f8..fc9d23f 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1059,7 +1059,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		learning_mode_force = false;
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
 	rdev->priv = dev;
 	rdev->open = ene_open;
 	rdev->close = ene_close;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index d6fa441..46b66e5 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -541,7 +541,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	/* Set up the rc device */
 	rdev->priv = fintek;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
 	rdev->open = fintek_open;
 	rdev->close = fintek_close;
 	rdev->input_name = FINTEK_DESCRIPTION;
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 80c611c..29b5f89 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -145,9 +145,9 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->dev.parent = &pdev->dev;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
 	if (pdata->allowed_protos)
-		rcdev->allowed_protos = pdata->allowed_protos;
+		rc_set_allowed_protocols(rcdev, pdata->allowed_protos);
 	else
-		rcdev->allowed_protos = RC_BIT_ALL;
+		rc_set_allowed_protocols(rcdev, RC_BIT_ALL);
 	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index a83519a..627ddfd 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -495,7 +495,7 @@ static int iguanair_probe(struct usb_interface *intf,
 	usb_to_input_id(ir->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rc, RC_BIT_ALL);
 	rc->priv = ir;
 	rc->open = iguanair_open;
 	rc->close = iguanair_close;
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 822b9f4..6f24e77 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1017,7 +1017,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
 	unsigned char ir_proto_packet[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
-	if (*rc_type && !(*rc_type & rc->allowed_protos))
+	if (*rc_type && !rc_protocols_allowed(rc, *rc_type))
 		dev_warn(dev, "Looks like you're trying to use an IR protocol "
 			 "this device does not support\n");
 
@@ -1867,7 +1867,8 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	rdev->priv = ictx;
 	rdev->driver_type = RC_DRIVER_SCANCODE;
-	rdev->allowed_protos = RC_BIT_OTHER | RC_BIT_RC6_MCE; /* iMON PAD or MCE */
+					/* iMON PAD or MCE */
+	rc_set_allowed_protocols(rdev, RC_BIT_OTHER | RC_BIT_RC6_MCE);
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
 
@@ -1880,7 +1881,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	if (ictx->product == 0xffdc) {
 		imon_get_ffdc_type(ictx);
-		rdev->allowed_protos = ictx->rc_type;
+		rc_set_allowed_protocols(rdev, ictx->rc_type);
 	}
 
 	imon_set_display_type(ictx);
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 3948138..4ea62a1 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -47,7 +47,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct jvc_dec *data = &dev->raw->jvc;
 
-	if (!(dev->enabled_protocols & RC_BIT_JVC))
+	if (!rc_protocols_enabled(dev, RC_BIT_JVC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index ed2c8a1..d731da6 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -35,7 +35,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!(dev->enabled_protocols & RC_BIT_LIRC))
+	if (!rc_protocols_enabled(dev, RC_BIT_LIRC))
 		return 0;
 
 	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 9f3c9b5..0c55f79 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -216,7 +216,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	unsigned long delay;
 
-	if (!(dev->enabled_protocols & RC_BIT_MCE_KBD))
+	if (!rc_protocols_enabled(dev, RC_BIT_MCE_KBD))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index e687a42..9de1791 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -52,7 +52,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 address, not_address, command, not_command;
 	bool send_32bits = false;
 
-	if (!(dev->enabled_protocols & RC_BIT_NEC))
+	if (!rc_protocols_enabled(dev, RC_BIT_NEC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index f0656fa..763c9d1 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -256,7 +256,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 		return -ENOMEM;
 
 	dev->raw->dev = dev;
-	dev->enabled_protocols = ~0;
+	rc_set_enabled_protocols(dev, ~0);
 	rc = kfifo_alloc(&dev->raw->kfifo,
 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 1085e17..4295d9b 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -52,7 +52,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle;
 	u32 scancode;
 
-	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
+	if (!rc_protocols_enabled(dev, RC_BIT_RC5 | RC_BIT_RC5X))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -128,7 +128,7 @@ again:
 		if (data->wanted_bits == RC5X_NBITS) {
 			/* RC5X */
 			u8 xdata, command, system;
-			if (!(dev->enabled_protocols & RC_BIT_RC5X)) {
+			if (!rc_protocols_enabled(dev, RC_BIT_RC5X)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -145,7 +145,7 @@ again:
 		} else {
 			/* RC5 */
 			u8 command, system;
-			if (!(dev->enabled_protocols & RC_BIT_RC5)) {
+			if (!rc_protocols_enabled(dev, RC_BIT_RC5)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index 984e5b9..dc18b74 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -48,7 +48,7 @@ static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle, command, system;
 	u32 scancode;
 
-	if (!(dev->enabled_protocols & RC_BIT_RC5_SZ))
+	if (!rc_protocols_enabled(dev, RC_BIT_RC5_SZ))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 7cba7d3..cfbd64e 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -89,9 +89,9 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 toggle;
 
-	if (!(dev->enabled_protocols &
-	      (RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
-	       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
+	if (!rc_protocols_enabled(dev, RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 |
+				  RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 |
+				  RC_BIT_RC6_MCE))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index e1351ed..eb715f0 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -58,7 +58,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 address, command, not_command;
 
-	if (!(dev->enabled_protocols & RC_BIT_SANYO))
+	if (!rc_protocols_enabled(dev, RC_BIT_SANYO))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index 4895bc7..66d2039 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -48,7 +48,7 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct sharp_dec *data = &dev->raw->sharp;
 	u32 msg, echo, address, command, scancode;
 
-	if (!(dev->enabled_protocols & RC_BIT_SHARP))
+	if (!rc_protocols_enabled(dev, RC_BIT_SHARP))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index 29ab9c2..599c19a 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -45,8 +45,8 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 device, subdevice, function;
 
-	if (!(dev->enabled_protocols &
-	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
+	if (!rc_protocols_enabled(dev, RC_BIT_SONY12 | RC_BIT_SONY15 |
+				  RC_BIT_SONY20))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -124,7 +124,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		switch (data->count) {
 		case 12:
-			if (!(dev->enabled_protocols & RC_BIT_SONY12)) {
+			if (!rc_protocols_enabled(dev, RC_BIT_SONY12)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -133,7 +133,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			function  = bitrev8((data->bits >>  4) & 0xFE);
 			break;
 		case 15:
-			if (!(dev->enabled_protocols & RC_BIT_SONY15)) {
+			if (!rc_protocols_enabled(dev, RC_BIT_SONY15)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -142,7 +142,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			function  = bitrev8((data->bits >>  7) & 0xFE);
 			break;
 		case 20:
-			if (!(dev->enabled_protocols & RC_BIT_SONY20)) {
+			if (!rc_protocols_enabled(dev, RC_BIT_SONY20)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 63b4225..ab24cc6 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1563,7 +1563,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* set up ir-core props */
 	rdev->priv = itdev;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
 	rdev->open = ite_open;
 	rdev->close = ite_close;
 	rdev->s_idle = ite_s_idle;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index c01b4c1..5d8f3d4 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1211,7 +1211,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->dev.parent = dev;
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rc, RC_BIT_ALL);
 	rc->timeout = MS_TO_NS(100);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index b41e52e..bedf784 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1038,7 +1038,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 53d0282..0a88e0c 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -195,7 +195,7 @@ static int __init loop_init(void)
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
-	rc->allowed_protos	= RC_BIT_ALL;
+	rc_set_allowed_protocols(rc, RC_BIT_ALL);
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
 	rc->max_timeout		= UINT_MAX;
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index a5d4f88..47cd373 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -922,7 +922,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->dev.parent = dev;
 	rc->priv = rr3;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rc, RC_BIT_ALL);
 	rc->timeout = US_TO_NS(2750);
 	rc->tx_ir = redrat3_transmit_ir;
 	rc->s_tx_carrier = redrat3_set_tx_carrier;
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 8f0cddb..22e4c1f 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -287,7 +287,7 @@ static int st_rc_probe(struct platform_device *pdev)
 	st_rc_hardware_init(rc_dev);
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
 	/* rx sampling rate is 10Mhz */
 	rdev->rx_resolution = 100;
 	rdev->timeout = US_TO_NS(MAX_SYMB_TIME);
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index d7b11e6..f4e0bc3 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -322,7 +322,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	rdev->dev.parent = dev;
 	rdev->priv = sz;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
 	rdev->driver_name = DRIVER_NAME;
 	rdev->map_name = RC_MAP_STREAMZAP;
 
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index d8de205..c5be38e 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -318,7 +318,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 	usb_to_input_id(tt->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(rc, RC_BIT_ALL);
 	rc->priv = tt;
 	rc->driver_name = DRIVER_NAME;
 	rc->map_name = RC_MAP_TT_1500;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 904baf4..a8b981f 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1082,7 +1082,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->dev.parent = &device->dev;
 	data->dev->timeout = MS_TO_NS(100);
 	data->dev->rx_resolution = US_TO_NS(2);
-	data->dev->allowed_protos = RC_BIT_ALL;
+	rc_set_allowed_protocols(data->dev, RC_BIT_ALL);
 
 	err = rc_register_device(data->dev);
 	if (err)
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 8a054d6..de02db8 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -164,7 +164,7 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
 	dev->driver_name = (char *) d->props->driver_name;
 	dev->map_name = d->rc.map_name;
 	dev->driver_type = d->rc.driver_type;
-	dev->allowed_protos = d->rc.allowed_protos;
+	rc_set_allowed_protocols(dev, d->rc.allowed_protos);
 	dev->change_protocol = d->rc.change_protocol;
 	dev->priv = d;
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
index 41bacff..4058aea 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
@@ -272,7 +272,7 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 	dev->driver_name = d->props.rc.core.module_name;
 	dev->map_name = d->props.rc.core.rc_codes;
 	dev->change_protocol = d->props.rc.core.change_protocol;
-	dev->allowed_protos = d->props.rc.core.allowed_protos;
+	rc_set_allowed_protocols(dev, d->props.rc.core.allowed_protos);
 	dev->driver_type = d->props.rc.core.driver_type;
 	usb_to_input_id(d->udev, &dev->input_id);
 	dev->input_name = "IR-receiver inside an USB DVB receiver";
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 048e5b6..3543c12 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -725,7 +725,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 		case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
 			rc->map_name = RC_MAP_HAUPPAUGE;
 			ir->get_key_i2c = em28xx_get_key_em_haup;
-			rc->allowed_protos = RC_BIT_RC5;
+			rc_set_allowed_protocols(rc, RC_BIT_RC5);
 			break;
 		case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
 			rc->map_name = RC_MAP_WINFAST_USBII_DELUXE;
@@ -741,7 +741,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 		switch (dev->chip_id) {
 		case CHIP_ID_EM2860:
 		case CHIP_ID_EM2883:
-			rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
+			rc_set_allowed_protocols(rc, RC_BIT_RC5 | RC_BIT_NEC);
 			ir->get_key = default_polling_getkey;
 			break;
 		case CHIP_ID_EM2884:
@@ -749,8 +749,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 		case CHIP_ID_EM28174:
 		case CHIP_ID_EM28178:
 			ir->get_key = em2874_polling_getkey;
-			rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC |
-					     RC_BIT_RC6_0;
+			rc_set_allowed_protocols(rc, RC_BIT_RC5 | RC_BIT_NEC |
+						 RC_BIT_RC6_0);
 			break;
 		default:
 			err = -ENODEV;
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 8a6bbf1..d1af543 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -422,7 +422,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	ir->rc = rc;
 
 	/* input setup */
-	rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
+	rc_set_allowed_protocols(rc, RC_BIT_RC5 | RC_BIT_NEC);
 	/* Neded, in order to support NEC remotes with 24 or 32 bits */
 	rc->scanmask = 0xffff;
 	rc->priv = ir;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 5e7197e..6f3c3d9 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -160,6 +160,28 @@ struct rc_dev {
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
 
+static inline bool rc_protocols_allowed(struct rc_dev *rdev, u64 protos)
+{
+	return rdev->allowed_protos & protos;
+}
+
+/* should be called prior to registration or with mutex held */
+static inline void rc_set_allowed_protocols(struct rc_dev *rdev, u64 protos)
+{
+	rdev->allowed_protos = protos;
+}
+
+static inline bool rc_protocols_enabled(struct rc_dev *rdev, u64 protos)
+{
+	return rdev->enabled_protocols & protos;
+}
+
+/* should be called prior to registration or with mutex held */
+static inline void rc_set_enabled_protocols(struct rc_dev *rdev, u64 protos)
+{
+	rdev->enabled_protocols = protos;
+}
+
 /*
  * From rc-main.c
  * Those functions can be used on any type of Remote Controller. They
-- 
1.8.3.2

