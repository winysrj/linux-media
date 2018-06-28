Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41955 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967336AbeF1QVx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:53 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 05/22] [media] v4l2-rect.h: add position and equal helpers
Date: Thu, 28 Jun 2018 18:20:37 +0200
Message-Id: <20180628162054.25613-6-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two helper functions to check if two rectangles have the same
position (top/left) and if two rectangles equals (same size and
same position).

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 include/media/v4l2-rect.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/media/v4l2-rect.h b/include/media/v4l2-rect.h
index 595c3ba05f23..1ae25f599a6f 100644
--- a/include/media/v4l2-rect.h
+++ b/include/media/v4l2-rect.h
@@ -82,6 +82,33 @@ static inline bool v4l2_rect_same_size(const struct v4l2_rect *r1,
 	return r1->width == r2->width && r1->height == r2->height;
 }
 
+/**
+ * v4l2_rect_same_position() - return true if r1 has the same position as r2
+ * @r1: rectangle.
+ * @r2: rectangle.
+ *
+ * Return true if both rectangles have the same position
+ */
+static inline bool v4l2_rect_same_position(const struct v4l2_rect *r1,
+					   const struct v4l2_rect *r2)
+{
+	return r1->top == r2->top && r1->left == r2->left;
+
+}
+
+/**
+ * v4l2_rect_equal() - return true if r1 equals r2
+ * @r1: rectangle.
+ * @r2: rectangle.
+ *
+ * Return true if both rectangles have the same size and position.
+ */
+static inline bool v4l2_rect_equal(const struct v4l2_rect *r1,
+				   const struct v4l2_rect *r2)
+{
+	return v4l2_rect_same_size(r1, r2) && v4l2_rect_same_position(r1, r2);
+}
+
 /**
  * v4l2_rect_intersect() - calculate the intersection of two rects.
  * @r: intersection of @r1 and @r2.
-- 
2.17.1
