Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:48997 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752463AbeBANRr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Feb 2018 08:17:47 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH] media: ov5640: fix virtual_channel parameter permissions
Date: Thu, 1 Feb 2018 14:17:34 +0100
Message-ID: <1517491054-12048-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix module_param(virtual_channel) permissions.
This problem was detected by checkpatch:
$ scripts/checkpatch.pl -f drivers/media/i2c/ov5640.c
ERROR: Use 4 digit octal (0777) not decimal permissions
#131: FILE: drivers/media/i2c/ov5640.c:131:
+module_param(virtual_channel, int, 0);

Also explicitly set initial value to 0 for default value
and add an error trace in case of virtual_channel not in
the valid range of values.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 696a28b..906f202 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -127,8 +127,8 @@ struct ov5640_pixfmt {
  * FIXME: remove this when a subdev API becomes available
  * to set the MIPI CSI-2 virtual channel.
  */
-static unsigned int virtual_channel;
-module_param(virtual_channel, int, 0);
+static unsigned int virtual_channel = 0;
+module_param(virtual_channel, int, 0444);
 MODULE_PARM_DESC(virtual_channel,
 		 "MIPI CSI-2 virtual channel (0..3), default 0");
 
@@ -1358,11 +1358,15 @@ static int ov5640_binning_on(struct ov5640_dev *sensor)
 
 static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
 {
+	struct i2c_client *client = sensor->i2c_client;
 	u8 temp, channel = virtual_channel;
 	int ret;
 
-	if (channel > 3)
+	if (channel > 3) {
+		dev_err(&client->dev, "%s: wrong virtual_channel parameter value, expected (0..3), got %d\n",
+			__func__, channel);
 		return -EINVAL;
+	}
 
 	ret = ov5640_read_reg(sensor, OV5640_REG_DEBUG_MODE, &temp);
 	if (ret)
-- 
1.9.1
