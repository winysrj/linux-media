Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57682 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751185AbdIPKvg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 06:51:36 -0400
Subject: [PATCH 1/3] [media] mr800: Delete two error messages for a failed
 memory allocation in usb_amradio_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Alexey Klimov <klimov.linux@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <7efe75db-dbb4-0fe7-509d-908b81072ca1@users.sourceforge.net>
Message-ID: <a112f104-2058-5812-9601-8e9b629864d4@users.sourceforge.net>
Date: Sat, 16 Sep 2017 12:51:29 +0200
MIME-Version: 1.0
In-Reply-To: <7efe75db-dbb4-0fe7-509d-908b81072ca1@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 11:23:53 +0200

Omit extra messages for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/radio/radio-mr800.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index c9f59129af79..63a9b92ab495 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -518,5 +518,4 @@ static int usb_amradio_probe(struct usb_interface *intf,
 	if (!radio) {
-		dev_err(&intf->dev, "kmalloc for amradio_device failed\n");
 		retval = -ENOMEM;
 		goto err;
 	}
@@ -526,5 +525,4 @@ static int usb_amradio_probe(struct usb_interface *intf,
 	if (!radio->buffer) {
-		dev_err(&intf->dev, "kmalloc for radio->buffer failed\n");
 		retval = -ENOMEM;
 		goto err_nobuf;
 	}
-- 
2.14.1
