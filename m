Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934024AbbLQIlK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:10 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 30/48] v4l: subdev: Call pad init_cfg operation when opening subdevs
Date: Thu, 17 Dec 2015 10:40:08 +0200
Message-Id: <1450341626-6695-31-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
index 951a9cf7b47e..c9f507afe5ec 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -83,6 +83,8 @@ static int subdev_open(struct file *file)
 	}
 #endif
 
+	v4l2_subdev_call(sd, pad, init_cfg, subdev_fh->pad);
+
 	if (sd->internal_ops && sd->internal_ops->open) {
 		ret = sd->internal_ops->open(sd, subdev_fh);
 		if (ret < 0)
-- 
2.4.10

