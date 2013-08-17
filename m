Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45229 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab3HQQcS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 12:32:18 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Ming Lei <ming.lei@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v1 43/49] media: usb: em28xx: prepare for enabling irq in complete()
Date: Sun, 18 Aug 2013 00:25:08 +0800
Message-Id: <1376756714-25479-44-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so add local_irq_save()
before acquiring the lock without irqsave().

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 2fdb66e..7fd1b2a 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -113,6 +113,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 		stride = runtime->frame_bits >> 3;
 
 		for (i = 0; i < urb->number_of_packets; i++) {
+			unsigned long flags;
 			int length =
 			    urb->iso_frame_desc[i].actual_length / stride;
 			cp = (unsigned char *)urb->transfer_buffer +
@@ -134,7 +135,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 				       length * stride);
 			}
 
-			snd_pcm_stream_lock(substream);
+			snd_pcm_stream_lock_irqsave(substream, flags);
 
 			dev->adev.hwptr_done_capture += length;
 			if (dev->adev.hwptr_done_capture >=
@@ -150,7 +151,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 				period_elapsed = 1;
 			}
 
-			snd_pcm_stream_unlock(substream);
+			snd_pcm_stream_unlock_irqrestore(substream, flags);
 		}
 		if (period_elapsed)
 			snd_pcm_period_elapsed(substream);
-- 
1.7.9.5

