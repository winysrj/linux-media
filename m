Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:19406 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752533AbeGDM7l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 08:59:41 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 3/5] media: ov5640: fix wrong binning value in exposure calculation
Date: Wed, 4 Jul 2018 14:58:41 +0200
Message-ID: <1530709123-12445-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
References: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ov5640_set_mode_exposure_calc() is checking binning value but
binning value read is buggy and binning value set is done
after calling ov5640_set_mode_exposure_calc(), fix all of this.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 7c569de..f9b256e 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1357,8 +1357,8 @@ static int ov5640_binning_on(struct ov5640_dev *sensor)
 	ret = ov5640_read_reg(sensor, OV5640_REG_TIMING_TC_REG21, &temp);
 	if (ret)
 		return ret;
-	temp &= 0xfe;
-	return temp ? 1 : 0;
+
+	return temp & BIT(0);
 }
 
 static int ov5640_set_binning(struct ov5640_dev *sensor, bool enable)
-- 
1.9.1
