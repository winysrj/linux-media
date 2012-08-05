Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41101 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2HEUkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2012 16:40:10 -0400
Received: by pbbrr13 with SMTP id rr13so1452676pbb.19
        for <linux-media@vger.kernel.org>; Sun, 05 Aug 2012 13:40:10 -0700 (PDT)
From: Devendra Naga <develkernel412222@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] staging: media: cxd2099: remove memcpy of similar structure variables
Date: Mon,  6 Aug 2012 02:25:02 +0545
Message-Id: <1344199202-15744-1-git-send-email-develkernel412222@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

structure variables can be assigned, no memcpy needed,
remove the memcpy and use assignment for the cfg and en variables.

Tested by Compilation Only

Suggested-by: Ezequiel Garcia <elezegarcia@gmail.com>
Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/media/cxd2099/cxd2099.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 4f2235f..0ff1972 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -696,13 +696,13 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 		return NULL;
 
 	mutex_init(&ci->lock);
-	memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
+	ci->cfg = *cfg;
 	ci->i2c = i2c;
 	ci->lastaddress = 0xff;
 	ci->clk_reg_b = 0x4a;
 	ci->clk_reg_f = 0x1b;
 
-	memcpy(&ci->en, &en_templ, sizeof(en_templ));
+	ci->en = en_templ;
 	ci->en.data = ci;
 	init(ci);
 	printk(KERN_INFO "Attached CXD2099AR at %02x\n", ci->cfg.adr);
-- 
1.7.9.5

