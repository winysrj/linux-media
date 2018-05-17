Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43867 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbeEQIyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:54:10 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v3 05/12] media: ov5640: Remove redundant register setup
Date: Thu, 17 May 2018 10:53:58 +0200
Message-Id: <20180517085405.10104-6-maxime.ripard@bootlin.com>
In-Reply-To: <20180517085405.10104-1-maxime.ripard@bootlin.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MIPI divider is also cleared as part of the clock setup sequence, so we
can remove that code.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index ce9bfaafb675..77864a1a5eb0 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1281,16 +1281,6 @@ static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
 	 */
 
 	if (on) {
-		/*
-		 * reset MIPI PCLK/SERCLK divider
-		 *
-		 * SC PLL CONTRL1 0
-		 * - [3..0]:	MIPI PCLK/SERCLK divider
-		 */
-		ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1, 0x0f, 0);
-		if (ret)
-			return ret;
-
 		/*
 		 * configure parallel port control lines polarity
 		 *
-- 
2.17.0
