Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90714C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69F1121019
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfCMOye (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:54:34 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:36550 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbfCMOye (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 10:54:34 -0400
Received: from [IPv6:2001:420:44c1:2579:e8a7:494:d652:7065] ([IPv6:2001:420:44c1:2579:e8a7:494:d652:7065])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 45H3hlT354HFn45H6hPrIg; Wed, 13 Mar 2019 15:54:32 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Dafna Hirschfeld <dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vicodec: fix g_selection: either handle crop or compose
Message-ID: <5855b4b0-c627-4df0-39ed-04644e6a10ba@xs4all.nl>
Date:   Wed, 13 Mar 2019 15:54:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGT9LBzziX1nF5mtwTxLPHmg02hpHcYiRX/xlferMEktl11RGRpgBE/hOZzIAwqBuTVjNn3ADTZq21tWqZJW4u7BCZqe/a8iMM37dyWSKaaIdWCSHJHg
 p9K0rWpodFB28kcLpnopAC4fsD1LCkaKV4U35C+DdFB7AReO5mP+P6voA0/V+t0GbUmUq2NfFjdgFQZek0iDvy99pS1jBrQYVT5uaD6kRnAYwCFrO3RlZnYY
 mKV7AxtPJqXJemxTDh0B7VIg4mvik3BrE0UcGVoK76TOzI0gYvXYXICMMw8WREPzCZnzIf0k9WL5qXx86/Hseg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The logic of g_selection was wrong: encoders support crop,
decoders support compose, but the code allowed both.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Note: this patch sits on top of the stateless decoder patch series.
---
 drivers/media/platform/vicodec/vicodec-core.c | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 2f7419b39452..88347ba8614d 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1111,18 +1111,14 @@ static int vidioc_g_selection(struct file *file, void *priv,
 	 * encoder supports only cropping on the OUTPUT buffer
 	 * decoder supports only composing on the CAPTURE buffer
 	 */
-	if ((ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ||
-	    (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
+	if (ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		switch (s->target) {
-		case V4L2_SEL_TGT_COMPOSE:
 		case V4L2_SEL_TGT_CROP:
 			s->r.left = 0;
 			s->r.top = 0;
 			s->r.width = q_data->visible_width;
 			s->r.height = q_data->visible_height;
 			return 0;
-		case V4L2_SEL_TGT_COMPOSE_DEFAULT:
-		case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 		case V4L2_SEL_TGT_CROP_DEFAULT:
 		case V4L2_SEL_TGT_CROP_BOUNDS:
 			s->r.left = 0;
@@ -1131,6 +1127,22 @@ static int vidioc_g_selection(struct file *file, void *priv,
 			s->r.height = q_data->coded_height;
 			return 0;
 		}
+	} else if (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		switch (s->target) {
+		case V4L2_SEL_TGT_COMPOSE:
+			s->r.left = 0;
+			s->r.top = 0;
+			s->r.width = q_data->visible_width;
+			s->r.height = q_data->visible_height;
+			return 0;
+		case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+			s->r.left = 0;
+			s->r.top = 0;
+			s->r.width = q_data->coded_width;
+			s->r.height = q_data->coded_height;
+			return 0;
+		}
 	}
 	return -EINVAL;
 }
-- 
2.20.1

