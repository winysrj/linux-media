Return-path: <linux-media-owner@vger.kernel.org>
Received: from bran.ispras.ru ([83.149.199.196]:16916 "EHLO smtp.ispras.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752486AbdHJP3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 11:29:48 -0400
From: Anton Vasilyev <vasilyev@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Anton Vasilyev <vasilyev@ispras.ru>,
        Jonathan McDowell <noodles@earth.li>,
        Alyssa Milburn <amilburn@zall.org>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] dvb-usb: Add memory free on error path in dw2102_probe()
Date: Thu, 10 Aug 2017 18:27:44 +0300
Message-Id: <1502378864-13124-1-git-send-email-vasilyev@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If dw2102_probe() fails on dvb_usb_device_init(), then memleak occurs.

The patch adds deallocation to the error path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
---
 drivers/media/usb/dvb-usb/dw2102.c | 39 +++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6e654e5..0d63693 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -2332,10 +2332,12 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
 static int dw2102_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
+	int retval = -ENOMEM;
 	p1100 = kmemdup(&s6x0_properties,
 			sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
 	if (!p1100)
-		return -ENOMEM;
+		goto err0;
+
 	/* copy default structure */
 	/* fill only different fields */
 	p1100->firmware = P1100_FIRMWARE;
@@ -2346,10 +2348,9 @@ static int dw2102_probe(struct usb_interface *intf,
 
 	s660 = kmemdup(&s6x0_properties,
 		       sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
-	if (!s660) {
-		kfree(p1100);
-		return -ENOMEM;
-	}
+	if (!s660)
+		goto err1;
+
 	s660->firmware = S660_FIRMWARE;
 	s660->num_device_descs = 3;
 	s660->devices[0] = d660;
@@ -2359,11 +2360,9 @@ static int dw2102_probe(struct usb_interface *intf,
 
 	p7500 = kmemdup(&s6x0_properties,
 			sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
-	if (!p7500) {
-		kfree(p1100);
-		kfree(s660);
-		return -ENOMEM;
-	}
+	if (!p7500)
+		goto err2;
+
 	p7500->firmware = P7500_FIRMWARE;
 	p7500->devices[0] = d7500;
 	p7500->rc.core.rc_query = prof_rc_query;
@@ -2373,12 +2372,9 @@ static int dw2102_probe(struct usb_interface *intf,
 
 	s421 = kmemdup(&su3000_properties,
 		       sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
-	if (!s421) {
-		kfree(p1100);
-		kfree(s660);
-		kfree(p7500);
-		return -ENOMEM;
-	}
+	if (!s421)
+		goto err3;
+
 	s421->num_device_descs = 2;
 	s421->devices[0] = d421;
 	s421->devices[1] = d632;
@@ -2408,7 +2404,16 @@ static int dw2102_probe(struct usb_interface *intf,
 			 THIS_MODULE, NULL, adapter_nr))
 		return 0;
 
-	return -ENODEV;
+	retval = -ENODEV;
+	kfree(s421);
+err3:
+	kfree(p7500);
+err2:
+	kfree(s660);
+err1:
+	kfree(p1100);
+err0:
+	return retval;
 }
 
 static void dw2102_disconnect(struct usb_interface *intf)
-- 
2.7.4
