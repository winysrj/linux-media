Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:25291 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752016AbeBFNYh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 08:24:37 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2] media: ov5640: fix virtual_channel parameter permissions
Date: Tue, 6 Feb 2018 14:24:09 +0100
Message-ID: <1517923449-7596-1-git-send-email-hugues.fruchet@st.com>
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

Also add an error trace in case of virtual_channel not in
the valid range of values.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
version 2:
  - Fix code as per Jacopo Mondi suggestions:
    - int to uint
    - no need to set global to 0
    - shorten error trace
    See https://www.mail-archive.com/linux-media@vger.kernel.org/msg125474.html
 drivers/media/i2c/ov5640.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 696a28b..3e7b43c 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -128,7 +128,7 @@ struct ov5640_pixfmt {
  * to set the MIPI CSI-2 virtual channel.
  */
 static unsigned int virtual_channel;
-module_param(virtual_channel, int, 0);
+module_param(virtual_channel, uint, 0444);
 MODULE_PARM_DESC(virtual_channel,
 		 "MIPI CSI-2 virtual channel (0..3), default 0");
 
@@ -1358,11 +1358,16 @@ static int ov5640_binning_on(struct ov5640_dev *sensor)
 
 static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
 {
+	struct i2c_client *client = sensor->i2c_client;
 	u8 temp, channel = virtual_channel;
 	int ret;
 
-	if (channel > 3)
+	if (channel > 3) {
+		dev_err(&client->dev,
+			"%s: wrong virtual_channel parameter, expected (0..3), got %d\n",
+			__func__, channel);
 		return -EINVAL;
+	}
 
 	ret = ov5640_read_reg(sensor, OV5640_REG_DEBUG_MODE, &temp);
 	if (ret)
-- 
1.9.1
