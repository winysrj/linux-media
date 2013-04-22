Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63008 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3DVOFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:05:23 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00FHQTSY4OG0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:05:22 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 02/12] s5c73m3: Add missing subdev .unregistered callback
Date: Mon, 22 Apr 2013 16:03:37 +0200
Message-id: <1366639427-14253-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed to free any resources requested in
the .registered subdev op.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index ce8fcf2..cb52438 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1457,6 +1457,12 @@ static int s5c73m3_oif_registered(struct v4l2_subdev *sd)
 	return ret;
 }
 
+static void s5c73m3_oif_unregistered(struct v4l2_subdev *sd)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	v4l2_device_unregister_subdev(&state->sensor_sd);
+}
+
 static const struct v4l2_subdev_internal_ops s5c73m3_internal_ops = {
 	.open		= s5c73m3_open,
 };
@@ -1474,6 +1480,7 @@ static const struct v4l2_subdev_ops s5c73m3_subdev_ops = {
 
 static const struct v4l2_subdev_internal_ops oif_internal_ops = {
 	.registered	= s5c73m3_oif_registered,
+	.unregistered	= s5c73m3_oif_unregistered,
 	.open		= s5c73m3_oif_open,
 };
 
-- 
1.7.9.5

