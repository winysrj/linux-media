Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52895 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752716AbdLDNcw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Dec 2017 08:32:52 -0500
To: Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Henrik Austad <haustad@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for 4.15] omapdrm/dss/hdmi4_cec: fix interrupt handling
Message-ID: <c8031caa-390c-7c13-aec3-59c56b10101b@xs4all.nl>
Date: Mon, 4 Dec 2017 14:32:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap4 CEC hardware cannot tell a Nack from a Low Drive from an
Arbitration Lost error, so just report a Nack, which is almost
certainly the reason for the error anyway.

This also simplifies the implementation. The only three interrupts
that need to be enabled are:

Transmit Buffer Full/Empty Change event: triggered when the
transmit finished successfully and cleared the buffer.

Receiver FIFO Not Empty event: triggered when a message was received.

Frame Retransmit Count Exceeded event: triggered when a transmit
failed repeatedly, usually due to the message being Nacked. Other
reasons are possible (Low Drive, Arbitration Lost) but there is no
way to know. If this happens the TX buffer needs to be cleared
manually.

While testing various error conditions I noticed that the hardware
can receive messages up to 18 bytes in total, which exceeds the legal
maximum of 16. This could cause a buffer overflow, so we check for
this and constrain the size to 16 bytes.

The old incorrect interrupt handler could cause the CEC framework to
enter into a bad state because it mis-detected the "Start Bit Irregularity
event" as an ARB_LOST transmit error when it actually is a receive error
which should be ignored.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Henrik Austad <haustad@cisco.com>
Tested-by: Henrik Austad <haustad@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c | 46 +++++++--------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
index d86873f2abe6..108a84cedaf6 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
@@ -78,6 +78,8 @@ static void hdmi_cec_received_msg(struct hdmi_core_data *core)

 			/* then read the message */
 			msg.len = cnt & 0xf;
+			if (msg.len > CEC_MAX_MSG_SIZE - 2)
+				msg.len = CEC_MAX_MSG_SIZE - 2;
 			msg.msg[0] = hdmi_read_reg(core->base,
 						   HDMI_CEC_RX_CMD_HEADER);
 			msg.msg[1] = hdmi_read_reg(core->base,
@@ -104,26 +106,6 @@ static void hdmi_cec_received_msg(struct hdmi_core_data *core)
 	}
 }

-static void hdmi_cec_transmit_fifo_empty(struct hdmi_core_data *core, u32 stat1)
-{
-	if (stat1 & 2) {
-		u32 dbg3 = hdmi_read_reg(core->base, HDMI_CEC_DBG_3);
-
-		cec_transmit_done(core->adap,
-				  CEC_TX_STATUS_NACK |
-				  CEC_TX_STATUS_MAX_RETRIES,
-				  0, (dbg3 >> 4) & 7, 0, 0);
-	} else if (stat1 & 1) {
-		cec_transmit_done(core->adap,
-				  CEC_TX_STATUS_ARB_LOST |
-				  CEC_TX_STATUS_MAX_RETRIES,
-				  0, 0, 0, 0);
-	} else if (stat1 == 0) {
-		cec_transmit_done(core->adap, CEC_TX_STATUS_OK,
-				  0, 0, 0, 0);
-	}
-}
-
 void hdmi4_cec_irq(struct hdmi_core_data *core)
 {
 	u32 stat0 = hdmi_read_reg(core->base, HDMI_CEC_INT_STATUS_0);
@@ -132,27 +114,21 @@ void hdmi4_cec_irq(struct hdmi_core_data *core)
 	hdmi_write_reg(core->base, HDMI_CEC_INT_STATUS_0, stat0);
 	hdmi_write_reg(core->base, HDMI_CEC_INT_STATUS_1, stat1);

-	if (stat0 & 0x40)
+	if (stat0 & 0x20) {
+		cec_transmit_done(core->adap, CEC_TX_STATUS_OK,
+				  0, 0, 0, 0);
 		REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
-	else if (stat0 & 0x24)
-		hdmi_cec_transmit_fifo_empty(core, stat1);
-	if (stat1 & 2) {
+	} else if (stat1 & 0x02) {
 		u32 dbg3 = hdmi_read_reg(core->base, HDMI_CEC_DBG_3);

 		cec_transmit_done(core->adap,
 				  CEC_TX_STATUS_NACK |
 				  CEC_TX_STATUS_MAX_RETRIES,
 				  0, (dbg3 >> 4) & 7, 0, 0);
-	} else if (stat1 & 1) {
-		cec_transmit_done(core->adap,
-				  CEC_TX_STATUS_ARB_LOST |
-				  CEC_TX_STATUS_MAX_RETRIES,
-				  0, 0, 0, 0);
+		REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
 	}
 	if (stat0 & 0x02)
 		hdmi_cec_received_msg(core);
-	if (stat1 & 0x3)
-		REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
 }

 static bool hdmi_cec_clear_tx_fifo(struct cec_adapter *adap)
@@ -231,18 +207,14 @@ static int hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 	/*
 	 * Enable CEC interrupts:
 	 * Transmit Buffer Full/Empty Change event
-	 * Transmitter FIFO Empty event
 	 * Receiver FIFO Not Empty event
 	 */
-	hdmi_write_reg(core->base, HDMI_CEC_INT_ENABLE_0, 0x26);
+	hdmi_write_reg(core->base, HDMI_CEC_INT_ENABLE_0, 0x22);
 	/*
 	 * Enable CEC interrupts:
-	 * RX FIFO Overrun Error event
-	 * Short Pulse Detected event
 	 * Frame Retransmit Count Exceeded event
-	 * Start Bit Irregularity event
 	 */
-	hdmi_write_reg(core->base, HDMI_CEC_INT_ENABLE_1, 0x0f);
+	hdmi_write_reg(core->base, HDMI_CEC_INT_ENABLE_1, 0x02);

 	/* cec calibration enable (self clearing) */
 	hdmi_write_reg(core->base, HDMI_CEC_SETUP, 0x03);
-- 
2.14.1
