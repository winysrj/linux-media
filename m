Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19795C10F00
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D939C2177E
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550584836;
	bh=HaUQS58Jxv/iT9W1QwA+gDl3D56V3uhGC8sQWkO4ciE=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=FNMUtLFigxXugPRfisi9Ed+1M2pRn2caicl0iucmxrZ0i9FHjRNFMEuTRdkjmXhvc
	 7+oGMmQkUS0393eWkGHsDTis8z0Ip7n5cYIHtj6tmgRqPuND4GiTHQQ4m8vO0Bqe/m
	 GrHY8GDkquDxsULQgOsPnv3SUq1HmZyG1ZJNM0hc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfBSOAf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:00:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44700 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfBSOAf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 09:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vwq2scBDjjb1loUwXCZHMjh0PpFfmoQEs2SA+VHxJGM=; b=avW+kJVVEwvN8QrSDP7cyUPii
        F8jh+Z+5ATLZBGsfhVRI9QbLGyKHz5ubL8PDLBTbZUNWXasNLElI78t7/MS0fYVQ/P0+hoZvS0tRt
        uq8njFsihcVFQbGuDT2V0ghmv9IVz4oGlAxat4pzKq50S9/sgUn0wi/rO2UJTFOKPaEssBehGAAyj
        2gmPIX24i8lyrrkDgTp9BKDHOlTRP5BLdX2cPX09nl86kmKOh/LkPc8yFBcTfs1qddvU9AbU+jfdX
        qdWDrHFHFvT2C550u/oswQWZf9aplzyYN3hBbcIAIDrJnJsY1FwmSl5/gXsTb9uzjTH1mNpGUavBX
        MBKRIaKLg==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gw5wo-0004zI-So; Tue, 19 Feb 2019 14:00:34 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gw5wl-000AbC-Ix; Tue, 19 Feb 2019 09:00:31 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/2] media: ipu3: shut up warnings produced with W=1
Date:   Tue, 19 Feb 2019 09:00:29 -0500
Message-Id: <0bdfc56c13c0ffe003f28395fcde2cd9b5ea0622.1550584828.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There are lots of warnings produced by this driver. It is not
as much as atomisp, but it is still a lot.

So, use the same solution to hide most of them.
Those need to be fixed before promoting it out of staging,
so add it at the TODO list.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/ipu3/Makefile | 6 ++++++
 drivers/staging/media/ipu3/TODO     | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/staging/media/ipu3/Makefile b/drivers/staging/media/ipu3/Makefile
index fb146d178bd4..fa7fa3372bcb 100644
--- a/drivers/staging/media/ipu3/Makefile
+++ b/drivers/staging/media/ipu3/Makefile
@@ -9,3 +9,9 @@ ipu3-imgu-objs += \
 		ipu3-css.o ipu3-v4l2.o ipu3.o
 
 obj-$(CONFIG_VIDEO_IPU3_IMGU) += ipu3-imgu.o
+
+# HACK! While this driver is in bad shape, don't enable several warnings
+#       that would be otherwise enabled with W=1
+ccflags-y += $(call cc-disable-warning, packed-not-aligned)
+ccflags-y += $(call cc-disable-warning, type-limits)
+ccflags-y += $(call cc-disable-warning, unused-const-variable)
diff --git a/drivers/staging/media/ipu3/TODO b/drivers/staging/media/ipu3/TODO
index 8b95e74e43a0..5e55baeaea1a 100644
--- a/drivers/staging/media/ipu3/TODO
+++ b/drivers/staging/media/ipu3/TODO
@@ -27,3 +27,5 @@ staging directory.
 - Document different operation modes, and which buffer queues are relevant
   in each mode. To process an image, which queues require a buffer an in
   which ones is it optional?
+
+- Make sure it builds fine with no warnings with W=1
-- 
2.20.1

