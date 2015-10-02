Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:55218 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbbJBWHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:39 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	dan.carpenter@oracle.com, tskd08@gmail.com, arnd@arndb.de,
	ruchandani.tina@gmail.com, corbet@lwn.net, k.kozlowski@samsung.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	elfring@users.sourceforge.net, Julia.Lawall@lip6.fr,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, johan@oljud.se,
	wsa@the-dreams.de, jcragg@gmail.com, clemens@ladisch.de,
	daniel@zonque.org, gtmkramer@xs4all.nl, misterpib@gmail.com,
	takamichiho@gmail.com, pmatilai@laiskiainen.org,
	vladcatoi@gmail.com, damien@zamaudio.com, normalperson@yhbt.net,
	joe@oampo.co.uk, jussi@sonarnerd.net, calcprogrammer1@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 02/20] media: Add ALSA Media Controller function entities
Date: Fri,  2 Oct 2015 16:07:14 -0600
Message-Id: <5817c3708ab4147f4092f2f5b268cd4331bec622.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ALSA Media Controller capture, playback, and mixer
function entity defines.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/uapi/linux/media.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 90e90a6..46b1e169 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -78,6 +78,13 @@ struct media_device_info {
 #define MEDIA_ENT_F_CONN_TEST		(MEDIA_ENT_F_BASE + 24)
 
 /*
+ * ALSA entities MEDIA_ENT_F_AUDIO_IO is for Capture and Playback
+*/
+#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 200)
+#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 201)
+#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 202)
+
+/*
  * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
  * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
  * with the legacy v1 API.The number range is out of range by purpose:
@@ -115,7 +122,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DEVNODE		MEDIA_ENT_F_OLD_BASE
 #define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_F_IO
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
-#define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
+#define MEDIA_ENT_T_DEVNODE_ALSA	MEDIA_ENT_F_AUDIO_IO
 #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
 
 #define MEDIA_ENT_T_UNKNOWN		MEDIA_ENT_F_UNKNOWN
-- 
2.1.4

