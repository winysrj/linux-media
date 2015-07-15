Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:58471 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047AbbGOAe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 20:34:27 -0400
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
Subject: [PATCH 3/7] media: Add ALSA Media Controller devnodes
Date: Tue, 14 Jul 2015 18:34:02 -0600
Message-Id: <78cb5dd3bb7d5e531c66384c48ee35aa89903b75.1436917513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1436917513.git.shuahkh@osg.samsung.com>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1436917513.git.shuahkh@osg.samsung.com>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ALSA Media Controller capture, playback, and mixer
devnode defines.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/uapi/linux/media.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4e816be..4a30ea3 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -49,12 +49,17 @@ struct media_device_info {
 #define MEDIA_ENT_T_DEVNODE		(1 << MEDIA_ENT_TYPE_SHIFT)
 #define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENT_T_DEVNODE + 1)
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
+/* Legacy ALSA symbol. Keep it to avoid userspace compilation breakages */
 #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
 #define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE + 4)
 #define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE + 5)
 #define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE + 6)
 #define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE + 7)
 #define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE + 8)
+/* ALSA devnodes */
+#define MEDIA_ENT_T_DEVNODE_ALSA_CAPTURE	(MEDIA_ENT_T_DEVNODE + 9)
+#define MEDIA_ENT_T_DEVNODE_ALSA_PLAYBACK	(MEDIA_ENT_T_DEVNODE + 10)
+#define MEDIA_ENT_T_DEVNODE_ALSA_MIXER		(MEDIA_ENT_T_DEVNODE + 11)
 
 /* Legacy symbol. Use it to avoid userspace compilation breakages */
 #define MEDIA_ENT_T_DEVNODE_DVB		MEDIA_ENT_T_DEVNODE_DVB_FE
-- 
2.1.4

