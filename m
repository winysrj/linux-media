Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D53C43612
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 20:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64CB720660
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 20:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977981;
	bh=g2lipeqmxBLVZO2Od5R3b/UbIc2gUb0QSaP0sqUkxSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Txq0OU3VwOT6CrPco0QZXJ9UUM+bbNsCYX6SMP5KPHir/rFeZnzhJxqWRAqhdPrlO
	 ePzCwX9gr5YinFvhbjP7aqtx3TmanQ16D+m8iSZTxxGMLlPDn06fswelkTGq3qPbdo
	 Xn6jjs02qnYAPY2x6V7hudst15i+M9JXDtrrwpa0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbfAHUGO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 15:06:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729921AbfAHT2K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 14:28:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CE4720645;
        Tue,  8 Jan 2019 19:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975689;
        bh=g2lipeqmxBLVZO2Od5R3b/UbIc2gUb0QSaP0sqUkxSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmelBLiNxGFRnXC+9A58xu/flH1jr1WQKgzN9NaPcMdoRrlYj0yiy86Ewwz1Sp1/R
         LQTBb1Y7ywkndmXs/dhfkyZGUi2NahkUnwoHjmmbHPy51nlAxGkEN9AbIBVMq1f6kj
         jQWk2wVJfr9kexFa+cTvtnwVLLWbGLGBkTipJ2Ds=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.20 056/117] media: cedrus: don't initialize pointers with zero
Date:   Tue,  8 Jan 2019 14:25:24 -0500
Message-Id: <20190108192628.121270-56-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192628.121270-1-sashal@kernel.org>
References: <20190108192628.121270-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

[ Upstream commit e4d7b113fdccde1acf8638c5879f2a450d492303 ]

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
Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c     | 2 +-
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index c912c70b3ef7..f18077e8810a 100644
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
2.19.1

