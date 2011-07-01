Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62510 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1GAPEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 11:04:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNN00ESKTVNRX80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:35 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNN0006UTVM2O@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:34 +0100 (BST)
Date: Fri, 01 Jul 2011 17:04:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 3/4] noon010pc30: Clean up the s_power callback
In-reply-to: <1309532672-17920-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1309532672-17920-4-git-send-email-s.nawrocki@samsung.com>
References: <1309532672-17920-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove unneeded check for the platform data in s_power operation.
Do not reset the image resolution and pixel format set by user
when cycling sensor's power.
Add a small delay for a proper reset signal shape.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/noon010pc30.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 3e24783..d05db4b 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -297,8 +297,10 @@ static int noon010_power_ctrl(struct v4l2_subdev *sd, bool reset, bool sleep)
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
@@ -587,24 +589,20 @@ static int noon010_base_config(struct v4l2_subdev *sd)
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
+		if (!ret)
+			ret = noon010_set_params(sd);
 	} else {
 		noon010_power_ctrl(sd, false, true);
 		ret = power_disable(info);
-		info->curr_win = NULL;
-		info->curr_fmt = NULL;
 	}
-
+	mutex_unlock(&info->lock);
 	return ret;
 }
 
@@ -735,6 +733,8 @@ static int noon010_probe(struct i2c_client *client,
 	info->i2c_reg_page	= -1;
 	info->gpio_nreset	= -EINVAL;
 	info->gpio_nstby	= -EINVAL;
+	info->curr_fmt		= &noon010_formats[0];
+	info->curr_win		= &noon010_sizes[0];
 
 	if (gpio_is_valid(pdata->gpio_nreset)) {
 		ret = gpio_request(pdata->gpio_nreset, "NOON010PC30 NRST");
-- 
1.7.5.4

