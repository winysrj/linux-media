Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.171]:18236 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751551AbdITBJW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 21:09:22 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 70C42262BF
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 20:09:21 -0500 (CDT)
Date: Tue, 19 Sep 2017 20:09:18 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] siano: fix a potential integer overflow
Message-ID: <20170920010918.GA30076@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add suffix ULL to constant 65535 in order to avoid a potential
integer overflow. This constant is used in a context that
expects an expression of type u64.

Addresses-Coverity-ID: 1056806
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/common/siano/smsdvb-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index affde14..166428c 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -271,7 +271,7 @@ static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
 	c->post_bit_count.stat[0].uvalue += p->ber_bit_count;
 
 	/* Legacy PER/BER */
-	tmp = p->ets_packets * 65535;
+	tmp = p->ets_packets * 65535ULL;
 	if (p->ts_packets + p->ets_packets)
 		do_div(tmp, p->ts_packets + p->ets_packets);
 	client->legacy_per = tmp;
-- 
2.7.4
