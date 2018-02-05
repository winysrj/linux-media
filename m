Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.171]:24625 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750943AbeBEU1X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 15:27:23 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 0CA064C092C
        for <linux-media@vger.kernel.org>; Mon,  5 Feb 2018 14:27:23 -0600 (CST)
Date: Mon, 5 Feb 2018 14:27:22 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH v2 5/8] pci: cx88-input: use 64-bit arithmetic instead of
 32-bit
Message-ID: <9db3fe5d4564caf97acb5bee69e92727ada4a633.1517856716.git.gustavo@embeddedor.com>
References: <cover.1517856716.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517856716.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add suffix LL to constant 1000000 in order to give the compiler
complete information about the proper arithmetic to use. Notice
that this constant is used in a context that expects an expression
of type ktime_t (64 bits, signed).

The expression ir->polling * 1000000 is currently being evaluated
using 32-bit arithmetic.

Addresses-Coverity-ID: 1392628
Addresses-Coverity-ID: 1392630
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Update subject and changelog to better reflect the proposed code changes.
 - Add suffix LL to constant instead of casting a variable.

 drivers/media/pci/cx88/cx88-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 4e9953e..6f4e692 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -180,7 +180,7 @@ static enum hrtimer_restart cx88_ir_work(struct hrtimer *timer)
 	struct cx88_IR *ir = container_of(timer, struct cx88_IR, timer);
 
 	cx88_ir_handle_key(ir);
-	missed = hrtimer_forward_now(&ir->timer, ir->polling * 1000000);
+	missed = hrtimer_forward_now(&ir->timer, ir->polling * 1000000LL);
 	if (missed > 1)
 		ir_dprintk("Missed ticks %ld\n", missed - 1);
 
@@ -200,7 +200,7 @@ static int __cx88_ir_start(void *priv)
 	if (ir->polling) {
 		hrtimer_init(&ir->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		ir->timer.function = cx88_ir_work;
-		hrtimer_start(&ir->timer, ir->polling * 1000000,
+		hrtimer_start(&ir->timer, ir->polling * 1000000LL,
 			      HRTIMER_MODE_REL);
 	}
 	if (ir->sampling) {
-- 
2.7.4
