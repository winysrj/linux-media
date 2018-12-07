Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE1DC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6092120989
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544187802;
	bh=bL2FmB3c1SPVzxuDdp2TUXg4DubJZd3diOjqmniNtUI=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=zi+1mgYvwOzCuYNa1jpE+vOWHxHrSHXDQLEsmevnjk1pnojVyRWrM8o5WagVWxmx+
	 KULQ+qqtOSaOQriCGh19YwsU3a2J8XGIwO6+uKrvbNYZzVFWKVP9diBp8uKtUplj0B
	 uwE5yV/sjgyS0sZKRNaawBm7qRBfQ+FUgnauqTsM=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6092120989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbeLGNDV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:03:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59836 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbeLGNDV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:03:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=irp9Q0vFaW5yDtwk3V9gSBSYVDjzI6i8ovMgXYUQUbo=; b=UOgGPNbSk06rTYHXc2qEqU5K1
        U9c8kJrra31HxQDWF30d5j+5AFC5lWm72Bik+DWLbYR63UZ1sSdskykhd4rXwnfyzNkbXgopsnIGT
        ms6kiA/bHaREkKr/izMvuyeKnVXCPrPf7xShwtSJ3q08CIm1WXm6BhHNVvVHhTK35pNdApyDbCeqH
        W45C2vtriRs7+I+cQnX/lEEwmjZuELb0I1RYmuuINkueovJV8V9gg4Kz2arDpzNna5QOlvOn9ETF7
        h97aXlz33j6igA1gaHYYk7VLoGLBUbqN/nVMTkhMJH+dnsokcUSwiPpvLGfpQtT1LhFIbl6Q6TNfB
        20ru8uxVQ==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVFmq-0001PA-O6; Fri, 07 Dec 2018 13:03:20 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gVFmn-000120-N2; Fri, 07 Dec 2018 08:03:17 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] media: cedrus: don't initialize pointers with zero
Date:   Fri,  7 Dec 2018 08:03:16 -0500
Message-Id: <9db60f061d1c577f14136f81af641f58bccbead3.1544187795.git.mchehab+samsung@kernel.org>
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

As the right initialization would be, instead:

	struct foo f = { NULL };

Another way to initialize it with gcc is to use:

	struct foo f = {};

That seems to be a gcc extension, but clang also does the right thing,
and that's a clean way for doing it.

Anyway, I decided to check upstream what's the most commonly pattern.
The "= {}" pattern has about 2000 entries:

	$ git grep -E "=\s*\{\s*\}"|wc -l
	1951

The standard-C compliant pattern has about 2500 entries:

	$ git grep -E "=\s*\{\s*NULL\s*\}"|wc -l
	137
	$ git grep -E "=\s*\{\s*0\s*\}"|wc -l
	2323

Meaning that developers have split options on that.

So, let's opt to the simpler form.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c     | 2 +-
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index b538eb0321d8..b7c918fa5fd1 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -75,7 +75,7 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
 	memset(ctx->ctrls, 0, ctrl_size);
 
 	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
-		struct v4l2_ctrl_config cfg = { 0 };
+		struct v4l2_ctrl_config cfg = {};
 
 		cfg.elem_size = cedrus_controls[i].elem_size;
 		cfg.id = cedrus_controls[i].id;
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index e40180a33951..f10c25f5460e 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -26,7 +26,7 @@ void cedrus_device_run(void *priv)
 {
 	struct cedrus_ctx *ctx = priv;
 	struct cedrus_dev *dev = ctx->dev;
-	struct cedrus_run run = { 0 };
+	struct cedrus_run run = {};
 	struct media_request *src_req;
 	unsigned long flags;
 
-- 
2.19.2

