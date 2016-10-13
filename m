Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:58808 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932150AbcJMR1C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 13:27:02 -0400
Subject: [PATCH 11/18] [media] RedRat3: Delete the variable "dev" in
 redrat3_init_rc_dev()
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <8eee44d9-d8c3-c495-b3b0-0b5adfda71d5@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:33:03 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 14:40:11 +0200

Use the data structure member "dev" directly without assigning it
to an intermediate variable.
Thus delete the extra variable definition at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index c43f43b..b23a8bb 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -854,7 +854,6 @@ static void redrat3_led_complete(struct urb *urb)
 
 static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 {
-	struct device *dev = rr3->dev;
 	struct rc_dev *rc;
 	int ret;
 	u16 prod = le16_to_cpu(rr3->udev->descriptor.idProduct);
@@ -873,7 +872,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->input_name = rr3->name;
 	rc->input_phys = rr3->phys;
 	usb_to_input_id(rr3->udev, &rc->input_id);
-	rc->dev.parent = dev;
+	rc->dev.parent = rr3->dev;
 	rc->priv = rr3;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protocols = RC_BIT_ALL;
@@ -889,7 +888,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 
 	ret = rc_register_device(rc);
 	if (ret < 0) {
-		dev_err(dev, "remote dev registration failed\n");
+		dev_err(rr3->dev, "remote dev registration failed\n");
 		goto out;
 	}
 
-- 
2.10.1

