Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:18362 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727522AbeI0VFF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 17:05:05 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
CC: <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH 4/4] media: ov5640: reduce rate according to maximum pixel clock frequency
Date: Thu, 27 Sep 2018 16:46:07 +0200
Message-ID: <1538059567-8381-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
References: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reduce parallel port rate according to maximum pixel clock frequency
admissible by camera interface.
This allows to support any resolutions/framerate requests by decreasing
the framerate according to maximum camera interface capabilities.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index da4d754..9f3c32e 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -918,6 +918,8 @@ static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor,
 {
 	u8 prediv, mult, sysdiv, pll_rdiv, bit_div, pclk_div;
 	int ret;
+	struct i2c_client *client = sensor->i2c_client;
+	unsigned int pclk_freq, max_pclk_freq;
 	/*
 	 * FIXME, value of PCLK divider deduced from
 	 * mode registers hardcoded sequence and tests
@@ -941,6 +943,16 @@ static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor,
 	if (ret)
 		return ret;
 
+	pclk_freq = rate / dvp_pclk_divider;
+	max_pclk_freq = sensor->ep.bus.parallel.pclk_max_frequency;
+
+	/* clip rate according to optional maximum pixel clock limit */
+	if (max_pclk_freq && pclk_freq > max_pclk_freq) {
+		rate = max_pclk_freq * dvp_pclk_divider;
+		dev_dbg(&client->dev, "DVP pixel clock too high (%d > %d Hz), reducing rate...\n",
+			pclk_freq, max_pclk_freq);
+	}
+
 	ov5640_calc_pclk(sensor, rate, &prediv, &mult, &sysdiv, &pll_rdiv,
 			 &bit_div, &pclk_div);
 
-- 
2.7.4
