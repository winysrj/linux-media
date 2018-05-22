Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.89]:21800 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751602AbeEVQKi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 12:10:38 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 025DB4011A998
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 11:05:03 -0500 (CDT)
Date: Tue, 22 May 2018 11:04:59 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] media: dvb-bt8xx: remove duplicate code
Message-ID: <20180522160459.GA26733@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The same code is executed regardless of whether c->frequency < 600000000
or c->frequency < 730000000 is true.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/pci/bt8xx/dvb-bt8xx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
index 5ef6e20..6b2a9e6 100644
--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
@@ -386,10 +386,6 @@ static int advbt771_samsung_tdtc9251dh0_tuner_calc_regs(struct dvb_frontend *fe,
 		bs = 0x02;
 	else if (c->frequency < 470000000)
 		bs = 0x02;
-	else if (c->frequency < 600000000)
-		bs = 0x08;
-	else if (c->frequency < 730000000)
-		bs = 0x08;
 	else
 		bs = 0x08;
 
-- 
2.7.4
