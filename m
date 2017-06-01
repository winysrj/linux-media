Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42562 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751238AbdFAU7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:10 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 25/27] ALSA: pcm: Kill set_fs() in PCM OSS layer
Date: Thu,  1 Jun 2017 22:58:48 +0200
Message-Id: <20170601205850.24993-26-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the last-standing one: kill the set_fs() usage in PCM OSS
layer by replacing with the new API functions to deal with the direct
in-kernel buffer copying.

The code to fill the silence can be replaced even to a one-liner to
pass NULL buffer instead of the manual copying.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/core/oss/pcm_oss.c | 77 ++++++++----------------------------------------
 1 file changed, 12 insertions(+), 65 deletions(-)

diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index e306f05ce51d..2d6a825cfe88 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -67,18 +67,6 @@ static int snd_pcm_oss_get_rate(struct snd_pcm_oss_file *pcm_oss_file);
 static int snd_pcm_oss_get_channels(struct snd_pcm_oss_file *pcm_oss_file);
 static int snd_pcm_oss_get_format(struct snd_pcm_oss_file *pcm_oss_file);
 
-static inline mm_segment_t snd_enter_user(void)
-{
-	mm_segment_t fs = get_fs();
-	set_fs(get_ds());
-	return fs;
-}
-
-static inline void snd_leave_user(mm_segment_t fs)
-{
-	set_fs(fs);
-}
-
 /*
  * helper functions to process hw_params
  */
@@ -1191,14 +1179,8 @@ snd_pcm_sframes_t snd_pcm_oss_write3(struct snd_pcm_substream *substream, const
 			if (ret < 0)
 				break;
 		}
-		if (in_kernel) {
-			mm_segment_t fs;
-			fs = snd_enter_user();
-			ret = snd_pcm_lib_write(substream, (void __force __user *)ptr, frames);
-			snd_leave_user(fs);
-		} else {
-			ret = snd_pcm_lib_write(substream, (void __force __user *)ptr, frames);
-		}
+		ret = __snd_pcm_lib_xfer(substream, (void *)ptr, true,
+					 frames, in_kernel);
 		if (ret != -EPIPE && ret != -ESTRPIPE)
 			break;
 		/* test, if we can't store new data, because the stream */
@@ -1234,14 +1216,8 @@ snd_pcm_sframes_t snd_pcm_oss_read3(struct snd_pcm_substream *substream, char *p
 		ret = snd_pcm_oss_capture_position_fixup(substream, &delay);
 		if (ret < 0)
 			break;
-		if (in_kernel) {
-			mm_segment_t fs;
-			fs = snd_enter_user();
-			ret = snd_pcm_lib_read(substream, (void __force __user *)ptr, frames);
-			snd_leave_user(fs);
-		} else {
-			ret = snd_pcm_lib_read(substream, (void __force __user *)ptr, frames);
-		}
+		ret = __snd_pcm_lib_xfer(substream, (void *)ptr, true,
+					 frames, in_kernel);
 		if (ret == -EPIPE) {
 			if (runtime->status->state == SNDRV_PCM_STATE_DRAINING) {
 				ret = snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_DROP, NULL);
@@ -1273,14 +1249,8 @@ snd_pcm_sframes_t snd_pcm_oss_writev3(struct snd_pcm_substream *substream, void
 			if (ret < 0)
 				break;
 		}
-		if (in_kernel) {
-			mm_segment_t fs;
-			fs = snd_enter_user();
-			ret = snd_pcm_lib_writev(substream, (void __user **)bufs, frames);
-			snd_leave_user(fs);
-		} else {
-			ret = snd_pcm_lib_writev(substream, (void __user **)bufs, frames);
-		}
+		ret = __snd_pcm_lib_xfer(substream, bufs, false, frames,
+					 in_kernel);
 		if (ret != -EPIPE && ret != -ESTRPIPE)
 			break;
 
@@ -1313,14 +1283,8 @@ snd_pcm_sframes_t snd_pcm_oss_readv3(struct snd_pcm_substream *substream, void *
 			if (ret < 0)
 				break;
 		}
-		if (in_kernel) {
-			mm_segment_t fs;
-			fs = snd_enter_user();
-			ret = snd_pcm_lib_readv(substream, (void __user **)bufs, frames);
-			snd_leave_user(fs);
-		} else {
-			ret = snd_pcm_lib_readv(substream, (void __user **)bufs, frames);
-		}
+		ret = __snd_pcm_lib_xfer(substream, bufs, false, frames,
+					 in_kernel);
 		if (ret != -EPIPE && ret != -ESTRPIPE)
 			break;
 	}
@@ -1650,27 +1614,10 @@ static int snd_pcm_oss_sync(struct snd_pcm_oss_file *pcm_oss_file)
 		size = runtime->control->appl_ptr % runtime->period_size;
 		if (size > 0) {
 			size = runtime->period_size - size;
-			if (runtime->access == SNDRV_PCM_ACCESS_RW_INTERLEAVED) {
-				size = (runtime->frame_bits * size) / 8;
-				while (size > 0) {
-					mm_segment_t fs;
-					size_t size1 = size < runtime->oss.period_bytes ? size : runtime->oss.period_bytes;
-					size -= size1;
-					size1 *= 8;
-					size1 /= runtime->sample_bits;
-					snd_pcm_format_set_silence(runtime->format,
-								   runtime->oss.buffer,
-								   size1);
-					size1 /= runtime->channels; /* frames */
-					fs = snd_enter_user();
-					snd_pcm_lib_write(substream, (void __force __user *)runtime->oss.buffer, size1);
-					snd_leave_user(fs);
-				}
-			} else if (runtime->access == SNDRV_PCM_ACCESS_RW_NONINTERLEAVED) {
-				void __user *buffers[runtime->channels];
-				memset(buffers, 0, runtime->channels * sizeof(void *));
-				snd_pcm_lib_writev(substream, buffers, size);
-			}
+			if (runtime->access == SNDRV_PCM_ACCESS_RW_INTERLEAVED)
+				snd_pcm_lib_write(substream, NULL, size);
+			else if (runtime->access == SNDRV_PCM_ACCESS_RW_NONINTERLEAVED)
+				snd_pcm_lib_writev(substream, NULL, size);
 		}
 		mutex_unlock(&runtime->oss.params_lock);
 		/*
-- 
2.13.0
