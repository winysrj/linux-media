Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51404 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbeLCIoq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:44:46 -0500
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
Subject: [PATCH v6 05/12] media: ov5640: Remove redundant register setup
Date: Mon,  3 Dec 2018 09:44:20 +0100
Message-Id: <39ae4eba35b68ff6834c3dd88017f40e8f6ce008.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MIPI divider is also cleared as part of the clock setup sequence, so we
can remove that code.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Tested-by: Adam Ford <aford173@gmail.com> #imx6dq
---
 drivers/media/i2c/ov5640.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 7c18120aabd1..e36b04912dcc 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1404,16 +1404,6 @@ static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
 
 	if (on) {
 		/*
-		 * reset MIPI PCLK/SERCLK divider
-		 *
-		 * SC PLL CONTRL1 0
-		 * - [3..0]:	MIPI PCLK/SERCLK divider
-		 */
-		ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1, 0x0f, 0);
-		if (ret)
-			return ret;
-
-		/*
 		 * configure parallel port control lines polarity
 		 *
 		 * POLARITY CTRL0
-- 
git-series 0.9.1
