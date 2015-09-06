Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbbIFMD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v8 15/55] [media] uapi/media.h: Declare interface types for ALSA
Date: Sun,  6 Sep 2015 09:02:46 -0300
Message-Id: <ab80a0838a2a82207de3b60d164877e90e3074e2.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <cd69226f7f42baafbc4a3db5f8a8c387fba879dd.1440902901.git.mchehab@osg.samsung.com>
References: <cd69226f7f42baafbc4a3db5f8a8c387fba879dd.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare the interface types to be used on alsa for the new
G_TOPOLOGY ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index dc679dfe8ade..27fce6224972 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -74,6 +74,18 @@ static inline const char *intf_type(struct media_interface *intf)
 		return "v4l2-subdev";
 	case MEDIA_INTF_T_V4L_SWRADIO:
 		return "swradio";
+	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
+		return "pcm-capture";
+	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
+		return "pcm-playback";
+	case MEDIA_INTF_T_ALSA_CONTROL:
+		return "alsa-control";
+	case MEDIA_INTF_T_ALSA_COMPRESS:
+		return "compress";
+	case MEDIA_INTF_T_ALSA_RAWMIDI:
+		return "rawmidi";
+	case MEDIA_INTF_T_ALSA_HWDEP:
+		return "hwdep";
 	default:
 		return "unknown-intf";
 	}
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 3ad3d6be293f..aca828709bad 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -171,6 +171,7 @@ struct media_links_enum {
 
 #define MEDIA_INTF_T_DVB_BASE	0x00000100
 #define MEDIA_INTF_T_V4L_BASE	0x00000200
+#define MEDIA_INTF_T_ALSA_BASE	0x00000300
 
 /* Interface types */
 
@@ -186,6 +187,13 @@ struct media_links_enum {
 #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
 #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
 
+#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
+#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
+#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
+#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
+#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
+#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
+
 /* TBD: declare the structs needed for the new G_TOPOLOGY ioctl */
 
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
-- 
2.4.3


