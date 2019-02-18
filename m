Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1354C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A081218AD
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550505139;
	bh=MhYP6ECIWjATO3zHsMkPizE5db4AA262uk0xqVs7WEQ=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=jdY2ZG87+uWxgGgfN+rf8v41SoyN5JG8N8exgaoSXJTNzYG0chhWbYzjunhmDrrXV
	 LI6nFxXRZEstJPggpa/UGqAb/6z1079symibUJu0T71+skyJwKwOhzzpkywJRfxJUb
	 +akrDIR6g5nKHOPWspJmziH116DP+Ge/pWdFoDKU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbfBRPwS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:52:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48782 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfBRPwS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 10:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mt6vfVjKKgZRW/nVUPTf6hMa61karPQK7IyupvG5+nY=; b=bcPTuCWt4O/gFzpIeUj4ss3k6
        PDXrR0/PodcmHuWbSoyULihIvL6l0q6R4jl34wWrMz92BI3qZS9RGD3x1a+eKsAOSYNVYDf/jBKpG
        wqbDzdwttlf1INisxbSmrPuMy/aOcGMt59JU8c+o6DDRAvMxyunm+6w/rmuqeVEWQg2KHmKb3UrRP
        RbKpeOr1SKY/FlNtbnxuI1EG1tfCeuxXgBBh6SOi0CreXJz5gluuaGvboHrIRqxxOcutWFCNl27qN
        l076AsIXKhRF0AkkNwvC6t5vX+6Y4VNdSBn6RW/g3WF/1DKishzATgqQn/LlmnzN/djFMXkbYDDq7
        CnB5z+0zg==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvlDN-000762-T6; Mon, 18 Feb 2019 15:52:17 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvlDL-0000vY-QN; Mon, 18 Feb 2019 10:52:15 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kees Cook <keescook@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Anton Leontiev <scileont@gmail.com>
Subject: [PATCH v2] media: vim2m: fix build breakage due to a merge conflict
Date:   Mon, 18 Feb 2019 10:52:14 -0500
Message-Id: <c450df23a26ea90c58791fba2092ef48c6f32d2b.1550505119.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A merge conflict rised when merging from -rc7. Fix it.

In this specific case, we don't need the if anymore, as the
work_run was moved to its rightful place (struct vim2m_ctx).

Fixes: b3e64e5b0778 ("media: vim2m: use per-file handler work queue")
Fixes: 240809ef6630 ("media: vim2m: only cancel work if it is for right context")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 04250adf58e0..a27d3052bb62 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -905,8 +905,7 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
 	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;
 
-	if (v4l2_m2m_get_curr_priv(dev->m2m_dev) == ctx)
-		cancel_delayed_work_sync(&dev->work_run);
+	cancel_delayed_work_sync(&ctx->work_run);
 
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
-- 
2.20.1


