Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934737AbcJRUqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH v2 46/58] ttusb-dec: don't break long lines
Date: Tue, 18 Oct 2016 18:45:58 -0200
Message-Id: <56d9fdb2cbd9b92c961b6ea1a6af3a5efdf1d948.1476822925.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 35d5003ff809..559c823a4fe8 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -708,8 +708,8 @@ static void ttusb_dec_process_urb_frame(struct ttusb_dec *dec, u8 *b,
 					dec->packet_payload_length = 2;
 					dec->packet_state = 7;
 				} else {
-					printk("%s: unknown packet type: "
-					       "%02x%02x\n", __func__,
+					printk("%s: unknown packet type: %02x%02x\n",
+					       __func__,
 					       dec->packet[0], dec->packet[1]);
 					dec->packet_state = 0;
 				}
@@ -961,8 +961,8 @@ static int ttusb_dec_start_iso_xfer(struct ttusb_dec *dec)
 		for (i = 0; i < ISO_BUF_COUNT; i++) {
 			if ((result = usb_submit_urb(dec->iso_urb[i],
 						     GFP_ATOMIC))) {
-				printk("%s: failed urb submission %d: "
-				       "error %d\n", __func__, i, result);
+				printk("%s: failed urb submission %d: error %d\n",
+				       __func__, i, result);
 
 				while (i) {
 					usb_kill_urb(dec->iso_urb[i - 1]);
@@ -1375,8 +1375,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	memcpy(&tmp, &firmware[56], 4);
 	crc32_check = ntohl(tmp);
 	if (crc32_csum != crc32_check) {
-		printk("%s: crc32 check of DSP code failed (calculated "
-		       "0x%08x != 0x%08x in file), file invalid.\n",
+		printk("%s: crc32 check of DSP code failed (calculated 0x%08x != 0x%08x in file), file invalid.\n",
 			__func__, crc32_csum, crc32_check);
 		release_firmware(fw_entry);
 		return -ENOENT;
@@ -1453,11 +1452,9 @@ static int ttusb_dec_init_stb(struct ttusb_dec *dec)
 
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
 
@@ -1481,8 +1478,7 @@ static int ttusb_dec_init_stb(struct ttusb_dec *dec)
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


