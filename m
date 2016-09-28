Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19506 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932613AbcI1NHk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 09:07:40 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Linux USB <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [RFC/PATCH 30/45] media: usb: uvc: remove unnecessary & operation
Date: Wed, 28 Sep 2016 16:05:39 +0300
Message-Id: <20160928130554.29790-31-felipe.balbi@linux.intel.com>
In-Reply-To: <20160928130554.29790-1-felipe.balbi@linux.intel.com>
References: <20160928130554.29790-1-felipe.balbi@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that usb_endpoint_maxp() only returns the lowest
11 bits from wMaxPacketSize, we can remove the &
operation from this driver.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/media/usb/uvc/uvc_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 11e0e5f4e1c2..f3c1c852e401 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1553,7 +1553,7 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 	u16 psize;
 	u32 size;
 
-	psize = usb_endpoint_maxp(&ep->desc) & 0x7ff;
+	psize = usb_endpoint_maxp(&ep->desc);
 	size = stream->ctrl.dwMaxPayloadTransferSize;
 	stream->bulk.max_payload_size = size;
 
-- 
2.10.0.440.g21f862b

