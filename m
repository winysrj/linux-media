Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4928DC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20B6D2085A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfCSV6Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:58:24 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:41529 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfCSV6X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:58:23 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 3A4EAFF80C;
        Tue, 19 Mar 2019 21:58:19 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [RFC PATCH 19/20] lib: image-formats: Add more functions
Date:   Tue, 19 Mar 2019 22:57:24 +0100
Message-Id: <f7196882b8aca389d99b4cba109704b4c79e0113.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

V4L2 drivers typically need a few more helpers compared to DRM drivers, so
let's add them.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 include/linux/image-formats.h |  4 +++-
 lib/image-formats.c           | 42 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+)

diff --git a/include/linux/image-formats.h b/include/linux/image-formats.h
index fbc3a4501ebd..f1d4a2a03cc0 100644
--- a/include/linux/image-formats.h
+++ b/include/linux/image-formats.h
@@ -236,9 +236,13 @@ unsigned int image_format_plane_cpp(const struct image_format_info *format,
 unsigned int image_format_plane_width(int width,
 				      const struct image_format_info *format,
 				      int plane);
+unsigned int image_format_plane_stride(const struct image_format_info *format,
+				       int width, int plane);
 unsigned int image_format_plane_height(int height,
 				       const struct image_format_info *format,
 				       int plane);
+unsigned int image_format_plane_size(const struct image_format_info *format,
+				     int width, int height, int plane);
 unsigned int image_format_block_width(const struct image_format_info *format,
 				      int plane);
 unsigned int image_format_block_height(const struct image_format_info *format,
diff --git a/lib/image-formats.c b/lib/image-formats.c
index 39f1d38ae861..c4e213a89edb 100644
--- a/lib/image-formats.c
+++ b/lib/image-formats.c
@@ -740,6 +740,26 @@ unsigned int image_format_plane_width(int width,
 EXPORT_SYMBOL(image_format_plane_width);
 
 /**
+ * image_format_plane_stride - determine the stride value
+ * @format: pointer to the image_format
+ * @width: plane width
+ * @plane: plane index
+ *
+ * Returns:
+ * The bytes per pixel value for the specified plane.
+ */
+unsigned int image_format_plane_stride(const struct image_format_info *format,
+				       unsigned int width, int plane)
+{
+	if (!format || plane >= format->num_planes)
+		return 0;
+
+	return image_format_plane_width(width, format, plane) *
+		image_format_plane_cpp(format, plane);
+}
+EXPORT_SYMBOL(image_format_plane_stride);
+
+/**
  * image_format_plane_height - height of the plane given the first plane
  * @format: pointer to the image_format
  * @height: height of the first plane
@@ -763,6 +783,28 @@ unsigned int image_format_plane_height(int height,
 EXPORT_SYMBOL(image_format_plane_height);
 
 /**
+ * image_format_plane_size - determine the size value
+ * @format: pointer to the image_format
+ * @width: plane width
+ * @height: plane width
+ * @plane: plane index
+ *
+ * Returns:
+ * The size of the plane buffer.
+ */
+unsigned int image_format_plane_size(const struct image_format_info *format,
+				     unsigned int width, unsigned int height,
+				     int plane)
+{
+	if (!format || plane >= format->num_planes)
+		return 0;
+
+	return image_format_plane_stride(format, width, plane) *
+		image_format_plane_height(format, height, plane);
+}
+EXPORT_SYMBOL(image_format_plane_size);
+
+/**
  * image_format_block_width - width in pixels of block.
  * @format: pointer to the image_format
  * @plane: plane index
-- 
git-series 0.9.1
