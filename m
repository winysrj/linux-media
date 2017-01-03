Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:55467 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758248AbdACUdN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 15:33:13 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-media@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] [media] adv7170: drop redundant ret local
Date: Tue,  3 Jan 2017 22:22:43 +0200
Message-Id: <95076630f627a4c4cecf1af4eeac10f2a7ece489.1483474963.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplifies return value logic of adv7170_set_fmt().

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/i2c/adv7170.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7170.c b/drivers/media/i2c/adv7170.c
index fc9ec0f3679c..9b0d6a4973c0 100644
--- a/drivers/media/i2c/adv7170.c
+++ b/drivers/media/i2c/adv7170.c
@@ -302,7 +302,6 @@ static int adv7170_set_fmt(struct v4l2_subdev *sd,
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
 	u8 val = adv7170_read(sd, 0x7);
-	int ret = 0;
 
 	if (format->pad)
 		return -EINVAL;
@@ -323,9 +322,9 @@ static int adv7170_set_fmt(struct v4l2_subdev *sd,
 	}
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		ret = adv7170_write(sd, 0x7, val);
+		return adv7170_write(sd, 0x7, val);
 
-	return ret;
+	return 0;
 }
 
 /* ----------------------------------------------------------------------- */
-- 
2.11.0

