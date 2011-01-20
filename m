Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57015 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1ATBoW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 20:44:22 -0500
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LFA00C94STVV9@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Jan 2011 01:44:19 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LFA0011ISTVEN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Jan 2011 01:44:19 +0000 (GMT)
Date: Thu, 20 Jan 2011 02:44:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/3] sr030pc30: Remove empty s_stream op
In-reply-to: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungin.park@samsung.com>
Message-id: <1295487842-23410-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

s_stream does nothing in current form so remove it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungin.park@samsung.com>
---
 drivers/media/video/sr030pc30.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
index c901721..e1eced1 100644
--- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -714,11 +714,6 @@ static int sr030pc30_base_config(struct v4l2_subdev *sd)
 	return ret;
 }
 
-static int sr030pc30_s_stream(struct v4l2_subdev *sd, int enable)
-{
-	return 0;
-}
-
 static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -761,7 +756,6 @@ static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops sr030pc30_video_ops = {
-	.s_stream	= sr030pc30_s_stream,
 	.g_mbus_fmt	= sr030pc30_g_fmt,
 	.s_mbus_fmt	= sr030pc30_s_fmt,
 	.try_mbus_fmt	= sr030pc30_try_fmt,
-- 
1.7.0.4

