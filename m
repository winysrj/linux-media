Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51178 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733149AbeKMXBu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 18:01:50 -0500
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
        Jacopo Mondi <jacopo@jmondi.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v5 04/11] media: ov5640: Remove redundant register setup
Date: Tue, 13 Nov 2018 14:03:18 +0100
Message-Id: <20181113130325.28975-5-maxime.ripard@bootlin.com>
In-Reply-To: <20181113130325.28975-1-maxime.ripard@bootlin.com>
References: <20181113130325.28975-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MIPI divider is also cleared as part of the clock setup sequence, so we
can remove that code.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 1b295d07aa15..25613ecf83c5 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1403,16 +1403,6 @@ static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
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
2.19.1
