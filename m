Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40EDBC4360F
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2E1D20857
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553551428;
	bh=mzy2AzKbNNRhieMEorCnVP9lUq3eIUwrNHbSHijBR7A=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=XM2Krfu4Fz9tVklGXu696LNs2244N9D1/IOZ1iZObwFh5+ULxORYVzDBJWZrDBigz
	 lgJVR865MiIyvlB2UfKnBHU+EACZTFjgGS4k4GjiomwoOPG5M7RZlO71/HNZVsG4LR
	 2RPUdT2OD0G3kgDY4N0P0yNEdrW4NE6gVoT/CYyA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbfCYWDq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:03:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730599AbfCYWDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 18:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xjmBaASz+r+k0qOF+7TrxhfSvYpuLnSdwYZX2rjbPbY=; b=FGASW+R102EXsHavOWER5MfrO/
        J81T45j4FVuQSmnf90k5ZxjWM7wUvClPKdzEuXhFMG7OeCfct5O8G2A21SgkixaP6vxcVtIxG97Wc
        mWYbXwVgvNJPC0wC8/sUZGKt3pRXllNgPHz2vp+kbGl3DXtXlfas4/2HZjSIisTlLljUlxIzAxBWF
        9TDIAEYVO9BGuRG6KoDq7y5+CaED8XcRk8TIJbC4DTIAp7CDcwWkUDMAVtxWRGrVRVLlObUx2JIxL
        X3y598h8pOMBFw9C0vf58V2AoH/BuvUpfqyhMFuP+q+7Ls2WyIbZvPQ3iPMWNO5gvXDKpsR/+hUT9
        YpWWfF9Q==;
Received: from 177.41.113.24.dynamic.adsl.gvt.net.br ([177.41.113.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8Xh0-0001YG-Cl; Mon, 25 Mar 2019 22:03:42 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1h8Xgw-0001ap-Ip; Mon, 25 Mar 2019 18:03:38 -0400
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH 3/5] media: sti/delta: remove uneeded check
Date:   Mon, 25 Mar 2019 18:03:35 -0400
Message-Id: <1021cd56772b636ebccc3941c44094ef6b0fac4e.1553551369.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553551369.git.mchehab+samsung@kernel.org>
References: <cover.1553551369.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

At the error logic, ipc_buf was already asigned to &ctx->ipc_buf_struct,
with can't be null, as warned by smatch:

	drivers/media/platform/sti/delta/delta-ipc.c:223 delta_ipc_open() warn: variable dereferenced before check 'ctx->ipc_buf' (see line 183)

So, remove the uneeded check.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/sti/delta/delta-ipc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/sti/delta/delta-ipc.c b/drivers/media/platform/sti/delta/delta-ipc.c
index a4603d573c34..186d88f02ecd 100644
--- a/drivers/media/platform/sti/delta/delta-ipc.c
+++ b/drivers/media/platform/sti/delta/delta-ipc.c
@@ -220,10 +220,8 @@ int delta_ipc_open(struct delta_ctx *pctx, const char *name,
 
 err:
 	pctx->sys_errors++;
-	if (ctx->ipc_buf) {
-		hw_free(pctx, ctx->ipc_buf);
-		ctx->ipc_buf = NULL;
-	}
+	hw_free(pctx, ctx->ipc_buf);
+	ctx->ipc_buf = NULL;
 
 	return ret;
 };
-- 
2.20.1

