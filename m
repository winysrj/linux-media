Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:54732 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbcCSCuk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 22:50:40 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, perex@perex.cz
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/usb: fix to release stream resources from media_snd_device_delete()
Date: Fri, 18 Mar 2016 20:50:31 -0600
Message-Id: <1458355831-9467-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix to release stream resources from media_snd_device_delete() before
media device is unregistered. Without this change, stream resource free
is attempted after the media device is unregistered which would result
in use-after-free errors.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

- Ran bind/unbind loop (1000 iteration) test on snd-usb-audio
  while running mc_nextgen_test loop (1000 iterations) in parallel.
- Ran bind/unbind and rmmod/modprobe tests on both drivers. Also
  generated graphs when after bind/unbind, rmmod/modprobe. Graphs
  look good.
- Note: Please apply the following patch to fix memory leak:
  sound/usb: Fix memory leak in media_snd_stream_delete() during unbind
  https://lkml.org/lkml/2016/3/16/1050

 sound/usb/media.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/usb/media.c b/sound/usb/media.c
index de4a815..e35af88 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -301,6 +301,13 @@ int media_snd_device_create(struct snd_usb_audio *chip,
 void media_snd_device_delete(struct snd_usb_audio *chip)
 {
 	struct media_device *mdev = chip->media_dev;
+	struct snd_usb_stream *stream;
+
+	/* release resources */
+	list_for_each_entry(stream, &chip->pcm_list, list) {
+		media_snd_stream_delete(&stream->substream[0]);
+		media_snd_stream_delete(&stream->substream[1]);
+	}
 
 	media_snd_mixer_delete(chip);
 
-- 
2.5.0

