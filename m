Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89488C43612
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58BEA20855
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfARIwM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 03:52:12 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:58354 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbfARIwL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 03:52:11 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id 7B1E15FD9F; Fri, 18 Jan 2019 16:52:09 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 4/6] media: ov5640: Add three more test patterns
Date:   Fri, 18 Jan 2019 16:52:04 +0800
Message-Id: <20190118085206.2598-5-wens@csie.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118085206.2598-1-wens@csie.org>
References: <20190118085206.2598-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The OV5640 driver currently supports a static color bar pattern with a
small vertical gamma gradient. The hardware also supports a color square
pattern, as well as having a rolling bar for dynamic sequences.

Add three more test patterns:

  - color bars with a rolling bar (but without the gamma gradient)
  - static color squares
  - color squares with a rolling bar

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/media/i2c/ov5640.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index a1fd69a21df1..13311483792c 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2444,6 +2444,9 @@ static int ov5640_set_ctrl_gain(struct ov5640_dev *sensor, bool auto_gain)
 static const char * const test_pattern_menu[] = {
 	"Disabled",
 	"Color bars",
+	"Color bars w/ rolling bar",
+	"Color squares",
+	"Color squares w/ rolling bar",
 };
 
 #define OV5640_TEST_ENABLE		BIT(7)
@@ -2463,6 +2466,10 @@ static const u8 test_pattern_val[] = {
 	0,
 	OV5640_TEST_ENABLE | OV5640_TEST_BAR_VERT_CHANGE_1 |
 		OV5640_TEST_BAR,
+	OV5640_TEST_ENABLE | OV5640_TEST_ROLLING |
+		OV5640_TEST_BAR_VERT_CHANGE_1 | OV5640_TEST_BAR,
+	OV5640_TEST_ENABLE | OV5640_TEST_SQUARE,
+	OV5640_TEST_ENABLE | OV5640_TEST_ROLLING | OV5640_TEST_SQUARE,
 };
 
 static int ov5640_set_ctrl_test_pattern(struct ov5640_dev *sensor, int value)
-- 
2.20.1

