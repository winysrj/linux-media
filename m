Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47778C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FCDE2087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfARIwN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 03:52:13 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:58344 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbfARIwM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 03:52:12 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id 754FE5FD4A; Fri, 18 Jan 2019 16:52:09 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 3/6] media: ov5640: Disable transparent feature for test pattern
Date:   Fri, 18 Jan 2019 16:52:03 +0800
Message-Id: <20190118085206.2598-4-wens@csie.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118085206.2598-1-wens@csie.org>
References: <20190118085206.2598-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The transparent feature for test patterns blends the test pattern with
an actual captured image. This makes the result non-static, subject to
changes in the sensor's field of view.

Test patterns should be predictable and deterministic, even if they are
dynamic patterns. Disable the transparent feature of the test pattern.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/media/i2c/ov5640.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 22d07b3cc8a2..a1fd69a21df1 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2461,8 +2461,7 @@ static const char * const test_pattern_menu[] = {
 
 static const u8 test_pattern_val[] = {
 	0,
-	OV5640_TEST_ENABLE | OV5640_TEST_TRANSPARENT |
-		OV5640_TEST_BAR_VERT_CHANGE_1 |
+	OV5640_TEST_ENABLE | OV5640_TEST_BAR_VERT_CHANGE_1 |
 		OV5640_TEST_BAR,
 };
 
-- 
2.20.1

