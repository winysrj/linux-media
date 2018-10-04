Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34464 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727444AbeJDQBZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 12:01:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] omapdrm/dss/hdmi4_cec.c: clear TX FIFO before transmit_done
Date: Thu,  4 Oct 2018 11:08:59 +0200
Message-Id: <20181004090900.32915-5-hverkuil@xs4all.nl>
In-Reply-To: <20181004090900.32915-1-hverkuil@xs4all.nl>
References: <20181004090900.32915-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The TX FIFO has to be cleared if the transmit failed due to e.g.
a NACK condition, otherwise the hardware will keep trying to
transmit the message.

An attempt was made to do this, but it was done after the call to
cec_transmit_done, which can cause a race condition since the call
to cec_transmit_done can cause a new transmit to be issued, and
then attempting to clear the TX FIFO will actually clear the new
transmit instead of the old transmit and the new transmit simply
never happens.

By clearing the FIFO before transmit_done is called this race
is fixed.

Note that there is no reason to clear the FIFO if the transmit
was successful, so the attempt to clear the FIFO in that case
was dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c | 35 ++++++++++++-------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
index 340383150fb9..dee66a5101b5 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
@@ -106,6 +106,22 @@ static void hdmi_cec_received_msg(struct hdmi_core_data *core)
 	}
 }
 
+static bool hdmi_cec_clear_tx_fifo(struct cec_adapter *adap)
+{
+	struct hdmi_core_data *core = cec_get_drvdata(adap);
+	int retry = HDMI_CORE_CEC_RETRY;
+	int temp;
+
+	REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
+	while (retry) {
+		temp = hdmi_read_reg(core->base, HDMI_CEC_DBG_3);
+		if (FLD_GET(temp, 7, 7) == 0)
+			break;
+		retry--;
+	}
+	return retry != 0;
+}
+
 void hdmi4_cec_irq(struct hdmi_core_data *core)
 {
 	u32 stat0 = hdmi_read_reg(core->base, HDMI_CEC_INT_STATUS_0);
@@ -117,36 +133,19 @@ void hdmi4_cec_irq(struct hdmi_core_data *core)
 	if (stat0 & 0x20) {
 		cec_transmit_done(core->adap, CEC_TX_STATUS_OK,
 				  0, 0, 0, 0);
-		REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
 	} else if (stat1 & 0x02) {
 		u32 dbg3 = hdmi_read_reg(core->base, HDMI_CEC_DBG_3);
 
+		hdmi_cec_clear_tx_fifo(core->adap);
 		cec_transmit_done(core->adap,
 				  CEC_TX_STATUS_NACK |
 				  CEC_TX_STATUS_MAX_RETRIES,
 				  0, (dbg3 >> 4) & 7, 0, 0);
-		REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
 	}
 	if (stat0 & 0x02)
 		hdmi_cec_received_msg(core);
 }
 
-static bool hdmi_cec_clear_tx_fifo(struct cec_adapter *adap)
-{
-	struct hdmi_core_data *core = cec_get_drvdata(adap);
-	int retry = HDMI_CORE_CEC_RETRY;
-	int temp;
-
-	REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
-	while (retry) {
-		temp = hdmi_read_reg(core->base, HDMI_CEC_DBG_3);
-		if (FLD_GET(temp, 7, 7) == 0)
-			break;
-		retry--;
-	}
-	return retry != 0;
-}
-
 static bool hdmi_cec_clear_rx_fifo(struct cec_adapter *adap)
 {
 	struct hdmi_core_data *core = cec_get_drvdata(adap);
-- 
2.18.0
