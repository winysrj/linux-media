Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59150 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2GRN63 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:58:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 9/9] ov772x: Stop sensor readout right after reset
Date: Wed, 18 Jul 2012 15:58:26 +0200
Message-Id: <1342619906-5820-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342619906-5820-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342619906-5820-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor starts streaming video as soon as it gets powered or is
reset. Disable the output in the reset function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index aa2ba9e..e78e0e1 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -537,9 +537,15 @@ static int ov772x_mask_set(struct i2c_client *client, u8  command, u8  mask,
 
 static int ov772x_reset(struct i2c_client *client)
 {
-	int ret = ov772x_write(client, COM7, SCCB_RESET);
+	int ret;
+
+	ret = ov772x_write(client, COM7, SCCB_RESET);
+	if (ret < 0)
+		return ret;
+
 	msleep(1);
-	return ret;
+
+	return ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
 }
 
 /*
-- 
1.7.8.6

