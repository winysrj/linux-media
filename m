Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D01C65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B91512086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B91512086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbeLLMjF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:39:05 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:55541 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727290AbeLLMjF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 07:39:05 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X3n3gidc5uDWoX3n6gHoWI; Wed, 12 Dec 2018 13:39:04 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv5 3/8] vicodec: use v4l2_m2m_buf_copy_data
Date:   Wed, 12 Dec 2018 13:38:56 +0100
Message-Id: <20181212123901.34109-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDHd6ERTK7RM32mc/MX3BgW/wGw99H95hHfgKIRdh3CyUZZovlctbVhEYqH7W2vjqq7A32lp9ID7ZyLat76rU2FrjlMNCfqCnh+kJMKTiQeb1PVI7zxb
 zCjex5ZMBOIRzEk5cOr33huvyXZNtxNxQKETKmFhfYyypwSd6iHPPjr24HSEkeFh5ez2HHbifQuMLB8GBWouJ6nS0ID757dnDHN9G4rcsx9vAI8HahNMuXaM
 WAzGSqjB/qWw/P8pS4Re8djKKqKJkeajEqwU09haqaFijTb9/vqz1kg8nZMigom+hV1mEtfgjLZfYHp/HmkimZl1ED9XFbdzNAb14x5Zyf7A8XhtQjFby1CV
 JxmtVLaN5pTNu4NN0yzNGR1UouOM0TgvfA5OD4DcuFFk+A0mIDOXQAH4gnFo/oK/gUKvSUqQdlvP1jTjrN7MaNiara5XVZVTC1T3bjlwBiFHEZG49yc=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Use the new v4l2_m2m_buf_copy_data() function in vicodec.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vicodec/vicodec-core.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 2b7daff63425..bed15580f3ec 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -190,18 +190,8 @@ static int device_process(struct vicodec_ctx *ctx,
 	}
 
 	dst_vb->sequence = q_dst->sequence++;
-	dst_vb->vb2_buf.timestamp = src_vb->vb2_buf.timestamp;
-
-	if (src_vb->flags & V4L2_BUF_FLAG_TIMECODE)
-		dst_vb->timecode = src_vb->timecode;
-	dst_vb->field = src_vb->field;
 	dst_vb->flags &= ~V4L2_BUF_FLAG_LAST;
-	dst_vb->flags |= src_vb->flags &
-		(V4L2_BUF_FLAG_TIMECODE |
-		 V4L2_BUF_FLAG_KEYFRAME |
-		 V4L2_BUF_FLAG_PFRAME |
-		 V4L2_BUF_FLAG_BFRAME |
-		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
+	v4l2_m2m_buf_copy_data(src_vb, dst_vb, !ctx->is_enc);
 
 	return 0;
 }
-- 
2.19.2

