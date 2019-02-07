Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B02C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 17:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 565E9218D3
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549560635;
	bh=XH36F/gOGbR6TjSmfc/9NNphA/noYa7SIJU97E/D8M8=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=d32sa6Mc3G9R+wWt0NT6Nt8SLHvuptwDi3cAlNZUDx0cLbE5m+pL8HedrTf8KQXhl
	 zAbIkmuSEMRU0uZp13yd5mNtI+WpJO+AK6VDLVNuljQ/GYNSCZ9cxMJ9KwhCq+upPM
	 rhnyroMMiSi1Uf76diCQuSxrfZ69AWRpyOLIoy+A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfBGRae (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 12:30:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfBGRae (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 12:30:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I6zxVXI2yPgBYR1/Z7YaMZDL/g/YpQoVfry2/jStnG0=; b=Vx7M1d5VY0z8VWMG2B6nhyG+V
        iJD921w3aNeWb3754KsRmO/X8HV2HABW84fSWF9L1crxWEAGmLnrqiW+q392jfZ2dzvhmPantO+XT
        jzQXsbywulzw+G8PXUkV3jX02sVR0ONxlMosR1vLjaUmLeJvn9l5vNibacx7vKYdPrZzUP0i1km0d
        M+ZtqtwweSsaMdMn1lPBr8Sn+2uQjGUgwV8IeT2PNf4Bdp4WxzRoboTASid7NGzT20lnUaeRGHCLK
        QRgakwMOTRvQpCdH+Plp7Mjqirg6jDgy+v0mKg4NvTQfYMkI3MiZ1Jr0lLDeGv8mLhi4EaslnMo+g
        jaMij6H/w==;
Received: from 177.205.88.104.dynamic.adsl.gvt.net.br ([177.205.88.104] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1grnVP-00045Y-Jv; Thu, 07 Feb 2019 17:30:31 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1grnVL-0004If-MI; Thu, 07 Feb 2019 12:30:27 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Leontiev <scileont@gmail.com>
Subject: [PATCH] media: vim2m: don't use curr_ctx->dev before checking
Date:   Thu,  7 Feb 2019 12:30:26 -0500
Message-Id: <22f05d646df9fdb4f1ff19582f17d350665c2ea9.1549560622.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It seems that it is possible that dev to be null, as there's
a warning printing:
	"Instance released before the end of transaction"

Solves this warning:
	drivers/media/platform/vim2m.c: drivers/media/platform/vim2m.c:525 device_work() warn: variable dereferenced before check 'curr_ctx' (see line 523)

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index bfa1a2a16009..bd125ad34343 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -520,13 +520,14 @@ static void device_work(struct work_struct *w)
 	unsigned long flags;
 
 	curr_ctx = container_of(w, struct vim2m_ctx, work_run.work);
-	vim2m_dev = curr_ctx->dev;
 
 	if (NULL == curr_ctx) {
 		pr_err("Instance released before the end of transaction\n");
 		return;
 	}
 
+	vim2m_dev = curr_ctx->dev;
+
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
 
-- 
2.20.1

