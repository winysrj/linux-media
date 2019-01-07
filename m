Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB10EC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 18:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 846532085A
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 18:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546884581;
	bh=prwgBEWhAECY3kMnmxbD1xR9RNNXPXWHdbGIoeN3BRQ=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=JKDHPSuHubaHgzFOLsicvAXe2Y86tD4btA65VR0/U+OkGa+B/LpkTooZFDfD7/9Ly
	 /DYUQtsjW1rDEjebuDsOaHPC+fVSeERUi62e5GEVL65WbBcdksev0Za9pR88uA0gdT
	 nx22aA0qCd0FAJTtCYPIlP8P9zJAHyYGJdBOAZn0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfAGSJk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 13:09:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35460 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfAGSJk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 13:09:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=T3mKhVNE9NJsr65JqWXbFvvowAeR6IlqrlN+dD3kJ58=; b=AYckB/BRqLVLGJYEKyLy2b7kH
        Yn4TqxeC+E9wUnpk0KdTaMpqY7KGAM/yQ/YlzSX5rRIkEgSzUZdNJScgfnuSjhQ0ZH9SHQey84dM/
        cY83NfaTZ/GJKxWAGJYVqaqoRO0Fhy5ReLPq3UwGagqOn19zah75Y0/4/jdz97LHXHsF5LQJD/ZoK
        AG+eJEeRuLumyq7iKysg6YjuCevw6FU3qcVUQ5ODidhYA6LBnjOAP0U8QxPgBHjCfD0WwNsP036Yt
        mOniyO00LuU8ig7u2vPAZMx2N7eAwKQ+BWMVYS72HthiK5/HBaqbnUNsirTzWhco8H3T+KuZhEWew
        XA1o/b/Ng==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggZLG-0002Ko-Fh; Mon, 07 Jan 2019 18:09:38 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1ggZLB-00040F-TO; Mon, 07 Jan 2019 13:09:33 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH] ipu3: add missing #include
Date:   Mon,  7 Jan 2019 13:09:32 -0500
Message-Id: <5f5b4fa522e630cfa154c59ae7649b5568913f96.1546884571.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Lots of warning due to non-static functions are generated because
the headers with define them were not included.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/ipu3/ipu3-css-params.c | 1 +
 drivers/staging/media/ipu3/ipu3-dmamap.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/media/ipu3/ipu3-css-params.c b/drivers/staging/media/ipu3/ipu3-css-params.c
index 776206ded83b..053edce54b71 100644
--- a/drivers/staging/media/ipu3/ipu3-css-params.c
+++ b/drivers/staging/media/ipu3/ipu3-css-params.c
@@ -6,6 +6,7 @@
 #include "ipu3-css.h"
 #include "ipu3-css-fw.h"
 #include "ipu3-tables.h"
+#include "ipu3-css-params.h"
 
 #define DIV_ROUND_CLOSEST_DOWN(a, b)	(((a) + ((b) / 2) - 1) / (b))
 #define roundclosest_down(a, b)		(DIV_ROUND_CLOSEST_DOWN(a, b) * (b))
diff --git a/drivers/staging/media/ipu3/ipu3-dmamap.c b/drivers/staging/media/ipu3/ipu3-dmamap.c
index 93a393d4e15e..5bed01d5b8df 100644
--- a/drivers/staging/media/ipu3/ipu3-dmamap.c
+++ b/drivers/staging/media/ipu3/ipu3-dmamap.c
@@ -12,6 +12,7 @@
 #include "ipu3.h"
 #include "ipu3-css-pool.h"
 #include "ipu3-mmu.h"
+#include "ipu3-dmamap.h"
 
 /*
  * Free a buffer allocated by ipu3_dmamap_alloc_buffer()
-- 
2.20.1

