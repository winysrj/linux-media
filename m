Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:56147 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751501AbcIUJyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 05:54:23 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] [media/input] rc: report rc protocol type to userspace through input
Date: Wed, 21 Sep 2016 10:54:21 +0100
Message-Id: <1474451661-28986-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We might want to know what protocol a remote uses when we do not know. With
this patch and another patch for v4l-utils (follows), you can do that with:

./ir-keytable  -p rc-5,nec,rc-6,jvc,sony,sanyo,sharp,xmp -t
Testing events. Please, press CTRL-C to abort.
1474415431.689685: event type EV_MSC(0x04): protocol = RC_TYPE_RC6_MCE
1474415431.689685: event type EV_MSC(0x04): scancode = 0x800f040e
1474415431.689685: event type EV_SYN(0x00).

This makes RC_TYPE_* part of the ABI. We also remove the enum rc_type,
since in input-event-codes.h we cannot not use enums.

In addition, now that the input layer knows the rc protocol and scancode,
at a later point we could add a feature where keymaps could be created
based on both protocol and scancode, not just scancode.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/i2c/ir-kbd-i2c.c              | 17 +++++----
 drivers/media/pci/bt8xx/bttv-input.c        |  4 +--
 drivers/media/pci/cx88/cx88-input.c         |  4 +--
 drivers/media/pci/ivtv/ivtv-i2c.c           |  4 +--
 drivers/media/pci/saa7134/saa7134-input.c   | 18 +++++-----
 drivers/media/rc/img-ir/img-ir-hw.h         |  2 +-
 drivers/media/rc/ir-nec-decoder.c           |  3 +-
 drivers/media/rc/ir-rc5-decoder.c           |  3 +-
 drivers/media/rc/ir-rc6-decoder.c           |  3 +-
 drivers/media/rc/ir-sony-decoder.c          |  3 +-
 drivers/media/rc/rc-main.c                  | 11 +++---
 drivers/media/usb/cx231xx/cx231xx-input.c   |  4 +--
 drivers/media/usb/dvb-usb-v2/af9015.c       |  2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c       |  3 +-
 drivers/media/usb/dvb-usb-v2/az6007.c       |  2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |  2 +-
 drivers/media/usb/dvb-usb/dib0700_core.c    |  2 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c |  3 +-
 drivers/media/usb/dvb-usb/dtt200u.c         |  2 +-
 drivers/media/usb/em28xx/em28xx-input.c     | 15 ++++----
 drivers/media/usb/tm6000/tm6000-input.c     |  3 +-
 include/media/i2c/ir-kbd-i2c.h              |  4 +--
 include/media/rc-core.h                     |  7 ++--
 include/media/rc-map.h                      | 54 ++---------------------------
 include/uapi/linux/input-event-codes.h      | 28 +++++++++++++++
 25 files changed, 89 insertions(+), 114 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index bf82726..f8435fa 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -62,7 +62,7 @@ module_param(debug, int, 0644);    /* debug level (0,1,2) */
 
 /* ----------------------------------------------------------------------- */
 
-static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_haup_common(struct IR_i2c *ir, u32 *protocol,
 			       u32 *scancode, u8 *ptoggle, int size, int offset)
 {
 	unsigned char buf[6];
@@ -104,13 +104,13 @@ static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
 	return 1;
 }
 
-static int get_key_haup(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_haup(struct IR_i2c *ir, u32 *protocol,
 			u32 *scancode, u8 *toggle)
 {
 	return get_key_haup_common (ir, protocol, scancode, toggle, 3, 0);
 }
 
-static int get_key_haup_xvr(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_haup_xvr(struct IR_i2c *ir, u32 *protocol,
 			    u32 *scancode, u8 *toggle)
 {
 	int ret;
@@ -129,7 +129,7 @@ static int get_key_haup_xvr(struct IR_i2c *ir, enum rc_type *protocol,
 	return get_key_haup_common(ir, protocol, scancode, toggle, 6, 3);
 }
 
-static int get_key_pixelview(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pixelview(struct IR_i2c *ir, u32 *protocol,
 			     u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -146,7 +146,7 @@ static int get_key_pixelview(struct IR_i2c *ir, enum rc_type *protocol,
 	return 1;
 }
 
-static int get_key_fusionhdtv(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_fusionhdtv(struct IR_i2c *ir, u32 *protocol,
 			      u32 *scancode, u8 *toggle)
 {
 	unsigned char buf[4];
@@ -171,7 +171,7 @@ static int get_key_fusionhdtv(struct IR_i2c *ir, enum rc_type *protocol,
 	return 1;
 }
 
-static int get_key_knc1(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_knc1(struct IR_i2c *ir, u32 *protocol,
 			u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -201,7 +201,7 @@ static int get_key_knc1(struct IR_i2c *ir, enum rc_type *protocol,
 	return 1;
 }
 
-static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_avermedia_cardbus(struct IR_i2c *ir, u32 *protocol,
 				     u32 *scancode, u8 *toggle)
 {
 	unsigned char subaddr, key, keygroup;
@@ -248,8 +248,7 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_type *protocol,
 
 static int ir_key_poll(struct IR_i2c *ir)
 {
-	enum rc_type protocol;
-	u32 scancode;
+	u32 protocol, scancode;
 	u8 toggle;
 	int rc;
 
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index a75c53d..9bc5c3b 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -331,8 +331,8 @@ static void bttv_ir_stop(struct bttv *btv)
  * Get_key functions used by I2C remotes
  */
 
-static int get_key_pv951(struct IR_i2c *ir, enum rc_type *protocol,
-			 u32 *scancode, u8 *toggle)
+static int get_key_pv951(struct IR_i2c *ir, u32 *protocol, u32 *scancode,
+								u8 *toggle)
 {
 	unsigned char b;
 
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 6eac81b..8950d78 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -556,8 +556,8 @@ void cx88_ir_irq(struct cx88_core *core)
 	ir_raw_event_handle(ir->dev);
 }
 
-static int get_key_pvr2000(struct IR_i2c *ir, enum rc_type *protocol,
-			   u32 *scancode, u8 *toggle)
+static int get_key_pvr2000(struct IR_i2c *ir, u32 *protocol, u32 *scancode,
+								u8 *toggle)
 {
 	int flags, code;
 
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index dd57442..f026d34 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -148,8 +148,8 @@ static const char * const hw_devicenames[] = {
 	"ir_video",		/* IVTV_HW_I2C_IR_RX_ADAPTEC */
 };
 
-static int get_key_adaptec(struct IR_i2c *ir, enum rc_type *protocol,
-			   u32 *scancode, u8 *toggle)
+static int get_key_adaptec(struct IR_i2c *ir, u32 *protocol, u32 *scancode,
+								u8 *toggle)
 {
 	unsigned char keybuf[4];
 
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index eff52bb..d480fb5 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -112,7 +112,7 @@ static int build_key(struct saa7134_dev *dev)
 
 /* --------------------- Chip specific I2C key builders ----------------- */
 
-static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_flydvb_trio(struct IR_i2c *ir, u32 *protocol,
 			       u32 *scancode, u8 *toggle)
 {
 	int gpio;
@@ -165,7 +165,7 @@ static int get_key_flydvb_trio(struct IR_i2c *ir, enum rc_type *protocol,
 	return 1;
 }
 
-static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *protocol,
 				       u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -214,7 +214,7 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, enum rc_type *protocol
 }
 
 /* copied and modified from get_key_msi_tvanywhere_plus() */
-static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_kworld_pc150u(struct IR_i2c *ir, u32 *protocol,
 				 u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -262,7 +262,7 @@ static int get_key_kworld_pc150u(struct IR_i2c *ir, enum rc_type *protocol,
 	return 1;
 }
 
-static int get_key_purpletv(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_purpletv(struct IR_i2c *ir, u32 *protocol,
 			    u32 *scancode, u8 *toggle)
 {
 	unsigned char b;
@@ -287,7 +287,7 @@ static int get_key_purpletv(struct IR_i2c *ir, enum rc_type *protocol,
 	return 1;
 }
 
-static int get_key_hvr1110(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_hvr1110(struct IR_i2c *ir, u32 *protocol,
 			   u32 *scancode, u8 *toggle)
 {
 	unsigned char buf[5];
@@ -318,7 +318,7 @@ static int get_key_hvr1110(struct IR_i2c *ir, enum rc_type *protocol,
 }
 
 
-static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_beholdm6xx(struct IR_i2c *ir, u32 *protocol,
 			      u32 *scancode, u8 *toggle)
 {
 	unsigned char data[12];
@@ -354,7 +354,7 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
 /* Common (grey or coloured) pinnacle PCTV remote handling
  *
  */
-static int get_key_pinnacle(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pinnacle(struct IR_i2c *ir, u32 *protocol,
 			    u32 *scancode, u8 *toggle, int parity_offset,
 			    int marker, int code_modulo)
 {
@@ -408,7 +408,7 @@ static int get_key_pinnacle(struct IR_i2c *ir, enum rc_type *protocol,
  *
  * Sylvain Pasche <sylvain.pasche@gmail.com>
  */
-static int get_key_pinnacle_grey(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pinnacle_grey(struct IR_i2c *ir, u32 *protocol,
 				 u32 *scancode, u8 *toggle)
 {
 
@@ -420,7 +420,7 @@ static int get_key_pinnacle_grey(struct IR_i2c *ir, enum rc_type *protocol,
  *
  * Ricardo Cerqueira <v4l@cerqueira.org>
  */
-static int get_key_pinnacle_color(struct IR_i2c *ir, enum rc_type *protocol,
+static int get_key_pinnacle_color(struct IR_i2c *ir, u32 *protocol,
 				  u32 *scancode, u8 *toggle)
 {
 	/* code_modulo parameter (0x88) is used to reduce code value to fit inside IR_KEYTAB_SIZE
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 91a2977..9f14d0f 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -141,7 +141,7 @@ struct img_ir_timing_regvals {
  * @toggle:	Toggle bit (defaults to 0).
  */
 struct img_ir_scancode_req {
-	enum rc_type protocol;
+	u32 protocol;
 	u32 scancode;
 	u8 toggle;
 };
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 2a9d155..10638d9 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -48,8 +48,7 @@ enum nec_state {
 static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct nec_dec *data = &dev->raw->nec;
-	u32 scancode;
-	enum rc_type rc_type;
+	u32 scancode, rc_type;
 	u8 address, not_address, command, not_command;
 	bool send_32bits = false;
 
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index a0fd4e6..4e4bdff 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -50,8 +50,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct rc5_dec *data = &dev->raw->rc5;
 	u8 toggle;
-	u32 scancode;
-	enum rc_type protocol;
+	u32 scancode, protocol;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index e0e2ede..1a62d40 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -86,9 +86,8 @@ static enum rc6_mode rc6_mode(struct rc6_dec *data)
 static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct rc6_dec *data = &dev->raw->rc6;
-	u32 scancode;
+	u32 scancode, protocol;
 	u8 toggle;
-	enum rc_type protocol;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index baa972c..047fd22 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -42,8 +42,7 @@ enum sony_state {
 static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct sony_dec *data = &dev->raw->sony;
-	enum rc_type protocol;
-	u32 scancode;
+	u32 protocol, scancode;
 	u8 device, subdevice, function;
 
 	if (!is_timing_event(ev)) {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 154020d..9c8e195 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -614,6 +614,7 @@ void rc_repeat(struct rc_dev *dev)
 
 	spin_lock_irqsave(&dev->keylock, flags);
 
+	input_event(dev->input_dev, EV_MSC, MSC_RC_TYPE, dev->last_protocol);
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
 	input_sync(dev->input_dev);
 
@@ -639,7 +640,7 @@ EXPORT_SYMBOL_GPL(rc_repeat);
  * This function is used internally to register a keypress, it must be
  * called with keylock held.
  */
-static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
+static void ir_do_keydown(struct rc_dev *dev, u32 protocol,
 			  u32 scancode, u32 keycode, u8 toggle)
 {
 	bool new_event = (!dev->keypressed		 ||
@@ -650,6 +651,7 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 	if (new_event && dev->keypressed)
 		ir_do_keyup(dev, false);
 
+	input_event(dev->input_dev, EV_MSC, MSC_RC_TYPE, protocol);
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
 
 	if (new_event && keycode != KEY_RESERVED) {
@@ -682,7 +684,7 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
  * This routine is used to signal that a key has been pressed on the
  * remote control.
  */
-void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle)
+void rc_keydown(struct rc_dev *dev, u32 protocol, u32 scancode, u8 toggle)
 {
 	unsigned long flags;
 	u32 keycode = rc_g_keycode_from_table(dev, scancode);
@@ -710,8 +712,8 @@ EXPORT_SYMBOL_GPL(rc_keydown);
  * This routine is used to signal that a key has been pressed on the
  * remote control. The driver must manually call rc_keyup() at a later stage.
  */
-void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
-			  u32 scancode, u8 toggle)
+void rc_keydown_notimeout(struct rc_dev *dev, u32 protocol, u32 scancode,
+								u8 toggle)
 {
 	unsigned long flags;
 	u32 keycode = rc_g_keycode_from_table(dev, scancode);
@@ -1425,6 +1427,7 @@ int rc_register_device(struct rc_dev *dev)
 	set_bit(EV_REP, dev->input_dev->evbit);
 	set_bit(EV_MSC, dev->input_dev->evbit);
 	set_bit(MSC_SCAN, dev->input_dev->mscbit);
+	set_bit(MSC_RC_TYPE, dev->input_dev->mscbit);
 	if (dev->open)
 		dev->input_dev->open = ir_open;
 	if (dev->close)
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 15d8d1b..51d121a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -24,8 +24,8 @@
 
 #define MODULE_NAME "cx231xx-input"
 
-static int get_key_isdbt(struct IR_i2c *ir, enum rc_type *protocol,
-			 u32 *pscancode, u8 *toggle)
+static int get_key_isdbt(struct IR_i2c *ir, u32 *protocol, u32 *pscancode,
+							u8 *toggle)
 {
 	int	rc;
 	u8	cmd, scancode;
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 941ceff..1974ba5 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1222,7 +1222,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 	/* Only process key if canary killed */
 	if (buf[16] != 0xff && buf[0] != 0x01) {
-		enum rc_type proto;
+		u32 proto;
 		dev_dbg(&d->udev->dev, "%s: key pressed %*ph\n",
 				__func__, 4, buf + 12);
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 8961dd7..4ca1607 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1828,8 +1828,7 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 {
 	struct usb_interface *intf = d->intf;
 	int ret;
-	enum rc_type proto;
-	u32 key;
+	u32 proto, key;
 	u8 buf[4];
 	struct usb_req req = { CMD_IR_GET, 0, 0, NULL, 4, buf };
 
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 50c07fe..9a9012b 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -208,7 +208,7 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 {
 	struct az6007_device_state *st = d_to_priv(d);
 	unsigned code;
-	enum rc_type proto;
+	u32 proto;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c583c63..ffb97c0 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1631,7 +1631,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		goto err;
 
 	if (buf[4] & 0x01) {
-		enum rc_type proto;
+		u32 proto;
 
 		if (buf[2] == (u8) ~buf[3]) {
 			if (buf[0] == (u8) ~buf[1]) {
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index f319665..dbe11fc 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -676,7 +676,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
 	struct dib0700_rc_response *poll_reply;
-	enum rc_type protocol;
+	u32 protocol;
 	u32 uninitialized_var(keycode);
 	u8 toggle;
 
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 0857b56..94b1630 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -518,8 +518,7 @@ static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
 static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 {
 	u8 key[4];
-	enum rc_type protocol;
-	u32 scancode;
+	u32 protocol, scancode;
 	u8 toggle;
 	int i;
 	struct dib0700_state *st = d->priv;
diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index d2a01b5..3b1d5da 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -62,7 +62,7 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)
 
 	dvb_usb_generic_rw(d,&cmd,1,key,5,0);
 	if (key[0] == 1) {
-		enum rc_type proto = RC_TYPE_NEC;
+		u32 proto = RC_TYPE_NEC;
 
 		scancode = key[1];
 		if ((u8) ~key[1] != key[2]) {
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 4007356..79e162d 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -54,7 +54,7 @@ struct em28xx_ir_poll_result {
 	unsigned int toggle_bit:1;
 	unsigned int read_count:7;
 
-	enum rc_type protocol;
+	u32 protocol;
 	u32 scancode;
 };
 
@@ -73,7 +73,8 @@ struct em28xx_IR {
 
 	struct i2c_client *i2c_client;
 
-	int  (*get_key_i2c)(struct i2c_client *ir, enum rc_type *protocol, u32 *scancode);
+	int  (*get_key_i2c)(struct i2c_client *ir, u32 *protocol,
+								u32 *scancode);
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
 };
 
@@ -82,7 +83,7 @@ struct em28xx_IR {
  **********************************************************/
 
 static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
-				   enum rc_type *protocol, u32 *scancode)
+				   u32 *protocol, u32 *scancode)
 {
 	unsigned char b;
 
@@ -106,7 +107,7 @@ static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
 }
 
 static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev,
-				  enum rc_type *protocol, u32 *scancode)
+				  u32 *protocol, u32 *scancode)
 {
 	unsigned char buf[2];
 	int size;
@@ -136,7 +137,7 @@ static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev,
 }
 
 static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
-					    enum rc_type *protocol, u32 *scancode)
+					    u32 *protocol, u32 *scancode)
 {
 	unsigned char buf[3];
 
@@ -154,7 +155,7 @@ static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
 }
 
 static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
-					       enum rc_type *protocol, u32 *scancode)
+					       u32 *protocol, u32 *scancode)
 {
 	unsigned char subaddr, keydetect, key;
 
@@ -294,7 +295,7 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
 {
 	static u32 scancode;
-	enum rc_type protocol;
+	u32 protocol;
 	int rc;
 
 	rc = ir->get_key_i2c(ir->i2c_client, &protocol, &scancode);
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 26b2ebb..03b5a5f 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -166,8 +166,7 @@ static void tm6000_ir_keydown(struct tm6000_IR *ir,
 			      const char *buf, unsigned int len)
 {
 	u8 device, command;
-	u32 scancode;
-	enum rc_type protocol;
+	u32 scancode, protocol;
 
 	if (len < 1)
 		return;
diff --git a/include/media/i2c/ir-kbd-i2c.h b/include/media/i2c/ir-kbd-i2c.h
index d856435..d4a065c 100644
--- a/include/media/i2c/ir-kbd-i2c.h
+++ b/include/media/i2c/ir-kbd-i2c.h
@@ -20,7 +20,7 @@ struct IR_i2c {
 	struct delayed_work    work;
 	char                   name[32];
 	char                   phys[32];
-	int                    (*get_key)(struct IR_i2c *ir, enum rc_type *protocol,
+	int                    (*get_key)(struct IR_i2c *ir, u32 *protocol,
 					  u32 *scancode, u8 *toggle);
 };
 
@@ -45,7 +45,7 @@ struct IR_i2c_init_data {
 	 * Specify either a function pointer or a value indicating one of
 	 * ir_kbd_i2c's internal get_key functions
 	 */
-	int                    (*get_key)(struct IR_i2c *ir, enum rc_type *protocol,
+	int                    (*get_key)(struct IR_i2c *ir, u32 *protocol,
 					  u32 *scancode, u8 *toggle);
 	enum ir_kbd_get_key_fn internal_get_key_func;
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 10908e3..e6ae9df 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -158,7 +158,7 @@ struct rc_dev {
 	unsigned long			keyup_jiffies;
 	struct timer_list		timer_keyup;
 	u32				last_keycode;
-	enum rc_type			last_protocol;
+	u32			last_protocol;
 	u32				last_scancode;
 	u8				last_toggle;
 	u32				timeout;
@@ -238,8 +238,9 @@ int rc_open(struct rc_dev *rdev);
 void rc_close(struct rc_dev *rdev);
 
 void rc_repeat(struct rc_dev *dev);
-void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
-void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
+void rc_keydown(struct rc_dev *dev, u32 protocol, u32 scancode, u8 toggle);
+void rc_keydown_notimeout(struct rc_dev *dev, u32 protocol, u32 scancode,
+								u8 toggle);
 void rc_keyup(struct rc_dev *dev);
 u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
 
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e1cc14c..cc5e5b3 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -10,57 +10,7 @@
  */
 
 #include <linux/input.h>
-
-/**
- * enum rc_type - type of the Remote Controller protocol
- *
- * @RC_TYPE_UNKNOWN: Protocol not known
- * @RC_TYPE_OTHER: Protocol known but proprietary
- * @RC_TYPE_RC5: Philips RC5 protocol
- * @RC_TYPE_RC5X: Philips RC5x protocol
- * @RC_TYPE_RC5_SZ: StreamZap variant of RC5
- * @RC_TYPE_JVC: JVC protocol
- * @RC_TYPE_SONY12: Sony 12 bit protocol
- * @RC_TYPE_SONY15: Sony 15 bit protocol
- * @RC_TYPE_SONY20: Sony 20 bit protocol
- * @RC_TYPE_NEC: NEC protocol
- * @RC_TYPE_NECX: Extended NEC protocol
- * @RC_TYPE_NEC32: NEC 32 bit protocol
- * @RC_TYPE_SANYO: Sanyo protocol
- * @RC_TYPE_MCE_KBD: RC6-ish MCE keyboard/mouse
- * @RC_TYPE_RC6_0: Philips RC6-0-16 protocol
- * @RC_TYPE_RC6_6A_20: Philips RC6-6A-20 protocol
- * @RC_TYPE_RC6_6A_24: Philips RC6-6A-24 protocol
- * @RC_TYPE_RC6_6A_32: Philips RC6-6A-32 protocol
- * @RC_TYPE_RC6_MCE: MCE (Philips RC6-6A-32 subtype) protocol
- * @RC_TYPE_SHARP: Sharp protocol
- * @RC_TYPE_XMP: XMP protocol
- * @RC_TYPE_CEC: CEC protocol
- */
-enum rc_type {
-	RC_TYPE_UNKNOWN		= 0,
-	RC_TYPE_OTHER		= 1,
-	RC_TYPE_RC5		= 2,
-	RC_TYPE_RC5X		= 3,
-	RC_TYPE_RC5_SZ		= 4,
-	RC_TYPE_JVC		= 5,
-	RC_TYPE_SONY12		= 6,
-	RC_TYPE_SONY15		= 7,
-	RC_TYPE_SONY20		= 8,
-	RC_TYPE_NEC		= 9,
-	RC_TYPE_NECX		= 10,
-	RC_TYPE_NEC32		= 11,
-	RC_TYPE_SANYO		= 12,
-	RC_TYPE_MCE_KBD		= 13,
-	RC_TYPE_RC6_0		= 14,
-	RC_TYPE_RC6_6A_20	= 15,
-	RC_TYPE_RC6_6A_24	= 16,
-	RC_TYPE_RC6_6A_32	= 17,
-	RC_TYPE_RC6_MCE		= 18,
-	RC_TYPE_SHARP		= 19,
-	RC_TYPE_XMP		= 20,
-	RC_TYPE_CEC		= 21,
-};
+#include <uapi/linux/input-event-codes.h>
 
 #define RC_BIT_NONE		0ULL
 #define RC_BIT_UNKNOWN		(1ULL << RC_TYPE_UNKNOWN)
@@ -135,7 +85,7 @@ struct rc_map {
 	unsigned int		size;
 	unsigned int		len;
 	unsigned int		alloc;
-	enum rc_type		rc_type;
+	unsigned int		rc_type;
 	const char		*name;
 	spinlock_t		lock;
 };
diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index d6d071f..97ef182 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -794,6 +794,7 @@
 #define MSC_RAW			0x03
 #define MSC_SCAN		0x04
 #define MSC_TIMESTAMP		0x05
+#define MSC_RC_TYPE		0x06
 #define MSC_MAX			0x07
 #define MSC_CNT			(MSC_MAX+1)
 
@@ -834,4 +835,31 @@
 #define SND_MAX			0x07
 #define SND_CNT			(SND_MAX+1)
 
+/*
+ * rc protocol type
+ */
+
+#define RC_TYPE_UNKNOWN		0    /* Protocol not known */
+#define RC_TYPE_OTHER		1    /* Protocol known but proprietary */
+#define RC_TYPE_RC5		2    /* Philips RC5 protocol */
+#define RC_TYPE_RC5X		3    /* Philips RC5x protocol */
+#define RC_TYPE_RC5_SZ		4    /* StreamZap variant of RC5 */
+#define RC_TYPE_JVC		5    /* JVC protocol */
+#define RC_TYPE_SONY12		6    /* Sony 12 bit protocol */
+#define RC_TYPE_SONY15		7    /* Sony 15 bit protocol */
+#define RC_TYPE_SONY20		8    /* Sony 20 bit protocol */
+#define RC_TYPE_NEC		9    /* NEC protocol */
+#define RC_TYPE_NECX		10   /* Extended NEC protocol */
+#define RC_TYPE_NEC32		11   /* NEC 32 bit protocol */
+#define RC_TYPE_SANYO		12   /* Sanyo protocol */
+#define RC_TYPE_MCE_KBD		13   /* RC6-ish MCE keyboard/mouse */
+#define RC_TYPE_RC6_0		14   /* Philips RC6-0-16 protocol */
+#define RC_TYPE_RC6_6A_20	15   /* Philips RC6-6A-20 protocol */
+#define RC_TYPE_RC6_6A_24	16   /* Philips RC6-6A-24 protocol */
+#define RC_TYPE_RC6_6A_32	17   /* Philips RC6-6A-32 protocol */
+#define RC_TYPE_RC6_MCE		18   /* MCE (Philips RC6-6A-32) protocol */
+#define RC_TYPE_SHARP		19   /* Sharp protocol */
+#define RC_TYPE_XMP		20   /* XMP protocol */
+#define RC_TYPE_CEC		21
+
 #endif
-- 
2.7.4

