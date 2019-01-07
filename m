Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227F3C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E99BF2173C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfAGLex (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:34:53 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:48635 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbfAGLer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:34:47 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gTB4gFRVhBDyIgTB8gNVGV; Mon, 07 Jan 2019 12:34:46 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv6 3/8] vicodec: use v4l2_m2m_buf_copy_data
Date:   Mon,  7 Jan 2019 12:34:36 +0100
Message-Id: <20190107113441.21569-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
References: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfCjeMOvf+KPq2SN08QQfqMB40uPoMr67uJG9k85tQ3R4NRmBt5/LrAa+muRz7CHkIv4KbpVduYj/tu52c0iILKo7c6VG3tDuZgzuEb0an6OWKxmORBmo
 IsmMnd5Rc8M3Baxu9MRucDOaJQ4OenGr0qeHX10dTFs46ZxjpcyNqGVdNy3Ia2pPTy9BJ9fueZ8ugNWcrSGEjO8iR90ENaMEWSXMboH8OE5W6MMmb8uSQrMf
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
index 0d7876f5acf0..2378582d9790 100644
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

