Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38300 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaC2QLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 12:11:08 -0400
Subject: [PATCH 04/11] rc-core: do not change 32bit NEC scancode format for now
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: james.hogan@imgtec.com, m.chehab@samsung.com
Date: Sat, 29 Mar 2014 17:11:05 +0100
Message-ID: <20140329161105.13234.40393.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts 18bc17448147e93f31cc9b1a83be49f1224657b2

The patch ignores the fact that NEC32 scancodes are generated not only in the
NEC raw decoder but also directly in some drivers. Whichever approach is chosen
it should be consistent across drivers and this patch needs more discussion.

Furthermore, I'm convinced that we have to stop playing games trying to
decipher the "meaning" of NEC scancodes (what's the customer/vendor/address,
which byte is the MSB, etc).

This patch is in preparation for the next few patches in this series.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/img-ir/img-ir-nec.c |   27 ++++++-----
 drivers/media/rc/ir-nec-decoder.c    |    5 --
 drivers/media/rc/keymaps/rc-tivo.c   |   86 +++++++++++++++++-----------------
 3 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
index c0111d6..40ee844 100644
--- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -5,6 +5,7 @@
  */
 
 #include "img-ir-hw.h"
+#include <linux/bitrev.h>
 
 /* Convert NEC data to a scancode */
 static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protocol,
@@ -23,11 +24,11 @@ static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protocol,
 	data_inv = (raw >> 24) & 0xff;
 	if ((data_inv ^ data) != 0xff) {
 		/* 32-bit NEC (used by Apple and TiVo remotes) */
-		/* scan encoding: aaAAddDD */
-		*scancode = addr_inv << 24 |
-			    addr     << 16 |
-			    data_inv <<  8 |
-			    data;
+		/* scan encoding: AAaaDDdd (LSBit first) */
+		*scancode = bitrev8(addr)     << 24 |
+			    bitrev8(addr_inv) << 16 |
+			    bitrev8(data)     <<  8 |
+			    bitrev8(data_inv);
 	} else if ((addr_inv ^ addr) != 0xff) {
 		/* Extended NEC */
 		/* scan encoding: AAaaDD */
@@ -56,13 +57,15 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
 
 	if ((in->data | in->mask) & 0xff000000) {
 		/* 32-bit NEC (used by Apple and TiVo remotes) */
-		/* scan encoding: aaAAddDD */
-		addr_inv   = (in->data >> 24) & 0xff;
-		addr_inv_m = (in->mask >> 24) & 0xff;
-		addr       = (in->data >> 16) & 0xff;
-		addr_m     = (in->mask >> 16) & 0xff;
-		data_inv   = (in->data >>  8) & 0xff;
-		data_inv_m = (in->mask >>  8) & 0xff;
+		/* scan encoding: AAaaDDdd (LSBit first) */
+		addr       = bitrev8((in->data >> 24) & 0xff);
+		addr_m     = (in->mask >> 24) & 0xff;
+		addr_inv   = bitrev8((in->data >> 16) & 0xff);
+		addr_inv_m = (in->mask >> 16) & 0xff;
+		data       = bitrev8((in->data >>  8) & 0xff);
+		data_m     = (in->mask >>  8) & 0xff;
+		data_inv   = bitrev8((in->data >>  0) & 0xff);
+		data_inv_m = (in->mask >>  0) & 0xff;
 	} else if ((in->data | in->mask) & 0x00ff0000) {
 		/* Extended NEC */
 		/* scan encoding AAaaDD */
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 735a509..c4333d5 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -172,10 +172,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (send_32bits) {
 			/* NEC transport, but modified protocol, used by at
 			 * least Apple and TiVo remotes */
-			scancode = not_address << 24 |
-				   address     << 16 |
-				   not_command <<  8 |
-				   command;
+			scancode = data->bits;
 			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
 		} else if ((address ^ not_address) != 0xff) {
 			/* Extended NEC */
diff --git a/drivers/media/rc/keymaps/rc-tivo.c b/drivers/media/rc/keymaps/rc-tivo.c
index 5cc1b45..454e062 100644
--- a/drivers/media/rc/keymaps/rc-tivo.c
+++ b/drivers/media/rc/keymaps/rc-tivo.c
@@ -15,62 +15,62 @@
  * Initial mapping is for the TiVo remote included in the Nero LiquidTV bundle,
  * which also ships with a TiVo-branded IR transceiver, supported by the mceusb
  * driver. Note that the remote uses an NEC-ish protocol, but instead of having
- * a command/not_command pair, it has a vendor ID of 0x3085, but some keys, the
+ * a command/not_command pair, it has a vendor ID of 0xa10c, but some keys, the
  * NEC extended checksums do pass, so the table presently has the intended
  * values and the checksum-passed versions for those keys.
  */
 static struct rc_map_table tivo[] = {
-	{ 0x3085f009, KEY_MEDIA },	/* TiVo Button */
-	{ 0x3085e010, KEY_POWER2 },	/* TV Power */
-	{ 0x3085e011, KEY_TV },		/* Live TV/Swap */
-	{ 0x3085c034, KEY_VIDEO_NEXT },	/* TV Input */
-	{ 0x3085e013, KEY_INFO },
-	{ 0x3085a05f, KEY_CYCLEWINDOWS }, /* Window */
+	{ 0xa10c900f, KEY_MEDIA },	/* TiVo Button */
+	{ 0xa10c0807, KEY_POWER2 },	/* TV Power */
+	{ 0xa10c8807, KEY_TV },		/* Live TV/Swap */
+	{ 0xa10c2c03, KEY_VIDEO_NEXT },	/* TV Input */
+	{ 0xa10cc807, KEY_INFO },
+	{ 0xa10cfa05, KEY_CYCLEWINDOWS }, /* Window */
 	{ 0x0085305f, KEY_CYCLEWINDOWS },
-	{ 0x3085c036, KEY_EPG },	/* Guide */
+	{ 0xa10c6c03, KEY_EPG },	/* Guide */
 
-	{ 0x3085e014, KEY_UP },
-	{ 0x3085e016, KEY_DOWN },
-	{ 0x3085e017, KEY_LEFT },
-	{ 0x3085e015, KEY_RIGHT },
+	{ 0xa10c2807, KEY_UP },
+	{ 0xa10c6807, KEY_DOWN },
+	{ 0xa10ce807, KEY_LEFT },
+	{ 0xa10ca807, KEY_RIGHT },
 
-	{ 0x3085e018, KEY_SCROLLDOWN },	/* Red Thumbs Down */
-	{ 0x3085e019, KEY_SELECT },
-	{ 0x3085e01a, KEY_SCROLLUP },	/* Green Thumbs Up */
+	{ 0xa10c1807, KEY_SCROLLDOWN },	/* Red Thumbs Down */
+	{ 0xa10c9807, KEY_SELECT },
+	{ 0xa10c5807, KEY_SCROLLUP },	/* Green Thumbs Up */
 
-	{ 0x3085e01c, KEY_VOLUMEUP },
-	{ 0x3085e01d, KEY_VOLUMEDOWN },
-	{ 0x3085e01b, KEY_MUTE },
-	{ 0x3085d020, KEY_RECORD },
-	{ 0x3085e01e, KEY_CHANNELUP },
-	{ 0x3085e01f, KEY_CHANNELDOWN },
+	{ 0xa10c3807, KEY_VOLUMEUP },
+	{ 0xa10cb807, KEY_VOLUMEDOWN },
+	{ 0xa10cd807, KEY_MUTE },
+	{ 0xa10c040b, KEY_RECORD },
+	{ 0xa10c7807, KEY_CHANNELUP },
+	{ 0xa10cf807, KEY_CHANNELDOWN },
 	{ 0x0085301f, KEY_CHANNELDOWN },
 
-	{ 0x3085d021, KEY_PLAY },
-	{ 0x3085d023, KEY_PAUSE },
-	{ 0x3085d025, KEY_SLOW },
-	{ 0x3085d022, KEY_REWIND },
-	{ 0x3085d024, KEY_FASTFORWARD },
-	{ 0x3085d026, KEY_PREVIOUS },
-	{ 0x3085d027, KEY_NEXT },	/* ->| */
+	{ 0xa10c840b, KEY_PLAY },
+	{ 0xa10cc40b, KEY_PAUSE },
+	{ 0xa10ca40b, KEY_SLOW },
+	{ 0xa10c440b, KEY_REWIND },
+	{ 0xa10c240b, KEY_FASTFORWARD },
+	{ 0xa10c640b, KEY_PREVIOUS },
+	{ 0xa10ce40b, KEY_NEXT },	/* ->| */
 
-	{ 0x3085b044, KEY_ZOOM },	/* Aspect */
-	{ 0x3085b048, KEY_STOP },
-	{ 0x3085b04a, KEY_DVD },	/* DVD Menu */
+	{ 0xa10c220d, KEY_ZOOM },	/* Aspect */
+	{ 0xa10c120d, KEY_STOP },
+	{ 0xa10c520d, KEY_DVD },	/* DVD Menu */
 
-	{ 0x3085d028, KEY_NUMERIC_1 },
-	{ 0x3085d029, KEY_NUMERIC_2 },
-	{ 0x3085d02a, KEY_NUMERIC_3 },
-	{ 0x3085d02b, KEY_NUMERIC_4 },
-	{ 0x3085d02c, KEY_NUMERIC_5 },
-	{ 0x3085d02d, KEY_NUMERIC_6 },
-	{ 0x3085d02e, KEY_NUMERIC_7 },
-	{ 0x3085d02f, KEY_NUMERIC_8 },
+	{ 0xa10c140b, KEY_NUMERIC_1 },
+	{ 0xa10c940b, KEY_NUMERIC_2 },
+	{ 0xa10c540b, KEY_NUMERIC_3 },
+	{ 0xa10cd40b, KEY_NUMERIC_4 },
+	{ 0xa10c340b, KEY_NUMERIC_5 },
+	{ 0xa10cb40b, KEY_NUMERIC_6 },
+	{ 0xa10c740b, KEY_NUMERIC_7 },
+	{ 0xa10cf40b, KEY_NUMERIC_8 },
 	{ 0x0085302f, KEY_NUMERIC_8 },
-	{ 0x3085c030, KEY_NUMERIC_9 },
-	{ 0x3085c031, KEY_NUMERIC_0 },
-	{ 0x3085c033, KEY_ENTER },
-	{ 0x3085c032, KEY_CLEAR },
+	{ 0xa10c0c03, KEY_NUMERIC_9 },
+	{ 0xa10c8c03, KEY_NUMERIC_0 },
+	{ 0xa10ccc03, KEY_ENTER },
+	{ 0xa10c4c03, KEY_CLEAR },
 };
 
 static struct rc_map_list tivo_map = {

