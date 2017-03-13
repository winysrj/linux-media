Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33965 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbdCMMyf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:54:35 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Sri Deevi <Srinivasa.Deevi@conexant.com>
Subject: [PATCH 4/6] [media] cx231xx-audio: fix init error path
Date: Mon, 13 Mar 2017 13:53:57 +0100
Message-Id: <20170313125359.29394-5-johan@kernel.org>
In-Reply-To: <20170313125359.29394-1-johan@kernel.org>
References: <20170313125359.29394-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure to release the snd_card also on a late allocation error.

Fixes: e0d3bafd0258 ("V4L/DVB (10954): Add cx231xx USB driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.30
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index cf80842dfa08..f3729d6eb46a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -670,10 +670,8 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 
 	spin_lock_init(&adev->slock);
 	err = snd_pcm_new(card, "Cx231xx Audio", 0, 0, 1, &pcm);
-	if (err < 0) {
-		snd_card_free(card);
-		return err;
-	}
+	if (err < 0)
+		goto err_free_card;
 
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE,
 			&snd_cx231xx_pcm_capture);
@@ -687,10 +685,9 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 	INIT_WORK(&dev->wq_trigger, audio_trigger);
 
 	err = snd_card_register(card);
-	if (err < 0) {
-		snd_card_free(card);
-		return err;
-	}
+	if (err < 0)
+		goto err_free_card;
+
 	adev->sndcard = card;
 	adev->udev = dev->udev;
 
@@ -709,9 +706,10 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 		"audio EndPoint Addr 0x%x, Alternate settings: %i\n",
 		adev->end_point_addr, adev->num_alt);
 	adev->alt_max_pkt_size = kmalloc(32 * adev->num_alt, GFP_KERNEL);
-
-	if (adev->alt_max_pkt_size == NULL)
-		return -ENOMEM;
+	if (!adev->alt_max_pkt_size) {
+		err = -ENOMEM;
+		goto err_free_card;
+	}
 
 	for (i = 0; i < adev->num_alt; i++) {
 		u16 tmp =
@@ -725,6 +723,11 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 	}
 
 	return 0;
+
+err_free_card:
+	snd_card_free(card);
+
+	return err;
 }
 
 static int cx231xx_audio_fini(struct cx231xx *dev)
-- 
2.12.0
