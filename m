Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42557 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751237AbdFAU7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:10 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 26/27] ALSA: pcm: Build OSS writev/readv helpers conditionally
Date: Thu,  1 Jun 2017 22:58:49 +0200
Message-Id: <20170601205850.24993-27-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The snd_pcm_oss_writev3() and snd_pcm_oss_readv3() are used only in
io.c with CONFIG_SND_PCM_OSS_PLUGINS=y.  Add an ifdef to reduce the
build of these functions.

Along with it, since they are called always for in-kernel copy, reduce
the argument and call snd_pcm_kernel_writev() and *_readv() directly
instead.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/core/oss/io.c         |  4 ++--
 sound/core/oss/pcm_oss.c    | 12 ++++++------
 sound/core/oss/pcm_plugin.h |  6 ++----
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/sound/core/oss/io.c b/sound/core/oss/io.c
index 6faa1d719206..d870b2d93135 100644
--- a/sound/core/oss/io.c
+++ b/sound/core/oss/io.c
@@ -26,9 +26,9 @@
 #include "pcm_plugin.h"
 
 #define pcm_write(plug,buf,count) snd_pcm_oss_write3(plug,buf,count,1)
-#define pcm_writev(plug,vec,count) snd_pcm_oss_writev3(plug,vec,count,1)
+#define pcm_writev(plug,vec,count) snd_pcm_oss_writev3(plug,vec,count)
 #define pcm_read(plug,buf,count) snd_pcm_oss_read3(plug,buf,count,1)
-#define pcm_readv(plug,vec,count) snd_pcm_oss_readv3(plug,vec,count,1)
+#define pcm_readv(plug,vec,count) snd_pcm_oss_readv3(plug,vec,count)
 
 /*
  *  Basic io plugin
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 2d6a825cfe88..5e1009d959a8 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1232,7 +1232,8 @@ snd_pcm_sframes_t snd_pcm_oss_read3(struct snd_pcm_substream *substream, char *p
 	return ret;
 }
 
-snd_pcm_sframes_t snd_pcm_oss_writev3(struct snd_pcm_substream *substream, void **bufs, snd_pcm_uframes_t frames, int in_kernel)
+#ifdef CONFIG_SND_PCM_OSS_PLUGINS
+snd_pcm_sframes_t snd_pcm_oss_writev3(struct snd_pcm_substream *substream, void **bufs, snd_pcm_uframes_t frames)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int ret;
@@ -1249,8 +1250,7 @@ snd_pcm_sframes_t snd_pcm_oss_writev3(struct snd_pcm_substream *substream, void
 			if (ret < 0)
 				break;
 		}
-		ret = __snd_pcm_lib_xfer(substream, bufs, false, frames,
-					 in_kernel);
+		ret = snd_pcm_kernel_writev(substream, bufs, frames);
 		if (ret != -EPIPE && ret != -ESTRPIPE)
 			break;
 
@@ -1262,7 +1262,7 @@ snd_pcm_sframes_t snd_pcm_oss_writev3(struct snd_pcm_substream *substream, void
 	return ret;
 }
 	
-snd_pcm_sframes_t snd_pcm_oss_readv3(struct snd_pcm_substream *substream, void **bufs, snd_pcm_uframes_t frames, int in_kernel)
+snd_pcm_sframes_t snd_pcm_oss_readv3(struct snd_pcm_substream *substream, void **bufs, snd_pcm_uframes_t frames)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int ret;
@@ -1283,13 +1283,13 @@ snd_pcm_sframes_t snd_pcm_oss_readv3(struct snd_pcm_substream *substream, void *
 			if (ret < 0)
 				break;
 		}
-		ret = __snd_pcm_lib_xfer(substream, bufs, false, frames,
-					 in_kernel);
+		ret = snd_pcm_kernel_readv(substream, bufs, frames);
 		if (ret != -EPIPE && ret != -ESTRPIPE)
 			break;
 	}
 	return ret;
 }
+#endif /* CONFIG_SND_PCM_OSS_PLUGINS */
 
 static ssize_t snd_pcm_oss_write2(struct snd_pcm_substream *substream, const char *buf, size_t bytes, int in_kernel)
 {
diff --git a/sound/core/oss/pcm_plugin.h b/sound/core/oss/pcm_plugin.h
index 73c068abaca5..c9cd29d86efd 100644
--- a/sound/core/oss/pcm_plugin.h
+++ b/sound/core/oss/pcm_plugin.h
@@ -162,11 +162,9 @@ snd_pcm_sframes_t snd_pcm_oss_write3(struct snd_pcm_substream *substream,
 snd_pcm_sframes_t snd_pcm_oss_read3(struct snd_pcm_substream *substream,
 				    char *ptr, snd_pcm_uframes_t size, int in_kernel);
 snd_pcm_sframes_t snd_pcm_oss_writev3(struct snd_pcm_substream *substream,
-				      void **bufs, snd_pcm_uframes_t frames,
-				      int in_kernel);
+				      void **bufs, snd_pcm_uframes_t frames);
 snd_pcm_sframes_t snd_pcm_oss_readv3(struct snd_pcm_substream *substream,
-				     void **bufs, snd_pcm_uframes_t frames,
-				     int in_kernel);
+				     void **bufs, snd_pcm_uframes_t frames);
 
 #else
 
-- 
2.13.0
