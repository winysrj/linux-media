Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:52578 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcCCQva (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 11:51:30 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, perex@perex.cz, tiwai@suse.com,
	dan.carpenter@oracle.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, alsa-devel@alsa-project.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/usb: Use meaninful names for goto labels
Date: Thu,  3 Mar 2016 09:51:26 -0700
Message-Id: <1457023886-4428-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix to use meaningful names instead of numbered goto labels

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 sound/usb/media.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/usb/media.c b/sound/usb/media.c
index b87d5b3..ab6a642 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -84,21 +84,21 @@ int media_snd_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 	ret =  media_device_register_entity(mctl->media_dev,
 					    &mctl->media_entity);
 	if (ret)
-		goto err1;
+		goto free_mctl;
 
 	mctl->intf_devnode = media_devnode_create(mdev, intf_type, 0,
 						  MAJOR(pcm_dev->devt),
 						  MINOR(pcm_dev->devt));
 	if (!mctl->intf_devnode) {
 		ret = -ENOMEM;
-		goto err2;
+		goto unregister_entity;
 	}
 	mctl->intf_link = media_create_intf_link(&mctl->media_entity,
 						 &mctl->intf_devnode->intf,
 						 MEDIA_LNK_FL_ENABLED);
 	if (!mctl->intf_link) {
 		ret = -ENOMEM;
-		goto err3;
+		goto devnode_remove;
 	}
 
 	/* create link between mixer and audio */
@@ -109,7 +109,7 @@ int media_snd_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 						    &mctl->media_entity, 0,
 						    MEDIA_LNK_FL_ENABLED);
 			if (ret)
-				goto err4;
+				goto remove_intf_link;
 			break;
 		}
 	}
@@ -117,13 +117,13 @@ int media_snd_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 	subs->media_ctl = mctl;
 	return 0;
 
-err4:
+remove_intf_link:
 	media_remove_intf_link(mctl->intf_link);
-err3:
+devnode_remove:
 	media_devnode_remove(mctl->intf_devnode);
-err2:
+unregister_entity:
 	media_device_unregister_entity(&mctl->media_entity);
-err1:
+free_mctl:
 	kfree(mctl);
 	return ret;
 }
-- 
2.5.0

