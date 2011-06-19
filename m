Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab1FSRn7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:59 -0400
Date: Sun, 19 Jun 2011 14:42:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org
Subject: [PATCH 09/11] [media] em28xx-audio: Some Alsa API fixes
Message-ID: <20110619144245.1f3c3619@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mark the alsa stream with SNDRV_PCM_INFO_BATCH,
as the timing to get audio streams can vary.

Also, add SNDRV_PCM_TRIGGER for pause/release.

while here, fix the stop indicator, to be sure that audio
will be properly released at the stop events.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index 5381f6d..47f21a3 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -249,6 +249,7 @@ static struct snd_pcm_hardware snd_em28xx_hw_capture = {
 	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
 		SNDRV_PCM_INFO_MMAP           |
 		SNDRV_PCM_INFO_INTERLEAVED    |
+		SNDRV_PCM_INFO_BATCH	      |
 		SNDRV_PCM_INFO_MMAP_VALID,
 
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
@@ -401,11 +402,15 @@ static int snd_em28xx_capture_trigger(struct snd_pcm_substream *substream,
 	int retval = 0;
 
 	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE: /* fall through */
+	case SNDRV_PCM_TRIGGER_RESUME: /* fall through */
 	case SNDRV_PCM_TRIGGER_START:
 		atomic_set(&dev->stream_started, 1);
 		break;
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH: /* fall through */
+	case SNDRV_PCM_TRIGGER_SUSPEND: /* fall through */
 	case SNDRV_PCM_TRIGGER_STOP:
-		atomic_set(&dev->stream_started, 1);
+		atomic_set(&dev->stream_started, 0);
 		break;
 	default:
 		retval = -EINVAL;
-- 
1.7.1


