Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:35201 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaAOFwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 00:52:13 -0500
Received: by mail-bk0-f50.google.com with SMTP id e11so557907bkh.37
        for <linux-media@vger.kernel.org>; Tue, 14 Jan 2014 21:52:12 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 15 Jan 2014 13:52:12 +0800
Message-ID: <CAPgLHd_NgAn-ZZZjYy73xDMRi_i4yvcqjLXRMNHz0eUmvMREAw@mail.gmail.com>
Subject: [PATCH -next] [media] em28xx-audio: remove needless check before usb_free_coherent()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

usb_free_coherent() is safe with NULL addr and this check is
not required.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index f3e3200..287ce17 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -695,11 +695,9 @@ static void em28xx_audio_free_urb(struct em28xx *dev)
 		if (!urb)
 			continue;
 
-		if (dev->adev.transfer_buffer[i])
-			usb_free_coherent(dev->udev,
-					  urb->transfer_buffer_length,
-					  dev->adev.transfer_buffer[i],
-					  urb->transfer_dma);
+		usb_free_coherent(dev->udev, urb->transfer_buffer_length,
+				  dev->adev.transfer_buffer[i],
+				  urb->transfer_dma);
 
 		usb_free_urb(urb);
 	}

