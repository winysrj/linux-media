Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21550 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1GAPEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 11:04:37 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNN008PDTVOAX@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNN00C74TVMEF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:35 +0100 (BST)
Date: Fri, 01 Jul 2011 17:04:32 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 4/4] noon010pc30: Remove g_chip_ident operation handler
In-reply-to: <1309532672-17920-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1309532672-17920-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309532672-17920-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It is now not needed as the sensor identification is done
through the media controller API.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/noon010pc30.c |   10 ----------
 include/media/v4l2-chip-ident.h   |    3 ---
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index d05db4b..28cf6ce 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -621,15 +621,6 @@ static int noon010_s_stream(struct v4l2_subdev *sd, int on)
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
@@ -643,7 +634,6 @@ static const struct v4l2_ctrl_ops noon010_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops noon010_core_ops = {
-	.g_chip_ident	= noon010_g_chip_ident,
 	.s_power	= noon010_s_power,
 	.g_ctrl		= v4l2_subdev_g_ctrl,
 	.s_ctrl		= v4l2_subdev_s_ctrl,
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 8717045..e23a351 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -211,9 +211,6 @@ enum {
 	/* module sn9c20x: just ident 10000 */
 	V4L2_IDENT_SN9C20X = 10000,
 
-	/* Siliconfile sensors: reserved range 10100 - 10199 */
-	V4L2_IDENT_NOON010PC30	= 10100,
-
 	/* module cx231xx and cx25840 */
 	V4L2_IDENT_CX2310X_AV = 23099, /* Integrated A/V decoder; not in '100 */
 	V4L2_IDENT_CX23100    = 23100,
-- 
1.7.5.4

