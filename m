Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50325 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751194AbdH1KKK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 06:10:10 -0400
Subject: [PATCH 1/2] [media] Cypress: Delete an error message for a failed
 memory allocation in cypress_load_firmware()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f95552e6-edf1-ceed-0c16-c8d23b8309ea@users.sourceforge.net>
Message-ID: <4c7cfbac-b9e5-4ab2-d569-d44cae90678e@users.sourceforge.net>
Date: Mon, 28 Aug 2017 12:09:57 +0200
MIME-Version: 1.0
In-Reply-To: <f95552e6-edf1-ceed-0c16-c8d23b8309ea@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Aug 2017 11:46:57 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/common/cypress_firmware.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/common/cypress_firmware.c b/drivers/media/common/cypress_firmware.c
index 50e3f76d4847..bfe47bc5f716 100644
--- a/drivers/media/common/cypress_firmware.c
+++ b/drivers/media/common/cypress_firmware.c
@@ -78,7 +78,5 @@ int cypress_load_firmware(struct usb_device *udev,
-	if (!hx) {
-		dev_err(&udev->dev, "%s: kmalloc() failed\n", KBUILD_MODNAME);
+	if (!hx)
 		return -ENOMEM;
-	}
 
 	/* stop the CPU */
 	hx->data[0] = 1;
-- 
2.14.1
