Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:32980 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751890AbeAaLTz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 06:19:55 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH] media: ov5640: add error trace in case of i2c read failure
Date: Wed, 31 Jan 2018 12:19:24 +0100
Message-ID: <1517397564-12335-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an error trace in ov5640_read_reg() in case of i2c_transfer()
failure.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 99a5902..882a7c3 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -868,8 +868,11 @@ static int ov5640_read_reg(struct ov5640_dev *sensor, u16 reg, u8 *val)
 	msg[1].len = 1;
 
 	ret = i2c_transfer(client->adapter, msg, 2);
-	if (ret < 0)
+	if (ret < 0) {
+		v4l2_err(&sensor->sd, "%s: error: reg=%x\n",
+			 __func__, reg);
 		return ret;
+	}
 
 	*val = buf[0];
 	return 0;
-- 
1.9.1
