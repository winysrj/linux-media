Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751154AbdFAU7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:05 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 03/27] ALSA: dummy: Convert to new PCM copy ops
Date: Thu,  1 Jun 2017 22:58:26 +0200
Message-Id: <20170601205850.24993-4-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's a dummy ops, so just replacing it.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/drivers/dummy.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 172dacd925f5..dd5ed037adf2 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -644,15 +644,22 @@ static int alloc_fake_buffer(void)
 }
 
 static int dummy_pcm_copy(struct snd_pcm_substream *substream,
-			  int channel, snd_pcm_uframes_t pos,
-			  void __user *dst, snd_pcm_uframes_t count)
+			  int channel, unsigned long pos,
+			  void __user *dst, unsigned long bytes)
+{
+	return 0; /* do nothing */
+}
+
+static int dummy_pcm_copy_kernel(struct snd_pcm_substream *substream,
+				 int channel, unsigned long pos,
+				 void *dst, unsigned long bytes)
 {
 	return 0; /* do nothing */
 }
 
 static int dummy_pcm_silence(struct snd_pcm_substream *substream,
-			     int channel, snd_pcm_uframes_t pos,
-			     snd_pcm_uframes_t count)
+			     int channel, unsigned long pos,
+			     unsigned long bytes)
 {
 	return 0; /* do nothing */
 }
@@ -683,8 +690,9 @@ static struct snd_pcm_ops dummy_pcm_ops_no_buf = {
 	.prepare =	dummy_pcm_prepare,
 	.trigger =	dummy_pcm_trigger,
 	.pointer =	dummy_pcm_pointer,
-	.copy =		dummy_pcm_copy,
-	.silence =	dummy_pcm_silence,
+	.copy_user =	dummy_pcm_copy,
+	.copy_kernel =	dummy_pcm_copy_kernel,
+	.fill_silence =	dummy_pcm_silence,
 	.page =		dummy_pcm_page,
 };
 
-- 
2.13.0
