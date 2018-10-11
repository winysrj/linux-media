Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46624 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbeJKQrq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 12:47:46 -0400
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
Subject: [PATCH v4 03/12] media: ov5640: Remove redundant defines
Date: Thu, 11 Oct 2018 11:20:58 +0200
Message-Id: <20181011092107.30715-4-maxime.ripard@bootlin.com>
In-Reply-To: <20181011092107.30715-1-maxime.ripard@bootlin.com>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT and OV5640_SCLK_ROOT_DIVIDER_DEFAULT
defines represent exactly the same setup, and are at the same value, than
the more consistent with the rest of the driver OV5640_SCLK2X_ROOT_DIV and
OV5640_SCLK_ROOT_DIV.

Remove them.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index e8544cd8298f..481406de8c55 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -94,9 +94,6 @@
 #define OV5640_REG_SDE_CTRL5		0x5585
 #define OV5640_REG_AVG_READOUT		0x56a1
 
-#define OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT	1
-#define OV5640_SCLK_ROOT_DIVIDER_DEFAULT	2
-
 enum ov5640_mode_id {
 	OV5640_MODE_QCIF_176_144 = 0,
 	OV5640_MODE_QVGA_320_240,
@@ -2009,8 +2006,8 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
 	sensor->last_mode = &ov5640_mode_init_data;
 
 	ret = ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER, 0x3f,
-			     (ilog2(OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT) << 2) |
-			     ilog2(OV5640_SCLK_ROOT_DIVIDER_DEFAULT));
+			     (ilog2(OV5640_SCLK2X_ROOT_DIV) << 2) |
+			     ilog2(OV5640_SCLK_ROOT_DIV));
 	if (ret)
 		return ret;
 
-- 
2.19.1
