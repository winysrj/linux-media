Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:59527 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751028AbeAVKHT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 05:07:19 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH] media: ov5640: fix spurious streamon failures
Date: Mon, 22 Jan 2018 11:06:41 +0100
Message-ID: <1516615601-16276-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1516615601-16276-1-git-send-email-hugues.fruchet@st.com>
References: <1516615601-16276-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Time to time, stream is failing with a strange positive error.
Error code is returned erroneously by ov5640_set_ctrl_exposure()
due to ov5640_get_vts() return value wrongly treated as error.
Fix this by forcing ret to 0 after ov5640_get_vts() success call,
in order that ret is set to success for rest of code sequence.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index f017742..e2dd352 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2057,6 +2057,7 @@ static int ov5640_set_ctrl_exposure(struct ov5640_dev *sensor, int exp)
 		if (ret < 0)
 			return ret;
 		max_exp += ret;
+		ret = 0;
 
 		if (ctrls->exposure->val < max_exp)
 			ret = ov5640_set_exposure(sensor, ctrls->exposure->val);
-- 
1.9.1
