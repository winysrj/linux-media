Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:49297 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbdIOUlz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 16:41:55 -0400
Subject: [PATCH 1/2] [media] ma901: Delete two error messages for a failed
 memory allocation in usb_ma901radio_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Alexey Klimov <klimov.linux@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <6d4d9e92-9ac5-1e46-99ed-2b7d93bd7121@users.sourceforge.net>
Message-ID: <0a794519-30e4-666d-d16b-7d3081f26a37@users.sourceforge.net>
Date: Fri, 15 Sep 2017 22:41:48 +0200
MIME-Version: 1.0
In-Reply-To: <6d4d9e92-9ac5-1e46-99ed-2b7d93bd7121@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 22:20:04 +0200

Omit extra messages for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/radio/radio-ma901.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
index fdc481257efd..c386fbd63703 100644
--- a/drivers/media/radio/radio-ma901.c
+++ b/drivers/media/radio/radio-ma901.c
@@ -361,10 +361,8 @@ static int usb_ma901radio_probe(struct usb_interface *intf,
 	if (!radio) {
-		dev_err(&intf->dev, "kzalloc for ma901radio_device failed\n");
 		retval = -ENOMEM;
 		goto err;
 	}
 
 	radio->buffer = kmalloc(BUFFER_LENGTH, GFP_KERNEL);
 	if (!radio->buffer) {
-		dev_err(&intf->dev, "kmalloc for radio->buffer failed\n");
 		retval = -ENOMEM;
-- 
2.14.1
