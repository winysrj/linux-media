Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB183C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 10:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EE692083D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 10:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544180188;
	bh=0FSKcxIZvOvh9YRhnwLm/wECZ73A/1FUDDrn13hMjfc=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=E5NPNKJON5jYP6SmT5BEqCEUCBz6OvwqWMBkuGEuQpaKPoHOUspFTbHC1zSv4EMhW
	 nFIgfr39GcA494xWm1o8ge7FTcC+5lJZjioNRpU+NRKuB1dNK9HV0V4KSzOSED1xwB
	 loV8wxYmTer4oQBaPJyzHKsG4w16Ume+k+Mn0E/o=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EE692083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbeLGK41 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 05:56:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35756 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbeLGK41 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 05:56:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zxQB2Bh8ge6ivzsDVnLsmNmfBriUfTL2fPihZ4ybBzY=; b=pVAL3/h+iBI1WQrPrBlfe3V8U
        3kDufJOCsx14d4X1cyIeGHiFFGpUYlfNNJXaod0Eki/aWxnsTUYuj0s+7fYab/afnb0+bnPVV6IE+
        j+n0Y7qJQIDfmYljVsp9N4cKkFCL40k3hX1IOLXIgzHyAWYWlrEDdq2d99BpaazDehmulr/rmJ6Lm
        1GbQTPTAGHLgWe6hIQ7lEUkXFmcTLOrkc3ZeLU/46t3bzDU7nqctC7Yz/czLnw73xbZntqHgDB+Z8
        K01PtPY2d4HwPD280woIBl0GQFvJpNbifKvs7OtUYu0+jV0YUj9DwefQeWR7YGCu/XKbCrd0DftxL
        ZGeTsXQiw==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVDo2-0001Vb-Eu; Fri, 07 Dec 2018 10:56:26 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gVDnx-0001bQ-0W; Fri, 07 Dec 2018 05:56:21 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] media: cedrus: don't initialize pointers with zero
Date:   Fri,  7 Dec 2018 05:56:12 -0500
Message-Id: <dd25052db89ccf292f2a5e45b7e94e8e6d000c40.1544180158.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A common mistake is to assume that initializing a var with:
	struct foo f = { 0 };

Would initialize a zeroed struct. Actually, what this does is
to initialize the first element of the struct to zero.

According to C99 Standard 6.7.8.21:

    "If there are fewer initializers in a brace-enclosed
     list than there are elements or members of an aggregate,
     or fewer characters in a string literal used to initialize
     an array of known size than there are elements in the array,
     the remainder of the aggregate shall be initialized implicitly
     the same as objects that have static storage duration."

So, in practice, it could zero the entire struct, but, if the
first element is not an integer, it will produce warnings:

	drivers/staging/media/sunxi/cedrus/cedrus.c:drivers/staging/media/sunxi/cedrus/cedrus.c:78:49:  warning: Using plain integer as NULL pointer
	drivers/staging/media/sunxi/cedrus/cedrus_dec.c:drivers/staging/media/sunxi/cedrus/cedrus_dec.c:29:35:  warning: Using plain integer as NULL pointer

A proper way to initialize it with gcc is to use:

	struct foo f = { };

But that seems to be a gcc extension. So, I decided to check upstream
what's the most commonly pattern. The gcc pattern has about 2000 entries:

	$ git grep -E "=\s*\{\s*\}"|wc -l
	1951

The standard-C compliant pattern has about 2500 entries:

	$ git grep -E "=\s*\{\s*NULL\s*\}"|wc -l
	137
	$ git grep -E "=\s*\{\s*0\s*\}"|wc -l
	2323

So, let's initialize those structs with:
	 = { NULL }

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c     | 2 +-
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index b538eb0321d8..44c45c687503 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -75,7 +75,7 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
 	memset(ctx->ctrls, 0, ctrl_size);
 
 	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
-		struct v4l2_ctrl_config cfg = { 0 };
+		struct v4l2_ctrl_config cfg = { NULL };
 
 		cfg.elem_size = cedrus_controls[i].elem_size;
 		cfg.id = cedrus_controls[i].id;
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index e40180a33951..4099a42dba2d 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -26,7 +26,7 @@ void cedrus_device_run(void *priv)
 {
 	struct cedrus_ctx *ctx = priv;
 	struct cedrus_dev *dev = ctx->dev;
-	struct cedrus_run run = { 0 };
+	struct cedrus_run run = { NULL };
 	struct media_request *src_req;
 	unsigned long flags;
 
-- 
2.19.2

