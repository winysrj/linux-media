Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46755 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbeJKQsB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 12:48:01 -0400
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
Subject: [PATCH v4 11/12] media: ov5640: Remove duplicate auto-exposure setup
Date: Thu, 11 Oct 2018 11:21:06 +0200
Message-Id: <20181011092107.30715-12-maxime.ripard@bootlin.com>
In-Reply-To: <20181011092107.30715-1-maxime.ripard@bootlin.com>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The autoexposure setup in the 1080p init array is redundant with the
default value of the sensor.

Remove it.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 9ce12c3cf7c7..818411400ef6 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -504,7 +504,7 @@ static const struct reg_value ov5640_setting_1080P_1920_1080[] = {
 	{0x3a0e, 0x03, 0, 0}, {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x04, 0, 0},
 	{0x3a15, 0x60, 0, 0}, {0x4713, 0x02, 0, 0}, {0x4407, 0x04, 0, 0},
 	{0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0}, {0x3824, 0x04, 0, 0},
-	{0x4005, 0x1a, 0, 0}, {0x3008, 0x02, 0, 0}, {0x3503, 0, 0, 0},
+	{0x4005, 0x1a, 0, 0}, {0x3008, 0x02, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_QSXGA_2592_1944[] = {
-- 
2.19.1
