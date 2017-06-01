Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42526 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751186AbdFAU7I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:08 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 10/27] ALSA: hdsp: Convert to the new PCM ops
Date: Thu,  1 Jun 2017 22:58:33 +0200
Message-Id: <20170601205850.24993-11-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new PCM ops.
The conversion is straightforward with standard helper functions.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/rme9652/hdsp.c | 67 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 17 deletions(-)

diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index fc0face6cdc6..b00009644e0e 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -3913,42 +3913,73 @@ static char *hdsp_channel_buffer_location(struct hdsp *hdsp,
 		return hdsp->playback_buffer + (mapped_channel * HDSP_CHANNEL_BUFFER_BYTES);
 }
 
-static int snd_hdsp_playback_copy(struct snd_pcm_substream *substream, int channel,
-				  snd_pcm_uframes_t pos, void __user *src, snd_pcm_uframes_t count)
+static int snd_hdsp_playback_copy(struct snd_pcm_substream *substream,
+				  int channel, unsigned long pos,
+				  void __user *src, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
 	char *channel_buf;
 
-	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES / 4))
+	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
 
 	channel_buf = hdsp_channel_buffer_location (hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
 		return -EIO;
-	if (copy_from_user(channel_buf + pos * 4, src, count * 4))
+	if (copy_from_user(channel_buf + pos, src, count))
 		return -EFAULT;
-	return count;
+	return 0;
 }
 
-static int snd_hdsp_capture_copy(struct snd_pcm_substream *substream, int channel,
-				 snd_pcm_uframes_t pos, void __user *dst, snd_pcm_uframes_t count)
+static int snd_hdsp_playback_copy_kernel(struct snd_pcm_substream *substream,
+					 int channel, unsigned long pos,
+					 void *src, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
 	char *channel_buf;
 
-	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES / 4))
+	channel_buf = hdsp_channel_buffer_location(hdsp, substream->pstr->stream, channel);
+	if (snd_BUG_ON(!channel_buf))
+		return -EIO;
+	memcpy(channel_buf + pos, src, count);
+	return 0;
+}
+
+static int snd_hdsp_capture_copy(struct snd_pcm_substream *substream,
+				 int channel, unsigned long pos,
+				 void __user *dst, unsigned long count)
+{
+	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
+	char *channel_buf;
+
+	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
 
 	channel_buf = hdsp_channel_buffer_location (hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
 		return -EIO;
-	if (copy_to_user(dst, channel_buf + pos * 4, count * 4))
+	if (copy_to_user(dst, channel_buf + pos, count))
 		return -EFAULT;
-	return count;
+	return 0;
 }
 
-static int snd_hdsp_hw_silence(struct snd_pcm_substream *substream, int channel,
-				  snd_pcm_uframes_t pos, snd_pcm_uframes_t count)
+static int snd_hdsp_capture_copy_kernel(struct snd_pcm_substream *substream,
+					int channel, unsigned long pos,
+					void *dst, unsigned long count)
+{
+	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
+	char *channel_buf;
+
+	channel_buf = hdsp_channel_buffer_location(hdsp, substream->pstr->stream, channel);
+	if (snd_BUG_ON(!channel_buf))
+		return -EIO;
+	memcpy(dst, channel_buf + pos, count);
+	return 0;
+}
+
+static int snd_hdsp_hw_silence(struct snd_pcm_substream *substream,
+			       int channel, unsigned long pos,
+			       unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
 	char *channel_buf;
@@ -3956,8 +3987,8 @@ static int snd_hdsp_hw_silence(struct snd_pcm_substream *substream, int channel,
 	channel_buf = hdsp_channel_buffer_location (hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
 		return -EIO;
-	memset(channel_buf + pos * 4, 0, count * 4);
-	return count;
+	memset(channel_buf + pos, 0, count);
+	return 0;
 }
 
 static int snd_hdsp_reset(struct snd_pcm_substream *substream)
@@ -4869,8 +4900,9 @@ static const struct snd_pcm_ops snd_hdsp_playback_ops = {
 	.prepare =	snd_hdsp_prepare,
 	.trigger =	snd_hdsp_trigger,
 	.pointer =	snd_hdsp_hw_pointer,
-	.copy =		snd_hdsp_playback_copy,
-	.silence =	snd_hdsp_hw_silence,
+	.copy_user =	snd_hdsp_playback_copy,
+	.copy_kernel =	snd_hdsp_playback_copy_kernel,
+	.fill_silence =	snd_hdsp_hw_silence,
 };
 
 static const struct snd_pcm_ops snd_hdsp_capture_ops = {
@@ -4881,7 +4913,8 @@ static const struct snd_pcm_ops snd_hdsp_capture_ops = {
 	.prepare =	snd_hdsp_prepare,
 	.trigger =	snd_hdsp_trigger,
 	.pointer =	snd_hdsp_hw_pointer,
-	.copy =		snd_hdsp_capture_copy,
+	.copy_user =	snd_hdsp_capture_copy,
+	.copy_kernel =	snd_hdsp_capture_copy_kernel,
 };
 
 static int snd_hdsp_create_hwdep(struct snd_card *card, struct hdsp *hdsp)
-- 
2.13.0
