Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60067 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab2GFOfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:35:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 10/10] ov772x: Stop sensor readout right after reset
Date: Fri,  6 Jul 2012 16:35:01 +0200
Message-Id: <1341585301-1003-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor starts streaming video as soon as it gets powered or is
reset. Disable the output in the reset function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 98b1bdf..6e08bae 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -432,9 +432,15 @@ static int ov772x_mask_set(struct i2c_client *client, u8  command, u8  mask,
 
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
 
 /* -----------------------------------------------------------------------------
-- 
1.7.8.6

