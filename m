Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbcCYKod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:33 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 03/54] v4l: subdev: Call pad init_cfg operation when opening subdevs
Date: Fri, 25 Mar 2016 12:43:37 +0200
Message-Id: <1458902668-1141-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The subdev core code currently rely on the subdev open handler to
initialize the file handle's pad configuration, even though subdevs now
have a pad operation dedicated for that purpose.

As a first step towards migration to init_cfg, call the operation
operation in the subdev core open implementation. Subdevs that haven't
been moved to init_cfg yet will just continue implementing pad config
initialization in their open handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index d4007f8f58d1..1fa6b713ee19 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -83,6 +83,12 @@ static int subdev_open(struct file *file)
 	}
 #endif
 
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
+	ret = v4l2_subdev_call(sd, pad, init_cfg, subdev_fh->pad);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto err;
+#endif
+
 	if (sd->internal_ops && sd->internal_ops->open) {
 		ret = sd->internal_ops->open(sd, subdev_fh);
 		if (ret < 0)
-- 
2.7.3

