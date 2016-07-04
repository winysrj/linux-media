Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:56576 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396AbcGDIfc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 10/14] v4l2-flash-led: remove unused ops
Date: Mon,  4 Jul 2016 10:35:06 +0200
Message-Id: <1467621310-8203-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These ops are deprecated and should not be used anymore (and in fact
they are not used at all).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-flash-led-class.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index fc5ff8b..ae7544d 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -609,14 +609,7 @@ static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
 	.close = v4l2_flash_close,
 };
 
-static const struct v4l2_subdev_core_ops v4l2_flash_core_ops = {
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
-};
-
-static const struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
-	.core = &v4l2_flash_core_ops,
-};
+static const struct v4l2_subdev_ops v4l2_flash_subdev_ops;
 
 struct v4l2_flash *v4l2_flash_init(
 	struct device *dev, struct device_node *of_node,
-- 
2.8.1

