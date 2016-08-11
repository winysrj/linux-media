Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56307 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbcHKVLd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:33 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 27/28] media: usb: usbvision: usbvision-core: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:04:03 +0200
Message-Id: <1470949451-24823-28-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/usbvision/usbvision-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 52ac4391582c49..c23bf73a68ea97 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -2303,11 +2303,8 @@ int usbvision_init_isoc(struct usb_usbvision *usbvision)
 		struct urb *urb;
 
 		urb = usb_alloc_urb(USBVISION_URB_FRAMES, GFP_KERNEL);
-		if (urb == NULL) {
-			dev_err(&usbvision->dev->dev,
-				"%s: usb_alloc_urb() failed\n", __func__);
+		if (urb == NULL)
 			return -ENOMEM;
-		}
 		usbvision->sbuf[buf_idx].urb = urb;
 		usbvision->sbuf[buf_idx].data =
 			usb_alloc_coherent(usbvision->dev,
-- 
2.8.1

