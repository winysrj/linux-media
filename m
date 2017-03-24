Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:58512 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965868AbdCXQsl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 12:48:41 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH 7/8] [media] usb: pulse8-cec: Use cec_get_drvdata()
Date: Fri, 24 Mar 2017 16:47:58 +0000
Message-Id: <cc501e17d57fa4a6a31423139af07bb9a8f9baa6.1490373500.git.joabreu@synopsys.com>
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
 drivers/media/usb/pulse8-cec/pulse8-cec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index 7c18dae..1dfc2de 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -461,7 +461,7 @@ static int pulse8_apply_persistent_config(struct pulse8 *pulse8,
 
 static int pulse8_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
-	struct pulse8 *pulse8 = adap->priv;
+	struct pulse8 *pulse8 = cec_get_drvdata(adap);
 	u8 cmd[16];
 	int err;
 
@@ -474,7 +474,7 @@ static int pulse8_cec_adap_enable(struct cec_adapter *adap, bool enable)
 
 static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
 {
-	struct pulse8 *pulse8 = adap->priv;
+	struct pulse8 *pulse8 = cec_get_drvdata(adap);
 	u16 mask = 0;
 	u16 pa = adap->phys_addr;
 	u8 cmd[16];
@@ -594,7 +594,7 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
 static int pulse8_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				    u32 signal_free_time, struct cec_msg *msg)
 {
-	struct pulse8 *pulse8 = adap->priv;
+	struct pulse8 *pulse8 = cec_get_drvdata(adap);
 	u8 cmd[2];
 	unsigned int i;
 	int err;
-- 
1.9.1
