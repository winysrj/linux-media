Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.49.184]:36544 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752189AbeA3A4z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 19:56:55 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id B113554F0
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 18:32:22 -0600 (CST)
Date: Mon, 29 Jan 2018 18:32:21 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 5/8] pci: cx88-input: fix potential integer overflow
Message-ID: <7958c3115b5727c2272ce9cf7454cea8e6f4cc50.1517268668.git.gustavo@embeddedor.com>
References: <cover.1517268667.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517268667.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cast ir->polling to ktime_t in order to avoid a potential integer
overflow. This variable is being used in a context that expects
an expression of type ktime_t (s64).

Addresses-Coverity-ID: 1392628 ("Unintentional integer overflow")
Addresses-Coverity-ID: 1392630 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/pci/cx88/cx88-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 4e9953e..096b350 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -180,7 +180,7 @@ static enum hrtimer_restart cx88_ir_work(struct hrtimer *timer)
 	struct cx88_IR *ir = container_of(timer, struct cx88_IR, timer);
 
 	cx88_ir_handle_key(ir);
-	missed = hrtimer_forward_now(&ir->timer, ir->polling * 1000000);
+	missed = hrtimer_forward_now(&ir->timer, (ktime_t)ir->polling * 1000000);
 	if (missed > 1)
 		ir_dprintk("Missed ticks %ld\n", missed - 1);
 
@@ -200,7 +200,7 @@ static int __cx88_ir_start(void *priv)
 	if (ir->polling) {
 		hrtimer_init(&ir->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		ir->timer.function = cx88_ir_work;
-		hrtimer_start(&ir->timer, ir->polling * 1000000,
+		hrtimer_start(&ir->timer, (ktime_t)ir->polling * 1000000,
 			      HRTIMER_MODE_REL);
 	}
 	if (ir->sampling) {
-- 
2.7.4
