Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:53120 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbbGOAeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 20:34:22 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de,
	sakari.ailus@linux.intel.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH] media-ctl: Update to add support for ALSA devices
Date: Tue, 14 Jul 2015 18:33:59 -0600
Message-Id: <1436920452-7548-1-git-send-email-shuahkh@osg.samsung.com>
In-Reply-To: <cover.1436917513.git.shuahkh@osg.samsung.com>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support to recognize ALSA media nodes and generate
media graph that includes ALSA pcm and mixer devices.
This patch depends on kernel Media Controller changes
to support ALSA.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 utils/media-ctl/libmediactl.c | 18 ++++++++++++------
 utils/media-ctl/media-ctl.c   |  3 +++
 utils/media-ctl/mediactl.h    |  4 +++-
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index dce8eeb..329a41a 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -153,7 +153,9 @@ struct media_entity *media_get_default_entity(struct media_device *media,
 		return media->def.v4l;
 	case MEDIA_ENT_T_DEVNODE_FB:
 		return media->def.fb;
-	case MEDIA_ENT_T_DEVNODE_ALSA:
+	case MEDIA_ENT_T_DEVNODE_ALSA_CAPTURE:
+	case MEDIA_ENT_T_DEVNODE_ALSA_PLAYBACK:
+	case MEDIA_ENT_T_DEVNODE_ALSA_MIXER:
 		return media->def.alsa;
 	case MEDIA_ENT_T_DEVNODE_DVB_FE:
 	case MEDIA_ENT_T_DEVNODE_DVB_DEMUX:
@@ -481,7 +483,6 @@ static int media_get_devname_sysfs(struct media_entity *entity)
 	if (p == NULL)
 		return -EINVAL;
 
-	sprintf(devname, "/dev/%s", p + 1);
 	if (strstr(p + 1, "dvb")) {
 		char *s = p + 1;
 
@@ -493,6 +494,8 @@ static int media_get_devname_sysfs(struct media_entity *entity)
 			return -EINVAL;
 		*p = '/';
 		sprintf(devname, "/dev/dvb/adapter%s", s);
+	} else if (strstr(p + 1, "pcm") || strstr(p + 1, "control")) {
+		sprintf(devname, "/dev/snd/%s", p + 1);
 	} else {
 		sprintf(devname, "/dev/%s", p + 1);
 	}
@@ -562,7 +565,9 @@ static int media_enum_entities(struct media_device *media)
 			case MEDIA_ENT_T_DEVNODE_FB:
 				media->def.fb = entity;
 				break;
-			case MEDIA_ENT_T_DEVNODE_ALSA:
+			case MEDIA_ENT_T_DEVNODE_ALSA_CAPTURE:
+			case MEDIA_ENT_T_DEVNODE_ALSA_PLAYBACK:
+			case MEDIA_ENT_T_DEVNODE_ALSA_MIXER:
 				media->def.alsa = entity;
 				break;
 			case MEDIA_ENT_T_DEVNODE_DVB_FE:
@@ -577,8 +582,7 @@ static int media_enum_entities(struct media_device *media)
 
 		/* Find the corresponding device name. */
 		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE &&
-		    media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV &&
-		    entity->info.type == MEDIA_ENT_T_DEVNODE_ALSA)
+		    media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			continue;
 
 		/* Try to get the device name via udev */
@@ -774,7 +778,9 @@ int media_device_add_entity(struct media_device *media,
 		defent = &media->def.fb;
 		entity->info.fb = desc->fb;
 		break;
-	case MEDIA_ENT_T_DEVNODE_ALSA:
+	case MEDIA_ENT_T_DEVNODE_ALSA_CAPTURE:
+	case MEDIA_ENT_T_DEVNODE_ALSA_PLAYBACK:
+	case MEDIA_ENT_T_DEVNODE_ALSA_MIXER:
 		defent = &media->def.alsa;
 		entity->info.alsa = desc->alsa;
 		break;
diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index 602486f..85151b5 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -290,6 +290,9 @@ static const char *media_entity_subtype_to_string(unsigned type)
 		"DVB DVR",
 		"DVB CA",
 		"DVB NET",
+		"ALSA CAPTURE",
+		"ALSA PLAYBACK",
+		"ALSA MIXER",
 	};
 	static const char *subdev_types[] = {
 		"Unknown",
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 03d9f70..3ac91eb 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -305,7 +305,9 @@ struct media_entity *media_get_entity(struct media_device *media, unsigned int i
  *
  *	MEDIA_ENT_T_DEVNODE_V4L
  *	MEDIA_ENT_T_DEVNODE_FB
- *	MEDIA_ENT_T_DEVNODE_ALSA
+ *	MEDIA_ENT_T_DEVNODE_ALSA_CAPTURE
+ *	MEDIA_ENT_T_DEVNODE_ALSA_PLAYBACK
+ *	MEDIA_ENT_T_DEVNODE_ALSA_MIXER
  *	MEDIA_ENT_T_DEVNODE_DVB_FE
  *	MEDIA_ENT_T_DEVNODE_DVB_DEMUX
  *	MEDIA_ENT_T_DEVNODE_DVB_DVR
-- 
2.1.4

