Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.188.18]:22133 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752286AbeBFRKG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 12:10:06 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 8D535400E3B48
        for <linux-media@vger.kernel.org>; Tue,  6 Feb 2018 10:47:10 -0600 (CST)
Date: Tue, 6 Feb 2018 10:47:09 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH v3 2/8] dvb-frontends: ves1820: use 64-bit arithmetic instead
 of 32-bit
Message-ID: <6e8742889d7c7f087e1b698409370bb5da5cd7ff.1517929336.git.gustavo@embeddedor.com>
References: <cover.1517929336.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517929336.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add suffix ULL to constant 10 in order to give the compiler complete
information about the proper arithmetic to use. Notice that this
constant is used in a context that expects an expression of type
u64 (64 bits, unsigned).

The expression fpxin = state->config->xin * 10 is currently being
evaluated using 32-bit arithmetic.

Addresses-Coverity-ID: 200604 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Update subject and changelog to better reflect the proposed code changes.
 - Add suffix ULL to constant instead of casting a variable.

Changes in v3:
 - Mention the specific Coverity report in the commit message.

 drivers/media/dvb-frontends/ves1820.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/ves1820.c b/drivers/media/dvb-frontends/ves1820.c
index 1d89792..1760098 100644
--- a/drivers/media/dvb-frontends/ves1820.c
+++ b/drivers/media/dvb-frontends/ves1820.c
@@ -137,7 +137,7 @@ static int ves1820_set_symbolrate(struct ves1820_state *state, u32 symbolrate)
 		NDEC = 3;
 
 	/* yeuch! */
-	fpxin = state->config->xin * 10;
+	fpxin = state->config->xin * 10ULL;
 	fptmp = fpxin; do_div(fptmp, 123);
 	if (symbolrate < fptmp)
 		SFIL = 1;
-- 
2.7.4
