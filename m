Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:35916 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbcBKXmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:04 -0500
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
Subject: [PATCH v3 10/22] media: Move au8522_media_pads enum to au8522.h from au8522_priv.h
Date: Thu, 11 Feb 2016 16:41:26 -0700
Message-Id: <f96bc76341fb03345022e04f3f75b1cf3cfb6f8a.1455233154.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the au8522_media_pads enum to au8522.h
from au8522_priv.h to export them. This will
allow au0828-core to use these defines instead
of hard-coding them them.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-frontends/au8522.h      | 7 +++++++
 drivers/media/dvb-frontends/au8522_priv.h | 8 --------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
index dde6158..3c72f40 100644
--- a/drivers/media/dvb-frontends/au8522.h
+++ b/drivers/media/dvb-frontends/au8522.h
@@ -90,4 +90,11 @@ enum au8522_audio_input {
 	AU8522_AUDIO_SIF,
 };
 
+enum au8522_media_pads {
+	AU8522_PAD_INPUT,
+	AU8522_PAD_VID_OUT,
+	AU8522_PAD_VBI_OUT,
+
+	AU8522_NUM_PADS
+};
 #endif /* __AU8522_H__ */
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index 404a0cb..505215a 100644
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
2.5.0

