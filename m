Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54543 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1IPQAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 12:00:02 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRM006A0HS0C7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 17:00:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRM000FUHRZZ2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 17:00:00 +0100 (BST)
Date: Fri, 16 Sep 2011 17:59:55 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 2/3] noon010pc30: Improve s_power operation handling
In-reply-to: <1316188796-8374-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1316188796-8374-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1316188796-8374-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the now unneeded check for the platform data in s_power
handler and the platform data pointer in struct noon010_info.
Also do not reset the configured output resolution and pixel
format when cycling sensor's power.
Add small delay for proper reset signal shape.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/noon010pc30.c |   40 +++++++++++++++---------------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 115d976..436b1ee 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -132,7 +132,6 @@ struct noon010_info {
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
-	const struct noon010pc30_platform_data *pdata;
 	struct regulator_bulk_data supply[NOON010_NUM_SUPPLIES];
 	u32 gpio_nreset;
 	u32 gpio_nstby;
@@ -282,8 +281,10 @@ static int noon010_power_ctrl(struct v4l2_subdev *sd, bool reset, bool sleep)
 	u8 reg = sleep ? 0xF1 : 0xF0;
 	int ret = 0;
 
-	if (reset)
+	if (reset) {
 		ret = cam_i2c_write(sd, POWER_CTRL_REG, reg | 0x02);
+		udelay(20);
+	}
 	if (!ret) {
 		ret = cam_i2c_write(sd, POWER_CTRL_REG, reg);
 		if (reset && !ret)
@@ -561,45 +562,37 @@ static int noon010_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return ret;
 }
 
+/* Called with struct noon010_info.lock mutex held */
 static int noon010_base_config(struct v4l2_subdev *sd)
 {
-	struct noon010_info *info = to_noon010(sd);
-	int ret;
-
-	ret = noon010_bulk_write_reg(sd, noon010_base_regs);
-	if (!ret) {
-		info->curr_fmt = &noon010_formats[0];
-		info->curr_win = &noon010_sizes[0];
+	int ret = noon010_bulk_write_reg(sd, noon010_base_regs);
+	if (!ret)
 		ret = noon010_set_params(sd);
-	}
 	if (!ret)
 		ret = noon010_set_flip(sd, 1, 0);
 
-	/* sync the handler and the registers state */
-	v4l2_ctrl_handler_setup(&to_noon010(sd)->hdl);
 	return ret;
 }
 
 static int noon010_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct noon010_info *info = to_noon010(sd);
-	const struct noon010pc30_platform_data *pdata = info->pdata;
-	int ret = 0;
-
-	if (WARN(pdata == NULL, "No platform data!\n"))
-		return -ENOMEM;
+	int ret;
 
+	mutex_lock(&info->lock);
 	if (on) {
 		ret = power_enable(info);
-		if (ret)
-			return ret;
-		ret = noon010_base_config(sd);
+		if (!ret)
+			ret = noon010_base_config(sd);
 	} else {
 		noon010_power_ctrl(sd, false, true);
 		ret = power_disable(info);
-		info->curr_win = NULL;
-		info->curr_fmt = NULL;
 	}
+	mutex_unlock(&info->lock);
+
+	/* Restore the controls state */
+	if (!ret && on)
+		ret = v4l2_ctrl_handler_setup(&info->hdl);
 
 	return ret;
 }
@@ -750,10 +743,11 @@ static int noon010_probe(struct i2c_client *client,
 	if (ret)
 		goto np_err;
 
-	info->pdata		= client->dev.platform_data;
 	info->i2c_reg_page	= -1;
 	info->gpio_nreset	= -EINVAL;
 	info->gpio_nstby	= -EINVAL;
+	info->curr_fmt		= &noon010_formats[0];
+	info->curr_win		= &noon010_sizes[0];
 
 	if (gpio_is_valid(pdata->gpio_nreset)) {
 		ret = gpio_request(pdata->gpio_nreset, "NOON010PC30 NRST");
-- 
1.7.6

