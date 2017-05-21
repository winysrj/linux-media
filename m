Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38197 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756771AbdEUUKB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:10:01 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 10/16] ALSA: hdsp: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:44 +0200
Message-Id: <20170521200950.4592-11-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new merged ops.
The conversion is straightforward with standard helper functions.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/rme9652/hdsp.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index fc0face6cdc6..5325e91fc3a8 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -3913,8 +3913,10 @@ static char *hdsp_channel_buffer_location(struct hdsp *hdsp,
 		return hdsp->playback_buffer + (mapped_channel * HDSP_CHANNEL_BUFFER_BYTES);
 }
 
-static int snd_hdsp_playback_copy(struct snd_pcm_substream *substream, int channel,
-				  snd_pcm_uframes_t pos, void __user *src, snd_pcm_uframes_t count)
+static int snd_hdsp_playback_copy(struct snd_pcm_substream *substream,
+				  int channel, snd_pcm_uframes_t pos,
+				  void __user *src, snd_pcm_uframes_t count,
+				  bool in_kernel)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
 	char *channel_buf;
@@ -3925,13 +3927,19 @@ static int snd_hdsp_playback_copy(struct snd_pcm_substream *substream, int chann
 	channel_buf = hdsp_channel_buffer_location (hdsp, substream->pstr->stream, channel);
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
 
-static int snd_hdsp_capture_copy(struct snd_pcm_substream *substream, int channel,
-				 snd_pcm_uframes_t pos, void __user *dst, snd_pcm_uframes_t count)
+static int snd_hdsp_capture_copy(struct snd_pcm_substream *substream,
+				 int channel, snd_pcm_uframes_t pos,
+				 void __user *dst, snd_pcm_uframes_t count,
+				 bool in_kernel)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
 	char *channel_buf;
@@ -3942,22 +3950,11 @@ static int snd_hdsp_capture_copy(struct snd_pcm_substream *substream, int channe
 	channel_buf = hdsp_channel_buffer_location (hdsp, substream->pstr->stream, channel);
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
-static int snd_hdsp_hw_silence(struct snd_pcm_substream *substream, int channel,
-				  snd_pcm_uframes_t pos, snd_pcm_uframes_t count)
-{
-	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
-
-	channel_buf = hdsp_channel_buffer_location (hdsp, substream->pstr->stream, channel);
-	if (snd_BUG_ON(!channel_buf))
-		return -EIO;
-	memset(channel_buf + pos * 4, 0, count * 4);
-	return count;
+	return 0;
 }
 
 static int snd_hdsp_reset(struct snd_pcm_substream *substream)
@@ -4869,8 +4866,7 @@ static const struct snd_pcm_ops snd_hdsp_playback_ops = {
 	.prepare =	snd_hdsp_prepare,
 	.trigger =	snd_hdsp_trigger,
 	.pointer =	snd_hdsp_hw_pointer,
-	.copy =		snd_hdsp_playback_copy,
-	.silence =	snd_hdsp_hw_silence,
+	.copy_silence =	snd_hdsp_playback_copy,
 };
 
 static const struct snd_pcm_ops snd_hdsp_capture_ops = {
@@ -4881,7 +4877,7 @@ static const struct snd_pcm_ops snd_hdsp_capture_ops = {
 	.prepare =	snd_hdsp_prepare,
 	.trigger =	snd_hdsp_trigger,
 	.pointer =	snd_hdsp_hw_pointer,
-	.copy =		snd_hdsp_capture_copy,
+	.copy_silence =	snd_hdsp_capture_copy,
 };
 
 static int snd_hdsp_create_hwdep(struct snd_card *card, struct hdsp *hdsp)
-- 
2.13.0
