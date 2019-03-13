Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7DEC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAAA92147C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfCMOrS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:47:18 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59252 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfCMOrS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 10:47:18 -0400
Received: from [IPv6:2001:420:44c1:2579:e8a7:494:d652:7065] ([IPv6:2001:420:44c1:2579:e8a7:494:d652:7065])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 45A1hlOVW4HFn45A4hPnrT; Wed, 13 Mar 2019 15:47:16 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Dafna Hirschfeld <dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vicodec: reset last_src/dst_buf based on the IS_OUTPUT
Message-ID: <d1af1611-5862-367c-da3e-10121f2745e1@xs4all.nl>
Date:   Wed, 13 Mar 2019 15:47:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCxW8NKS71Jas0Gkr8NL5EZKtSveU0FaPOf6bw95BpgQEH/9iudLjrP6m9hAa9blhfiII3xxs+hWgsXofSDFeaEAHFLNvj103zMgVAui0fBNvYNMWdS4
 1iuYwRZynQIOlUPctLDz2kSlA+on2ig8R+LO/fAqzzVQJv+RMhQYyyQq7NLea3qpqAaxs98jCjlu66WeWADiXQM1b1yyV/PQKnrs3Wr2NT8WOqnMinXvXUAF
 mcF5jsYgXU4T741891AuiJQyYJdXywAsXRvLO0Vy0SmdQupErELf1OIpJFhBX40kXTmI0X+XBm1taQfWDOlkvg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When start_streaming was called both last_src_buf and last_dst_buf
pointers were set to NULL, but this depends on whether the capture
or output queue starts streaming.

When decoding with resolution changes in between the capture queue
has to restart streaming whenever a resolution change occurs. And
that would reset last_src_buf as well, which causes a problem if
the decoder was stopped by the application. Since last_src_buf
is now NULL, the LAST flag is never set for the last capture
buffer.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vicodec/vicodec-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 075927dba614..39433ffdf417 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1337,8 +1337,11 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	chroma_div = info->width_div * info->height_div;
 	q_data->sequence = 0;

-	ctx->last_src_buf = NULL;
-	ctx->last_dst_buf = NULL;
+	if (V4L2_TYPE_IS_OUTPUT(q->type))
+		ctx->last_src_buf = NULL;
+	else
+		ctx->last_dst_buf = NULL;
+
 	state->gop_cnt = 0;

 	if ((V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
-- 
2.20.1

