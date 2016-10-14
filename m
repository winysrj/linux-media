Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59138 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757023AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 47/57] [media] ttusb-dec: don't break long lines
Date: Fri, 14 Oct 2016 17:20:35 -0300
Message-Id: <673e9a0676e16bb5658f25df656dc07ce3c4b3b2.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 35d5003ff809..6d1b84be105a 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -708,8 +708,7 @@ static void ttusb_dec_process_urb_frame(struct ttusb_dec *dec, u8 *b,
 					dec->packet_payload_length = 2;
 					dec->packet_state = 7;
 				} else {
-					printk("%s: unknown packet type: "
-					       "%02x%02x\n", __func__,
+					printk("%s: unknown packet type: %02x%02x\n", __func__,
 					       dec->packet[0], dec->packet[1]);
 					dec->packet_state = 0;
 				}
@@ -961,8 +960,7 @@ static int ttusb_dec_start_iso_xfer(struct ttusb_dec *dec)
 		for (i = 0; i < ISO_BUF_COUNT; i++) {
 			if ((result = usb_submit_urb(dec->iso_urb[i],
 						     GFP_ATOMIC))) {
-				printk("%s: failed urb submission %d: "
-				       "error %d\n", __func__, i, result);
+				printk("%s: failed urb submission %d: error %d\n", __func__, i, result);
 
 				while (i) {
 					usb_kill_urb(dec->iso_urb[i - 1]);
@@ -1375,8 +1373,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	memcpy(&tmp, &firmware[56], 4);
 	crc32_check = ntohl(tmp);
 	if (crc32_csum != crc32_check) {
-		printk("%s: crc32 check of DSP code failed (calculated "
-		       "0x%08x != 0x%08x in file), file invalid.\n",
+		printk("%s: crc32 check of DSP code failed (calculated 0x%08x != 0x%08x in file), file invalid.\n",
 			__func__, crc32_csum, crc32_check);
 		release_firmware(fw_entry);
 		return -ENOENT;
@@ -1453,11 +1450,9 @@ static int ttusb_dec_init_stb(struct ttusb_dec *dec)
 
 	if (!mode) {
 		if (version == 0xABCDEFAB)
-			printk(KERN_INFO "ttusb_dec: no version "
-			       "info in Firmware\n");
+			printk(KERN_INFO "ttusb_dec: no version info in Firmware\n");
 		else
-			printk(KERN_INFO "ttusb_dec: Firmware "
-			       "%x.%02x%c%c\n",
+			printk(KERN_INFO "ttusb_dec: Firmware %x.%02x%c%c\n",
 			       version >> 24, (version >> 16) & 0xff,
 			       (version >> 8) & 0xff, version & 0xff);
 
@@ -1481,8 +1476,7 @@ static int ttusb_dec_init_stb(struct ttusb_dec *dec)
 			ttusb_dec_set_model(dec, TTUSB_DEC2540T);
 			break;
 		default:
-			printk(KERN_ERR "%s: unknown model returned "
-			       "by firmware (%08x) - please report\n",
+			printk(KERN_ERR "%s: unknown model returned by firmware (%08x) - please report\n",
 			       __func__, model);
 			return -ENOENT;
 		}
-- 
2.7.4


