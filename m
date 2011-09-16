Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54543 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab1IPQAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 12:00:04 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRM006A0HS0C7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 17:00:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRM00K78HS0OD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 17:00:00 +0100 (BST)
Date: Fri, 16 Sep 2011 17:59:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3 (resend)] noon010pc30: Remove g_chip_ident operation handler
In-reply-to: <1316188796-8374-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1316188796-8374-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1316188796-8374-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is now not needed as the sensor identification is done
through the media controller API.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/noon010pc30.c |   10 ----------
 include/media/v4l2-chip-ident.h   |    3 ---
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 436b1ee..d38b4d4 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -617,15 +617,6 @@ static int noon010_s_stream(struct v4l2_subdev *sd, int on)
 	return ret;
 }
 
-static int noon010_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip,
-					  V4L2_IDENT_NOON010PC30, 0);
-}
-
 static int noon010_log_status(struct v4l2_subdev *sd)
 {
 	struct noon010_info *info = to_noon010(sd);
@@ -655,7 +646,6 @@ static const struct v4l2_ctrl_ops noon010_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops noon010_core_ops = {
-	.g_chip_ident	= noon010_g_chip_ident,
 	.s_power	= noon010_s_power,
 	.g_ctrl		= v4l2_subdev_g_ctrl,
 	.s_ctrl		= v4l2_subdev_s_ctrl,
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 63fd9d3..810a209 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -212,9 +212,6 @@ enum {
 	/* module sn9c20x: just ident 10000 */
 	V4L2_IDENT_SN9C20X = 10000,
 
-	/* Siliconfile sensors: reserved range 10100 - 10199 */
-	V4L2_IDENT_NOON010PC30	= 10100,
-
 	/* module cx231xx and cx25840 */
 	V4L2_IDENT_CX2310X_AV = 23099, /* Integrated A/V decoder; not in '100 */
 	V4L2_IDENT_CX23100    = 23100,
-- 
1.7.6

