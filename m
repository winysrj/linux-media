Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B848C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF8D921738
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548694151;
	bh=HHoBPmFaNONrrQW1lZU51D9gyZpfWuhPZIxPdiBeYDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mToxuzNrP6ZrivEraHcMn9ks68qbIFvTQSyhtF7IASg7uESN99O5SY+SrdqTeebCy
	 +qEZKNZhU88RqZqYphAqsJm+QarDInI3UWByNVxjuULdqbMVIWOwE8IOCgUyrWVez6
	 co13GPX2ZuwhDalANnthBS60HevqwK76VACP7Nck=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbfA1QU6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388917AbfA1QU4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 11:20:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44E512084A;
        Mon, 28 Jan 2019 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548692455;
        bh=HHoBPmFaNONrrQW1lZU51D9gyZpfWuhPZIxPdiBeYDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0sux6VhrTwCv0z7qG3aJT0uv8xECBpF4BZgwLnlBfn4xNpM6TRyagM4gZ28Gg5CC
         037ro6l8jTGIGApNbru6s9U1egWPwsMIAUsL6WB+njNJ8T1oQogeyJZElyDbIPm8Ml
         Td9gtwy+5Uhr1qIz9bJIZ0sD3zdQ5bJkCOzQ97f0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 025/107] media: adv*/tc358743/ths8200: fill in min width/height/pixelclock
Date:   Mon, 28 Jan 2019 11:18:25 -0500
Message-Id: <20190128161947.57405-25-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128161947.57405-1-sashal@kernel.org>
References: <20190128161947.57405-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 2912289a518077ddb8214e05336700148e97e235 ]

The v4l2_dv_timings_cap struct is used to do sanity checks when setting and
enumerating DV timings, ensuring that only valid timings as per the HW
capabilities are allowed.

However, many drivers just filled in 0 for the minimum width, height or
pixelclock frequency. This can cause timings with e.g. 0 as width and height
to be accepted, which will in turn lead to a potential division by zero.

Fill in proper values are minimum boundaries. 640x350 was chosen since it is
the smallest resolution in v4l2-dv-timings.h. Same for 13 MHz as the lowest
pixelclock frequency (it's slightly below the minimum of 13.5 MHz in the
v4l2-dv-timings.h header).

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ad9389b.c  | 2 +-
 drivers/media/i2c/adv7511.c  | 2 +-
 drivers/media/i2c/adv7604.c  | 4 ++--
 drivers/media/i2c/adv7842.c  | 4 ++--
 drivers/media/i2c/tc358743.c | 2 +-
 drivers/media/i2c/ths8200.c  | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 50f354144ee7..2abbbc6392c0 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -590,7 +590,7 @@ static const struct v4l2_dv_timings_cap ad9389b_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 170000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 5ba0f21bcfe4..5f1c8ee8a50e 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -142,7 +142,7 @@ static const struct v4l2_dv_timings_cap adv7511_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, ADV7511_MAX_WIDTH, 0, ADV7511_MAX_HEIGHT,
+	V4L2_INIT_BT_TIMINGS(640, ADV7511_MAX_WIDTH, 350, ADV7511_MAX_HEIGHT,
 		ADV7511_MIN_PIXELCLOCK, ADV7511_MAX_PIXELCLOCK,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 7b1935ab03c8..ce6f93074ae0 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -777,7 +777,7 @@ static const struct v4l2_dv_timings_cap adv7604_timings_cap_analog = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 170000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
@@ -788,7 +788,7 @@ static const struct v4l2_dv_timings_cap adv76xx_timings_cap_digital = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 225000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 225000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 8c2a52e280af..cf3b42c9417e 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -676,7 +676,7 @@ static const struct v4l2_dv_timings_cap adv7842_timings_cap_analog = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 170000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
@@ -687,7 +687,7 @@ static const struct v4l2_dv_timings_cap adv7842_timings_cap_digital = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 225000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 25000000, 225000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 0f572bff64f5..7ebcb9473956 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -66,7 +66,7 @@ static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
 	/* Pixel clock from REF_01 p. 20. Min/max height/width are unknown */
-	V4L2_INIT_BT_TIMINGS(1, 10000, 1, 10000, 0, 165000000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1200, 13000000, 165000000,
 			V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
 			V4L2_DV_BT_CAP_PROGRESSIVE |
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 42340e364cea..e06e2de87f90 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -49,7 +49,7 @@ static const struct v4l2_dv_timings_cap ths8200_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1080, 25000000, 148500000,
+	V4L2_INIT_BT_TIMINGS(640, 1920, 350, 1080, 25000000, 148500000,
 		V4L2_DV_BT_STD_CEA861, V4L2_DV_BT_CAP_PROGRESSIVE)
 };
 
-- 
2.19.1

