Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57545 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdKUNvL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 08:51:11 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] stb0899: remove redundant self assignment of k_indirect
Date: Tue, 21 Nov 2017 13:51:10 +0000
Message-Id: <20171121135110.16665-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The self assignment of k_indirect is redundant and can be removed.
Detected using coccinelle.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/stb0899_algo.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index 3012f196e9bd..222ee51b90ef 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -925,8 +925,7 @@ static void stb0899_dvbs2_set_btr_loopbw(struct stb0899_state *state)
 		wn = (4 * zeta * zeta) + 1000000;
 		wn = (2 * (loopbw_percent * 1000) * 40 * zeta) /wn;  /*wn =wn 10^-8*/
 
-		k_indirect = (wn * wn) / K;
-		k_indirect = k_indirect;	  /*kindirect = kindirect 10^-6*/
+		k_indirect = (wn * wn) / K;	/*kindirect = kindirect 10^-6*/
 		k_direct   = (2 * wn * zeta) / K;	/*kDirect = kDirect 10^-2*/
 		k_direct  *= 100;
 
-- 
2.14.1
