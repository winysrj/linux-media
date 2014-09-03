Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44412 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 22/46] [media] ene_ir: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:54 -0300
Message-Id: <4b9c36e8cbdff281bf4f98cc05952190fe43c683.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index d16d9b496b92..e80f2c6c5f1a 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -979,7 +979,7 @@ static int ene_transmit(struct rc_dev *rdev, unsigned *buf, unsigned n)
 	dev->tx_reg = 0;
 	dev->tx_done = 0;
 	dev->tx_sample = 0;
-	dev->tx_sample_pulse = 0;
+	dev->tx_sample_pulse = false;
 
 	dbg("TX: %d samples", dev->tx_len);
 
-- 
1.9.3

