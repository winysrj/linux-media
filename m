Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:61356 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751418AbdINKcq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 06:32:46 -0400
Subject: [PATCH 2/8] [media] ttusb_dec: Adjust five checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <66b087d3-6dd3-1e1c-d33d-e34c9e2ffe25@users.sourceforge.net>
Message-ID: <4cd3254b-abc3-2145-e693-c454a13d1a2a@users.sourceforge.net>
Date: Thu, 14 Sep 2017 12:32:36 +0200
MIME-Version: 1.0
In-Reply-To: <66b087d3-6dd3-1e1c-d33d-e34c9e2ffe25@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 13 Sep 2017 18:22:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 0bc80daf6e2e..901cb221aad2 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -406,15 +406,15 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
 		return result;
 
 	if (c_length >= 0x0c) {
-		if (mode != NULL) {
+		if (mode) {
 			memcpy(&tmp, c, 4);
 			*mode = ntohl(tmp);
 		}
-		if (model != NULL) {
+		if (model) {
 			memcpy(&tmp, &c[4], 4);
 			*model = ntohl(tmp);
 		}
-		if (version != NULL) {
+		if (version) {
 			memcpy(&tmp, &c[8], 4);
 			*version = ntohl(tmp);
 		}
@@ -1393,7 +1393,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	j = 0;
 
 	b = kmalloc(ARM_PACKET_SIZE, GFP_KERNEL);
-	if (b == NULL) {
+	if (!b) {
 		release_firmware(fw_entry);
 		return -ENOMEM;
 	}
@@ -1703,18 +1703,17 @@ static int ttusb_dec_probe(struct usb_interface *intf,
 		break;
 	}
 
-	if (dec->fe == NULL) {
+	if (!dec->fe)
 		printk("dvb-ttusb-dec: A frontend driver was not found for device [%04x:%04x]\n",
 		       le16_to_cpu(dec->udev->descriptor.idVendor),
 		       le16_to_cpu(dec->udev->descriptor.idProduct));
-	} else {
+	else
 		if (dvb_register_frontend(&dec->adapter, dec->fe)) {
 			printk("budget-ci: Frontend registration failed!\n");
 			if (dec->fe->ops.release)
 				dec->fe->ops.release(dec->fe);
 			dec->fe = NULL;
 		}
-	}
 
 	ttusb_dec_init_v_pes(dec);
 	ttusb_dec_init_filters(dec);
-- 
2.14.1
