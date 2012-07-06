Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20372 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab2GFPcL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 11:32:11 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] media: dvb-usb: print mac address via native %pM
Date: Fri,  6 Jul 2012 18:31:51 +0300
Message-Id: <1341588711-22818-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 4008b9c..8ffcad0 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -593,9 +593,7 @@ static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 	memcpy(mac, st->data, sizeof(mac));
 
 	if (ret > 0)
-		deb_info("%s: mac is %02x:%02x:%02x:%02x:%02x:%02x\n",
-			 __func__, mac[0], mac[1], mac[2],
-			 mac[3], mac[4], mac[5]);
+		deb_info("%s: mac is %pM\n", __func__, mac);
 
 	return ret;
 }
-- 
1.7.10.4

