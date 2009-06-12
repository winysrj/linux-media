Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56940 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760342AbZFLRgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 13:36:04 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv7 2/9] v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX controls
Date: Fri, 12 Jun 2009 20:30:33 +0300
Message-Id: <1244827840-886-3-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1244827840-886-2-git-send-email-eduardo.valentin@nokia.com>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
 <1244827840-886-2-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a new class of extended controls. This class
is intended to support FM Radio Modulators properties such as:
rds, audio limiters, audio compression, pilot tone generation,
tuning power levels and preemphasis properties.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 linux/include/linux/videodev2.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
index b8cffc9..9733435 100644
--- a/linux/include/linux/videodev2.h
+++ b/linux/include/linux/videodev2.h
@@ -806,6 +806,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_USER 0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
+#define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1144,6 +1145,39 @@ enum  v4l2_exposure_auto_type {
 
 #define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)
 
+/* FM Modulator class control IDs */
+#define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
+#define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
+
+#define V4L2_CID_RDS_ENABLED			(V4L2_CID_FM_TX_CLASS_BASE + 1)
+#define V4L2_CID_RDS_PI				(V4L2_CID_FM_TX_CLASS_BASE + 2)
+#define V4L2_CID_RDS_PTY			(V4L2_CID_FM_TX_CLASS_BASE + 3)
+#define V4L2_CID_RDS_PS_NAME			(V4L2_CID_FM_TX_CLASS_BASE + 4)
+#define V4L2_CID_RDS_RADIO_TEXT			(V4L2_CID_FM_TX_CLASS_BASE + 5)
+
+#define V4L2_CID_AUDIO_LIMITER_ENABLED		(V4L2_CID_FM_TX_CLASS_BASE + 6)
+#define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 7)
+#define V4L2_CID_AUDIO_LIMITER_DEVIATION	(V4L2_CID_FM_TX_CLASS_BASE + 8)
+
+#define V4L2_CID_AUDIO_COMPRESSION_ENABLED	(V4L2_CID_FM_TX_CLASS_BASE + 9)
+#define V4L2_CID_AUDIO_COMPRESSION_GAIN		(V4L2_CID_FM_TX_CLASS_BASE + 10)
+#define V4L2_CID_AUDIO_COMPRESSION_THRESHOLD	(V4L2_CID_FM_TX_CLASS_BASE + 11)
+#define V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 12)
+#define V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 13)
+
+#define V4L2_CID_PILOT_TONE_ENABLED		(V4L2_CID_FM_TX_CLASS_BASE + 14)
+#define V4L2_CID_PILOT_TONE_DEVIATION		(V4L2_CID_FM_TX_CLASS_BASE + 15)
+#define V4L2_CID_PILOT_TONE_FREQUENCY		(V4L2_CID_FM_TX_CLASS_BASE + 16)
+
+#define V4L2_CID_PREEMPHASIS			(V4L2_CID_FM_TX_CLASS_BASE + 17)
+enum v4l2_fm_tx_preemphasis {
+	V4L2_FM_TX_PREEMPHASIS_DISABLED		= 0,
+	V4L2_FM_TX_PREEMPHASIS_50_uS		= 1,
+	V4L2_FM_TX_PREEMPHASIS_75_uS		= 2,
+};
+#define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FM_TX_CLASS_BASE + 18)
+#define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FM_TX_CLASS_BASE + 19)
+
 /*
  *	T U N I N G
  */
-- 
1.6.2.GIT

