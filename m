Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:37723 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935649AbcLOMuI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:08 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v6 03/18] [media] rc: unify nec32 protocol scancode format
Date: Thu, 15 Dec 2016 12:50:04 +0000
Message-Id: <1eeb7850fb04976789befdc11929ffa408d4d663.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two different encodings used for nec32:
 - The ir-nec-decoder.c decoder treats it as 32 bit msb first.
 - The img-ir decoder/encoder, winbond wakeup, dib0700, ir-ctl userspace,
   treat nec32 analogous to necx and nec: 4 bytes, each lsb first. So this
   format reverses the 4 bytes.

There are arguments to be had for both formats, but we should not use
different formats in different parts of the kernel. Selecting the second
format introduces the least code churn. It does mean that the TiVo keymap
needs updating.

This change was submitted before as "18bc174 [media] media: rc: change
32bit NEC scancode format", which was reverted because it was unclear
what scancode rc drivers produce. There are now more examples of drivers
which produce nec32 in lsb format.

The TiVo keymap is verified against the Nero Liquid TiVo remote. The
keymap is not for the Tivo DVR remote, which uses rc-5.

Signed-off-by: Sean Young <sean@mess.org>
Cc: James Hogan <james.hogan@imgtec.com>
---
 drivers/media/rc/ir-nec-decoder.c  |  5 ++-
 drivers/media/rc/keymaps/rc-tivo.c | 86 +++++++++++++++++++-------------------
 2 files changed, 47 insertions(+), 44 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 2a9d155..a5d418e 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -170,7 +170,10 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (send_32bits) {
 			/* NEC transport, but modified protocol, used by at
 			 * least Apple and TiVo remotes */
-			scancode = data->bits;
+			scancode = not_address << 24 |
+				address     << 16 |
+				not_command <<  8 |
+				command;
 			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
 			rc_type = RC_TYPE_NEC32;
 		} else if ((address ^ not_address) != 0xff) {
diff --git a/drivers/media/rc/keymaps/rc-tivo.c b/drivers/media/rc/keymaps/rc-tivo.c
index 454e062..5cc1b45 100644
--- a/drivers/media/rc/keymaps/rc-tivo.c
+++ b/drivers/media/rc/keymaps/rc-tivo.c
@@ -15,62 +15,62 @@
  * Initial mapping is for the TiVo remote included in the Nero LiquidTV bundle,
  * which also ships with a TiVo-branded IR transceiver, supported by the mceusb
  * driver. Note that the remote uses an NEC-ish protocol, but instead of having
- * a command/not_command pair, it has a vendor ID of 0xa10c, but some keys, the
+ * a command/not_command pair, it has a vendor ID of 0x3085, but some keys, the
  * NEC extended checksums do pass, so the table presently has the intended
  * values and the checksum-passed versions for those keys.
  */
 static struct rc_map_table tivo[] = {
-	{ 0xa10c900f, KEY_MEDIA },	/* TiVo Button */
-	{ 0xa10c0807, KEY_POWER2 },	/* TV Power */
-	{ 0xa10c8807, KEY_TV },		/* Live TV/Swap */
-	{ 0xa10c2c03, KEY_VIDEO_NEXT },	/* TV Input */
-	{ 0xa10cc807, KEY_INFO },
-	{ 0xa10cfa05, KEY_CYCLEWINDOWS }, /* Window */
+	{ 0x3085f009, KEY_MEDIA },	/* TiVo Button */
+	{ 0x3085e010, KEY_POWER2 },	/* TV Power */
+	{ 0x3085e011, KEY_TV },		/* Live TV/Swap */
+	{ 0x3085c034, KEY_VIDEO_NEXT },	/* TV Input */
+	{ 0x3085e013, KEY_INFO },
+	{ 0x3085a05f, KEY_CYCLEWINDOWS }, /* Window */
 	{ 0x0085305f, KEY_CYCLEWINDOWS },
-	{ 0xa10c6c03, KEY_EPG },	/* Guide */
+	{ 0x3085c036, KEY_EPG },	/* Guide */
 
-	{ 0xa10c2807, KEY_UP },
-	{ 0xa10c6807, KEY_DOWN },
-	{ 0xa10ce807, KEY_LEFT },
-	{ 0xa10ca807, KEY_RIGHT },
+	{ 0x3085e014, KEY_UP },
+	{ 0x3085e016, KEY_DOWN },
+	{ 0x3085e017, KEY_LEFT },
+	{ 0x3085e015, KEY_RIGHT },
 
-	{ 0xa10c1807, KEY_SCROLLDOWN },	/* Red Thumbs Down */
-	{ 0xa10c9807, KEY_SELECT },
-	{ 0xa10c5807, KEY_SCROLLUP },	/* Green Thumbs Up */
+	{ 0x3085e018, KEY_SCROLLDOWN },	/* Red Thumbs Down */
+	{ 0x3085e019, KEY_SELECT },
+	{ 0x3085e01a, KEY_SCROLLUP },	/* Green Thumbs Up */
 
-	{ 0xa10c3807, KEY_VOLUMEUP },
-	{ 0xa10cb807, KEY_VOLUMEDOWN },
-	{ 0xa10cd807, KEY_MUTE },
-	{ 0xa10c040b, KEY_RECORD },
-	{ 0xa10c7807, KEY_CHANNELUP },
-	{ 0xa10cf807, KEY_CHANNELDOWN },
+	{ 0x3085e01c, KEY_VOLUMEUP },
+	{ 0x3085e01d, KEY_VOLUMEDOWN },
+	{ 0x3085e01b, KEY_MUTE },
+	{ 0x3085d020, KEY_RECORD },
+	{ 0x3085e01e, KEY_CHANNELUP },
+	{ 0x3085e01f, KEY_CHANNELDOWN },
 	{ 0x0085301f, KEY_CHANNELDOWN },
 
-	{ 0xa10c840b, KEY_PLAY },
-	{ 0xa10cc40b, KEY_PAUSE },
-	{ 0xa10ca40b, KEY_SLOW },
-	{ 0xa10c440b, KEY_REWIND },
-	{ 0xa10c240b, KEY_FASTFORWARD },
-	{ 0xa10c640b, KEY_PREVIOUS },
-	{ 0xa10ce40b, KEY_NEXT },	/* ->| */
+	{ 0x3085d021, KEY_PLAY },
+	{ 0x3085d023, KEY_PAUSE },
+	{ 0x3085d025, KEY_SLOW },
+	{ 0x3085d022, KEY_REWIND },
+	{ 0x3085d024, KEY_FASTFORWARD },
+	{ 0x3085d026, KEY_PREVIOUS },
+	{ 0x3085d027, KEY_NEXT },	/* ->| */
 
-	{ 0xa10c220d, KEY_ZOOM },	/* Aspect */
-	{ 0xa10c120d, KEY_STOP },
-	{ 0xa10c520d, KEY_DVD },	/* DVD Menu */
+	{ 0x3085b044, KEY_ZOOM },	/* Aspect */
+	{ 0x3085b048, KEY_STOP },
+	{ 0x3085b04a, KEY_DVD },	/* DVD Menu */
 
-	{ 0xa10c140b, KEY_NUMERIC_1 },
-	{ 0xa10c940b, KEY_NUMERIC_2 },
-	{ 0xa10c540b, KEY_NUMERIC_3 },
-	{ 0xa10cd40b, KEY_NUMERIC_4 },
-	{ 0xa10c340b, KEY_NUMERIC_5 },
-	{ 0xa10cb40b, KEY_NUMERIC_6 },
-	{ 0xa10c740b, KEY_NUMERIC_7 },
-	{ 0xa10cf40b, KEY_NUMERIC_8 },
+	{ 0x3085d028, KEY_NUMERIC_1 },
+	{ 0x3085d029, KEY_NUMERIC_2 },
+	{ 0x3085d02a, KEY_NUMERIC_3 },
+	{ 0x3085d02b, KEY_NUMERIC_4 },
+	{ 0x3085d02c, KEY_NUMERIC_5 },
+	{ 0x3085d02d, KEY_NUMERIC_6 },
+	{ 0x3085d02e, KEY_NUMERIC_7 },
+	{ 0x3085d02f, KEY_NUMERIC_8 },
 	{ 0x0085302f, KEY_NUMERIC_8 },
-	{ 0xa10c0c03, KEY_NUMERIC_9 },
-	{ 0xa10c8c03, KEY_NUMERIC_0 },
-	{ 0xa10ccc03, KEY_ENTER },
-	{ 0xa10c4c03, KEY_CLEAR },
+	{ 0x3085c030, KEY_NUMERIC_9 },
+	{ 0x3085c031, KEY_NUMERIC_0 },
+	{ 0x3085c033, KEY_ENTER },
+	{ 0x3085c032, KEY_CLEAR },
 };
 
 static struct rc_map_list tivo_map = {
-- 
2.9.3

