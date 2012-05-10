Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62432 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab2EJGpj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 02:45:39 -0400
Received: by pbbrp8 with SMTP id rp8so1502829pbb.19
        for <linux-media@vger.kernel.org>; Wed, 09 May 2012 23:45:39 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, k.debski@samsung.com,
	kyungmin.park@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH 2/2] [media] s5p-g2d: Add missing static storage class in g2d.c file
Date: Thu, 10 May 2012 12:05:48 +0530
Message-Id: <1336631748-25160-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1336631748-25160-1-git-send-email-sachin.kamat@linaro.org>
References: <1336631748-25160-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warnings:
drivers/media/video/s5p-g2d/g2d.c:68:18: warning: symbol 'def_frame' was not declared. Should it be static?
drivers/media/video/s5p-g2d/g2d.c:80:16: warning: symbol 'find_fmt' was not declared. Should it be static?
drivers/media/video/s5p-g2d/g2d.c:205:5: warning: symbol 'g2d_setup_ctrls' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-g2d/g2d.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 70bee1c..115b936 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -65,7 +65,7 @@ static struct g2d_fmt formats[] = {
 };
 #define NUM_FORMATS ARRAY_SIZE(formats)
 
-struct g2d_frame def_frame = {
+static struct g2d_frame def_frame = {
 	.width		= DEFAULT_WIDTH,
 	.height		= DEFAULT_HEIGHT,
 	.c_width	= DEFAULT_WIDTH,
@@ -77,7 +77,7 @@ struct g2d_frame def_frame = {
 	.bottom		= DEFAULT_HEIGHT,
 };
 
-struct g2d_fmt *find_fmt(struct v4l2_format *f)
+static struct g2d_fmt *find_fmt(struct v4l2_format *f)
 {
 	unsigned int i;
 	for (i = 0; i < NUM_FORMATS; i++) {
@@ -202,7 +202,7 @@ static const struct v4l2_ctrl_ops g2d_ctrl_ops = {
 	.s_ctrl		= g2d_s_ctrl,
 };
 
-int g2d_setup_ctrls(struct g2d_ctx *ctx)
+static int g2d_setup_ctrls(struct g2d_ctx *ctx)
 {
 	struct g2d_dev *dev = ctx->dev;
 
-- 
1.7.4.1

