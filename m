Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1550 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2GBOPt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 10:15:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/6] videodev2.h: add VIDIOC_ENUM_FREQ_BANDS.
Date: Mon,  2 Jul 2012 16:15:07 +0200
Message-Id: <f8baa47c370e4d79309e126b56127df8a5edd11a.1341237775.git.hans.verkuil@cisco.com>
In-Reply-To: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl>
References: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new ioctl to enumerate the supported frequency bands of a tuner.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/linux/videodev2.h |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index f79d0cc..d54ec6e 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2048,6 +2048,7 @@ struct v4l2_modulator {
 #define V4L2_TUNER_CAP_RDS		0x0080
 #define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
 #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
+#define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
 
 /*  Flags for the 'rxsubchans' field */
 #define V4L2_TUNER_SUB_MONO		0x0001
@@ -2066,19 +2067,30 @@ struct v4l2_modulator {
 #define V4L2_TUNER_MODE_LANG1_LANG2	0x0004
 
 struct v4l2_frequency {
-	__u32		      tuner;
-	__u32		      type;	/* enum v4l2_tuner_type */
-	__u32		      frequency;
-	__u32		      reserved[8];
+	__u32	tuner;
+	__u32	type;	/* enum v4l2_tuner_type */
+	__u32	frequency;
+	__u32	reserved[8];
+};
+
+struct v4l2_frequency_band {
+	__u32	tuner;
+	__u32	type;	/* enum v4l2_tuner_type */
+	__u32	index;
+	__u32	capability;
+	__u32	rangelow;
+	__u32	rangehigh;
+	__u8	name[32];
+	__u32	reserved[6];
 };
 
 struct v4l2_hw_freq_seek {
-	__u32		      tuner;
-	__u32		      type;	/* enum v4l2_tuner_type */
-	__u32		      seek_upward;
-	__u32		      wrap_around;
-	__u32		      spacing;
-	__u32		      reserved[7];
+	__u32	tuner;
+	__u32	type;	/* enum v4l2_tuner_type */
+	__u32	seek_upward;
+	__u32	wrap_around;
+	__u32	spacing;
+	__u32	reserved[7];
 };
 
 /*
@@ -2646,6 +2658,10 @@ struct v4l2_create_buffers {
 #define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 99, struct v4l2_dv_timings)
 #define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 100, struct v4l2_dv_timings_cap)
 
+/* Experimental, this ioctl may change over the next couple of kernel
+   versions. */
+#define VIDIOC_ENUM_FREQ_BANDS	_IOWR('V', 101, struct v4l2_frequency_band)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
-- 
1.7.10

