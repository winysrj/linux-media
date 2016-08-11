Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56245 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbcHKVLY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:24 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 13/28] media: usb: em28xx: em28xx-audio: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:49 +0200
Message-Id: <1470949451-24823-14-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 49a5f9532bd8d8..78f3687772bfe3 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -850,7 +850,6 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 
 		urb = usb_alloc_urb(npackets, GFP_ATOMIC);
 		if (!urb) {
-			em28xx_errdev("usb_alloc_urb failed!\n");
 			em28xx_audio_free_urb(dev);
 			return -ENOMEM;
 		}
-- 
2.8.1

