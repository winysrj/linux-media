Return-path: <linux-media-owner@vger.kernel.org>
Received: from vpndallas.adeneo-embedded.us ([162.254.209.190]:40161 "EHLO
	mxadeneo.adeneo-embedded.us" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932161AbcAHVQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jan 2016 16:16:13 -0500
From: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
To: <linux-media@vger.kernel.org>
CC: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
Subject: [PATCH] [media] cx231xx: Fix memory leak
Date: Fri, 8 Jan 2016 13:10:50 -0800
Message-ID: <1452287450-17623-1-git-send-email-jtheou@adeneo-embedded.us>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_area needs to be freed when the device is close.

Based on em23xx-audio.c

Signed-off-by: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index de4ae5e..2f3d7df 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -499,6 +499,11 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 	}
 
 	dev->adev.users--;
+	if (substream->runtime->dma_area) {
+		dprintk("freeing\n");
+		vfree(substream->runtime->dma_area);
+		substream->runtime->dma_area = NULL;
+	}
 	mutex_unlock(&dev->lock);
 
 	if (dev->adev.users == 0 && dev->adev.shutdown == 1) {
-- 
2.6.4

