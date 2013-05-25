Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab3EYRk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 13:40:27 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH v2 3/4] media: i2c: ths7303: remove unnecessary function ths7303_setup()
Date: Sat, 25 May 2013 23:09:35 +0530
Message-Id: <1369503576-22271-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

the ths7303_setup() was doing the same thing as ths7303_setval()
except that ths7303_setval() sets it to some particular mode.
This patch removes ths7303_setup() function and calls ths7303_setval()
in the probe setting the device to 480I_576I filter mode in the probe.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
---
 drivers/media/i2c/ths7303.c |   31 ++++---------------------------
 1 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 8cddcd0..af06187 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -349,30 +349,6 @@ static const struct v4l2_subdev_ops ths7303_ops = {
 	.video 	= &ths7303_video_ops,
 };
 
-static int ths7303_setup(struct v4l2_subdev *sd)
-{
-	struct ths7303_state *state = to_state(sd);
-	struct ths7303_platform_data *pdata = &state->pdata;
-	int ret;
-	u8 mask;
-
-	mask = 0xf8;
-
-	ret = ths7303_write(sd, THS7303_CHANNEL_1, pdata->ch_1 & mask);
-	if (ret)
-		return ret;
-
-	ret = ths7303_write(sd, THS7303_CHANNEL_2, pdata->ch_2 & mask);
-	if (ret)
-		return ret;
-
-	ret = ths7303_write(sd, THS7303_CHANNEL_3, pdata->ch_3 & mask);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
 static int ths7303_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -402,9 +378,10 @@ static int ths7303_probe(struct i2c_client *client,
 	/* store the driver data to differntiate the chip */
 	state->driver_data = (int)id->driver_data;
 
-	if (ths7303_setup(sd) < 0) {
-		v4l_err(client, "init failed\n");
-		return -EIO;
+	/* set to default 480I_576I filter mode */
+	if (ths7303_setval(sd, THS7303_FILTER_MODE_480I_576I) < 0) {
+		v4l_err(client, "Setting to 480I_576I filter mode failed!\n");
+		return -EINVAL;
 	}
 
 	return 0;
-- 
1.7.0.4

