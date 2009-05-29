Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:18625 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZE2HiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 03:38:04 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "\\\"ext Hans Verkuil\\\"" <hverkuil@xs4all.nl>,
	"\\\"ext Mauro Carvalho Chehab\\\"" <mchehab@infradead.org>
Cc: "\\\"Nurkkala Eero.An (EXT-Offcode/Oulu)\\\""
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\"ext Douglas Schilling Landgraf\\\"" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv5 2 of 8] v4l2: video device: Add V4L2_CTRL_CLASS_FMTX controls
Date: Fri, 29 May 2009 10:33:22 +0300
Message-Id: <1243582408-13084-3-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1243582408-13084-2-git-send-email-eduardo.valentin@nokia.com>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-2-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Eduardo Valentin <eduardo.valentin@nokia.com>
# Date 1243414606 -10800
# Branch export
# Node ID ebb409d7a258df2bc7a6dcd72113584b4c0e7ce2
# Parent  4fb354645426f8b187c2c90cd8528b2518461005
This patch adds a new class of extended controls. This class
is intended to support Radio Modulators properties such as:
rds, audio limiters, audio compression, pilot tone generation,
tuning power levels and region related properties.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 include/linux/videodev2.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff -r 4fb354645426 -r ebb409d7a258 linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Wed May 27 11:56:45 2009 +0300
+++ b/linux/include/linux/videodev2.h	Wed May 27 11:56:46 2009 +0300
@@ -803,6 +803,7 @@
 #define V4L2_CTRL_CLASS_USER 0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
+#define V4L2_CTRL_CLASS_FMTX 0x009b0000	/* FM Radio Modulator class controls */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1141,6 +1142,39 @@
 
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
