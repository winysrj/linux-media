Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34842 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbeJHVIp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 17:08:45 -0400
To: Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] omapdrm/dss/hdmi4_cec.c: simplify clear_tx/rx_fifo functions
Message-ID: <3bc5d91c-89ce-1885-7b56-7e6047c7ff8b@xs4all.nl>
Date: Mon, 8 Oct 2018 15:56:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use REG_GET to avoid the temp variable.

Add pr_err_once if hdmi_cec_clear_tx_fifo() fails in hdmi4_cec_irq().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: the FIFOs are cleared almost immediately (after just one try), so adding
delays is overkill.
---
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
index 00407f1995a8..92b55780aafd 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
@@ -110,16 +110,12 @@ static bool hdmi_cec_clear_tx_fifo(struct cec_adapter *adap)
 {
 	struct hdmi_core_data *core = cec_get_drvdata(adap);
 	int retry = HDMI_CORE_CEC_RETRY;
-	int temp;

 	REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
-	while (retry) {
-		temp = hdmi_read_reg(core->base, HDMI_CEC_DBG_3);
-		if (FLD_GET(temp, 7, 7) == 0)
-			break;
-		retry--;
-	}
-	return retry != 0;
+	while (retry--)
+		if (!REG_GET(core->base, HDMI_CEC_DBG_3, 7, 7))
+			return true;
+	return false;
 }

 void hdmi4_cec_irq(struct hdmi_core_data *core)
@@ -136,7 +132,9 @@ void hdmi4_cec_irq(struct hdmi_core_data *core)
 	} else if (stat1 & 0x02) {
 		u32 dbg3 = hdmi_read_reg(core->base, HDMI_CEC_DBG_3);

-		hdmi_cec_clear_tx_fifo(core->adap);
+		if (!hdmi_cec_clear_tx_fifo(core->adap))
+			pr_err_once("cec-%s: could not clear TX FIFO\n",
+				    core->adap->name);
 		cec_transmit_done(core->adap,
 				  CEC_TX_STATUS_NACK |
 				  CEC_TX_STATUS_MAX_RETRIES,
@@ -150,17 +148,12 @@ static bool hdmi_cec_clear_rx_fifo(struct cec_adapter *adap)
 {
 	struct hdmi_core_data *core = cec_get_drvdata(adap);
 	int retry = HDMI_CORE_CEC_RETRY;
-	int temp;

 	hdmi_write_reg(core->base, HDMI_CEC_RX_CONTROL, 0x3);
-	retry = HDMI_CORE_CEC_RETRY;
-	while (retry) {
-		temp = hdmi_read_reg(core->base, HDMI_CEC_RX_CONTROL);
-		if (FLD_GET(temp, 1, 0) == 0)
-			break;
-		retry--;
-	}
-	return retry != 0;
+	while (retry--)
+		if (!REG_GET(core->base, HDMI_CEC_RX_CONTROL, 1, 0))
+			return true;
+	return false;
 }

 static int hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
