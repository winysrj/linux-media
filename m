Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41393 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbeHAOvz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 10:51:55 -0400
From: Colin King <colin.king@canonical.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][media-next] media: ddbridge/sx8: remove redundant check of iq_mode == 2
Date: Wed,  1 Aug 2018 14:06:10 +0100
Message-Id: <20180801130610.19643-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check for irq_mode == 2 occurs is always false and hence flags
is always zero.  This is because the check occurs in a path where
irq_mode is >= 3. Clean up the code by removing the check and irq_mode
and just pass 0.

Detected by CoverityScan, CID#1472214 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/ddbridge/ddbridge-sx8.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-sx8.c b/drivers/media/pci/ddbridge/ddbridge-sx8.c
index 4418604258d1..c1c69d47f8c9 100644
--- a/drivers/media/pci/ddbridge/ddbridge-sx8.c
+++ b/drivers/media/pci/ddbridge/ddbridge-sx8.c
@@ -398,9 +398,7 @@ static int set_parameters(struct dvb_frontend *fe)
 		}
 		stat = start(fe, 3, mask, ts_config);
 	} else {
-		u32 flags = (iq_mode == 2) ? 1 : 0;
-
-		stat = start_iq(fe, flags, 4, ts_config);
+		stat = start_iq(fe, 0, 4, ts_config);
 	}
 	if (!stat) {
 		state->started = 1;
-- 
2.17.1
