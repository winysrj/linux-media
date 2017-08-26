Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:56612 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdHZUw4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 16:52:56 -0400
Subject: [PATCH 3/3] [media] usbvision: Improve a size determination in
 usbvision_alloc()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Johan Hovold <johan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f72f836e-6cab-8b79-9d87-a79bd62be174@users.sourceforge.net>
Message-ID: <0c35f860-fcae-4bbf-5b7b-19dd36af25e6@users.sourceforge.net>
Date: Sat, 26 Aug 2017 22:52:41 +0200
MIME-Version: 1.0
In-Reply-To: <f72f836e-6cab-8b79-9d87-a79bd62be174@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 26 Aug 2017 22:22:13 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/usbvision/usbvision-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index e6807bad9792..960272d3c924 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1319,7 +1319,7 @@ static struct usb_usbvision *usbvision_alloc(struct usb_device *dev,
 {
 	struct usb_usbvision *usbvision;
 
-	usbvision = kzalloc(sizeof(struct usb_usbvision), GFP_KERNEL);
+	usbvision = kzalloc(sizeof(*usbvision), GFP_KERNEL);
 	if (!usbvision)
 		return NULL;
 
-- 
2.14.0
