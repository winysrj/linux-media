Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E43C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6694720868
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544181233;
	bh=P47vBDS695IcDuW445Za6S0gSS7lYP4Iu9ovVK3ytCI=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=FAf8ACCld5FuuMl/eavN6vVYrpzrqvWpLnBRZ+tbFhRjWPMQyOfKNBZ6/c86sW4Y/
	 ecK3POHZ9rajhOhWKpFn1AGCb5P8mm+bEWsodAbALiU3WuTzV1doRWlD7MaGbhNwZv
	 BOzsOQZ9pIMP0adqQeic1vm5u/dCypTxBuCA14ew=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6694720868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbeLGLNw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:13:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbeLGLNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 06:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bN5YLJGy9YAmuQQ8atOsp/1gnpm8kDXFQUDcL2uVBX0=; b=Z2IItIAhWKEqjwh7C6ZjT+yGt
        Qznglf2pj6bDfOiD5K0qRtT1UDtjtQ9IMuyY/DGN0+60DiBAFztRcJ/D6ErOw7o8klMd01PZwqJrg
        1ixP7hT5+Mix6EK4QyrrKkA2vaBuVUiM1w1+WS/9QM1xvx1vG3D2pKm6Yu1xoAgH51IR4dtYkZ0fX
        iCkmQbTP1gjGnUBO6SrIYaFyBWszoYuBoqBChmDZtd5Sy4A0h3aytdYXBnKT/rVHupx7pEMcsY3ph
        MpXleeLsjeGchUa9q4Ia4I8rj5Y8y05P520MdzXgat2HBlRn+KfXjEhkgLo2XCYEMAB7kPLUAoZjp
        nI97KLINg==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVE4t-0007iC-Lw; Fri, 07 Dec 2018 11:13:51 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gVE4r-0008UE-HA; Fri, 07 Dec 2018 06:13:49 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] media: cetrus: return an error if alloc fails
Date:   Fri,  7 Dec 2018 06:13:48 -0500
Message-Id: <7d746ddf408ab1bc100d4d676daf3e2400637fbe.1544181226.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As warned by smatch:

	drivers/staging/media/sunxi/cedrus/cedrus.c: drivers/staging/media/sunxi/cedrus/cedrus.c:93 cedrus_init_ctrls() error: potential null dereference 'ctx->ctrls'.  (kzalloc returns null)

While here, remove the memset(), as kzalloc() already zeroes the
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index 44c45c687503..24b89cd2b692 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -72,7 +72,8 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
 	ctrl_size = sizeof(ctrl) * CEDRUS_CONTROLS_COUNT + 1;
 
 	ctx->ctrls = kzalloc(ctrl_size, GFP_KERNEL);
-	memset(ctx->ctrls, 0, ctrl_size);
+	if (!ctx->ctrls)
+		return -ENOMEM;
 
 	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
 		struct v4l2_ctrl_config cfg = { NULL };
-- 
2.19.2

