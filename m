Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.150.114]:46249 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751787AbeA3Axp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 19:53:45 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 7BFB71E5136
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 18:31:21 -0600 (CST)
Date: Mon, 29 Jan 2018 18:31:20 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 2/8] dvb-frontends: ves1820: fix potential integer overflow
Message-ID: <2bc8d41c5ef755fbbe3f3e06c427928b97ed4731.1517268667.git.gustavo@embeddedor.com>
References: <cover.1517268667.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517268667.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cast state->config->xin to u64 in order to avoid a potential integer
overflow. This variable is being used in a context that expects an
expression of type u64.

Addresses-Coverity-ID: 200604 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/dvb-frontends/ves1820.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/ves1820.c b/drivers/media/dvb-frontends/ves1820.c
index 1d89792..9dbd582 100644
--- a/drivers/media/dvb-frontends/ves1820.c
+++ b/drivers/media/dvb-frontends/ves1820.c
@@ -137,7 +137,7 @@ static int ves1820_set_symbolrate(struct ves1820_state *state, u32 symbolrate)
 		NDEC = 3;
 
 	/* yeuch! */
-	fpxin = state->config->xin * 10;
+	fpxin = (u64)state->config->xin * 10;
 	fptmp = fpxin; do_div(fptmp, 123);
 	if (symbolrate < fptmp)
 		SFIL = 1;
-- 
2.7.4
