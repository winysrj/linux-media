Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36346 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752451AbeGDOQx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 10:16:53 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media.h: add encoder/decoder functions for codecs
Message-ID: <98a07de1-1301-9eff-b149-9412714c1401@xs4all.nl>
Date: Wed, 4 Jul 2018 16:16:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add MEDIA_ENT_F_PROC_VIDEO_EN/DECODER to be used for the encoder
and decoder entities of codec hardware.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/mediactl/media-types.rst | 10 ++++++++++
 include/uapi/linux/media.h                        |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 96910cf2eaaa..825920c2f57f 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -188,6 +188,16 @@ Types and flags used to represent the media graph elements
 	  received on its sink pad and outputs the statistics data on
 	  its source pad.

+
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
2.18.0
