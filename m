Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38194 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756905AbdEUUKA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:10:00 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 09/16] ALSA: rme9652: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:43 +0200
Message-Id: <20170521200950.4592-10-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new merged ops.
The conversion is straightforward with standard helper functions.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/rme9652/rme9652.c | 46 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 55172c689991..ce9faa32c7ed 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -1883,8 +1883,10 @@ static char *rme9652_channel_buffer_location(struct snd_rme9652 *rme9652,
 	}
 }
 
-static int snd_rme9652_playback_copy(struct snd_pcm_substream *substream, int channel,
-				     snd_pcm_uframes_t pos, void __user *src, snd_pcm_uframes_t count)
+static int snd_rme9652_playback_copy(struct snd_pcm_substream *substream,
+				     int channel, snd_pcm_uframes_t pos,
+				     void __user *src, snd_pcm_uframes_t count,
+				     bool in_kernel)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
 	char *channel_buf;
@@ -1897,13 +1899,19 @@ static int snd_rme9652_playback_copy(struct snd_pcm_substream *substream, int ch
 						       channel);
 	if (snd_BUG_ON(!channel_buf))
 		return -EIO;
-	if (copy_from_user(channel_buf + pos * 4, src, count * 4))
+	if (!src)
+		memset(channel_buf + pos * 4, 0, count * 4);
+	else if (in_kernel)
+		memcpy(channel_buf + pos * 4, (void *)src, count * 4);
+	else if (copy_from_user(channel_buf + pos * 4, src, count * 4))
 		return -EFAULT;
-	return count;
+	return 0;
 }
 
-static int snd_rme9652_capture_copy(struct snd_pcm_substream *substream, int channel,
-				    snd_pcm_uframes_t pos, void __user *dst, snd_pcm_uframes_t count)
+static int snd_rme9652_capture_copy(struct snd_pcm_substream *substream,
+				    int channel, snd_pcm_uframes_t pos,
+				    void __user *dst, snd_pcm_uframes_t count,
+				    bool in_kernel)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
 	char *channel_buf;
@@ -1916,24 +1924,11 @@ static int snd_rme9652_capture_copy(struct snd_pcm_substream *substream, int cha
 						       channel);
 	if (snd_BUG_ON(!channel_buf))
 		return -EIO;
-	if (copy_to_user(dst, channel_buf + pos * 4, count * 4))
+	if (in_kernel)
+		memcpy((void *)dst, channel_buf + pos * 4, count * 4);
+	else if (copy_to_user(dst, channel_buf + pos * 4, count * 4))
 		return -EFAULT;
-	return count;
-}
-
-static int snd_rme9652_hw_silence(struct snd_pcm_substream *substream, int channel,
-				  snd_pcm_uframes_t pos, snd_pcm_uframes_t count)
-{
-	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
-
-	channel_buf = rme9652_channel_buffer_location (rme9652,
-						       substream->pstr->stream,
-						       channel);
-	if (snd_BUG_ON(!channel_buf))
-		return -EIO;
-	memset(channel_buf + pos * 4, 0, count * 4);
-	return count;
+	return 0;
 }
 
 static int snd_rme9652_reset(struct snd_pcm_substream *substream)
@@ -2376,8 +2371,7 @@ static const struct snd_pcm_ops snd_rme9652_playback_ops = {
 	.prepare =	snd_rme9652_prepare,
 	.trigger =	snd_rme9652_trigger,
 	.pointer =	snd_rme9652_hw_pointer,
-	.copy =		snd_rme9652_playback_copy,
-	.silence =	snd_rme9652_hw_silence,
+	.copy_silence =	snd_rme9652_playback_copy,
 };
 
 static const struct snd_pcm_ops snd_rme9652_capture_ops = {
@@ -2388,7 +2382,7 @@ static const struct snd_pcm_ops snd_rme9652_capture_ops = {
 	.prepare =	snd_rme9652_prepare,
 	.trigger =	snd_rme9652_trigger,
 	.pointer =	snd_rme9652_hw_pointer,
-	.copy =		snd_rme9652_capture_copy,
+	.copy_silence =	snd_rme9652_capture_copy,
 };
 
 static int snd_rme9652_create_pcm(struct snd_card *card,
-- 
2.13.0
