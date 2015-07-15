Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:51607 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbbGOAe2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 20:34:28 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	crope@iki.fi, sakari.ailus@linux.intel.com, arnd@arndb.de,
	stefanr@s5r6.in-berlin.de, ruchandani.tina@gmail.com,
	chehabrafael@gmail.com, dan.carpenter@oracle.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com,
	agoode@google.com, pierre-louis.bossart@linux.intel.com,
	gtmkramer@xs4all.nl, clemens@ladisch.de, daniel@zonque.org,
	vladcatoi@gmail.com, misterpib@gmail.com, damien@zamaudio.com,
	pmatilai@laiskiainen.org, takamichiho@gmail.com,
	normalperson@yhbt.net, bugzilla.frnkcg@spamgourmet.com,
	joe@oampo.co.uk, calcprogrammer1@gmail.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH 5/7] media: au8522 change to create MC pad for ALSA Audio Out
Date: Tue, 14 Jul 2015 18:34:04 -0600
Message-Id: <f1523ea9906d0f1065809bf50efea113317c62ac.1436917513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1436917513.git.shuahkh@osg.samsung.com>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1436917513.git.shuahkh@osg.samsung.com>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new pad for ALSA Audio Out to au8522_media_pads. Move the
au8522_media_pads enum to au8522.h from au8522_priv.h. This will
allow au0828-core to use these defines instead of hard-coding the
pad values when it creates media graph linking decode pads to other
entities.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-frontends/au8522.h         | 8 ++++++++
 drivers/media/dvb-frontends/au8522_decoder.c | 1 +
 drivers/media/dvb-frontends/au8522_priv.h    | 8 --------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
index dde6158..d7a997f 100644
--- a/drivers/media/dvb-frontends/au8522.h
+++ b/drivers/media/dvb-frontends/au8522.h
@@ -90,4 +90,12 @@ enum au8522_audio_input {
 	AU8522_AUDIO_SIF,
 };
 
+enum au8522_media_pads {
+	AU8522_PAD_INPUT,
+	AU8522_PAD_VID_OUT,
+	AU8522_PAD_VBI_OUT,
+	AU8522_PAD_AUDIO_OUT,
+
+	AU8522_NUM_PADS
+};
 #endif /* __AU8522_H__ */
diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 24990db..01d8fe7 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -775,6 +775,7 @@ static int au8522_probe(struct i2c_client *client,
 	state->pads[AU8522_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
 	state->pads[AU8522_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	state->pads[AU8522_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[AU8522_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SINK;
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
 
 	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index d6209d9..4c2a6ed 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -39,14 +39,6 @@
 #define AU8522_DIGITAL_MODE 1
 #define AU8522_SUSPEND_MODE 2
 
-enum au8522_media_pads {
-	AU8522_PAD_INPUT,
-	AU8522_PAD_VID_OUT,
-	AU8522_PAD_VBI_OUT,
-
-	AU8522_NUM_PADS
-};
-
 struct au8522_state {
 	struct i2c_client *c;
 	struct i2c_adapter *i2c;
-- 
2.1.4

