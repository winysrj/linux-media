Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36564 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbcL1Vgh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Dec 2016 16:36:37 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb-frontends: fix spelling mistake on cx24123_pll_calcutate
Date: Wed, 28 Dec 2016 21:35:48 +0000
Message-Id: <20161228213548.7130-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake of function name in err message,
should be cx24123_pll_calculate instead of cx24123_pll_calcutate.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/cx24123.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index 8aed8cc..9f78a5a 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -653,7 +653,7 @@ static int cx24123_pll_tune(struct dvb_frontend *fe)
 	dprintk("frequency=%i\n", p->frequency);
 
 	if (cx24123_pll_calculate(fe) != 0) {
-		err("%s: cx24123_pll_calcutate failed\n", __func__);
+		err("%s: cx24123_pll_calculate failed\n", __func__);
 		return -EINVAL;
 	}
 
-- 
2.10.2

