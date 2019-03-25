Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B39C10F03
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41C812087E
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553551423;
	bh=kGF5Sa6taLzVMUWnOZq0uAxRbugI/0lIU+aJt2GYYqk=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=ORcJbgDmqEwGB6cQy0WmJIbGN3mtm6op5THAQ6WcFnW9TsvosG0NdVGSNlfGDcXI2
	 VE+maKjkYDQXA/farVAZjmCC4NLJJ5V1eL0uMmM6p9liy2mETrSDhGqxzVe3LwFX8k
	 UmMPb4Yc9W1PSn7rvmobAU5IJsAbZvuqTQfd5iWE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfCYWDm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:03:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54880 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbfCYWDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 18:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=D37LR49oRn1OGbJ/FtuBRk8QnqmadVtvTMVLlC3goZo=; b=lg6u7bv5HtnwBfL1bP6wuyPNJa
        sPLrPIJXq0MbDg/LGKGGdSlXrBURXrl3V+nNyAIQ/5PwW0/Rmbb87AqlwuBOAaxnnBR/TPukqHhfn
        Uk4j4uTYlwPiBzVS2oDvwZOOMM2IvvqMgcDNK/+sPdmwZTOl8H0MojObHOwzLwc4S+W8G1Ccm/ynB
        59uUKPeu2yj3BExDET03w6lo+MRAWZZ0g3WCSjCETG7JwPWoPDF1cWwTounB/g9FDaZw3Qwj5+UYk
        TmiJZXIqv06JFvtHk2rA4wCjvZT8d9lXgcAZInH+qrqt22Wz6nJsHWi6Nm6p27+T6FkfIYNFBhNYZ
        /J5h0jsg==;
Received: from 177.41.113.24.dynamic.adsl.gvt.net.br ([177.41.113.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8Xgz-0001YF-Nb; Mon, 25 Mar 2019 22:03:41 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1h8Xgw-0001at-JY; Mon, 25 Mar 2019 18:03:38 -0400
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 4/5] media: rcar-dma: p_set can't be NULL
Date:   Mon, 25 Mar 2019 18:03:36 -0400
Message-Id: <bf78f23acf023d5bc9d31bab2918a3092dc821f0.1553551369.git.mchehab+samsung@kernel.org>
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

The only way for p_set to be NULL would be if vin_coef_set would be an
empty array.

On such case, the driver will OOPS, as it would try to de-reference a
NULL value. So, the check if p_set is not NULL doesn't make any sense.

Solves those two smatch warnings:

	drivers/media/platform/rcar-vin/rcar-dma.c:489 rvin_set_coeff() warn: variable dereferenced before check 'p_set' (see line 484)
	drivers/media/platform/rcar-vin/rcar-dma.c:494 rvin_set_coeff() error: we previously assumed 'p_set' could be null (see line 489)

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 2207a31d355e..91ab064404a1 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -486,7 +486,7 @@ static void rvin_set_coeff(struct rvin_dev *vin, unsigned short xs)
 	}
 
 	/* Use previous value if its XS value is closer */
-	if (p_prev_set && p_set &&
+	if (p_prev_set &&
 	    xs - p_prev_set->xs_value < p_set->xs_value - xs)
 		p_set = p_prev_set;
 
-- 
2.20.1

