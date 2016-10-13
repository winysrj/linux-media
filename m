Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:61951 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933319AbcJMQzA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:55:00 -0400
Subject: [PATCH 18/18] [media] RedRat3: Combine substrings for six messages
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
Message-ID: <cdf5a033-1858-98c4-20a5-4a829d0fc483@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:48:10 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 17:50:11 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index a09d5cb..b8c4b98 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -233,8 +233,7 @@ static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 
 	/* Codes 0x20 through 0x2f are IR Firmware Errors */
 	case 0x20:
-		pr_cont("Initial signal pulse not long enough "
-			"to measure carrier frequency\n");
+		pr_cont("Initial signal pulse not long enough to measure carrier frequency\n");
 		break;
 	case 0x21:
 		pr_cont("Not enough length values allocated for signal\n");
@@ -246,18 +245,15 @@ static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 		pr_cont("Too many signal repeats\n");
 		break;
 	case 0x28:
-		pr_cont("Insufficient memory available for IR signal "
-			"data memory allocation\n");
+		pr_cont("Insufficient memory available for IR signal data memory allocation\n");
 		break;
 	case 0x29:
-		pr_cont("Insufficient memory available "
-			"for IrDa signal data memory allocation\n");
+		pr_cont("Insufficient memory available for IrDa signal data memory allocation\n");
 		break;
 
 	/* Codes 0x30 through 0x3f are USB Firmware Errors */
 	case 0x30:
-		pr_cont("Insufficient memory available for bulk "
-			"transfer structure\n");
+		pr_cont("Insufficient memory available for bulk transfer structure\n");
 		break;
 
 	/*
@@ -269,8 +265,7 @@ static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 			pr_cont("Signal capture has been terminated\n");
 		break;
 	case 0x41:
-		pr_cont("Attempt to set/get and unknown signal I/O "
-			"algorithm parameter\n");
+		pr_cont("Attempt to set/get and unknown signal I/O algorithm parameter\n");
 		break;
 	case 0x42:
 		pr_cont("Signal capture already started\n");
@@ -866,8 +861,8 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 		return NULL;
 
 	prod = le16_to_cpu(rr3->udev->descriptor.idProduct);
-	snprintf(rr3->name, sizeof(rr3->name), "RedRat3%s "
-		 "Infrared Remote Transceiver (%04x:%04x)",
+	snprintf(rr3->name, sizeof(rr3->name),
+		 "RedRat3%s Infrared Remote Transceiver (%04x:%04x)",
 		 prod == USB_RR3IIUSB_PRODUCT_ID ? "-II" : "",
 		 le16_to_cpu(rr3->udev->descriptor.idVendor), prod);
 
-- 
2.10.1

