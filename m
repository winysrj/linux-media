Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835BFC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 552FC20855
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfARIwM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 03:52:12 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:58340 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbfARIwL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 03:52:11 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id 6FA135FD43; Fri, 18 Jan 2019 16:52:09 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 2/6] media: ov5640: Add register definition for test pattern register
Date:   Fri, 18 Jan 2019 16:52:02 +0800
Message-Id: <20190118085206.2598-3-wens@csie.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118085206.2598-1-wens@csie.org>
References: <20190118085206.2598-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The OV5640 can generate many types of test patterns, some with
additional modifiers, such as a rolling bar, or gamma gradients.

Add the bit definitions for all bits in the test pattern register,
and use them to compose the values to be written to the register.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/media/i2c/ov5640.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 8e4e8fa3685f..22d07b3cc8a2 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2446,10 +2446,30 @@ static const char * const test_pattern_menu[] = {
 	"Color bars",
 };
 
+#define OV5640_TEST_ENABLE		BIT(7)
+#define OV5640_TEST_ROLLING		BIT(6)	/* rolling horizontal bar */
+#define OV5640_TEST_TRANSPARENT		BIT(5)
+#define OV5640_TEST_SQUARE_BW		BIT(4)	/* black & white squares */
+#define OV5640_TEST_BAR_STANDARD	(0 << 2)
+#define OV5640_TEST_BAR_VERT_CHANGE_1	(1 << 2)
+#define OV5640_TEST_BAR_HOR_CHANGE	(2 << 2)
+#define OV5640_TEST_BAR_VERT_CHANGE_2	(3 << 2)
+#define OV5640_TEST_BAR			(0 << 0)
+#define OV5640_TEST_RANDOM		(1 << 0)
+#define OV5640_TEST_SQUARE		(2 << 0)
+#define OV5640_TEST_BLACK		(3 << 0)
+
+static const u8 test_pattern_val[] = {
+	0,
+	OV5640_TEST_ENABLE | OV5640_TEST_TRANSPARENT |
+		OV5640_TEST_BAR_VERT_CHANGE_1 |
+		OV5640_TEST_BAR,
+};
+
 static int ov5640_set_ctrl_test_pattern(struct ov5640_dev *sensor, int value)
 {
-	return ov5640_mod_reg(sensor, OV5640_REG_PRE_ISP_TEST_SET1,
-			      0xa4, value ? 0xa4 : 0);
+	return ov5640_write_reg(sensor, OV5640_REG_PRE_ISP_TEST_SET1,
+				test_pattern_val[value]);
 }
 
 static int ov5640_set_ctrl_light_freq(struct ov5640_dev *sensor, int value)
-- 
2.20.1

