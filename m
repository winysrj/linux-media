Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:56251 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758775AbbIVR2C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:28:02 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 10/21] media: au8522 change to create MC pad for ALSA Audio Out
Date: Tue, 22 Sep 2015 11:19:29 -0600
Message-Id: <350974dc0fdc9832ab0f22c88f82eabc703092d3.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new pad for ALSA Audio Out to au8522_media_pads.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-frontends/au8522.h         | 1 +
 drivers/media/dvb-frontends/au8522_decoder.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
index 3c72f40..d7a997f 100644
--- a/drivers/media/dvb-frontends/au8522.h
+++ b/drivers/media/dvb-frontends/au8522.h
@@ -94,6 +94,7 @@ enum au8522_media_pads {
 	AU8522_PAD_INPUT,
 	AU8522_PAD_VID_OUT,
 	AU8522_PAD_VBI_OUT,
+	AU8522_PAD_AUDIO_OUT,
 
 	AU8522_NUM_PADS
 };
diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 24990db..5fc9a39 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -775,6 +775,7 @@ static int au8522_probe(struct i2c_client *client,
 	state->pads[AU8522_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
 	state->pads[AU8522_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	state->pads[AU8522_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[AU8522_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
 
 	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
-- 
2.1.4

