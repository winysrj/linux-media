Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45862 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaAQRRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 12:17:47 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so1503461eek.27
        for <linux-media@vger.kernel.org>; Fri, 17 Jan 2014 09:17:46 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/2] em28xx-audio: make sure audio is unmuted on open()
Date: Fri, 17 Jan 2014 18:18:43 +0100
Message-Id: <1389979123-6919-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389979123-6919-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389979123-6919-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c |   42 ++++++++++++++++---------------
 1 Datei geändert, 22 Zeilen hinzugefügt(+), 20 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index dfdfa77..a3daf07 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -273,26 +273,28 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 		mutex_lock(&dev->lock);
 
 	runtime->hw = snd_em28xx_hw_capture;
-	if ((dev->alt == 0 || dev->is_audio_only) && dev->adev.users == 0) {
-		if (dev->is_audio_only)
-			/* vendor audio is on a separate interface */
-			dev->alt = 1;
-		else
-			/* vendor audio is on the same interface as video */
-			dev->alt = 7;
-			/*
-			 * FIXME: The intention seems to be to select the alt
-			 * setting with the largest wMaxPacketSize for the video
-			 * endpoint.
-			 * At least dev->alt should be used instead, but we
-			 * should probably not touch it at all if it is
-			 * already >0, because wMaxPacketSize of the audio
-			 * endpoints seems to be the same for all.
-			 */
-
-		dprintk("changing alternate number on interface %d to %d\n",
-			dev->ifnum, dev->alt);
-		usb_set_interface(dev->udev, dev->ifnum, dev->alt);
+
+	if (dev->adev.users == 0) {
+		if (dev->alt == 0 || dev->is_audio_only) {
+			if (dev->is_audio_only)
+				/* audio is on a separate interface */
+				dev->alt = 1;
+			else
+				/* audio is on the same interface as video */
+				dev->alt = 7;
+				/*
+				 * FIXME: The intention seems to be to select
+				 * the alt setting with the largest
+				 * wMaxPacketSize for the video endpoint.
+				 * At least dev->alt should be used instead, but
+				 * we should probably not touch it at all if it
+				 * is already >0, because wMaxPacketSize of the
+				 * audio endpoints seems to be the same for all.
+				 */
+			dprintk("changing alternate number on interface %d to %d\n",
+				dev->ifnum, dev->alt);
+			usb_set_interface(dev->udev, dev->ifnum, dev->alt);
+		}
 
 		/* Sets volume, mute, etc */
 		dev->mute = 0;
-- 
1.7.10.4

