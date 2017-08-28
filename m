Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50093 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751187AbdH1KMV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 06:12:21 -0400
Subject: [PATCH 2/2] [media] Cypress: Improve a size determination in
 cypress_load_firmware()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f95552e6-edf1-ceed-0c16-c8d23b8309ea@users.sourceforge.net>
Message-ID: <f67848f4-268c-9764-65f5-200a1f569724@users.sourceforge.net>
Date: Mon, 28 Aug 2017 12:12:08 +0200
MIME-Version: 1.0
In-Reply-To: <f95552e6-edf1-ceed-0c16-c8d23b8309ea@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Aug 2017 11:55:16 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/common/cypress_firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/cypress_firmware.c b/drivers/media/common/cypress_firmware.c
index bfe47bc5f716..8895158c1962 100644
--- a/drivers/media/common/cypress_firmware.c
+++ b/drivers/media/common/cypress_firmware.c
@@ -74,7 +74,7 @@ int cypress_load_firmware(struct usb_device *udev,
 	struct hexline *hx;
 	int ret, pos = 0;
 
-	hx = kmalloc(sizeof(struct hexline), GFP_KERNEL);
+	hx = kmalloc(sizeof(*hx), GFP_KERNEL);
 	if (!hx)
 		return -ENOMEM;
 
-- 
2.14.1
