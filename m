Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503912AbeKWWop (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 17:44:45 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ettore Chimenti <ek5.chimenti@gmail.com>
Subject: [PATCH] media: seco-cec: declare ops as static const
Date: Fri, 23 Nov 2018 07:00:43 -0500
Message-Id: <a2717eae73ac4f1548fa5195adb9fafbacdfc1ad.1542974442.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:

	drivers/media/platform/seco-cec/seco-cec.c:338:21:  warning: symbol 'secocec_cec_adap_ops' was not declared. Should it be static?

This struct should be static. Also, it is const, so declare it
as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/seco-cec/seco-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/seco-cec/seco-cec.c b/drivers/media/platform/seco-cec/seco-cec.c
index 8308873c53ab..01ada99de723 100644
--- a/drivers/media/platform/seco-cec/seco-cec.c
+++ b/drivers/media/platform/seco-cec/seco-cec.c
@@ -335,7 +335,7 @@ static void secocec_rx_done(struct cec_adapter *adap, u16 status_val)
 	smb_wr16(SECOCEC_STATUS, status_val);
 }
 
-struct cec_adap_ops secocec_cec_adap_ops = {
+static const struct cec_adap_ops secocec_cec_adap_ops = {
 	/* Low-level callbacks */
 	.adap_enable = secocec_adap_enable,
 	.adap_log_addr = secocec_adap_log_addr,
-- 
2.19.1
