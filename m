Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35592 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755484AbdGYCe5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 22:34:57 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, roliveir@synopsys.com,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        vladimir_zapolskiy@mentor.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH] media: i2c: OV5647: gate clock lane before stream on
Date: Tue, 25 Jul 2017 10:34:01 +0800
Message-Id: <1500950041-5449-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to datasheet, BIT5 in reg-0x4800 are used to
enable/disable clock lane gate.

It's wrong to make clock lane free running before
sensor stream on was called, while the mipi phy
are not initialized.

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 drivers/media/i2c/ov5647.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 95ce90f..d3e6fd0 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -253,6 +253,10 @@ static int ov5647_stream_on(struct v4l2_subdev *sd)
 {
 	int ret;
 
+	ret = ov5647_write(sd, 0x4800, 0x04);
+	if (ret < 0)
+		return ret;
+
 	ret = ov5647_write(sd, 0x4202, 0x00);
 	if (ret < 0)
 		return ret;
@@ -264,6 +268,10 @@ static int ov5647_stream_off(struct v4l2_subdev *sd)
 {
 	int ret;
 
+	ret = ov5647_write(sd, 0x4800, 0x25);
+	if (ret < 0)
+		return ret;
+
 	ret = ov5647_write(sd, 0x4202, 0x0f);
 	if (ret < 0)
 		return ret;
@@ -320,7 +328,7 @@ static int __sensor_init(struct v4l2_subdev *sd)
 			return ret;
 	}
 
-	return ov5647_write(sd, 0x4800, 0x04);
+	return ov5647_stream_off(sd);
 }
 
 static int ov5647_sensor_power(struct v4l2_subdev *sd, int on)
-- 
2.7.4
