Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:59311 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751191AbdH2FcE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 01:32:04 -0400
Subject: [PATCH 1/4] [media] zr364xx: Delete an error message for a failed
 memory allocation in two functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Antoine Jacquet <royale@zerezo.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
Message-ID: <f2637234-7746-cb9d-6cf5-97d519090e84@users.sourceforge.net>
Date: Tue, 29 Aug 2017 07:31:58 +0200
MIME-Version: 1.0
In-Reply-To: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Aug 2017 22:23:56 +0200

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/zr364xx/zr364xx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index efdcd5bd6a4c..97af697dcc81 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -212,7 +212,5 @@ static int send_control_msg(struct usb_device *udev, u8 request, u16 value,
-	if (!transfer_buffer) {
-		dev_err(&udev->dev, "kmalloc(%d) failed\n", size);
+	if (!transfer_buffer)
 		return -ENOMEM;
-	}
 
 	memcpy(transfer_buffer, cp, size);
 
@@ -1427,7 +1425,5 @@ static int zr364xx_probe(struct usb_interface *intf,
-	if (cam == NULL) {
-		dev_err(&udev->dev, "cam: out of memory !\n");
+	if (!cam)
 		return -ENOMEM;
-	}
 
 	cam->v4l2_dev.release = zr364xx_release;
 	err = v4l2_device_register(&intf->dev, &cam->v4l2_dev);
-- 
2.14.1
