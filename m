Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:52780 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbcEDL2m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 07:28:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 3/3] v4l: subdev: Call pad init_cfg operation when opening subdevs
Date: Wed,  4 May 2016 14:25:33 +0300
Message-Id: <1462361133-23887-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The subdev core code currently rely on the subdev open handler to
initialize the file handle's pad configuration, even though subdevs now
have a pad operation dedicated for that purpose.

As a first step towards migration to init_cfg, call the operation
operation in the subdev core open implementation. Subdevs that are
haven't been moved to init_cfg yet will just continue implementing pad
config initialization in their open handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 224ea60..9cbd011 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -85,6 +85,8 @@ static int subdev_open(struct file *file)
 	}
 #endif
 
+	v4l2_subdev_call(sd, pad, init_cfg, subdev_fh->pad);
+
 	if (sd->internal_ops && sd->internal_ops->open) {
 		ret = sd->internal_ops->open(sd, subdev_fh);
 		if (ret < 0)
-- 
1.9.1

