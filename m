Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751A8C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A5E020851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551446677;
	bh=GZo7bOkgrjHSBjFpk7G8D8q6AZ+lA26iJXEZSlmkARY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rZD6HHOd+U8AUaGFW9jUdtlgEAELuquZ/onmLkt8hBgQFjBcRUYdQyhJ/zXarjYtN
	 viIceaZ8YgRbuEsd1G0Ga4SdGbCb/3SrVoKPcpv/og3w7RYXagWxVQYqM6lGjLVwGu
	 81zwkDdAKboOiVwEj46CK/7Cqvq4m9fENB2wWRrQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbfCANYb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:24:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbfCANYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xh22J4XA+hjblSGFGgRDqvYC0M0Uy/7E1aW07Lwqh1s=; b=cwib5UptaN11AONipJCEFyCasm
        XdwKP/T4V3XVJj97HX6fyT/nUwmd7rHZpgJXd74DQLmJOx/wW/cqF4hgAc5+vDs5FxPYnBPm6khMW
        MJ8xMDd1SYBuVlpXmSTCZJ6MrPE1+G8MAN1mCNp58jHnJjz2dTETimv7R9n6P1rl+wHPecUBDt7sK
        WCDjIRepNG1w8NgTVQSkaiqVP6Jv0rcNKq/DejApQxsBfADmiDHcmUpdx1+3w+IDytECKzU9pVulD
        yaQYe5svCzhnZ5C8ZSqRTSwUuY0n4CyGd7mxKHqYz0xDLdTptTWCJRsk6ETJGlUSHX0CSvNd5uwy8
        52Gu+kpA==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzi9N-0003xy-SX; Fri, 01 Mar 2019 13:24:29 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzi9L-0002ND-Pl; Fri, 01 Mar 2019 10:24:27 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 03/10] media: vim2m: ensure that width is multiple of two
Date:   Fri,  1 Mar 2019 10:24:19 -0300
Message-Id: <6786af5ad640e0e7caace2168e8a24323434f382.1551446121.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551446121.git.mchehab+samsung@kernel.org>
References: <cover.1551446121.git.mchehab+samsung@kernel.org>
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
index 17d40cec2d95..fb736356ee6b 100644
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

