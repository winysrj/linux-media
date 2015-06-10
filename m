Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:7347 "EHLO
	mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965851AbbFJQc5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 12:32:57 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1 linux-next] ttusb-dec: use swap() in swap_bytes()
Date: Wed, 10 Jun 2015 18:32:44 +0200
Message-Id: <1433953965-24317-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 322b53a..7c3a7c5 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -593,14 +593,9 @@ static void ttusb_dec_process_packet(struct ttusb_dec *dec)
 
 static void swap_bytes(u8 *b, int length)
 {
-	u8 c;
-
 	length -= length % 2;
-	for (; length; b += 2, length -= 2) {
-		c = *b;
-		*b = *(b + 1);
-		*(b + 1) = c;
-	}
+	for (; length; b += 2, length -= 2)
+		swap(*b, *(b + 1));
 }
 
 static void ttusb_dec_process_urb_frame(struct ttusb_dec *dec, u8 *b,
-- 
2.4.2

