Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39317 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaAOVbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 16:31:03 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so736593eae.33
        for <linux-media@vger.kernel.org>; Wed, 15 Jan 2014 13:31:01 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT PATCH] em28xx-audio: don't overwrite the usb alt setting made by the video part
Date: Wed, 15 Jan 2014 22:31:42 +0100
Message-Id: <1389821502-11346-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx-audio currently switches to usb alternate setting #7 in case of a mixed
interface. This may overwrite the setting made by the video part and break video
streaming.
As far as we know, there is no difference between the alt settings with regards
to the audio endpoint if the interface is a mixed interface, the audio part only
has to make sure that alt is > 0, which is fortunately only the case when video
streaming is off.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c |   41 ++++++++++++-------------------
 1 Datei geändert, 16 Zeilen hinzugefügt(+), 25 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 05e9bd1..2e7a3ad 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -266,33 +266,30 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	dprintk("opening device and trying to acquire exclusive lock\n");
 
 	runtime->hw = snd_em28xx_hw_capture;
-	if ((dev->alt == 0 || dev->is_audio_only) && dev->adev.users == 0) {
-		int nonblock = !!(substream->f_flags & O_NONBLOCK);
 
+	if (dev->adev.users == 0) {
+		int nonblock = !!(substream->f_flags & O_NONBLOCK);
 		if (nonblock) {
 			if (!mutex_trylock(&dev->lock))
 				return -EAGAIN;
 		} else
 			mutex_lock(&dev->lock);
-		if (dev->is_audio_only)
-			/* vendor audio is on a separate interface */
+
+		/* Select initial alternate setting (if necessary) */
+		if (dev->alt == 0) {
 			dev->alt = 1;
-		else
-			/* vendor audio is on the same interface as video */
-			dev->alt = 7;
 			/*
-			 * FIXME: The intention seems to be to select the alt
-			 * setting with the largest wMaxPacketSize for the video
-			 * endpoint.
-			 * At least dev->alt should be used instead, but we
-			 * should probably not touch it at all if it is
-			 * already >0, because wMaxPacketSize of the audio
-			 * endpoints seems to be the same for all.
+			 * NOTE: in case of a mixed (audio+video) interface, we
+			 * don't want to touch the alt setting made by the video
+			 * part. There is no difference between the alt settings
+			 * with regards to the audio endpoint.
+			 * TODO: in case of a pure audio interface, this could
+			 * be improved. The alt settings are different here.
 			 */
-
-		dprintk("changing alternate number on interface %d to %d\n",
-			dev->ifnum, dev->alt);
-		usb_set_interface(dev->udev, dev->ifnum, dev->alt);
+			dprintk("changing alternate number on interface %d to %d\n",
+				dev->ifnum, dev->alt);
+			usb_set_interface(dev->udev, dev->ifnum, dev->alt);
+		}
 
 		/* Sets volume, mute, etc */
 		dev->mute = 0;
@@ -740,15 +737,9 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	struct usb_endpoint_descriptor *e, *ep = NULL;
 	int                 i, ep_size, interval, num_urb, npackets;
 	int		    urb_size, bytes_per_transfer;
-	u8 alt;
-
-	if (dev->ifnum)
-		alt = 1;
-	else
-		alt = 7;
+	u8 alt = 1;
 
 	intf = usb_ifnum_to_if(dev->udev, dev->ifnum);
-
 	if (intf->num_altsetting <= alt) {
 		em28xx_errdev("alt %d doesn't exist on interface %d\n",
 			      dev->ifnum, alt);
-- 
1.7.10.4

