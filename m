Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbaHZVzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:20 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 28/35] Revert "[media] staging: omap4iss: copy paste error in iss_get_clocks"
Date: Tue, 26 Aug 2014 18:55:04 -0300
Message-Id: <1409090111-8290-29-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch readded a call to iss_put_clocks(), with was removed
by changeset 1153be56a105, causing a compilation breakage.

This reverts commit d4b32646468088323f27a7788ce3b07191015142.
---
 drivers/staging/media/omap4iss/iss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 8a23d164e847..d548371db65a 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1014,7 +1014,6 @@ static int iss_get_clocks(struct iss_device *iss)
 	iss->iss_ctrlclk = devm_clk_get(iss->dev, "iss_ctrlclk");
 	if (IS_ERR(iss->iss_ctrlclk)) {
 		dev_err(iss->dev, "Unable to get iss_ctrlclk clock info\n");
-		iss_put_clocks(iss);
 		return PTR_ERR(iss->iss_ctrlclk);
 	}
 
-- 
1.9.3

