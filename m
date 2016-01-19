Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59738 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbcASLMy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 06:12:54 -0500
Date: Tue, 19 Jan 2016 12:12:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] V4L: fix ov9650 control clusters
Message-ID: <Pine.LNX.4.64.1601191211300.15265@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Auto-gain and auto-exposure clusters in the ov9650 driver have both a
size of 2, not 3 controls. Fix this.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/ov9650.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 9fe9006..2baa528 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1046,8 +1046,8 @@ static int ov965x_initialize_controls(struct ov965x *ov965x)
 	ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 	v4l2_ctrl_auto_cluster(3, &ctrls->auto_wb, 0, false);
-	v4l2_ctrl_auto_cluster(3, &ctrls->auto_gain, 0, true);
-	v4l2_ctrl_auto_cluster(3, &ctrls->auto_exp, 1, true);
+	v4l2_ctrl_auto_cluster(2, &ctrls->auto_gain, 0, true);
+	v4l2_ctrl_auto_cluster(2, &ctrls->auto_exp, 1, true);
 	v4l2_ctrl_cluster(2, &ctrls->hflip);
 
 	ov965x->sd.ctrl_handler = hdl;
-- 
1.9.3

