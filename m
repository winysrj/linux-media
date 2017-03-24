Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:58515 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966642AbdCXQtG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 12:49:06 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH 8/8] [media] platform: vivid: Use cec_get_drvdata()
Date: Fri, 24 Mar 2017 16:47:59 +0000
Message-Id: <6d16b273f040ff230f3e51f87c18fe55e7c369aa.1490373500.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use helper function to get driver private data from CEC
adapter.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-cec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index cb49335..653f409 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -135,7 +135,7 @@ static int vivid_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
 static int vivid_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				   u32 signal_free_time, struct cec_msg *msg)
 {
-	struct vivid_dev *dev = adap->priv;
+	struct vivid_dev *dev = cec_get_drvdata(adap);
 	struct vivid_cec_work *cw = kzalloc(sizeof(*cw), GFP_KERNEL);
 	long delta_jiffies = 0;
 
@@ -166,7 +166,7 @@ static int vivid_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 
 static int vivid_received(struct cec_adapter *adap, struct cec_msg *msg)
 {
-	struct vivid_dev *dev = adap->priv;
+	struct vivid_dev *dev = cec_get_drvdata(adap);
 	struct cec_msg reply;
 	u8 dest = cec_msg_destination(msg);
 	u8 disp_ctl;
-- 
1.9.1
