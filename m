Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:50443 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751873AbdH2LGI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 07:06:08 -0400
Subject: [PATCH 2/2] [media] imon: Improve a size determination in two
 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geliang Tang <geliangtang@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <09417655-9241-72f4-6484-a3c8b3eae87a@users.sourceforge.net>
Message-ID: <8a174347-580c-520c-436b-7d9406fe94cd@users.sourceforge.net>
Date: Tue, 29 Aug 2017 13:05:51 +0200
MIME-Version: 1.0
In-Reply-To: <09417655-9241-72f4-6484-a3c8b3eae87a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Aug 2017 12:45:59 +0200

Replace the specification of data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/imon.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index e6978f1b7f2c..27aab02b75b5 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -602,8 +602,7 @@ static int send_packet(struct imon_context *ictx)
 		ictx->tx_urb->actual_length = 0;
 	} else {
 		/* fill request into kmalloc'ed space: */
-		control_req = kmalloc(sizeof(struct usb_ctrlrequest),
-				      GFP_KERNEL);
+		control_req = kmalloc(sizeof(*control_req), GFP_KERNEL);
 		if (control_req == NULL)
 			return -ENOMEM;
 
@@ -2309,7 +2308,7 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf,
 	struct usb_host_interface *iface_desc;
 	int ret = -ENOMEM;
 
-	ictx = kzalloc(sizeof(struct imon_context), GFP_KERNEL);
+	ictx = kzalloc(sizeof(*ictx), GFP_KERNEL);
 	if (!ictx)
 		goto exit;
 
-- 
2.14.1
