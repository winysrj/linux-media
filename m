Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56304 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbcHKVLc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:32 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 25/28] media: usb: tm6000: tm6000-dvb: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:04:01 +0200
Message-Id: <1470949451-24823-26-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/tm6000/tm6000-dvb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 095f5db1a790f9..0426b210383b7c 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -129,10 +129,8 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 	}
 
 	dvb->bulk_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (dvb->bulk_urb == NULL) {
-		printk(KERN_ERR "tm6000: couldn't allocate urb\n");
+	if (dvb->bulk_urb == NULL)
 		return -ENOMEM;
-	}
 
 	pipe = usb_rcvbulkpipe(dev->udev, dev->bulk_in.endp->desc.bEndpointAddress
 							  & USB_ENDPOINT_NUMBER_MASK);
-- 
2.8.1

