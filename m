Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:57210 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaBGOZ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 09:25:29 -0500
Message-Id: <E1WBmMy-0005WI-ER@www.linuxtv.org>
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Thu, 06 Feb 2014 12:20:07 +0100
Subject: [git:media_tree/master] [media] media: rc: change 32bit NEC scancode format
To: linuxtv-commits@linuxtv.org
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] media: rc: change 32bit NEC scancode format
Author:  James Hogan <james.hogan@imgtec.com>
Date:    Fri Jan 17 10:58:50 2014 -0300

Change 32bit NEC scancode format (used by Apple and TiVo remotes) to
encode the data with the correct bit order. Previously the raw bits were
used without being bit reversed, now each 16bit half is bit reversed
compared to before.

So for the raw NEC data:
  (LSB/First) 0xAAaaCCcc (MSB/Last)
(where traditionally AA=address, aa=~address, CC=command, cc=~command)

We now generate the scancodes:
  (MSB) 0x0000AACC (LSB) (normal NEC)
  (MSB) 0x00AAaaCC (LSB) (extended NEC, address check wrong)
  (MSB) 0xaaAAccCC (LSB) (32-bit NEC, command check wrong)

Note that the address byte order in 32-bit NEC scancodes is different to
that of the extended NEC scancodes. I chose this way as it maintains the
order of the bits in the address/command fields, and CC is clearly
intended to be the LSB of the command if the TiVo codes are anything to
go by so it makes sense for AA to also be the LSB.

The TiVo keymap is updated accordingly.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

 drivers/media/rc/ir-nec-decoder.c  |    5 ++-
 drivers/media/rc/keymaps/rc-tivo.c |   86 ++++++++++++++++++------------------
 2 files changed, 47 insertions(+), 44 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=18bc17448147e93f31cc9b1a83be49f1224657b2

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 9a90094..1bab7ea 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -172,7 +172,10 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (send_32bits) {
 			/* NEC transport, but modified protocol, used by at
 			 * least Apple and TiVo remotes */
-			scancode = data->bits;
+			scancode = not_address << 24 |
+				   address     << 16 |
+				   not_command <<  8 |
+				   command;
 			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
 		} else if ((address ^ not_address) != 0xff) {
 			/* Extended NEC */
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
