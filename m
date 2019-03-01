Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2729BC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD71020850
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551446093;
	bh=GHlyWossnmhNHlfNjStqRCNy7VFXoSTAb/Avgu4iTrY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=PV+ClVrqaTsoPkUXOxNim4y8ajYgpm+HIbCc2Ui9vNwjk3fjpvFqARa9H54ROgPOr
	 ePaqOdtWTVkZoLIk1KBk1Iy2Az064h4zHGQM619jsGdogTipFhnxmqNbjZsMay4ZdG
	 x5lDjbdJ2Wv7gnB+Q+DOrHHCPhUgMP7dpzWqnor8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733206AbfCANOw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:14:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48268 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfCANOw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:14:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HdAOrrKQq4G6AGeh+JxepzrSNVzIO/5cEm4xowGAM6Q=; b=rCHgpVlEEKKXn7/lXUPJ9536q
        l3T8tPgyBt8yqp3uAB9e3h0atLjF43Kl0+RVEw3vP/yV61UG3PTlO/dQ0grgI6Us3ngqHkfZnZ2ZY
        UWfk/H5lkMqYBKXYGghL7o89ZaeWwzUUrQ/9cZBYJ7tBESeWKwN0X299wI8UTcHgwy2nbzcxKy+H3
        zeMNK1/NQ7pShjXzTfpEweHsGRzPPZsaACxhZgrY7ywSpWQ3veODjK/HJbsIIpdfp39Qhpptowqr2
        yNvSkTWKvhI2VusrMhBKbNzfo/U7CkMuCp74bX2LXc8ECNlfZ83M5RyEkp9eMK3BANOBKhmG0gmkT
        khq5CE5yQ==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzi02-0008PU-7Z; Fri, 01 Mar 2019 13:14:50 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzi00-0002DS-4g; Fri, 01 Mar 2019 10:14:48 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] media: vim2m: speedup passthrough copy
Date:   Fri,  1 Mar 2019 10:14:47 -0300
Message-Id: <6f5f188f02ad43bd7b9b4affade082d84e1805ad.1551446082.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When in passthrough mode, copy the entire line at once, in
order to make it faster (if not HFLIP).

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 37 ++++++++++++++++------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 6bcc0c9f9910..e98dc8f99e3e 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -267,25 +267,22 @@ static const char *type_name(enum v4l2_buf_type type)
 #define CLIP(__color) \
 	(u8)(((__color) > 0xff) ? 0xff : (((__color) < 0) ? 0 : (__color)))
 
-static void fast_copy_two_pixels(struct vim2m_q_data *q_data_in,
-				 struct vim2m_q_data *q_data_out,
-				 u8 **src, u8 **dst, bool reverse)
+static void copy_line(struct vim2m_q_data *q_data_out,
+		      u8 *src, u8 *dst, bool reverse)
 {
-	int depth = q_data_out->fmt->depth >> 3;
+	int x, depth = q_data_out->fmt->depth >> 3;
 
 	if (!reverse) {
-		memcpy(*dst, *src, depth << 1);
-		*src += depth << 1;
-		*dst += depth << 1;
+		memcpy(dst, src, q_data_out->width * depth);
+	} else {
+		for (x = 0; x < q_data_out->width >> 1; x++) {
+			memcpy(dst, src, depth);
+			memcpy(dst + depth, src - depth, depth);
+			src -= depth << 1;
+			dst += depth << 1;
+		}
 		return;
 	}
-
-	/* copy RGB formats in reverse order */
-	memcpy(*dst, *src, depth);
-	memcpy(*dst + depth, *src - depth, depth);
-	*src -= depth << 1;
-	*dst += depth << 1;
-	return;
 }
 
 static void copy_two_pixels(struct vim2m_q_data *q_data_in,
@@ -491,7 +488,7 @@ static int device_process(struct vim2m_ctx *ctx,
 	}
 	y_out = 0;
 
-	/* Faster copy logic,  when format and resolution are identical */
+	/* When format and resolution are identical, we can use a faster copy logic */
 	if (q_data_in->fmt->fourcc == q_data_out->fmt->fourcc &&
 	    q_data_in->width == q_data_out->width &&
 	    q_data_in->height == q_data_out->height) {
@@ -500,15 +497,15 @@ static int device_process(struct vim2m_ctx *ctx,
 			if (ctx->mode & MEM2MEM_HFLIP)
 				p += bytesperline - (q_data_in->fmt->depth >> 3);
 
-			for (x = 0; x < width >> 1; x++)
-				fast_copy_two_pixels(q_data_in, q_data_out,
-						     &p, &p_out,
-						     ctx->mode & MEM2MEM_HFLIP);
+			copy_line(q_data_out, p, p_out,
+				  ctx->mode & MEM2MEM_HFLIP);
+
+			p_out += bytesperline;
 		}
 		return 0;
 	}
 
-	/* Slower algorithm with format conversion and scaler */
+	/* Slower algorithm with format conversion, hflip, vflip and scaler */
 
 	/* To speed scaler up, use Bresenham for X dimension */
 	x_int = q_data_in->width / q_data_out->width;
-- 
2.20.1

