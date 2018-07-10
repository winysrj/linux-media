Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:57023 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751992AbeGJIpP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:45:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv6 07/12] media.h: reorder video en/decoder functions
Date: Tue, 10 Jul 2018 10:45:07 +0200
Message-Id: <20180710084512.99238-8-hverkuil@xs4all.nl>
In-Reply-To: <20180710084512.99238-1-hverkuil@xs4all.nl>
References: <20180710084512.99238-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Keep the function defines in numerical order: 0x6000 comes after
0x2000, so move it back.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/uapi/linux/media.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 6f594fa238c2..76d9bd64c116 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -89,13 +89,6 @@ struct media_device_info {
 #define MEDIA_ENT_F_FLASH			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 2)
 #define MEDIA_ENT_F_LENS			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
 
-/*
- * Video decoder/encoder functions
- */
-#define MEDIA_ENT_F_ATV_DECODER			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
-#define MEDIA_ENT_F_DV_DECODER			(MEDIA_ENT_F_BASE + 0x6001)
-#define MEDIA_ENT_F_DV_ENCODER			(MEDIA_ENT_F_BASE + 0x6002)
-
 /*
  * Digital TV, analog TV, radio and/or software defined radio tuner functions.
  *
@@ -140,6 +133,13 @@ struct media_device_info {
 #define MEDIA_ENT_F_VID_MUX			(MEDIA_ENT_F_BASE + 0x5001)
 #define MEDIA_ENT_F_VID_IF_BRIDGE		(MEDIA_ENT_F_BASE + 0x5002)
 
+/*
+ * Video decoder/encoder functions
+ */
+#define MEDIA_ENT_F_ATV_DECODER			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
+#define MEDIA_ENT_F_DV_DECODER			(MEDIA_ENT_F_BASE + 0x6001)
+#define MEDIA_ENT_F_DV_ENCODER			(MEDIA_ENT_F_BASE + 0x6002)
+
 /* Entity flags */
 #define MEDIA_ENT_FL_DEFAULT			(1 << 0)
 #define MEDIA_ENT_FL_CONNECTOR			(1 << 1)
-- 
2.18.0
