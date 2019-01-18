Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3855AC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 081D02087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfARIwo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 03:52:44 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:58328 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbfARIwM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 03:52:12 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id 6BA435F848; Fri, 18 Jan 2019 16:52:09 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 1/6] media: ov5640: Move test_pattern_menu before ov5640_set_ctrl_test_pattern
Date:   Fri, 18 Jan 2019 16:52:01 +0800
Message-Id: <20190118085206.2598-2-wens@csie.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118085206.2598-1-wens@csie.org>
References: <20190118085206.2598-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The OV5640 has many options for generating test patterns. Unfortunately
there is only one V4L2 control for it. Thus the driver would need to
list some or all combinations.

Move the test_pattern_menu list before the ov5640_set_ctrl_test_pattern
function that programs the hardware. This would allow us to add a
matching list of values to program into the hardware, while keeping the
two lists together for ease of maintenance.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/media/i2c/ov5640.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 5a909abd0a2d..8e4e8fa3685f 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2441,6 +2441,11 @@ static int ov5640_set_ctrl_gain(struct ov5640_dev *sensor, bool auto_gain)
 	return ret;
 }
 
+static const char * const test_pattern_menu[] = {
+	"Disabled",
+	"Color bars",
+};
+
 static int ov5640_set_ctrl_test_pattern(struct ov5640_dev *sensor, int value)
 {
 	return ov5640_mod_reg(sensor, OV5640_REG_PRE_ISP_TEST_SET1,
@@ -2585,11 +2590,6 @@ static const struct v4l2_ctrl_ops ov5640_ctrl_ops = {
 	.s_ctrl = ov5640_s_ctrl,
 };
 
-static const char * const test_pattern_menu[] = {
-	"Disabled",
-	"Color bars",
-};
-
 static int ov5640_init_controls(struct ov5640_dev *sensor)
 {
 	const struct v4l2_ctrl_ops *ops = &ov5640_ctrl_ops;
-- 
2.20.1

