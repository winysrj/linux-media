Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaIISyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 14:54:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCHv3 3/3] [media] vpif: Fix compilation with allmodconfig
Date: Tue,  9 Sep 2014 15:54:06 -0300
Message-Id: <2175db07ac69dc231466ca89b75c2171358ca210.1410288748.git.m.chehab@samsung.com>
In-Reply-To: <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
References: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
In-Reply-To: <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
References: <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When vpif is compiled as module, those errors happen:

ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_display.ko] undefined!
ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_capture.ko] undefined!

That's because vpif_lock symbol is not exported.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index cd08e5248387..3dad5bd7fe0a 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -38,6 +38,7 @@ MODULE_LICENSE("GPL");
 #define VPIF_CH3_MAX_MODES	2
 
 spinlock_t vpif_lock;
+EXPORT_SYMBOL_GPL(vpif_lock);
 
 void __iomem *vpif_base;
 EXPORT_SYMBOL_GPL(vpif_base);
-- 
1.9.3

