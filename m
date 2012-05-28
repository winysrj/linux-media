Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1031 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab2E1Kqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 06:46:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 4/6] videodev2.h: add frequency band information.
Date: Mon, 28 May 2012 12:46:43 +0200
Message-Id: <005651489cd5c9f832df2d5d90e19e2eee07c9b9.1338201853.git.hans.verkuil@cisco.com>
In-Reply-To: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <e874de9bb774639e0ea58054862853b9703dc2aa.1338201853.git.hans.verkuil@cisco.com>
References: <e874de9bb774639e0ea58054862853b9703dc2aa.1338201853.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 include/linux/videodev2.h |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 2339678..013ee46 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2023,7 +2023,8 @@ struct v4l2_tuner {
 	__u32			audmode;
 	__s32			signal;
 	__s32			afc;
-	__u32			reserved[4];
+	__u32			band;
+	__u32			reserved[3];
 };
 
 struct v4l2_modulator {
@@ -2033,7 +2034,8 @@ struct v4l2_modulator {
 	__u32			rangelow;
 	__u32			rangehigh;
 	__u32			txsubchans;
-	__u32			reserved[4];
+	__u32			band;
+	__u32			reserved[3];
 };
 
 /*  Flags for the 'capability' field */
@@ -2048,6 +2050,11 @@ struct v4l2_modulator {
 #define V4L2_TUNER_CAP_RDS		0x0080
 #define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
 #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
+#define V4L2_TUNER_CAP_BAND_FM_EUROPE_US     0x00010000
+#define V4L2_TUNER_CAP_BAND_FM_JAPAN         0x00020000
+#define V4L2_TUNER_CAP_BAND_FM_RUSSIAN       0x00040000
+#define V4L2_TUNER_CAP_BAND_FM_WEATHER       0x00080000
+#define V4L2_TUNER_CAP_BAND_AM_MW            0x00100000
 
 /*  Flags for the 'rxsubchans' field */
 #define V4L2_TUNER_SUB_MONO		0x0001
@@ -2065,6 +2072,14 @@ struct v4l2_modulator {
 #define V4L2_TUNER_MODE_LANG1		0x0003
 #define V4L2_TUNER_MODE_LANG1_LANG2	0x0004
 
+/*  Values for the 'band' field */
+#define V4L2_TUNER_BAND_DEFAULT       0
+#define V4L2_TUNER_BAND_FM_EUROPE_US  1       /* 87.5 Mhz - 108 MHz */
+#define V4L2_TUNER_BAND_FM_JAPAN      2       /* 76 MHz - 90 MHz */
+#define V4L2_TUNER_BAND_FM_RUSSIAN    3       /* 65.8 MHz - 74 MHz */
+#define V4L2_TUNER_BAND_FM_WEATHER    4       /* 162.4 MHz - 162.55 MHz */
+#define V4L2_TUNER_BAND_AM_MW         5
+
 struct v4l2_frequency {
 	__u32		      tuner;
 	__u32		      type;	/* enum v4l2_tuner_type */
-- 
1.7.10

