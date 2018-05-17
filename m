Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43843 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751379AbeEQIyJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:54:09 -0400
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
Subject: [PATCH v3 04/12] media: ov5640: Remove redundant defines
Date: Thu, 17 May 2018 10:53:57 +0200
Message-Id: <20180517085405.10104-5-maxime.ripard@bootlin.com>
In-Reply-To: <20180517085405.10104-1-maxime.ripard@bootlin.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
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
index 45e5ba32b8d1..ce9bfaafb675 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -93,9 +93,6 @@
 #define OV5640_REG_SDE_CTRL5		0x5585
 #define OV5640_REG_AVG_READOUT		0x56a1
 
-#define OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT	1
-#define OV5640_SCLK_ROOT_DIVIDER_DEFAULT	2
-
 enum ov5640_mode_id {
 	OV5640_MODE_QCIF_176_144 = 0,
 	OV5640_MODE_QVGA_320_240,
@@ -1961,8 +1958,8 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
 		return ret;
 
 	ret = ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER, 0x3f,
-			     (ilog2(OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT) << 2) |
-			     ilog2(OV5640_SCLK_ROOT_DIVIDER_DEFAULT));
+			     (ilog2(OV5640_SCLK2X_ROOT_DIV) << 2) |
+			     ilog2(OV5640_SCLK_ROOT_DIV));
 	if (ret)
 		return ret;
 
-- 
2.17.0
