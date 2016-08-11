Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56300 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423AbcHKVLb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:31 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 24/28] media: usb: stkwebcam: stk-webcam: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:04:00 +0200
Message-Id: <1470949451-24823-25-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index c21c4c004f9778..db200c9d796d36 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -452,10 +452,8 @@ static int stk_prepare_iso(struct stk_camera *dev)
 			STK_ERROR("isobuf data already allocated\n");
 		if (dev->isobufs[i].urb == NULL) {
 			urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
-			if (urb == NULL) {
-				STK_ERROR("Failed to allocate URB %d\n", i);
+			if (urb == NULL)
 				goto isobufs_out;
-			}
 			dev->isobufs[i].urb = urb;
 		} else {
 			STK_ERROR("Killing URB\n");
-- 
2.8.1

