Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67A8C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C9A921934
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518156;
	bh=G+bVhoHr/tLQD//7iW88kYu2r0PgWIhB7hQG7bbUgX8=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=DfdXHV1da+yp227loZkeb/I2iBXmwhwOHj/ZAvxAE/2NKrKzR8ppi7nEaSIPUnjMg
	 kgsbYzzeE9t8NNnpOS+S4ry0E1+i5vLSyKSUDYgtvgKzrP6Edi2QsZqnCOt46BVttn
	 gcLdh3gXQlSKXTcdz+HN+sdyJKeUMFy0YNxQdexw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbfBRT3O (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34200 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfBRT3N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OY+yTJlwN/32YX+VJM5SBB9uzumUHtIxmSYFiUN7BpU=; b=sYsnO/dHAMhIwtAFHZglEioIC6
        ttJ6IqLJ5apRLh/VkF8TH/3NkT6NAbVk0dVC3oc1iUzxVhL6VC1/syLEl7FTIJvkGaRpSco4P4lUN
        eKnA+Ek2HxGD1TB7YLIrvltx490Cl6Bz/hMdTko3Fb7UyYOMUJmtmTD+r8o0KbFVCBUcrNuKZVcHG
        e/JM0IaqNRMsM12/hdbzJiLDX8Ka8/Gzjzo/eLENfemdBAWN8rAusQJIzlJrpuX4JgU2a1+VhKWqj
        nMW2Ot5lNKtFcvoquNkAMDRUpTpdn7vi7A2TH56XW3CONvBPknxN3EeZuOYZZJxHrAW7cZ+Y5SYq0
        IDl24D6A==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Ui-5r; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006fi-8Z; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/14] media: dvb-core: fix several typos
Date:   Mon, 18 Feb 2019 14:28:57 -0500
Message-Id: <8ca5db2c2f6ca022853b44693647a27ba9b15612.1550518128.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
References: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use codespell to fix lots of typos over frontends.

Manually verified to avoid false-positives.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 drivers/media/dvb-core/dvbdev.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 27a1d4a98d73..fbdb4ecc7c50 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1596,7 +1596,7 @@ static bool is_dvbv3_delsys(u32 delsys)
  *
  * Provides emulation for delivery systems that are compatible with the old
  * DVBv3 call. Among its usages, it provices support for ISDB-T, and allows
- * using a DVB-S2 only frontend just like it were a DVB-S, if the frontent
+ * using a DVB-S2 only frontend just like it were a DVB-S, if the frontend
  * parameters are compatible with DVB-S spec.
  */
 static int emulate_delivery_system(struct dvb_frontend *fe, u32 delsys)
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index b7171bf094fb..4a5834a1c3b7 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -898,7 +898,7 @@ EXPORT_SYMBOL(dvb_unregister_adapter);
 
 /* if the miracle happens and "generic_usercopy()" is included into
    the kernel, then this can vanish. please don't make the mistake and
-   define this as video_usercopy(). this will introduce a dependecy
+   define this as video_usercopy(). this will introduce a dependency
    to the v4l "videodev.o" module, which is unnecessary for some
    cards (ie. the budget dvb-cards don't need the v4l module...) */
 int dvb_usercopy(struct file *file,
-- 
2.20.1

