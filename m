Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56295 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbcHKVLa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:30 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 23/28] media: usb: stk1160: stk1160-video: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:59 +0200
Message-Id: <1470949451-24823-24-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/stk1160/stk1160-video.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 6ecb0b48423f3d..ce8ebbe395a620 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -457,10 +457,8 @@ int stk1160_alloc_isoc(struct stk1160 *dev)
 	for (i = 0; i < num_bufs; i++) {
 
 		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
-		if (!urb) {
-			stk1160_err("cannot alloc urb[%d]\n", i);
+		if (!urb)
 			goto free_i_bufs;
-		}
 		dev->isoc_ctl.urb[i] = urb;
 
 #ifndef CONFIG_DMA_NONCOHERENT
-- 
2.8.1

