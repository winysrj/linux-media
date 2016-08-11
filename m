Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56287 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642AbcHKVL3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:29 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 21/28] media: usb: pwc: pwc-if: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:57 +0200
Message-Id: <1470949451-24823-22-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/pwc/pwc-if.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index b51b27a3fd6108..c4454c928776f7 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -410,7 +410,6 @@ retry:
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
 		urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
 		if (urb == NULL) {
-			PWC_ERROR("Failed to allocate urb %d\n", i);
 			pwc_isoc_cleanup(pdev);
 			return -ENOMEM;
 		}
-- 
2.8.1

