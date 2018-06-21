Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:52168 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753906AbeFUHTU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 03:19:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 5/8] media.h: add MEDIA_ENT_F_DTV_ENCODER
Date: Thu, 21 Jun 2018 09:19:11 +0200
Message-Id: <20180621071914.28729-6-hverkuil@xs4all.nl>
In-Reply-To: <20180621071914.28729-1-hverkuil@xs4all.nl>
References: <20180621071914.28729-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new function for digital video encoders such as HDMI transmitters.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/mediactl/media-types.rst | 7 +++++++
 include/uapi/linux/media.h                        | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 96910cf2eaaa..1db40c1f45d2 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -206,6 +206,13 @@ Types and flags used to represent the media graph elements
 	  and output it in some digital video standard, with appropriate
 	  timing signals.
 
+    *  -  ``MEDIA_ENT_F_DTV_ENCODER``
+       -  Digital video encoder. The basic function of the video encoder is
+	  to accept digital video from some digital video standard with
+	  appropriate timing signals (usually a parallel video bus with sync
+	  signals) and output this to a digital video output connector such
+	  as HDMI or DisplayPort.
+
 ..  tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
 .. _media-entity-flag:
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index ebd2cda67833..58be49e1adca 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -90,10 +90,11 @@ struct media_device_info {
 #define MEDIA_ENT_F_LENS			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
 
 /*
- * Video decoder functions
+ * Video decoder/encoder functions
  */
 #define MEDIA_ENT_F_ATV_DECODER			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
 #define MEDIA_ENT_F_DTV_DECODER			(MEDIA_ENT_F_BASE + 0x6001)
+#define MEDIA_ENT_F_DTV_ENCODER			(MEDIA_ENT_F_BASE + 0x6002)
 
 /*
  * Digital TV, analog TV, radio and/or software defined radio tuner functions.
-- 
2.17.0
