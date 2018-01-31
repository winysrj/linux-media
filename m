Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:56624 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751187AbeAaMqq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 07:46:46 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2] media: ov5640: add error trace in case of i2c read failure
Date: Wed, 31 Jan 2018 13:46:17 +0100
Message-ID: <1517402777-18729-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an error trace in ov5640_read_reg() in case of i2c_transfer()
failure.
Uniformize error traces using dev_err instead v4l2_err.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
version 2:
  - Uniformize error traces using dev_err instead v4l2_err
    as per Sakari's review comment.

 drivers/media/i2c/ov5640.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 99a5902..6f18460 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -839,7 +839,7 @@ static int ov5640_write_reg(struct ov5640_dev *sensor, u16 reg, u8 val)
 
 	ret = i2c_transfer(client->adapter, &msg, 1);
 	if (ret < 0) {
-		v4l2_err(&sensor->sd, "%s: error: reg=%x, val=%x\n",
+		dev_err(&client->dev, "%s: error: reg=%x, val=%x\n",
 			__func__, reg, val);
 		return ret;
 	}
@@ -868,8 +868,11 @@ static int ov5640_read_reg(struct ov5640_dev *sensor, u16 reg, u8 *val)
 	msg[1].len = 1;
 
 	ret = i2c_transfer(client->adapter, msg, 2);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: error: reg=%x\n",
+			__func__, reg);
 		return ret;
+	}
 
 	*val = buf[0];
 	return 0;
-- 
1.9.1
