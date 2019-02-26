Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4D7C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B87C32184D
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551202620;
	bh=aNo5udXWxx4YD6sauaGZPeDRxaaT4zp8rgvR62kUtrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=B9AHjoNON92g1brtqR1H/XCLmnsfGSeFIvrQuGDIXWp7KdbYj8sLHZjdsK/2nCjzL
	 Fv9NdDX426V2bAjcYD1VqAVKxAahV4WIYP/SQ/vNbeJyjimYiIb9TCDiSmxpItMTGS
	 PCJnjmBvinZNZB6dmO5D/RMIj7u1YXzi1igTUPXw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfBZRhA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:37:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60662 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbfBZRhA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:37:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ldC5jaNZeBLuT4TFhUSrB1oh58ptpjmDDrx5uKHOP+c=; b=XPe29h3ybG2lXBXyo7SMEInb2k
        2qY9vnRWFwMmYbbtYbsZyrGSa3LZEAYgh2LEYj9yzrPEnFbO4x5xv60Ua2XdY0k4q3lCwt2VeKBmd
        CDmUWqx/2ZMPZOAcSAretFYq9A8dMYvplQLkxgv7K/nk5JSJ7rkWIxq4ufmqrZ1zK+Y4o8SfwfKyI
        Yx76zKRZ0RczoSPpXNUHOX1qgT2sKQiYzyZVl5ML1QX6dbBFgu59ea1Mhe3SyqOENof0LS3BnRS18
        UrARamIlUjprzeF40b3mo7k1+UYkIkSwvRf/BgASdvT9yLHrbbwikh+56zF3otj3ActKI95SMQXLI
        Rd17hGTA==;
Received: from 177.41.100.217.dynamic.adsl.gvt.net.br ([177.41.100.217] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gygf5-0006Oi-J0; Tue, 26 Feb 2019 17:36:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gygf2-0002Nx-PY; Tue, 26 Feb 2019 14:36:56 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 2/2] media: vim2m: ensure that width is multiple of two
Date:   Tue, 26 Feb 2019 14:36:55 -0300
Message-Id: <0a47c5ad8099c5988e961d44221b4a95d74f8322.1551202610.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <627b2c823606801a9d2cf0bb2ea15ad83942e6dd.1551202610.git.mchehab+samsung@kernel.org>
References: <627b2c823606801a9d2cf0bb2ea15ad83942e6dd.1551202610.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The copy logic assumes that the data width is multiple of two,
as this is needed in order to support YUYV.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index ab288e8377f1..89384f324e25 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -801,7 +801,7 @@ static int vidioc_s_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 	}
 
 	q_data->fmt		= find_format(f);
-	q_data->width		= f->fmt.pix.width;
+	q_data->width		= f->fmt.pix.width & (~1);
 	q_data->height		= f->fmt.pix.height;
 	q_data->sizeimage	= q_data->width * q_data->height
 				* q_data->fmt->depth >> 3;
-- 
2.20.1

