Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbcCWNDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 09:03:09 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] media: i2c: ths7303: remove redundant assignment on bt
Date: Wed, 23 Mar 2016 13:03:03 +0000
Message-Id: <1458738183-7395-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The extraneous assignment on bt is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/ths7303.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 5bbfcab..71a3135 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -285,7 +285,7 @@ static int ths7303_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "stream %s\n", state->stream_on ? "On" : "Off");
 
 	if (state->bt.pixelclock) {
-		struct v4l2_bt_timings *bt = bt = &state->bt;
+		struct v4l2_bt_timings *bt = &state->bt;
 		u32 frame_width, frame_height;
 
 		frame_width = V4L2_DV_BT_FRAME_WIDTH(bt);
-- 
2.7.3

