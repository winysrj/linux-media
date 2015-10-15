Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:56317 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbbJOUu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 16:50:58 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 2/2] media: au0828 create link between ALSA Mixer and decoder
Date: Thu, 15 Oct 2015 14:50:53 -0600
Message-Id: <5d44b252378049b68a9cf6ad966c1b1978848676.1444941680.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1444941680.git.shuahkh@osg.samsung.com>
References: <cover.1444941680.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1444941680.git.shuahkh@osg.samsung.com>
References: <cover.1444941680.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828_create_media_graph() to create pad link
between MEDIA_ENT_F_AUDIO_MIXER entity and decoder's
AU8522_PAD_AUDIO_OUT.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 12 ++++++++++++
 drivers/media/usb/au0828/au0828.h      |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 7af5d0d..84b2405 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -225,6 +225,7 @@ void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 	struct media_entity *entity;
 	struct media_entity *tuner = NULL, *decoder = NULL;
 	struct media_entity *audio_capture = NULL;
+	struct media_entity *mixer = NULL;
 	int i, ret;
 
 	if (!mdev)
@@ -245,6 +246,9 @@ void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 		case MEDIA_ENT_F_AUDIO_CAPTURE:
 			audio_capture = entity;
 			break;
+		case MEDIA_ENT_F_AUDIO_MIXER:
+			mixer = entity;
+			break;
 		}
 	}
 
@@ -316,6 +320,14 @@ void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 		if (ret == 0)
 			dev->audio_capture_linked = 1;
 	}
+
+	if (mixer && !dev->mixer_linked) {
+		ret = media_create_pad_link(decoder, AU8522_PAD_AUDIO_OUT,
+					    mixer, 0,
+					    MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->mixer_linked = 1;
+	}
 #endif
 }
 
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 2f4d597..6dd81b2 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -288,6 +288,7 @@ struct au0828_dev {
 	bool vdev_linked;
 	bool vbi_linked;
 	bool audio_capture_linked;
+	bool mixer_linked;
 	struct media_link *active_link;
 	struct media_entity *active_link_owner;
 #endif
-- 
2.1.4

