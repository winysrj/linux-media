Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.119]:26423 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751692AbdGESQH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 14:16:07 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id EFFD515ADFB
        for <linux-media@vger.kernel.org>; Wed,  5 Jul 2017 13:16:04 -0500 (CDT)
Date: Wed, 5 Jul 2017 13:16:04 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] sir_ir: remove unnecessary static in sir_interrupt()
Message-ID: <20170705181604.GA11956@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unnecessary static on local variable delt.
Such variable is initialized before being used,
on every execution path throughout the function.
The static has no benefit and, removing it reduces
the code size.

This issue was detected using Coccinelle and the following semantic patch:

@bad exists@
position p;
identifier x;
type T;
@@

static T x@p;
...
x = <+...x...+>

@@
identifier x;
expression e;
type T;
position p != bad.p;
@@

-static
 T x@p;
 ... when != x
     when strict
?x = e;

In the following log you can see the difference in the code size. Also,
there is a significant difference in the bss segment. This log is the
output of the size command, before and after the code change:

before:
   text    data     bss     dec     hex filename
   5009    3456     576    9041    2351 drivers/media/rc/sir_ir.o

after:
   text    data     bss     dec     hex filename
   4988    3400     512    8900    22c4 drivers/media/rc/sir_ir.o

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/rc/sir_ir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index 20234ba..be67f7c 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -155,7 +155,7 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 {
 	unsigned char data;
 	ktime_t curr_time;
-	static unsigned long delt;
+	unsigned long delt;
 	unsigned long deltintr;
 	unsigned long flags;
 	int counter = 0;
-- 
2.5.0
