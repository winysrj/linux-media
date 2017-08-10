Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33411 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbdHJNjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 09:39:32 -0400
Date: Thu, 10 Aug 2017 19:09:25 +0530
From: Harold Gomez <haroldgmz11@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: Add blank line after variable
 declarations.
Message-ID: <20170810133925.GA3650@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the checkpatch.pl warning

WARNING: Missing a blank line after declarations
+	int i;
+	dev_dbg(&client->dev, "Dump registers for context[%d]:\n",
context)

WARNING: Missing a blank line after declarations
+	int ret;
+	ret = request_firmware(&dev->fw, "ap1302_fw.bin", &client->dev);

WARNING: Missing a blank line after declarations
+	u32 sub_len;
+	for (pos = 0; pos < len; pos += sub_len) {

WARNING: Missing a blank line after declarations
+	struct ap1302_device *dev = to_ap1302_device(sd);
+	return dev->cur_context;

WARNING: Missing a blank line after declarations
+	enum ap1302_contexts context, main_context;
+	if (format->pad)

WARNING: Missing a blank line after declarations
+	long ret = 0;
+	switch (cmd) {

Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index fba4f96..3e229ba 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -275,6 +275,7 @@ static int ap1302_write_context_reg(struct v4l2_subdev *sd,
 {
 	struct ap1302_device *dev = to_ap1302_device(sd);
 	u16 reg_addr = ap1302_calculate_context_reg_addr(context, offset);
+
 	if (reg_addr == 0)
 		return -EINVAL;
 	return ap1302_i2c_write_reg(sd, reg_addr, len,
@@ -287,6 +288,7 @@ static int ap1302_dump_context_reg(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ap1302_device *dev = to_ap1302_device(sd);
 	int i;
+
 	dev_dbg(&client->dev, "Dump registers for context[%d]:\n", context);
 	for (i = 0; i < ARRAY_SIZE(context_info); i++) {
 		struct ap1302_context_info *info = &context_info[i];
@@ -311,6 +313,7 @@ static int ap1302_request_firmware(struct v4l2_subdev *sd)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ap1302_device *dev = to_ap1302_device(sd);
 	int ret;
+
 	ret = request_firmware(&dev->fw, "ap1302_fw.bin", &client->dev);
 	if (ret)
 		dev_err(&client->dev,
@@ -539,6 +542,7 @@ static int ap1302_s_config(struct v4l2_subdev *sd, void *pdata)
 static enum ap1302_contexts ap1302_get_context(struct v4l2_subdev *sd)
 {
 	struct ap1302_device *dev = to_ap1302_device(sd);
+
 	return dev->cur_context;
 }
 
@@ -641,6 +645,7 @@ static int ap1302_set_fmt(struct v4l2_subdev *sd,
 	struct atomisp_input_stream_info *stream_info =
 		(struct atomisp_input_stream_info *)fmt->reserved;
 	enum ap1302_contexts context, main_context;
+
 	if (format->pad)
 		return -EINVAL;
 	if (!fmt)
@@ -1003,6 +1008,7 @@ static int ap1302_s_register(struct v4l2_subdev *sd,
 static long ap1302_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 {
 	long ret = 0;
+
 	switch (cmd) {
 	case VIDIOC_DBG_G_REGISTER:
 		ret = ap1302_g_register(sd, arg);
-- 
2.1.4
