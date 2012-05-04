Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55730 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879Ab2EDUtH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 May 2012 16:49:07 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH V4 3/5] Add new CID for FM TX RDS Alternate Frequency
Date: Fri, 4 May 2012 15:49:00 -0500
Message-ID: <1336164542-11014-4-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1336164542-11014-1-git-send-email-manjunatha_halli@ti.com>
References: <1336164542-11014-1-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Manjunatha Halli <x0130808@ti.com>

Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/media/video/v4l2-ctrls.c |    1 +
 include/linux/videodev2.h        |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9d7608e..610076c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -608,6 +608,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
 	case V4L2_CID_RDS_TX_PS_NAME:		return "RDS PS Name";
 	case V4L2_CID_RDS_TX_RADIO_TEXT:	return "RDS Radio Text";
+	case V4L2_CID_RDS_TX_AF_FREQ:		return "RDS Alternate Frequency";
 	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
 	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
 	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 534a3f1..e7a8e96 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1699,6 +1699,7 @@ enum  v4l2_exposure_auto_type {
 #define V4L2_CID_RDS_TX_PTY			(V4L2_CID_FM_TX_CLASS_BASE + 3)
 #define V4L2_CID_RDS_TX_PS_NAME			(V4L2_CID_FM_TX_CLASS_BASE + 5)
 #define V4L2_CID_RDS_TX_RADIO_TEXT		(V4L2_CID_FM_TX_CLASS_BASE + 6)
+#define V4L2_CID_RDS_TX_AF_FREQ			(V4L2_CID_FM_TX_CLASS_BASE + 7)
 
 #define V4L2_CID_AUDIO_LIMITER_ENABLED		(V4L2_CID_FM_TX_CLASS_BASE + 64)
 #define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 65)
-- 
1.7.4.1

