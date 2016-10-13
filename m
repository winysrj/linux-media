Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:61342 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933351AbcJMQqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:46:21 -0400
Subject: [PATCH 12/18] [media] RedRat3: Move a variable assignment in
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
Message-ID: <b51ed26a-4a89-4e58-9fcc-3f4b4fa0987f@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:39:23 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 14:50:05 +0200

Move the assignment for the local variable "prod" behind the source code
for a memory allocation by this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index b23a8bb..002030f 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -856,12 +856,13 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 {
 	struct rc_dev *rc;
 	int ret;
-	u16 prod = le16_to_cpu(rr3->udev->descriptor.idProduct);
+	u16 prod;
 
 	rc = rc_allocate_device();
 	if (!rc)
 		goto out;
 
+	prod = le16_to_cpu(rr3->udev->descriptor.idProduct);
 	snprintf(rr3->name, sizeof(rr3->name), "RedRat3%s "
 		 "Infrared Remote Transceiver (%04x:%04x)",
 		 prod == USB_RR3IIUSB_PRODUCT_ID ? "-II" : "",
-- 
2.10.1

