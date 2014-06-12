Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33043 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbaFLRGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 22/26] [media] v4l2-subdev: Export v4l2_subdev_fops
Date: Thu, 12 Jun 2014 19:06:36 +0200
Message-Id: <1402592800-2925-23-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed by the imx-ipuv3-csi driver when compiled as a module.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index aea84ac..c4dc495 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -406,6 +406,7 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
 	.release = subdev_close,
 	.poll = subdev_poll,
 };
+EXPORT_SYMBOL_GPL(v4l2_subdev_fops);
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
-- 
2.0.0.rc2

