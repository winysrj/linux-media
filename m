Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:61715 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752555AbdIRQKp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 12:10:45 -0400
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] gspca: Delete two error messages for a failed memory
 allocation in gspca_dev_probe2()
Message-ID: <6bef0198-a455-6ede-c6da-58667771a45a@users.sourceforge.net>
Date: Mon, 18 Sep 2017 18:10:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 17:47:58 +0200

Omit extra messages for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/gspca/gspca.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 0f141762abf1..8be1c81b7cab 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -2037,10 +2037,8 @@ int gspca_dev_probe2(struct usb_interface *intf,
-	if (!gspca_dev) {
-		pr_err("couldn't kzalloc gspca struct\n");
+	if (!gspca_dev)
 		return -ENOMEM;
-	}
+
 	gspca_dev->usb_buf = kmalloc(USB_BUF_SZ, GFP_KERNEL);
 	if (!gspca_dev->usb_buf) {
-		pr_err("out of memory\n");
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.14.1
