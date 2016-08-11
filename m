Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56216 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273AbcHKVLU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:20 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 08/28] media: usb: cpia2: cpia2_usb: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:44 +0200
Message-Id: <1470949451-24823-9-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/cpia2/cpia2_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index c1aa1ab2ece9ff..13620cdf05996f 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -662,7 +662,6 @@ static int submit_urbs(struct camera_data *cam)
 		}
 		urb = usb_alloc_urb(FRAMES_PER_DESC, GFP_KERNEL);
 		if (!urb) {
-			ERR("%s: usb_alloc_urb error!\n", __func__);
 			for (j = 0; j < i; j++)
 				usb_free_urb(cam->sbuf[j].urb);
 			return -ENOMEM;
-- 
2.8.1

