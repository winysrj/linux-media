Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40288 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXcX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:32:23 -0400
Subject: [PATCH 13/49] rc-core: remove protocol arrays
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:32:21 +0200
Message-ID: <20140403233221.27099.17661.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The basic API of rc-core used to be:

	dev = rc_allocate_device();
	dev->x = a;
	dev->y = b;
	dev->z = c;
	rc_register_device();

which is a pretty common pattern in the kernel, after the introduction of
protocol arrays the API looks something like:

	dev = rc_allocate_device();
	dev->x = a;
	rc_set_allowed_protocols(dev, RC_BIT_X);
	dev->z = c;
	rc_register_device();

There's no real need for the protocols to be an array, so change it
back to be consistent (and in preparation for the following patches).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/hid/hid-picolcd_cir.c               |    2 -
 drivers/media/common/siano/smsir.c          |    2 -
 drivers/media/i2c/ir-kbd-i2c.c              |    4 +-
 drivers/media/pci/cx23885/cx23885-input.c   |    2 -
 drivers/media/pci/cx88/cx88-input.c         |    2 -
 drivers/media/rc/ati_remote.c               |    2 -
 drivers/media/rc/ene_ir.c                   |    2 -
 drivers/media/rc/fintek-cir.c               |    2 -
 drivers/media/rc/gpio-ir-recv.c             |    4 +-
 drivers/media/rc/iguanair.c                 |    2 -
 drivers/media/rc/img-ir/img-ir-hw.c         |   16 ++++----
 drivers/media/rc/imon.c                     |    7 +--
 drivers/media/rc/ir-jvc-decoder.c           |    2 -
 drivers/media/rc/ir-lirc-codec.c            |    2 -
 drivers/media/rc/ir-mce_kbd-decoder.c       |    2 -
 drivers/media/rc/ir-nec-decoder.c           |    2 -
 drivers/media/rc/ir-raw.c                   |    2 -
 drivers/media/rc/ir-rc5-decoder.c           |    6 +--
 drivers/media/rc/ir-rc5-sz-decoder.c        |    2 -
 drivers/media/rc/ir-rc6-decoder.c           |    6 +--
 drivers/media/rc/ir-sanyo-decoder.c         |    2 -
 drivers/media/rc/ir-sharp-decoder.c         |    2 -
 drivers/media/rc/ir-sony-decoder.c          |   10 ++---
 drivers/media/rc/ite-cir.c                  |    2 -
 drivers/media/rc/mceusb.c                   |    2 -
 drivers/media/rc/nuvoton-cir.c              |    2 -
 drivers/media/rc/rc-loopback.c              |    2 -
 drivers/media/rc/rc-main.c                  |   38 +++++++++---------
 drivers/media/rc/redrat3.c                  |    2 -
 drivers/media/rc/st_rc.c                    |    2 -
 drivers/media/rc/streamzap.c                |    2 -
 drivers/media/rc/ttusbir.c                  |    2 -
 drivers/media/rc/winbond-cir.c              |    2 -
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |    2 -
 drivers/media/usb/dvb-usb/dvb-usb-remote.c  |    2 -
 drivers/media/usb/em28xx/em28xx-input.c     |    8 ++--
 drivers/media/usb/tm6000/tm6000-input.c     |    2 -
 include/media/rc-core.h                     |   56 ++++++---------------------
 38 files changed, 89 insertions(+), 122 deletions(-)

diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index cf1a9f1..59d5eb1 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -114,7 +114,7 @@ int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
 
 	rdev->priv             = data;
 	rdev->driver_type      = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
+	rdev->allowed_protos   = RC_BIT_ALL;
 	rdev->open             = picolcd_cir_open;
 	rdev->close            = picolcd_cir_close;
 	rdev->input_name       = data->hdev->name;
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 6d7c0c8..273043e 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -88,7 +88,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 	dev->priv = coredev;
 	dev->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(dev, RC_BIT_ALL);
+	dev->allowed_protocols = RC_BIT_ALL;
 	dev->map_name = sms_get_board(board_id)->rc_codes;
 	dev->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index f9c4233..8311f1a 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -432,8 +432,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 * Initialize the other fields of rc_dev
 	 */
 	rc->map_name       = ir->ir_codes;
-	rc_set_allowed_protocols(rc, rc_type);
-	rc_set_enabled_protocols(rc, rc_type);
+	rc->allowed_protocols = rc_type;
+	rc->enabled_protocols = rc_type;
 	if (!rc->driver_name)
 		rc->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 097d0a0..1940c18 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -346,7 +346,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	}
 	rc->dev.parent = &dev->pci->dev;
 	rc->driver_type = driver_type;
-	rc_set_allowed_protocols(rc, allowed_protos);
+	rc->allowed_protocols = allowed_protos;
 	rc->priv = kernel_ir;
 	rc->open = cx23885_input_ir_open;
 	rc->close = cx23885_input_ir_close;
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 9bf48ca..93ff6a7 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -485,7 +485,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		dev->timeout = 10 * 1000 * 1000; /* 10 ms */
 	} else {
 		dev->driver_type = RC_DRIVER_SCANCODE;
-		rc_set_allowed_protocols(dev, rc_type);
+		dev->allowed_protocols = rc_type;
 	}
 
 	ir->core = core;
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 7098fa5..3ada4dc 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -785,7 +785,7 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
 
 	rdev->priv = ati_remote;
 	rdev->driver_type = RC_DRIVER_SCANCODE;
-	rc_set_allowed_protocols(rdev, RC_BIT_OTHER);
+	rdev->allowed_protocols = RC_BIT_OTHER;
 	rdev->driver_name = "ati_remote";
 
 	rdev->open = ati_remote_rc_open;
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index fc9d23f..d16d9b4 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1059,7 +1059,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		learning_mode_force = false;
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
+	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->priv = dev;
 	rdev->open = ene_open;
 	rdev->close = ene_close;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 46b66e5..f000faf 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -541,7 +541,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	/* Set up the rc device */
 	rdev->priv = fintek;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
+	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->open = fintek_open;
 	rdev->close = fintek_close;
 	rdev->input_name = FINTEK_DESCRIPTION;
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 29b5f89..5985308 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -145,9 +145,9 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->dev.parent = &pdev->dev;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
 	if (pdata->allowed_protos)
-		rc_set_allowed_protocols(rcdev, pdata->allowed_protos);
+		rcdev->allowed_protocols = pdata->allowed_protos;
 	else
-		rc_set_allowed_protocols(rcdev, RC_BIT_ALL);
+		rcdev->allowed_protocols = RC_BIT_ALL;
 	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 627ddfd..ee60e17 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -495,7 +495,7 @@ static int iguanair_probe(struct usb_interface *intf,
 	usb_to_input_id(ir->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rc, RC_BIT_ALL);
+	rc->allowed_protocols = RC_BIT_ALL;
 	rc->priv = ir;
 	rc->open = iguanair_open;
 	rc->close = iguanair_close;
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 871a9b3..9fc41780 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -551,8 +551,8 @@ static void img_ir_set_decoder(struct img_ir_priv *priv,
 	hw->mode = IMG_IR_M_NORMAL;
 
 	/* clear the wakeup scancode filter */
-	rdev->scancode_filters[RC_FILTER_WAKEUP].data = 0;
-	rdev->scancode_filters[RC_FILTER_WAKEUP].mask = 0;
+	rdev->scancode_wakeup_filter.data = 0;
+	rdev->scancode_wakeup_filter.mask = 0;
 
 	/* clear raw filters */
 	_img_ir_set_filter(priv, NULL);
@@ -656,8 +656,8 @@ success:
 	wakeup_protocols = *ir_type;
 	if (!hw->decoder || !hw->decoder->filter)
 		wakeup_protocols = 0;
-	rc_set_allowed_wakeup_protocols(rdev, wakeup_protocols);
-	rc_set_enabled_wakeup_protocols(rdev, wakeup_protocols);
+	rdev->allowed_wakeup_protocols = wakeup_protocols;
+	rdev->enabled_wakeup_protocols = wakeup_protocols;
 	return 0;
 }
 
@@ -671,9 +671,9 @@ static void img_ir_set_protocol(struct img_ir_priv *priv, u64 proto)
 	spin_unlock_irq(&rdev->rc_map.lock);
 
 	mutex_lock(&rdev->lock);
-	rc_set_enabled_protocols(rdev, proto);
-	rc_set_allowed_wakeup_protocols(rdev, proto);
-	rc_set_enabled_wakeup_protocols(rdev, proto);
+	rdev->enabled_protocols = proto;
+	rdev->allowed_wakeup_protocols = proto;
+	rdev->enabled_wakeup_protocols = proto;
 	mutex_unlock(&rdev->lock);
 }
 
@@ -998,7 +998,7 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
 	}
 	rdev->priv = priv;
 	rdev->map_name = RC_MAP_EMPTY;
-	rc_set_allowed_protocols(rdev, img_ir_allowed_protos(priv));
+	rdev->allowed_protocols = img_ir_allowed_protos(priv);
 	rdev->input_name = "IMG Infrared Decoder";
 	rdev->s_filter = img_ir_set_normal_filter;
 	rdev->s_wakeup_filter = img_ir_set_wakeup_filter;
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 8abbb8d..2461933 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1017,7 +1017,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
 	unsigned char ir_proto_packet[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
-	if (*rc_type && !rc_protocols_allowed(rc, *rc_type))
+	if (*rc_type && !(*rc_type & rc->allowed_protocols))
 		dev_warn(dev, "Looks like you're trying to use an IR protocol "
 			 "this device does not support\n");
 
@@ -1876,8 +1876,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	rdev->priv = ictx;
 	rdev->driver_type = RC_DRIVER_SCANCODE;
-					/* iMON PAD or MCE */
-	rc_set_allowed_protocols(rdev, RC_BIT_OTHER | RC_BIT_RC6_MCE);
+	rdev->allowed_protocols = RC_BIT_OTHER | RC_BIT_RC6_MCE; /* iMON PAD or MCE */
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
 
@@ -1890,7 +1889,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	if (ictx->product == 0xffdc) {
 		imon_get_ffdc_type(ictx);
-		rc_set_allowed_protocols(rdev, ictx->rc_type);
+		rdev->allowed_protocols = ictx->rc_type;
 	}
 
 	imon_set_display_type(ictx);
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 7b79eca..30bcf18 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -47,7 +47,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct jvc_dec *data = &dev->raw->jvc;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_JVC))
+	if (!(dev->enabled_protocols & RC_BIT_JVC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index d731da6..ed2c8a1 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -35,7 +35,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_LIRC))
+	if (!(dev->enabled_protocols & RC_BIT_LIRC))
 		return 0;
 
 	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 0c55f79..9f3c9b5 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -216,7 +216,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	unsigned long delay;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_MCE_KBD))
+	if (!(dev->enabled_protocols & RC_BIT_MCE_KBD))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 798e32b..1683aaa 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -51,7 +51,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 address, not_address, command, not_command;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_NEC))
+	if (!(dev->enabled_protocols & RC_BIT_NEC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index f38557f..2a7f858 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -261,7 +261,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 		return -ENOMEM;
 
 	dev->raw->dev = dev;
-	rc_set_enabled_protocols(dev, ~0);
+	dev->enabled_protocols = ~0;
 	dev->change_protocol = change_protocol;
 	rc = kfifo_alloc(&dev->raw->kfifo,
 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 3d38cbc..04ce42f 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -53,7 +53,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	enum rc_type protocol;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_RC5 | RC_BIT_RC5X))
+	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -129,7 +129,7 @@ again:
 		if (data->wanted_bits == RC5X_NBITS) {
 			/* RC5X */
 			u8 xdata, command, system;
-			if (!rc_protocols_enabled(dev, RC_BIT_RC5X)) {
+			if (!(dev->enabled_protocols & RC_BIT_RC5X)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -147,7 +147,7 @@ again:
 		} else {
 			/* RC5 */
 			u8 command, system;
-			if (!rc_protocols_enabled(dev, RC_BIT_RC5)) {
+			if (!(dev->enabled_protocols & RC_BIT_RC5)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index 85c7711..771e9fc 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -48,7 +48,7 @@ static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle, command, system;
 	u32 scancode;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_RC5_SZ))
+	if (!(dev->enabled_protocols & RC_BIT_RC5_SZ))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 1dc97a7..f1f098e 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -90,9 +90,9 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle;
 	enum rc_type protocol;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 |
-				  RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 |
-				  RC_BIT_RC6_MCE))
+	if (!(dev->enabled_protocols &
+	      (RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
+	       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 5f77022..ad1dc6a 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -58,7 +58,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 address, command, not_command;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_SANYO))
+	if (!(dev->enabled_protocols & RC_BIT_SANYO))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index c8f2519..b7acdba 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -48,7 +48,7 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct sharp_dec *data = &dev->raw->sharp;
 	u32 msg, echo, address, command, scancode;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_SHARP))
+	if (!(dev->enabled_protocols & RC_BIT_SHARP))
 		return 0;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index f485f9fe..d12dc3d 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -46,8 +46,8 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 device, subdevice, function;
 
-	if (!rc_protocols_enabled(dev, RC_BIT_SONY12 | RC_BIT_SONY15 |
-				  RC_BIT_SONY20))
+	if (!(dev->enabled_protocols &
+	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -125,7 +125,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		switch (data->count) {
 		case 12:
-			if (!rc_protocols_enabled(dev, RC_BIT_SONY12)) {
+			if (!(dev->enabled_protocols & RC_BIT_SONY12)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -135,7 +135,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			protocol = RC_TYPE_SONY12;
 			break;
 		case 15:
-			if (!rc_protocols_enabled(dev, RC_BIT_SONY15)) {
+			if (!(dev->enabled_protocols & RC_BIT_SONY15)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
@@ -145,7 +145,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			protocol = RC_TYPE_SONY15;
 			break;
 		case 20:
-			if (!rc_protocols_enabled(dev, RC_BIT_SONY20)) {
+			if (!(dev->enabled_protocols & RC_BIT_SONY20)) {
 				data->state = STATE_INACTIVE;
 				return 0;
 			}
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index ab24cc6..32fd5f4 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1563,7 +1563,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* set up ir-core props */
 	rdev->priv = itdev;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
+	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->open = ite_open;
 	rdev->close = ite_close;
 	rdev->s_idle = ite_s_idle;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 5d8f3d4..a347736 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1211,7 +1211,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->dev.parent = dev;
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rc, RC_BIT_ALL);
+	rc->allowed_protocols = RC_BIT_ALL;
 	rc->timeout = MS_TO_NS(100);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index d244e1a..8c6008f 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1044,7 +1044,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
+	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 0a88e0c..63dace8 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -195,7 +195,7 @@ static int __init loop_init(void)
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rc, RC_BIT_ALL);
+	rc->allowed_protocols	= RC_BIT_ALL;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
 	rc->max_timeout		= UINT_MAX;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index df3175d..287191b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -340,10 +340,10 @@ static inline enum rc_type guess_protocol(struct rc_dev *rdev)
 {
 	struct rc_map *rc_map = &rdev->rc_map;
 
-	if (hweight64(rdev->enabled_protocols[RC_FILTER_NORMAL]) == 1)
-		return rc_bitmap_to_type(rdev->enabled_protocols[RC_FILTER_NORMAL]);
-	else if (hweight64(rdev->allowed_protocols[RC_FILTER_NORMAL]) == 1)
-		return rc_bitmap_to_type(rdev->allowed_protocols[RC_FILTER_NORMAL]);
+	if (hweight64(rdev->enabled_protocols) == 1)
+		return rc_bitmap_to_type(rdev->enabled_protocols);
+	else if (hweight64(rdev->allowed_protocols) == 1)
+		return rc_bitmap_to_type(rdev->allowed_protocols);
 	else if (rc_map->len > 0)
 		return rc_map->scan[0].protocol;
 	else
@@ -986,14 +986,14 @@ static ssize_t show_protocols(struct device *device,
 	mutex_lock(&dev->lock);
 
 	if (fattr->type == RC_FILTER_NORMAL) {
-		enabled = dev->enabled_protocols[RC_FILTER_NORMAL];
+		enabled = dev->enabled_protocols;
 		if (dev->raw)
 			allowed = ir_raw_get_allowed_protocols();
 		else
-			allowed = dev->allowed_protocols[RC_FILTER_NORMAL];
+			allowed = dev->allowed_protocols;
 	} else {
-		enabled = dev->enabled_protocols[RC_FILTER_WAKEUP];
-		allowed = dev->allowed_protocols[RC_FILTER_WAKEUP];
+		enabled = dev->enabled_wakeup_protocols;
+		allowed = dev->allowed_wakeup_protocols;
 	}
 
 	mutex_unlock(&dev->lock);
@@ -1118,15 +1118,15 @@ static ssize_t store_protocols(struct device *device,
 
 	if (fattr->type == RC_FILTER_NORMAL) {
 		IR_dprintk(1, "Normal protocol change requested\n");
-		current_protocols = &dev->enabled_protocols[RC_FILTER_NORMAL];
+		current_protocols = &dev->enabled_protocols;
 		change_protocol = dev->change_protocol;
-		filter = &dev->scancode_filters[RC_FILTER_NORMAL];
+		filter = &dev->scancode_filter;
 		set_filter = dev->s_filter;
 	} else {
 		IR_dprintk(1, "Wakeup protocol change requested\n");
-		current_protocols = &dev->enabled_protocols[RC_FILTER_WAKEUP];
+		current_protocols = &dev->enabled_wakeup_protocols;
 		change_protocol = dev->change_wakeup_protocol;
-		filter = &dev->scancode_filters[RC_FILTER_WAKEUP];
+		filter = &dev->scancode_wakeup_filter;
 		set_filter = dev->s_wakeup_filter;
 	}
 
@@ -1214,9 +1214,9 @@ static ssize_t show_filter(struct device *device,
 		return -EINVAL;
 
 	if (fattr->type == RC_FILTER_NORMAL)
-		filter = &dev->scancode_filters[RC_FILTER_NORMAL];
+		filter = &dev->scancode_filter;
 	else
-		filter = &dev->scancode_filters[RC_FILTER_WAKEUP];
+		filter = &dev->scancode_wakeup_filter;
 
 	mutex_lock(&dev->lock);
 	if (fattr->mask)
@@ -1269,12 +1269,12 @@ static ssize_t store_filter(struct device *device,
 
 	if (fattr->type == RC_FILTER_NORMAL) {
 		set_filter = dev->s_filter;
-		enabled_protocols = &dev->enabled_protocols[RC_FILTER_NORMAL];
-		filter = &dev->scancode_filters[RC_FILTER_NORMAL];
+		enabled_protocols = &dev->enabled_protocols;
+		filter = &dev->scancode_filter;
 	} else {
 		set_filter = dev->s_wakeup_filter;
-		enabled_protocols = &dev->enabled_protocols[RC_FILTER_WAKEUP];
-		filter = &dev->scancode_filters[RC_FILTER_WAKEUP];
+		enabled_protocols = &dev->enabled_wakeup_protocols;
+		filter = &dev->scancode_wakeup_filter;
 	}
 
 	if (!set_filter)
@@ -1553,7 +1553,7 @@ int rc_register_device(struct rc_dev *dev)
 		rc = dev->change_protocol(dev, &rc_type);
 		if (rc < 0)
 			goto out_raw;
-		dev->enabled_protocols[RC_FILTER_NORMAL] = rc_type;
+		dev->enabled_protocols = rc_type;
 	}
 
 	mutex_unlock(&dev->lock);
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 47cd373..3f45e1a 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -922,7 +922,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->dev.parent = dev;
 	rc->priv = rr3;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rc, RC_BIT_ALL);
+	rc->allowed_protocols = RC_BIT_ALL;
 	rc->timeout = US_TO_NS(2750);
 	rc->tx_ir = redrat3_transmit_ir;
 	rc->s_tx_carrier = redrat3_set_tx_carrier;
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 22e4c1f..8f0cddb 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -287,7 +287,7 @@ static int st_rc_probe(struct platform_device *pdev)
 	st_rc_hardware_init(rc_dev);
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
+	rdev->allowed_protos = RC_BIT_ALL;
 	/* rx sampling rate is 10Mhz */
 	rdev->rx_resolution = 100;
 	rdev->timeout = US_TO_NS(MAX_SYMB_TIME);
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index f4e0bc3..7d7be0c 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -322,7 +322,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	rdev->dev.parent = dev;
 	rdev->priv = sz;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rdev, RC_BIT_ALL);
+	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->driver_name = DRIVER_NAME;
 	rdev->map_name = RC_MAP_STREAMZAP;
 
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index c5be38e..bc214e2 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -318,7 +318,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 	usb_to_input_id(tt->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc_set_allowed_protocols(rc, RC_BIT_ALL);
+	rc->allowed_protocols = RC_BIT_ALL;
 	rc->priv = tt;
 	rc->driver_name = DRIVER_NAME;
 	rc->map_name = RC_MAP_TT_1500;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index a8b981f..d839f73 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1082,7 +1082,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->dev.parent = &device->dev;
 	data->dev->timeout = MS_TO_NS(100);
 	data->dev->rx_resolution = US_TO_NS(2);
-	rc_set_allowed_protocols(data->dev, RC_BIT_ALL);
+	data->dev->allowed_protocols = RC_BIT_ALL;
 
 	err = rc_register_device(data->dev);
 	if (err)
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index de02db8..eaa76ef 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -164,7 +164,7 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
 	dev->driver_name = (char *) d->props->driver_name;
 	dev->map_name = d->rc.map_name;
 	dev->driver_type = d->rc.driver_type;
-	rc_set_allowed_protocols(dev, d->rc.allowed_protos);
+	dev->allowed_protocols = d->rc.allowed_protos;
 	dev->change_protocol = d->rc.change_protocol;
 	dev->priv = d;
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
index 4058aea..7b5dae3 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
@@ -272,7 +272,7 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 	dev->driver_name = d->props.rc.core.module_name;
 	dev->map_name = d->props.rc.core.rc_codes;
 	dev->change_protocol = d->props.rc.core.change_protocol;
-	rc_set_allowed_protocols(dev, d->props.rc.core.allowed_protos);
+	dev->allowed_protocols = d->props.rc.core.allowed_protos;
 	dev->driver_type = d->props.rc.core.driver_type;
 	usb_to_input_id(d->udev, &dev->input_id);
 	dev->input_name = "IR-receiver inside an USB DVB receiver";
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 4bbd8e4..1232e32 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -739,7 +739,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 		case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
 			rc->map_name = RC_MAP_HAUPPAUGE;
 			ir->get_key_i2c = em28xx_get_key_em_haup;
-			rc_set_allowed_protocols(rc, RC_BIT_RC5);
+			rc->allowed_protocols = RC_BIT_RC5;
 			break;
 		case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
 			rc->map_name = RC_MAP_WINFAST_USBII_DELUXE;
@@ -755,7 +755,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 		switch (dev->chip_id) {
 		case CHIP_ID_EM2860:
 		case CHIP_ID_EM2883:
-			rc_set_allowed_protocols(rc, RC_BIT_RC5 | RC_BIT_NEC);
+			rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC;
 			ir->get_key = default_polling_getkey;
 			break;
 		case CHIP_ID_EM2884:
@@ -763,8 +763,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 		case CHIP_ID_EM28174:
 		case CHIP_ID_EM28178:
 			ir->get_key = em2874_polling_getkey;
-			rc_set_allowed_protocols(rc, RC_BIT_RC5 | RC_BIT_NEC |
-						 RC_BIT_RC6_0);
+			rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC |
+					     RC_BIT_RC6_0;
 			break;
 		default:
 			err = -ENODEV;
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 676c0232..8a519f5 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -441,7 +441,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	ir->rc = rc;
 
 	/* input setup */
-	rc_set_allowed_protocols(rc, RC_BIT_RC5 | RC_BIT_NEC);
+	rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC;
 	/* Neded, in order to support NEC remotes with 24 or 32 bits */
 	rc->scanmask = 0xffff;
 	rc->priv = ir;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 6f66305..e6784e8 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -92,10 +92,12 @@ enum rc_filter_type {
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
- * @allowed_protocols: bitmask with the supported RC_BIT_* protocols for each
- *	filter type
- * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols for each
- *	filter type
+ * @allowed_protocols: bitmask with the supported RC_BIT_* protocols
+ * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
+ * @allowed_wakeup_protocols: bitmask with the supported RC_BIT_* wakeup protocols
+ * @enabled_wakeup_protocols: bitmask with the enabled RC_BIT_* wakeup protocols
+ * @scancode_filter: scancode filter
+ * @scancode_wakeup_filter: scancode wakeup filters
  * @scanmask: some hardware decoders are not capable of providing the full
  *	scancode to the application. As this is a hardware limit, we can't do
  *	anything with it. Yet, as the same keycode table can be used with other
@@ -115,7 +117,6 @@ enum rc_filter_type {
  * @max_timeout: maximum timeout supported by device
  * @rx_resolution : resolution (in ns) of input sampler
  * @tx_resolution: resolution (in ns) of output sampler
- * @scancode_filters: scancode filters (indexed by enum rc_filter_type)
  * @change_protocol: allow changing the protocol used on hardware decoders
  * @change_wakeup_protocol: allow changing the protocol used for wakeup
  *	filtering
@@ -150,8 +151,12 @@ struct rc_dev {
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
 	bool				idle;
-	u64				allowed_protocols[RC_FILTER_MAX];
-	u64				enabled_protocols[RC_FILTER_MAX];
+	u64				allowed_protocols;
+	u64				enabled_protocols;
+	u64				allowed_wakeup_protocols;
+	u64				enabled_wakeup_protocols;
+	struct rc_scancode_filter	scancode_filter;
+	struct rc_scancode_filter	scancode_wakeup_filter;
 	u32				users;
 	u32				scanmask;
 	void				*priv;
@@ -168,7 +173,6 @@ struct rc_dev {
 	u32				max_timeout;
 	u32				rx_resolution;
 	u32				tx_resolution;
-	struct rc_scancode_filter	scancode_filters[RC_FILTER_MAX];
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
 	int				(*change_wakeup_protocol)(struct rc_dev *dev, u64 *rc_type);
 	int				(*open)(struct rc_dev *dev);
@@ -189,42 +193,6 @@ struct rc_dev {
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
 
-static inline bool rc_protocols_allowed(struct rc_dev *rdev, u64 protos)
-{
-	return rdev->allowed_protocols[RC_FILTER_NORMAL] & protos;
-}
-
-/* should be called prior to registration or with mutex held */
-static inline void rc_set_allowed_protocols(struct rc_dev *rdev, u64 protos)
-{
-	rdev->allowed_protocols[RC_FILTER_NORMAL] = protos;
-}
-
-static inline bool rc_protocols_enabled(struct rc_dev *rdev, u64 protos)
-{
-	return rdev->enabled_protocols[RC_FILTER_NORMAL] & protos;
-}
-
-/* should be called prior to registration or with mutex held */
-static inline void rc_set_enabled_protocols(struct rc_dev *rdev, u64 protos)
-{
-	rdev->enabled_protocols[RC_FILTER_NORMAL] = protos;
-}
-
-/* should be called prior to registration or with mutex held */
-static inline void rc_set_allowed_wakeup_protocols(struct rc_dev *rdev,
-						   u64 protos)
-{
-	rdev->allowed_protocols[RC_FILTER_WAKEUP] = protos;
-}
-
-/* should be called prior to registration or with mutex held */
-static inline void rc_set_enabled_wakeup_protocols(struct rc_dev *rdev,
-						   u64 protos)
-{
-	rdev->enabled_protocols[RC_FILTER_WAKEUP] = protos;
-}
-
 /*
  * From rc-main.c
  * Those functions can be used on any type of Remote Controller. They

