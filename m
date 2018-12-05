Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB64C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1BC32082B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1BC32082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbeLEKUx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:20:53 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48137 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727660AbeLEKUv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:20:51 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id UUIKgznz1aOW5UUIUgJekS; Wed, 05 Dec 2018 11:20:50 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 09/10] vicodec: add tag support
Date:   Wed,  5 Dec 2018 11:20:39 +0100
Message-Id: <20181205102040.11741-10-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfJBvDexiEY0pSrleLccKK8Qkrl0Pyg39te+UIJ3BF3yHLQFAoalqhLZ578R0Rt6I1+82yNstcXP4ZYjlHZsTf52x5+qG22i22cP4pDfk087T4tac5Oh0
 ATsr30EoLA9V7ORo/Z7SCTCKDDyEU4OShU87kHCgP3moPI5TU1+cJUCGDaHAquTIsyQmxiKDwbkp8Ma+maURjh7fxNDgfFgpcJctOxgtaFVEXlo/M3jp+npP
 tCuLORHJtLauYwzTgDRRMCqIxCflrZNhtAIrDrg0XksOpybvgbVXgVWowUGiHZJqDzh/2dXlTzNwV6AqgpvWiQX2Y3RNp0SOXr7af/OQXz0ER+I5jIMugk/X
 pYiImipk39OjtxYwqfbKc2sgmXvb8DcFF6xKfpLqNd06Fb1F+i9ziMZvX77S+XuWQpqk0sOHSCm9xuud5dDKpZ1T8M07Mw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Copy tags in vicodec.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vicodec/vicodec-core.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index b7bdfe97215b..4d39ea033653 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -190,18 +190,8 @@ static int device_process(struct vicodec_ctx *ctx,
 	}
 
 	out_vb->sequence = q_cap->sequence++;
-	out_vb->vb2_buf.timestamp = in_vb->vb2_buf.timestamp;
-
-	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
-		out_vb->timecode = in_vb->timecode;
-	out_vb->field = in_vb->field;
 	out_vb->flags &= ~V4L2_BUF_FLAG_LAST;
-	out_vb->flags |= in_vb->flags &
-		(V4L2_BUF_FLAG_TIMECODE |
-		 V4L2_BUF_FLAG_KEYFRAME |
-		 V4L2_BUF_FLAG_PFRAME |
-		 V4L2_BUF_FLAG_BFRAME |
-		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
+	v4l2_m2m_buf_copy_data(in_vb, out_vb, !ctx->is_enc);
 
 	return 0;
 }
@@ -1083,6 +1073,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = ctx->is_enc ? &ctx->dev->enc_mutex :
 		&ctx->dev->dec_mutex;
+	src_vq->supports_tags = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1098,6 +1089,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = src_vq->lock;
+	dst_vq->supports_tags = true;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.19.1

