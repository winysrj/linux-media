Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:50373 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdHZUpI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 16:45:08 -0400
Subject: [PATCH 1/3] [media] usbvision: Delete an error message for a failed
 memory allocation in usbvision_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Johan Hovold <johan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f72f836e-6cab-8b79-9d87-a79bd62be174@users.sourceforge.net>
Message-ID: <edf82b37-bbc4-5a8d-ae51-6c13902dbf4f@users.sourceforge.net>
Date: Sat, 26 Aug 2017 22:44:43 +0200
MIME-Version: 1.0
In-Reply-To: <f72f836e-6cab-8b79-9d87-a79bd62be174@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 26 Aug 2017 22:06:05 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/usbvision/usbvision-video.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 756322c4ac05..b74fb2dcb6f5 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1498,4 +1498,3 @@ static int usbvision_probe(struct usb_interface *intf,
-		dev_err(&intf->dev, "usbvision: out of memory!\n");
 		ret = -ENOMEM;
 		goto err_pkt;
 	}
-- 
2.14.0
