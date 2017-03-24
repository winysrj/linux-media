Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:45691 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966663AbdCXQsx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 12:48:53 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        Kamil Debski <kamil@wypas.org>
Subject: [PATCH 3/8] [media] staging: s5p-cec: Use cec_get_drvdata()
Date: Fri, 24 Mar 2017 16:47:54 +0000
Message-Id: <d2c1283b742e653cf7e0865530862b69b4401db9.1490373499.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use helper function to get driver private data from CEC
adapter.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Kamil Debski <kamil@wypas.org>
---
 drivers/staging/media/s5p-cec/s5p_cec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/staging/media/s5p-cec/s5p_cec.c
index 2a07968..a30b80a 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.c
+++ b/drivers/staging/media/s5p-cec/s5p_cec.c
@@ -37,7 +37,7 @@
 
 static int s5p_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
-	struct s5p_cec_dev *cec = adap->priv;
+	struct s5p_cec_dev *cec = cec_get_drvdata(adap);
 
 	if (enable) {
 		pm_runtime_get_sync(cec->dev);
@@ -61,7 +61,7 @@ static int s5p_cec_adap_enable(struct cec_adapter *adap, bool enable)
 
 static int s5p_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
 {
-	struct s5p_cec_dev *cec = adap->priv;
+	struct s5p_cec_dev *cec = cec_get_drvdata(adap);
 
 	s5p_cec_set_addr(cec, addr);
 	return 0;
@@ -70,7 +70,7 @@ static int s5p_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
 static int s5p_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				 u32 signal_free_time, struct cec_msg *msg)
 {
-	struct s5p_cec_dev *cec = adap->priv;
+	struct s5p_cec_dev *cec = cec_get_drvdata(adap);
 
 	/*
 	 * Unclear if 0 retries are allowed by the hardware, so have 1 as
-- 
1.9.1
