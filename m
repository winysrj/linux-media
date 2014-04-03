Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40282 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXcI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:32:08 -0400
Subject: [PATCH 10/49] [RFC] rc-core: use the full 32 bits for NEC scancodes
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:32:06 +0200
Message-ID: <20140403233206.27099.59633.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the full 32 bits for all kinds of NEC scancodes simplifies rc-core
and the nec decoder without any loss of functionality.

In order to maintain backwards compatibility, some heuristics are added
in rc-main.c to convert scancodes to NEC32 as necessary.

I plan to introduce a different ioctl later which makes the protocol
explicit (and which expects all NEC scancodes to be 32 bit, thereby
removing the need for guesswork).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/pci/saa7134/saa7134-input.c |    6 +-
 drivers/media/rc/img-ir/img-ir-nec.c      |   79 ++----------------------
 drivers/media/rc/ir-nec-decoder.c         |   28 ++-------
 drivers/media/rc/keymaps/rc-tivo.c        |   95 ++++++++++++++---------------
 drivers/media/rc/rc-main.c                |   53 ++++++++++++++++
 drivers/media/usb/dvb-usb-v2/af9015.c     |   22 +------
 drivers/media/usb/dvb-usb-v2/af9035.c     |   15 +----
 drivers/media/usb/dvb-usb-v2/az6007.c     |   16 +----
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c   |   16 +----
 drivers/media/usb/dvb-usb/dib0700_core.c  |   21 ++----
 drivers/media/usb/em28xx/em28xx-input.c   |   14 +---
 include/media/rc-map.h                    |   16 ++++-
 12 files changed, 147 insertions(+), 234 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 887429b..4ba61ff 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -342,11 +342,9 @@ static int get_key_beholdm6xx(struct IR_i2c *ir, enum rc_type *protocol,
 		return -EIO;
 	}
 
-	if (data[9] != (unsigned char)(~data[8]))
-		return 0;
-
 	*protocol = RC_TYPE_NEC;
-	*scancode = RC_SCANCODE_NECX(data[11] << 8 | data[10], data[9]);
+	*scancode = RC_SCANCODE_NEC32(data[11] << 24 | data[10] << 16 |
+				      data[9]  << 8  | data[8]);
 	*toggle = 0;
 	return 1;
 }
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
index ee45795..133ea45 100644
--- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -5,42 +5,20 @@
  */
 
 #include "img-ir-hw.h"
-#include <linux/bitrev.h>
 
 /* Convert NEC data to a scancode */
 static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protocol,
 			       u32 *scancode, u64 enabled_protocols)
 {
-	unsigned int addr, addr_inv, data, data_inv;
 	/* a repeat code has no data */
 	if (!len)
 		return IMG_IR_REPEATCODE;
+
 	if (len != 32)
 		return -EINVAL;
-	/* raw encoding: ddDDaaAA */
-	addr     = (raw >>  0) & 0xff;
-	addr_inv = (raw >>  8) & 0xff;
-	data     = (raw >> 16) & 0xff;
-	data_inv = (raw >> 24) & 0xff;
-	if ((data_inv ^ data) != 0xff) {
-		/* 32-bit NEC (used by Apple and TiVo remotes) */
-		/* scan encoding: AAaaDDdd (LSBit first) */
-		*scancode = bitrev8(addr)     << 24 |
-			    bitrev8(addr_inv) << 16 |
-			    bitrev8(data)     <<  8 |
-			    bitrev8(data_inv);
-	} else if ((addr_inv ^ addr) != 0xff) {
-		/* Extended NEC */
-		/* scan encoding: AAaaDD */
-		*scancode = addr     << 16 |
-			    addr_inv <<  8 |
-			    data;
-	} else {
-		/* Normal NEC */
-		/* scan encoding: AADD */
-		*scancode = addr << 8 |
-			    data;
-	}
+
+	/* raw encoding : ddDDaaAA -> scan encoding: AAaaDDdd */
+	*scancode = swab32((u32)raw);
 	*protocol = RC_TYPE_NEC;
 	return IMG_IR_SCANCODE;
 }
@@ -49,52 +27,9 @@ static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protocol,
 static int img_ir_nec_filter(const struct rc_scancode_filter *in,
 			     struct img_ir_filter *out, u64 protocols)
 {
-	unsigned int addr, addr_inv, data, data_inv;
-	unsigned int addr_m, addr_inv_m, data_m, data_inv_m;
-
-	data       = in->data & 0xff;
-	data_m     = in->mask & 0xff;
-
-	if ((in->data | in->mask) & 0xff000000) {
-		/* 32-bit NEC (used by Apple and TiVo remotes) */
-		/* scan encoding: AAaaDDdd (LSBit first) */
-		addr       = bitrev8(in->data >> 24);
-		addr_m     = bitrev8(in->mask >> 24);
-		addr_inv   = bitrev8(in->data >> 16);
-		addr_inv_m = bitrev8(in->mask >> 16);
-		data       = bitrev8(in->data >>  8);
-		data_m     = bitrev8(in->mask >>  8);
-		data_inv   = bitrev8(in->data >>  0);
-		data_inv_m = bitrev8(in->mask >>  0);
-	} else if ((in->data | in->mask) & 0x00ff0000) {
-		/* Extended NEC */
-		/* scan encoding AAaaDD */
-		addr       = (in->data >> 16) & 0xff;
-		addr_m     = (in->mask >> 16) & 0xff;
-		addr_inv   = (in->data >>  8) & 0xff;
-		addr_inv_m = (in->mask >>  8) & 0xff;
-		data_inv   = data ^ 0xff;
-		data_inv_m = data_m;
-	} else {
-		/* Normal NEC */
-		/* scan encoding: AADD */
-		addr       = (in->data >>  8) & 0xff;
-		addr_m     = (in->mask >>  8) & 0xff;
-		addr_inv   = addr ^ 0xff;
-		addr_inv_m = addr_m;
-		data_inv   = data ^ 0xff;
-		data_inv_m = data_m;
-	}
-
-	/* raw encoding: ddDDaaAA */
-	out->data = data_inv << 24 |
-		    data     << 16 |
-		    addr_inv <<  8 |
-		    addr;
-	out->mask = data_inv_m << 24 |
-		    data_m     << 16 |
-		    addr_inv_m <<  8 |
-		    addr_m;
+	/* scan encoding: AAaaDDdd -> raw encoding: ddDDaaAA */
+	out->data = swab32((u32)in->data);
+	out->mask = swab32((u32)in->mask);
 	return 0;
 }
 
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index c4333d5..798e32b 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -50,7 +50,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct nec_dec *data = &dev->raw->nec;
 	u32 scancode;
 	u8 address, not_address, command, not_command;
-	bool send_32bits = false;
 
 	if (!rc_protocols_enabled(dev, RC_BIT_NEC))
 		return 0;
@@ -163,28 +162,11 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		command	    = bitrev8((data->bits >>  8) & 0xff);
 		not_command = bitrev8((data->bits >>  0) & 0xff);
 
-		if ((command ^ not_command) != 0xff) {
-			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
-				   data->bits);
-			send_32bits = true;
-		}
-
-		if (send_32bits) {
-			/* NEC transport, but modified protocol, used by at
-			 * least Apple and TiVo remotes */
-			scancode = data->bits;
-			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
-		} else if ((address ^ not_address) != 0xff) {
-			/* Extended NEC */
-			scancode = address     << 16 |
-				   not_address <<  8 |
-				   command;
-			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
-		} else {
-			/* Normal NEC */
-			scancode = address << 8 | command;
-			IR_dprintk(1, "NEC scancode 0x%04x\n", scancode);
-		}
+		scancode = RC_SCANCODE_NEC32(address	 << 24 |
+					     not_address << 16 |
+					     command	 << 8  |
+					     not_command);
+		IR_dprintk(1, "NEC scancode 0x%08x\n", scancode);
 
 		if (data->is_nec_x)
 			data->necx_repeat = true;
diff --git a/drivers/media/rc/keymaps/rc-tivo.c b/drivers/media/rc/keymaps/rc-tivo.c
index 454e062..63ed7ad 100644
--- a/drivers/media/rc/keymaps/rc-tivo.c
+++ b/drivers/media/rc/keymaps/rc-tivo.c
@@ -15,62 +15,61 @@
  * Initial mapping is for the TiVo remote included in the Nero LiquidTV bundle,
  * which also ships with a TiVo-branded IR transceiver, supported by the mceusb
  * driver. Note that the remote uses an NEC-ish protocol, but instead of having
- * a command/not_command pair, it has a vendor ID of 0xa10c, but some keys, the
- * NEC extended checksums do pass, so the table presently has the intended
- * values and the checksum-passed versions for those keys.
+ * a command/not_command pair, it has a vendor ID of 0x8530, but some keys, the
+ * NEC extended checksums do pass, so the table has the full code for all keys.
  */
 static struct rc_map_table tivo[] = {
-	{ 0xa10c900f, KEY_MEDIA },	/* TiVo Button */
-	{ 0xa10c0807, KEY_POWER2 },	/* TV Power */
-	{ 0xa10c8807, KEY_TV },		/* Live TV/Swap */
-	{ 0xa10c2c03, KEY_VIDEO_NEXT },	/* TV Input */
-	{ 0xa10cc807, KEY_INFO },
-	{ 0xa10cfa05, KEY_CYCLEWINDOWS }, /* Window */
-	{ 0x0085305f, KEY_CYCLEWINDOWS },
-	{ 0xa10c6c03, KEY_EPG },	/* Guide */
+	{ 0x853009f0, KEY_MEDIA },	/* TiVo Button */
+	{ 0x853010e0, KEY_POWER2 },	/* TV Power */
+	{ 0x853011e0, KEY_TV },		/* Live TV/Swap */
+	{ 0x853034c0, KEY_VIDEO_NEXT },	/* TV Input */
+	{ 0x853013e0, KEY_INFO },
+	{ 0x85305fa0, KEY_CYCLEWINDOWS }, /* Window */
+	{ 0x85005f30, KEY_CYCLEWINDOWS },
+	{ 0x853036c0, KEY_EPG },	/* Guide */
 
-	{ 0xa10c2807, KEY_UP },
-	{ 0xa10c6807, KEY_DOWN },
-	{ 0xa10ce807, KEY_LEFT },
-	{ 0xa10ca807, KEY_RIGHT },
+	{ 0x853014e0, KEY_UP },
+	{ 0x853016e0, KEY_DOWN },
+	{ 0x853017e0, KEY_LEFT },
+	{ 0x853015e0, KEY_RIGHT },
 
-	{ 0xa10c1807, KEY_SCROLLDOWN },	/* Red Thumbs Down */
-	{ 0xa10c9807, KEY_SELECT },
-	{ 0xa10c5807, KEY_SCROLLUP },	/* Green Thumbs Up */
+	{ 0x853018e0, KEY_SCROLLDOWN },	/* Red Thumbs Down */
+	{ 0x853019e0, KEY_SELECT },
+	{ 0x85301ae0, KEY_SCROLLUP },	/* Green Thumbs Up */
 
-	{ 0xa10c3807, KEY_VOLUMEUP },
-	{ 0xa10cb807, KEY_VOLUMEDOWN },
-	{ 0xa10cd807, KEY_MUTE },
-	{ 0xa10c040b, KEY_RECORD },
-	{ 0xa10c7807, KEY_CHANNELUP },
-	{ 0xa10cf807, KEY_CHANNELDOWN },
-	{ 0x0085301f, KEY_CHANNELDOWN },
+	{ 0x85301ce0, KEY_VOLUMEUP },
+	{ 0x85301de0, KEY_VOLUMEDOWN },
+	{ 0x85301be0, KEY_MUTE },
+	{ 0x853020d0, KEY_RECORD },
+	{ 0x85301ee0, KEY_CHANNELUP },
+	{ 0x85301fe0, KEY_CHANNELDOWN },
+	{ 0x85001f30, KEY_CHANNELDOWN },
 
-	{ 0xa10c840b, KEY_PLAY },
-	{ 0xa10cc40b, KEY_PAUSE },
-	{ 0xa10ca40b, KEY_SLOW },
-	{ 0xa10c440b, KEY_REWIND },
-	{ 0xa10c240b, KEY_FASTFORWARD },
-	{ 0xa10c640b, KEY_PREVIOUS },
-	{ 0xa10ce40b, KEY_NEXT },	/* ->| */
+	{ 0x853021d0, KEY_PLAY },
+	{ 0x853023d0, KEY_PAUSE },
+	{ 0x853025d0, KEY_SLOW },
+	{ 0x853022d0, KEY_REWIND },
+	{ 0x853024d0, KEY_FASTFORWARD },
+	{ 0x853026d0, KEY_PREVIOUS },
+	{ 0x853027d0, KEY_NEXT },	/* ->| */
 
-	{ 0xa10c220d, KEY_ZOOM },	/* Aspect */
-	{ 0xa10c120d, KEY_STOP },
-	{ 0xa10c520d, KEY_DVD },	/* DVD Menu */
+	{ 0x853044b0, KEY_ZOOM },	/* Aspect */
+	{ 0x853048b0, KEY_STOP },
+	{ 0x85304ab0, KEY_DVD },	/* DVD Menu */
 
-	{ 0xa10c140b, KEY_NUMERIC_1 },
-	{ 0xa10c940b, KEY_NUMERIC_2 },
-	{ 0xa10c540b, KEY_NUMERIC_3 },
-	{ 0xa10cd40b, KEY_NUMERIC_4 },
-	{ 0xa10c340b, KEY_NUMERIC_5 },
-	{ 0xa10cb40b, KEY_NUMERIC_6 },
-	{ 0xa10c740b, KEY_NUMERIC_7 },
-	{ 0xa10cf40b, KEY_NUMERIC_8 },
-	{ 0x0085302f, KEY_NUMERIC_8 },
-	{ 0xa10c0c03, KEY_NUMERIC_9 },
-	{ 0xa10c8c03, KEY_NUMERIC_0 },
-	{ 0xa10ccc03, KEY_ENTER },
-	{ 0xa10c4c03, KEY_CLEAR },
+	{ 0x853028d0, KEY_NUMERIC_1 },
+	{ 0x853029d0, KEY_NUMERIC_2 },
+	{ 0x85302ad0, KEY_NUMERIC_3 },
+	{ 0x85302bd0, KEY_NUMERIC_4 },
+	{ 0x85302cd0, KEY_NUMERIC_5 },
+	{ 0x85302dd0, KEY_NUMERIC_6 },
+	{ 0x85302ed0, KEY_NUMERIC_7 },
+	{ 0x85302fd0, KEY_NUMERIC_8 },
+	{ 0x85002f30, KEY_NUMERIC_8 },
+	{ 0x853030c0, KEY_NUMERIC_9 },
+	{ 0x853031c0, KEY_NUMERIC_0 },
+	{ 0x853033c0, KEY_ENTER },
+	{ 0x853032c0, KEY_CLEAR },
 };
 
 static struct rc_map_list tivo_map = {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 26c266b..00a0879 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -316,6 +316,49 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 }
 
 /**
+ * guess_protocol() - heuristics to guess the protocol for a scancode
+ * @rdev:	the struct rc_dev device descriptor
+ * @return:	the guessed RC_TYPE_* protocol
+ *
+ * Internal routine to guess the current IR protocol for legacy ioctls.
+ */
+static inline enum rc_type guess_protocol(struct rc_dev *rdev)
+{
+	struct rc_map *rc_map = &rdev->rc_map;
+
+	if (hweight64(rdev->enabled_protocols[RC_FILTER_NORMAL]) == 1)
+		return rc_bitmap_to_type(rdev->enabled_protocols[RC_FILTER_NORMAL]);
+	else if (hweight64(rdev->allowed_protocols[RC_FILTER_NORMAL]) == 1)
+		return rc_bitmap_to_type(rdev->allowed_protocols[RC_FILTER_NORMAL]);
+	else
+		return rc_map->rc_type;
+}
+
+/**
+ * to_nec32() - helper function to try to convert misc NEC scancodes to NEC32
+ * @orig:	original scancode
+ * @return:	NEC32 scancode
+ *
+ * This helper routine is used to provide backwards compatibility.
+ */
+static u32 to_nec32(u32 orig)
+{
+	u8 b3 = (u8)(orig >> 16);
+	u8 b2 = (u8)(orig >>  8);
+	u8 b1 = (u8)(orig >>  0);
+
+	if (orig <= 0xffff)
+		/* Plain old NEC */
+		return b2 << 24 | ((u8)~b2) << 16 |  b1 << 8 | ((u8)~b1);
+	else if (orig <= 0xffffff)
+		/* NEC extended */
+		return b3 << 24 | b2 << 16 |  b1 << 8 | ((u8)~b1);
+	else
+		/* NEC32 */
+		return orig;
+}
+
+/**
  * ir_setkeycode() - set a keycode in the scancode->keycode table
  * @idev:	the struct input_dev device descriptor
  * @scancode:	the desired scancode
@@ -348,6 +391,9 @@ static int ir_setkeycode(struct input_dev *idev,
 		if (retval)
 			goto out;
 
+		if (guess_protocol(rdev) == RC_TYPE_NEC)
+			scancode = to_nec32(scancode);
+
 		index = ir_establish_scancode(rdev, rc_map, scancode, true);
 		if (index >= rc_map->len) {
 			retval = -ENOMEM;
@@ -388,7 +434,10 @@ static int ir_setkeytable(struct rc_dev *dev,
 
 	for (i = 0; i < from->size; i++) {
 		index = ir_establish_scancode(dev, rc_map,
-					      from->scan[i].scancode, false);
+					      from->rc_type == RC_TYPE_NEC ?
+					      to_nec32(from->scan[i].scancode) :
+					      from->scan[i].scancode,
+					      false);
 		if (index >= rc_map->len) {
 			rc = -ENOMEM;
 			break;
@@ -462,6 +511,8 @@ static int ir_getkeycode(struct input_dev *idev,
 		if (retval)
 			goto out;
 
+		if (guess_protocol(rdev) == RC_TYPE_NEC)
+			scancode = to_nec32(scancode);
 		index = ir_lookup_by_scancode(rc_map, scancode);
 	}
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 5ca738a..8776eaf 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1230,24 +1230,10 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 		/* Remember this key */
 		memcpy(state->rc_last, &buf[12], 4);
-		if (buf[14] == (u8) ~buf[15]) {
-			if (buf[12] == (u8) ~buf[13]) {
-				/* NEC */
-				state->rc_keycode = RC_SCANCODE_NEC(buf[12],
-								    buf[14]);
-			} else {
-				/* NEC extended*/
-				state->rc_keycode = RC_SCANCODE_NECX(buf[12] << 8 |
-								     buf[13],
-								     buf[14]);
-			}
-		} else {
-			/* 32 bit NEC */
-			state->rc_keycode = RC_SCANCODE_NEC32(buf[12] << 24 |
-							      buf[13] << 16 |
-							      buf[14] << 8  |
-							      buf[15]);
-		}
+		state->rc_keycode = RC_SCANCODE_NEC32(buf[12] << 24 |
+						      buf[13] << 16 |
+						      buf[14] << 8  |
+						      buf[15]);
 		rc_keydown(d->rc_dev, RC_TYPE_NEC, state->rc_keycode, 0);
 	} else {
 		dev_dbg(&d->udev->dev, "%s: no key press\n", __func__);
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 3bfba13..6bc9693 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1284,19 +1284,8 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 	else if (ret < 0)
 		goto err;
 
-	if ((buf[2] + buf[3]) == 0xff) {
-		if ((buf[0] + buf[1]) == 0xff) {
-			/* NEC standard 16bit */
-			key = RC_SCANCODE_NEC(buf[0], buf[2]);
-		} else {
-			/* NEC extended 24bit */
-			key = RC_SCANCODE_NECX(buf[0] << 8 | buf[1], buf[2]);
-		}
-	} else {
-		/* NEC full code 32bit */
-		key = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
-					buf[2] << 8  | buf[3]);
-	}
+	key = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
+				buf[2] << 8  | buf[3]);
 
 	dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 4, buf);
 
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 935dbaa..7e38278 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -214,18 +214,10 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 	if (st->data[1] == 0x44)
 		return 0;
 
-	if ((st->data[3] ^ st->data[4]) == 0xff) {
-		if ((st->data[1] ^ st->data[2]) == 0xff)
-			code = RC_SCANCODE_NEC(st->data[1], st->data[3]);
-		else
-			code = RC_SCANCODE_NECX(st->data[1] << 8 | st->data[2],
-						st->data[3]);
-	} else {
-		code = RC_SCANCODE_NEC32(st->data[1] << 24 |
-					 st->data[2] << 16 |
-					 st->data[3] << 8  |
-					 st->data[4]);
-	}
+	code = RC_SCANCODE_NEC32(st->data[1] << 24 |
+				 st->data[2] << 16 |
+				 st->data[3] << 8  |
+				 st->data[4]);
 
 	rc_keydown(d->rc_dev, RC_TYPE_NEC, code, st->data[5]);
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 574f4ee..45c77b1 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1246,20 +1246,8 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		goto err;
 
 	if (buf[4] & 0x01) {
-		if (buf[2] == (u8) ~buf[3]) {
-			if (buf[0] == (u8) ~buf[1]) {
-				/* NEC standard (16 bit) */
-				rc_code = RC_SCANCODE_NEC(buf[0], buf[2]);
-			} else {
-				/* NEC extended (24 bit) */
-				rc_code = RC_SCANCODE_NECX(buf[0] << 8 | buf[1],
-							   buf[2]);
-			}
-		} else {
-			/* NEC full (32 bit) */
-			rc_code = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
-						    buf[2] << 8  | buf[3]);
-		}
+		rc_code = RC_SCANCODE_NEC32(buf[0] << 24 | buf[1] << 16 |
+					    buf[2] << 8  | buf[3]);
 
 		rc_keydown(d->rc_dev, RC_TYPE_NEC, rc_code, 0);
 
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 0d881b9..d7b7932 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -715,22 +715,11 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 			break;
 		}
 
-		if ((poll_reply->data ^ poll_reply->not_data) != 0xff) {
-			deb_data("NEC32 protocol\n");
-			scancode = RC_SCANCODE_NEC32(poll_reply->system     << 24 |
-						     poll_reply->not_system << 16 |
-						     poll_reply->data       << 8  |
-						     poll_reply->not_data);
-		} else if ((poll_reply->system ^ poll_reply->not_system) != 0xff) {
-			deb_data("NEC extended protocol\n");
-			scancode = RC_SCANCODE_NECX(poll_reply->system << 8 |
-						    poll_reply->not_system,
-						    poll_reply->data);
-		} else {
-			deb_data("NEC normal protocol\n");
-			scancode = RC_SCANCODE_NEC(poll_reply->system,
-						   poll_reply->data);
-		}
+		deb_data("NEC protocol\n");
+		scancode = RC_SCANCODE_NEC32(poll_reply->system     << 24 |
+					     poll_reply->not_system << 16 |
+					     poll_reply->data       << 8  |
+					     poll_reply->not_data);
 
 		break;
 	default:
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 014888f..4bbd8e4 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -261,16 +261,10 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 	case RC_BIT_NEC:
 		poll_result->protocol = RC_TYPE_RC5;
 		poll_result->scancode = msg[1] << 8 | msg[2];
-		if ((msg[3] ^ msg[4]) != 0xff)		/* 32 bits NEC */
-			poll_result->scancode = RC_SCANCODE_NEC32((msg[1] << 24) |
-								  (msg[2] << 16) |
-								  (msg[3] << 8)  |
-								  (msg[4]));
-		else if ((msg[1] ^ msg[2]) != 0xff)	/* 24 bits NEC */
-			poll_result->scancode = RC_SCANCODE_NECX(msg[1] << 8 |
-								 msg[2], msg[3]); 
-		else					/* Normal NEC */
-			poll_result->scancode = RC_SCANCODE_NEC(msg[1], msg[3]);
+		poll_result->scancode = RC_SCANCODE_NEC32((msg[1] << 24) |
+							  (msg[2] << 16) |
+							  (msg[3] << 8)  |
+							  (msg[4]));
 		break;
 
 	case RC_BIT_RC6_0:
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 894c7e4..2e6c659 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -33,6 +33,8 @@ enum rc_type {
 	RC_TYPE_SHARP		= 18,	/* Sharp protocol */
 };
 
+#define rc_bitmap_to_type(x) fls64(x)
+
 #define RC_BIT_NONE		0
 #define RC_BIT_UNKNOWN		(1 << RC_TYPE_UNKNOWN)
 #define RC_BIT_OTHER		(1 << RC_TYPE_OTHER)
@@ -64,13 +66,21 @@ enum rc_type {
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
 #define RC_SCANCODE_OTHER(x)			(x)
-#define RC_SCANCODE_NEC(addr, cmd)		(((addr) << 8) | (cmd))
-#define RC_SCANCODE_NECX(addr, cmd)		(((addr) << 8) | (cmd))
-#define RC_SCANCODE_NEC32(data)			((data) & 0xffffffff)
 #define RC_SCANCODE_RC5(sys, cmd)		(((sys) << 8) | (cmd))
 #define RC_SCANCODE_RC5_SZ(sys, cmd)		(((sys) << 8) | (cmd))
 #define RC_SCANCODE_RC6_0(sys, cmd)		(((sys) << 8) | (cmd))
 #define RC_SCANCODE_RC6_6A(vendor, sys, cmd)	(((vendor) << 16) | ((sys) << 8) | (cmd))
+#define RC_SCANCODE_NEC(addr, cmd)  \
+	((( (addr) & 0xff) << 24) | \
+	 ((~(addr) & 0xff) << 16) | \
+	 (( (cmd)  & 0xff) << 8 ) | \
+	 ((~(cmd)  & 0xff) << 0 ))
+#define RC_SCANCODE_NECX(addr, cmd)   \
+        ((( (addr) & 0xffff) << 16) | \
+         (( (cmd)  & 0x00ff) << 8)  | \
+         ((~(cmd)  & 0x00ff) << 0))
+#define RC_SCANCODE_NEC32(data) ((data) & 0xffffffff)
+
 
 struct rc_map_table {
 	u32	scancode;

