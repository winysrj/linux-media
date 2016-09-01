Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37775 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753229AbcIALLD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 07:11:03 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] lgdt3306a: fix spelling mistake "supportted" -> "supported"
Date: Thu,  1 Sep 2016 12:09:41 +0100
Message-Id: <20160901110941.27824-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in pr_warn message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 179c26e..afb9d73 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -731,7 +731,7 @@ static int lgdt3306a_set_if(struct lgdt3306a_state *state,
 
 	switch (if_freq_khz) {
 	default:
-		pr_warn("IF=%d KHz is not supportted, 3250 assumed\n",
+		pr_warn("IF=%d KHz is not supported, 3250 assumed\n",
 			if_freq_khz);
 		/* fallthrough */
 	case 3250: /* 3.25Mhz */
-- 
2.9.3

