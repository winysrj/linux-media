Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab1FSRnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:51 -0400
Date: Sun, 19 Jun 2011 14:42:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
Subject: [PATCH 08/11] [media] em28xx-audio: Properly report failures to
 start stream
Message-ID: <20110619144240.24cec9ac@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If the audio stream fails for any reason, it should:
	1) Report an error via dmesg;
	2) Mark internally that the stream didn't started.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index 56739a4..5381f6d 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -213,9 +213,12 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
 		errCode = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
 		if (errCode) {
+			em28xx_errdev("submit of audio urb failed\n");
 			em28xx_deinit_isoc_audio(dev);
+			atomic_set(&dev->stream_started, 0);
 			return errCode;
 		}
+
 	}
 
 	return 0;
-- 
1.7.1


