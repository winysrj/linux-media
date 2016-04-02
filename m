Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:45205 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbcDBRm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2016 13:42:59 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-renesas-soc@vger.kernel.org, lars@metafoo.de,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 3/3] [media] adv7180: Add g_tvnorms operation
Date: Sat,  2 Apr 2016 19:42:20 +0200
Message-Id: <1459618940-8170-4-git-send-email-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
References: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV7180 supports NTSC, PAL and SECAM.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv7180.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 80ded70..51a92b3 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -741,6 +741,12 @@ static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *cropcap)
 	return 0;
 }
 
+static int adv7180_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
+{
+	*norm = V4L2_STD_ALL;
+	return 0;
+}
+
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.s_std = adv7180_s_std,
 	.g_std = adv7180_g_std,
@@ -749,9 +755,9 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.s_routing = adv7180_s_routing,
 	.g_mbus_config = adv7180_g_mbus_config,
 	.cropcap = adv7180_cropcap,
+	.g_tvnorms = adv7180_g_tvnorms,
 };
 
-
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.s_power = adv7180_s_power,
 };
-- 
2.7.4

