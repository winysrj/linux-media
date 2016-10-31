Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43387 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945224AbcJaRwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:52:31 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/9] [media] redrat3: don't include vendor/product id in name
Date: Mon, 31 Oct 2016 17:52:20 +0000
Message-Id: <1477936347-9029-3-git-send-email-sean@mess.org>
In-Reply-To: <1477936347-9029-1-git-send-email-sean@mess.org>
References: <1477936347-9029-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to duplicate these in the rc name.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 3b0ed1c..de40e58 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -912,9 +912,9 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 		goto out;
 	}
 
-	snprintf(rr3->name, sizeof(rr3->name), "RedRat3%s Infrared Remote Transceiver (%04x:%04x)",
-		 prod == USB_RR3IIUSB_PRODUCT_ID ? "-II" : "",
-		 le16_to_cpu(rr3->udev->descriptor.idVendor), prod);
+	snprintf(rr3->name, sizeof(rr3->name),
+		 "RedRat3%s Infrared Remote Transceiver",
+		 prod == USB_RR3IIUSB_PRODUCT_ID ? "-II" : "");
 
 	usb_make_path(rr3->udev, rr3->phys, sizeof(rr3->phys));
 
-- 
2.7.4

