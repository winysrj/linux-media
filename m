Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:46201 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbbKJUq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 15:46:57 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen v3 4/6] sound/usb: Fix media_stream_init() and media_stream_delete() error paths
Date: Tue, 10 Nov 2015 13:40:47 -0700
Message-Id: <249a5b1eb3463167d2aef448265d638bf90c72f2.1447184001.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1447183999.git.shuahkh@osg.samsung.com>
References: <cover.1447183999.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1447183999.git.shuahkh@osg.samsung.com>
References: <cover.1447183999.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix media_stream_init() to free memory in error paths. Fix
media_stream_delete() to remove unnecessary set media_dev
pointer to null before free mctl.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 sound/usb/media.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/usb/media.c b/sound/usb/media.c
index 6df346a..bebe27b 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -127,7 +127,6 @@ int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 	if (!mctl)
 		return -ENOMEM;
 
-	subs->media_ctl = (void *) mctl;
 	mctl->media_dev = mdev;
 	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		intf_type = MEDIA_INTF_T_ALSA_PCM_PLAYBACK;
@@ -143,13 +142,16 @@ int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 	media_entity_init(&mctl->media_entity, 1, &mctl->media_pad);
 	ret =  media_device_register_entity(mctl->media_dev,
 					    &mctl->media_entity);
-	if (ret)
+	if (ret) {
+		kfree(mctl);
 		return ret;
+	}
 	mctl->intf_devnode = media_devnode_create(mdev, intf_type, 0,
 						  MAJOR(pcm_dev->devt),
 						  MINOR(pcm_dev->devt));
 	if (!mctl->intf_devnode) {
 		media_device_unregister_entity(&mctl->media_entity);
+		kfree(mctl);
 		return -ENOMEM;
 	}
 	mctl->intf_link = media_create_intf_link(&mctl->media_entity,
@@ -158,8 +160,10 @@ int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 	if (!mctl->intf_link) {
 		media_devnode_remove(mctl->intf_devnode);
 		media_device_unregister_entity(&mctl->media_entity);
+		kfree(mctl);
 		return -ENOMEM;
 	}
+	subs->media_ctl = (void *) mctl;
 	return 0;
 }
 
@@ -177,7 +181,6 @@ void media_stream_delete(struct snd_usb_substream *subs)
 			media_device_unregister_entity(&mctl->media_entity);
 			media_entity_cleanup(&mctl->media_entity);
 		}
-		mctl->media_dev = NULL;
 		kfree(mctl);
 		subs->media_ctl = NULL;
 	}
-- 
2.5.0

