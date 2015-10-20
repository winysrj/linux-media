Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:59500 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbbJTXZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 19:25:21 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen v2 3/3] media: au0828 create link between ALSA Mixer and decoder
Date: Tue, 20 Oct 2015 17:25:16 -0600
Message-Id: <c2499491a5c4f215efeaf15312078736a207afab.1445380851.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1445380851.git.shuahkh@osg.samsung.com>
References: <cover.1445380851.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1445380851.git.shuahkh@osg.samsung.com>
References: <cover.1445380851.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828_create_media_graph() to create pad link
between MEDIA_ENT_F_AUDIO_MIXER entity and decoder's
AU8522_PAD_AUDIO_OUT. With mixer entity now linked to
decoder, change to link MEDIA_ENT_F_AUDIO_CAPTURE to
mixer's source pad.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 17 ++++++++++++++---
 drivers/media/usb/au0828/au0828.h      |  1 +
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 7af5d0d..3ef6fee 100644
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
 
@@ -309,13 +313,20 @@ void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 		}
 	}
 
-	if (audio_capture && !dev->audio_capture_linked) {
-		ret = media_create_pad_link(decoder, AU8522_PAD_AUDIO_OUT,
-					    audio_capture, 0,
+	if (mixer && audio_capture && !dev->audio_capture_linked) {
+		ret = media_create_pad_link(mixer, 1, audio_capture, 0,
 					    MEDIA_LNK_FL_ENABLED);
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

