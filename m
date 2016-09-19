Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37924 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750809AbcISGVd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 02:21:33 -0400
From: Colin King <colin.king@canonical.com>
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] st-hva: fix a copy-and-paste variable name error
Date: Mon, 19 Sep 2016 07:19:28 +0100
Message-Id: <20160919061928.6575-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The second check for an error on hva->lmi_err_reg appears
to be a copy-and-paste error, it should be hva->emi_err_reg
instead.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/sti/hva/hva-hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
index d341d49..dcf362c 100644
--- a/drivers/media/platform/sti/hva/hva-hw.c
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -245,7 +245,7 @@ static irqreturn_t hva_hw_err_irq_thread(int irq, void *arg)
 		ctx->hw_err = true;
 	}
 
-	if (hva->lmi_err_reg) {
+	if (hva->emi_err_reg) {
 		dev_err(dev, "%s     external memory interface error: 0x%08x\n",
 			ctx->name, hva->emi_err_reg);
 		ctx->hw_err = true;
-- 
2.9.3

