Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BE3C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 18:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84DEA2184D
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 18:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551204913;
	bh=Ls8YKQ+LLImPEmCez2DttDVWVFYbCbDkxN7WJ0EKzqY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=FbINqgIj+Zy5KCnE0L4cfJsHc8CXfGBThZ61TXeiSfIvRTm9M6pCZIaD5kyXq1Pul
	 RAFFU9KooAOow0jp7qaByEevv6Bix1COPcvaoQ59oE5fT0kF9gYatjHvYZ1lRFhgpO
	 HQtTvBQ5OboMNrae+TX2jmkdUVWRJNb2rQmOyeo0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfBZSPM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 13:15:12 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60136 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbfBZSPM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 13:15:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=J1Ju+p6v4mZgtnczTyLNoCpwl1yO+BAMUjjhpLbqf0c=; b=N0FWxnA9aURQle0vU5h1slpMs
        7SWgcJCWoWuJdrDQUQjCljuXq3Uh1qwG3xLVvqM0HqivLJtfkoTrsmR6h12v6B7HBuA2RUTao+HyO
        vHqFdfDH7bRn8zOzwlqe8xpCmxN8FCRGLua/jYnt1iHHgEE5r85AtCHT5m0hOIzTWxMgE4YNP6lh7
        OQSrXL8hepnEp/FNLP+9Yx8dDg21Sqi1GrRfr5blNOclHegBDp4aGdPNjzbKI9wPreYMyIZn9oAXz
        wKB4ZVgAbkxbfcpY65PcpGJ+L6IDzEUx6xslHc8dBRfUdULRmH7DcAicudz57iY+jLVrbhumTWl9W
        PZtBOB7Xw==;
Received: from 177.41.100.217.dynamic.adsl.gvt.net.br ([177.41.100.217] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gyhG4-0006Kj-7L; Tue, 26 Feb 2019 18:15:12 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gyhG2-0006NW-4f; Tue, 26 Feb 2019 15:15:10 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] media: vim2m: ensure that width is multiple of two
Date:   Tue, 26 Feb 2019 15:15:09 -0300
Message-Id: <39d12d5da9f3d0d15e05f8bb0e9aea337d50b436.1551204906.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The copy logic assumes that the data width is multiple of two,
as this is needed in order to support YUYV.

There's no reason to force it to be 8-pixel aligned, as 2-pixel
alignment is enough.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 3c0fe2224d83..a4f917c65e20 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -50,7 +50,7 @@ MODULE_PARM_DESC(default_transtime, "default transaction time in ms");
 #define MIN_H 32
 #define MAX_W 640
 #define MAX_H 480
-#define DIM_ALIGN_MASK 7 /* 8-byte alignment for line length */
+#define DIM_ALIGN_MASK 1 /* 2-byte alignment */
 
 /* Flags that indicate a format can be used for capture/output */
 #define MEM2MEM_CAPTURE	(1 << 0)
-- 
2.20.1

