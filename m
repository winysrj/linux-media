Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42490 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751194AbdFAU7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:09 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 24/27] usb: gadget: u_uac1: Kill set_fs() usage
Date: Thu,  1 Jun 2017 22:58:47 +0200
Message-Id: <20170601205850.24993-25-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the new API to perform the in-kernel buffer copy, we can get rid
of set_fs() usage in this driver, finally.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/usb/gadget/function/u_uac1.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/function/u_uac1.c b/drivers/usb/gadget/function/u_uac1.c
index c78c84138a28..ca88e4c0fd1e 100644
--- a/drivers/usb/gadget/function/u_uac1.c
+++ b/drivers/usb/gadget/function/u_uac1.c
@@ -157,7 +157,6 @@ size_t u_audio_playback(struct gaudio *card, void *buf, size_t count)
 	struct gaudio_snd_dev	*snd = &card->playback;
 	struct snd_pcm_substream *substream = snd->substream;
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	mm_segment_t old_fs;
 	ssize_t result;
 	snd_pcm_sframes_t frames;
 
@@ -174,15 +173,11 @@ size_t u_audio_playback(struct gaudio *card, void *buf, size_t count)
 	}
 
 	frames = bytes_to_frames(runtime, count);
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	result = snd_pcm_lib_write(snd->substream, (void __user *)buf, frames);
+	result = snd_pcm_kernel_write(snd->substream, buf, frames);
 	if (result != frames) {
 		ERROR(card, "Playback error: %d\n", (int)result);
-		set_fs(old_fs);
 		goto try_again;
 	}
-	set_fs(old_fs);
 
 	return 0;
 }
-- 
2.13.0
