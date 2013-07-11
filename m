Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60075 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab3GKJMq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:12:46 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 46/50] Sound: usb: ua101: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:06:09 +0800
Message-Id: <1373533573-12272-47-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so disable local
interrupt before holding a global lock which is held without irqsave.

Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 sound/usb/misc/ua101.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index 8b5d2c5..52a60c6 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -613,14 +613,24 @@ static int start_usb_playback(struct ua101 *ua)
 
 static void abort_alsa_capture(struct ua101 *ua)
 {
-	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states))
+	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states)) {
+		unsigned long flags;
+
+		local_irq_save(flags);
 		snd_pcm_stop(ua->capture.substream, SNDRV_PCM_STATE_XRUN);
+		local_irq_restore(flags);
+	}
 }
 
 static void abort_alsa_playback(struct ua101 *ua)
 {
-	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states))
+	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states)) {
+		unsigned long flags;
+
+		local_irq_save(flags);
 		snd_pcm_stop(ua->playback.substream, SNDRV_PCM_STATE_XRUN);
+		local_irq_restore(flags);
+	}
 }
 
 static int set_stream_hw(struct ua101 *ua, struct snd_pcm_substream *substream,
-- 
1.7.9.5

