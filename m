Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38127 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756771AbdEUUJ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:09:59 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 03/16] ALSA: dummy: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:37 +0200
Message-Id: <20170521200950.4592-4-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's a dummy ops, so just replacing it.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/drivers/dummy.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 172dacd925f5..68519689a9ea 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -645,14 +645,8 @@ static int alloc_fake_buffer(void)
 
 static int dummy_pcm_copy(struct snd_pcm_substream *substream,
 			  int channel, snd_pcm_uframes_t pos,
-			  void __user *dst, snd_pcm_uframes_t count)
-{
-	return 0; /* do nothing */
-}
-
-static int dummy_pcm_silence(struct snd_pcm_substream *substream,
-			     int channel, snd_pcm_uframes_t pos,
-			     snd_pcm_uframes_t count)
+			  void __user *dst, snd_pcm_uframes_t count,
+			  bool in_kernel)
 {
 	return 0; /* do nothing */
 }
@@ -683,8 +677,7 @@ static struct snd_pcm_ops dummy_pcm_ops_no_buf = {
 	.prepare =	dummy_pcm_prepare,
 	.trigger =	dummy_pcm_trigger,
 	.pointer =	dummy_pcm_pointer,
-	.copy =		dummy_pcm_copy,
-	.silence =	dummy_pcm_silence,
+	.copy_silence =	dummy_pcm_copy,
 	.page =		dummy_pcm_page,
 };
 
-- 
2.13.0
