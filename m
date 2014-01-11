Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60430 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaAKNli (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jan 2014 08:41:38 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so2304256eek.18
        for <linux-media@vger.kernel.org>; Sat, 11 Jan 2014 05:41:37 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/2] em28xx: fix check for audio only usb interfaces when changing the usb alternate setting
Date: Sat, 11 Jan 2014 14:42:30 +0100
Message-Id: <1389447750-2642-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389447750-2642-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389447750-2642-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, we've been assuming that the video endpoints are always at usb
interface 0. Hence, if vendor audio endpoints are provided at a separate
interface, they were supposed to be at interface number > 0.
Instead of checking for (interface number > 0) to determine if an interface is a
pure audio interface, dev->is_audio_only should be checked.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c |   15 +++++++++++++--
 1 Datei geändert, 13 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index b2ae954..18b745f 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -243,11 +243,22 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	}
 
 	runtime->hw = snd_em28xx_hw_capture;
-	if ((dev->alt == 0 || dev->ifnum) && dev->adev.users == 0) {
-		if (dev->ifnum)
+	if (dev->adev.users == 0 && (dev->alt == 0 || dev->is_audio_only)) {
+		if (dev->is_audio_only)
+			/* vendor audio is on a separate interface */
 			dev->alt = 1;
 		else
+			/* vendor audio is on the same interface as video */
 			dev->alt = 7;
+			/*
+			 * FIXME: The intention seems to be to select the alt
+			 * setting with the largest wMaxPacketSize for the video
+			 * endpoint.
+			 * At least dev->alt and dev->dvb_alt_isoc should be
+			 * used instead, but we should probably not touch it at
+			 * all if it is already >0, because wMaxPacketSize of
+			 * the audio endpoints seems to be the same for all.
+			 */
 
 		dprintk("changing alternate number on interface %d to %d\n",
 			dev->ifnum, dev->alt);
-- 
1.7.10.4

