Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:47832 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730899AbeGSM4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 08:56:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tom aan de Wiel <tom.aandewiel@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] media.h: add encoder/decoder functions for codecs
Date: Thu, 19 Jul 2018 14:13:49 +0200
Message-Id: <20180719121353.20021-2-hverkuil@xs4all.nl>
In-Reply-To: <20180719121353.20021-1-hverkuil@xs4all.nl>
References: <20180719121353.20021-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add MEDIA_ENT_F_PROC_VIDEO_EN/DECODER to be used for the encoder
and decoder entities of codec hardware.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/mediactl/media-types.rst | 11 +++++++++++
 include/uapi/linux/media.h                        |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 96910cf2eaaa..8aea7661e243 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -40,6 +40,8 @@ Types and flags used to represent the media graph elements
 .. _MEDIA-ENT-F-VID-MUX:
 .. _MEDIA-ENT-F-VID-IF-BRIDGE:
 .. _MEDIA-ENT-F-DTV-DECODER:
+.. _MEDIA-ENT-F-PROC-VIDEO-ENCODER:
+.. _MEDIA-ENT-F-PROC-VIDEO-DECODER:
 
 .. cssclass:: longtable
 
@@ -188,6 +190,15 @@ Types and flags used to represent the media graph elements
 	  received on its sink pad and outputs the statistics data on
 	  its source pad.
 
+    *  -  ``MEDIA_ENT_F_PROC_VIDEO_ENCODER``
+       -  Video (MPEG, HEVC, VPx, etc.) encoder. An entity capable of
+          compressing video frames must have one sink pad and one source pad.
+
+    *  -  ``MEDIA_ENT_F_PROC_VIDEO_DECODER``
+       -  Video (MPEG, HEVC, VPx, etc.) decoder. An entity capable of
+          decompressing a compressed video stream into uncompressed video
+	  frames must have one sink pad and one source pad.
+
     *  -  ``MEDIA_ENT_F_VID_MUX``
        - Video multiplexer. An entity capable of multiplexing must have at
          least two sink pads and one source pad, and must pass the video
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 86c7dcc9cba3..9004d0c5560c 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -132,6 +132,8 @@ struct media_device_info {
 #define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
 #define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
 #define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
+#define MEDIA_ENT_F_PROC_VIDEO_ENCODER		(MEDIA_ENT_F_BASE + 0x4007)
+#define MEDIA_ENT_F_PROC_VIDEO_DECODER		(MEDIA_ENT_F_BASE + 0x4008)
 
 /*
  * Switch and bridge entity functions
-- 
2.17.0
