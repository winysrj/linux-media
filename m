Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:49995 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbdIPNiD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 09:38:03 -0400
Subject: [PATCH 1/3] [media] si470x: Delete an error message for a failed
 memory allocation in si470x_usb_driver_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b58222fa-99f8-f2d6-2755-5ccd4a91e783@users.sourceforge.net>
Message-ID: <2cc6c33d-4d3f-c097-e0ef-faf828d18c28@users.sourceforge.net>
Date: Sat, 16 Sep 2017 15:37:56 +0200
MIME-Version: 1.0
In-Reply-To: <b58222fa-99f8-f2d6-2755-5ccd4a91e783@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 14:53:49 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/radio/si470x/radio-si470x-usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index c311f9951d80..af295530b20f 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -618,5 +618,4 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	if (!radio->int_in_buffer) {
-		dev_info(&intf->dev, "could not allocate int_in_buffer");
 		retval = -ENOMEM;
 		goto err_usbbuf;
 	}
-- 
2.14.1
