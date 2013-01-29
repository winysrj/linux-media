Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:56860 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab3A2MTd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 07:19:33 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/5] [media] ttusbir: add missing endian conversion
Date: Tue, 29 Jan 2013 12:19:28 +0000
Message-Id: <1359461971-27492-2-git-send-email-sean@mess.org>
In-Reply-To: <1359461971-27492-1-git-send-email-sean@mess.org>
References: <1359461971-27492-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

spotted by sparse.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ttusbir.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index f9226b8..cf0d47f 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -213,19 +213,20 @@ static int ttusbir_probe(struct usb_interface *intf,
 
 	/* find the correct alt setting */
 	for (i = 0; i < intf->num_altsetting && altsetting == -1; i++) {
-		int bulk_out_endp = -1, iso_in_endp = -1;
+		int max_packet, bulk_out_endp = -1, iso_in_endp = -1;
 
 		idesc = &intf->altsetting[i].desc;
 
 		for (j = 0; j < idesc->bNumEndpoints; j++) {
 			desc = &intf->altsetting[i].endpoint[j].desc;
+			max_packet = le16_to_cpu(desc->wMaxPacketSize);
 			if (usb_endpoint_dir_in(desc) &&
 					usb_endpoint_xfer_isoc(desc) &&
-					desc->wMaxPacketSize == 0x10)
+					max_packet == 0x10)
 				iso_in_endp = j;
 			else if (usb_endpoint_dir_out(desc) &&
 					usb_endpoint_xfer_bulk(desc) &&
-					desc->wMaxPacketSize == 0x20)
+					max_packet == 0x20)
 				bulk_out_endp = j;
 
 			if (bulk_out_endp != -1 && iso_in_endp != -1) {
-- 
1.8.1

