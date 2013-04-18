Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936358Ab3DRVf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:57 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 06/24] V4L2: add a common V4L2 subdevice platform data type
Date: Thu, 18 Apr 2013 23:35:27 +0200
Message-Id: <1366320945-21591-7-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This struct shall be used by subdevice drivers to pass per-subdevice data,
e.g. power supplies, to generic V4L2 methods, at the same time allowing
optional host-specific extensions via the host_priv pointer. To avoid
having to pass two pointers to those methods, add a pointer to this new
struct to struct v4l2_subdev.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/v4l2-subdev.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index eb91366..b15c6e0 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -561,6 +561,17 @@ struct v4l2_subdev_internal_ops {
 /* Set this flag if this subdev generates events. */
 #define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
 
+struct regulator_bulk_data;
+
+struct v4l2_subdev_platform_data {
+	/* Optional regulators uset to power on/off the subdevice */
+	struct regulator_bulk_data *regulators;
+	int num_regulators;
+
+	/* Per-subdevice data, specific for a certain video host device */
+	void *host_priv;
+};
+
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.
  */
@@ -589,6 +600,8 @@ struct v4l2_subdev {
 	/* pointer to the physical device */
 	struct device *dev;
 	struct v4l2_async_subdev_list asdl;
+	/* common part of subdevice platform data */
+	struct v4l2_subdev_platform_data *pdata;
 };
 
 static inline struct v4l2_subdev *v4l2_async_to_subdev(
-- 
1.7.2.5

