Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42002 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZENLwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 07:52:24 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH v3 1/7] v4l2: video device: Add V4L2_CTRL_CLASS_FMTX controls
Date: Thu, 14 May 2009 14:46:55 +0300
Message-Id: <1242301622-29672-2-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1242301622-29672-1-git-send-email-eduardo.valentin@nokia.com>
References: <1242301622-29672-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a new class of extended controls. This class
is intended to support Radio Modulators properties such as:
rds, audio limiters, audio compression, pilot tone generation,
tuning power levels and region related properties.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 include/linux/videodev2.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 82f9e72..0f74dec 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -803,6 +803,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_USER 0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
+#define V4L2_CTRL_CLASS_FMTX 0x009b0000	/* FM Radio Modulator class controls */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1141,6 +1142,39 @@ enum  v4l2_exposure_auto_type {
 
 #define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)
 
+/* FM Radio Modulator class control IDs */
+#define V4L2_CID_FMTX_CLASS_BASE		(V4L2_CTRL_CLASS_FMTX | 0x900)
+#define V4L2_CID_FMTX_CLASS			(V4L2_CTRL_CLASS_FMTX | 1)
+
+#define V4L2_CID_RDS_ENABLED			(V4L2_CID_FMTX_CLASS_BASE + 1)
+#define V4L2_CID_RDS_PI				(V4L2_CID_FMTX_CLASS_BASE + 2)
+#define V4L2_CID_RDS_PTY			(V4L2_CID_FMTX_CLASS_BASE + 3)
+#define V4L2_CID_RDS_PS_NAME			(V4L2_CID_FMTX_CLASS_BASE + 4)
+#define V4L2_CID_RDS_RADIO_TEXT			(V4L2_CID_FMTX_CLASS_BASE + 5)
+
+#define V4L2_CID_AUDIO_LIMITER_ENABLED		(V4L2_CID_FMTX_CLASS_BASE + 6)
+#define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME	(V4L2_CID_FMTX_CLASS_BASE + 7)
+#define V4L2_CID_AUDIO_LIMITER_DEVIATION	(V4L2_CID_FMTX_CLASS_BASE + 8)
+
+#define V4L2_CID_AUDIO_COMPRESSION_ENABLED	(V4L2_CID_FMTX_CLASS_BASE + 9)
+#define V4L2_CID_AUDIO_COMPRESSION_GAIN		(V4L2_CID_FMTX_CLASS_BASE + 10)
+#define V4L2_CID_AUDIO_COMPRESSION_THRESHOLD	(V4L2_CID_FMTX_CLASS_BASE + 11)
+#define V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME	(V4L2_CID_FMTX_CLASS_BASE + 12)
+#define V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME	(V4L2_CID_FMTX_CLASS_BASE + 13)
+
+#define V4L2_CID_PILOT_TONE_ENABLED		(V4L2_CID_FMTX_CLASS_BASE + 14)
+#define V4L2_CID_PILOT_TONE_DEVIATION		(V4L2_CID_FMTX_CLASS_BASE + 15)
+#define V4L2_CID_PILOT_TONE_FREQUENCY		(V4L2_CID_FMTX_CLASS_BASE + 16)
+
+#define V4L2_CID_PREEMPHASIS			(V4L2_CID_FMTX_CLASS_BASE + 17)
+enum v4l2_fmtx_preemphasis {
+	V4L2_FMTX_PREEMPHASIS_DISABLED		= 0,
+	V4L2_FMTX_PREEMPHASIS_50_uS		= 1,
+	V4L2_FMTX_PREEMPHASIS_75_uS		= 2,
+};
+#define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FMTX_CLASS_BASE + 18)
+#define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FMTX_CLASS_BASE + 19)
+
 /*
  *	T U N I N G
  */
-- 
1.6.2.GIT

