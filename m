Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:35957 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbcBKXmK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:10 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 11/22] media: au8522 change to create MC pad for ALSA Audio Out
Date: Thu, 11 Feb 2016 16:41:27 -0700
Message-Id: <61856ba34546a398d4ebe1fa616b1b2bd41af975.1455233154.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
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
index 73612c5..0ab9f1e 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -766,6 +766,7 @@ static int au8522_probe(struct i2c_client *client,
 	state->pads[AU8522_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
 	state->pads[AU8522_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	state->pads[AU8522_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[AU8522_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
 	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
-- 
2.5.0

