Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:54497 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751218AbdH2FdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 01:33:08 -0400
Subject: [PATCH 2/4] [media] zr364xx: Improve a size determination in
 zr364xx_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Antoine Jacquet <royale@zerezo.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
Message-ID: <19adacd0-3862-188f-9128-5d09fd13ebae@users.sourceforge.net>
Date: Tue, 29 Aug 2017 07:33:02 +0200
MIME-Version: 1.0
In-Reply-To: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Aug 2017 22:28:02 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/zr364xx/zr364xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 97af697dcc81..37cd6e20e68a 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1421,7 +1421,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 		 le16_to_cpu(udev->descriptor.idVendor),
 		 le16_to_cpu(udev->descriptor.idProduct));
 
-	cam = kzalloc(sizeof(struct zr364xx_camera), GFP_KERNEL);
+	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
 	if (!cam)
 		return -ENOMEM;
 
-- 
2.14.1
