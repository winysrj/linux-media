Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56218 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484AbcHKVLU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:20 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 09/28] media: usb: cx231xx: cx231xx-audio: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:45 +0200
Message-Id: <1470949451-24823-10-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index a6a9508418f8ee..4cd5fa91612f62 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -293,7 +293,6 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
 		urb = usb_alloc_urb(CX231XX_ISO_NUM_AUDIO_PACKETS, GFP_ATOMIC);
 		if (!urb) {
-			dev_err(dev->dev, "usb_alloc_urb failed!\n");
 			for (j = 0; j < i; j++) {
 				usb_free_urb(dev->adev.urb[j]);
 				kfree(dev->adev.transfer_buffer[j]);
@@ -355,7 +354,6 @@ static int cx231xx_init_audio_bulk(struct cx231xx *dev)
 		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
 		urb = usb_alloc_urb(CX231XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
 		if (!urb) {
-			dev_err(dev->dev, "usb_alloc_urb failed!\n");
 			for (j = 0; j < i; j++) {
 				usb_free_urb(dev->adev.urb[j]);
 				kfree(dev->adev.transfer_buffer[j]);
-- 
2.8.1

