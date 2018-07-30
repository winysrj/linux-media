Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40742 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbeG3K6P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 06:58:15 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 1/3] media: usb: em28xx: Replace GFP_ATOMIC with GFP_KERNEL in em28xx_audio_urb_init()
Date: Mon, 30 Jul 2018 17:23:52 +0800
Message-Id: <20180730092352.7775-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx_audio_urb_init() is never called in atomic context.
It calls kcalloc(), usb_alloc_urb() and usb_alloc_coherent() 
with GFP_ATOMIC, which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 8e799ae1df69..bb510cf8fbbb 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -842,11 +842,11 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 
 	dev->adev.transfer_buffer = kcalloc(num_urb,
 					    sizeof(*dev->adev.transfer_buffer),
-					    GFP_ATOMIC);
+					    GFP_KERNEL);
 	if (!dev->adev.transfer_buffer)
 		return -ENOMEM;
 
-	dev->adev.urb = kcalloc(num_urb, sizeof(*dev->adev.urb), GFP_ATOMIC);
+	dev->adev.urb = kcalloc(num_urb, sizeof(*dev->adev.urb), GFP_KERNEL);
 	if (!dev->adev.urb) {
 		kfree(dev->adev.transfer_buffer);
 		return -ENOMEM;
@@ -859,14 +859,14 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 		int j, k;
 		void *buf;
 
-		urb = usb_alloc_urb(npackets, GFP_ATOMIC);
+		urb = usb_alloc_urb(npackets, GFP_KERNEL);
 		if (!urb) {
 			em28xx_audio_free_urb(dev);
 			return -ENOMEM;
 		}
 		dev->adev.urb[i] = urb;
 
-		buf = usb_alloc_coherent(udev, npackets * ep_size, GFP_ATOMIC,
+		buf = usb_alloc_coherent(udev, npackets * ep_size, GFP_KERNEL,
 					 &urb->transfer_dma);
 		if (!buf) {
 			dev_err(&dev->intf->dev,
-- 
2.17.0
