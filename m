Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46727 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755174AbdGKLU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 07:20:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] drm/vc4: add HDMI CEC support
Date: Tue, 11 Jul 2017 13:20:21 +0200
Message-Id: <20170711112021.38525-5-hverkuil@xs4all.nl>
In-Reply-To: <20170711112021.38525-1-hverkuil@xs4all.nl>
References: <20170711112021.38525-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch adds support to VC4 for CEC.

To prevent the firmware from eating the CEC interrupts you need to add this to
your config.txt:

mask_gpu_interrupt1=0x100

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/vc4/Kconfig    |   8 ++
 drivers/gpu/drm/vc4/vc4_hdmi.c | 203 ++++++++++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/vc4/vc4_regs.h |   5 +
 3 files changed, 211 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vc4/Kconfig b/drivers/gpu/drm/vc4/Kconfig
index 4361bdcfd28a..fdae18aeab4f 100644
--- a/drivers/gpu/drm/vc4/Kconfig
+++ b/drivers/gpu/drm/vc4/Kconfig
@@ -19,3 +19,11 @@ config DRM_VC4
 	  This driver requires that "avoid_warnings=2" be present in
 	  the config.txt for the firmware, to keep it from smashing
 	  our display setup.
+
+config DRM_VC4_HDMI_CEC
+       bool "Broadcom VC4 HDMI CEC Support"
+       depends on DRM_VC4
+       select CEC_CORE
+       help
+	  Choose this option if you have a Broadcom VC4 GPU
+	  and want to use CEC.
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index b0521e6cc281..14e2ece5db94 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -57,6 +57,7 @@
 #include <sound/pcm_drm_eld.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
+#include "media/cec.h"
 #include "vc4_drv.h"
 #include "vc4_regs.h"
 
@@ -85,6 +86,11 @@ struct vc4_hdmi {
 	int hpd_gpio;
 	bool hpd_active_low;
 
+	struct cec_adapter *cec_adap;
+	struct cec_msg cec_rx_msg;
+	bool cec_tx_ok;
+	bool cec_irq_was_rx;
+
 	struct clk *pixel_clock;
 	struct clk *hsm_clock;
 };
@@ -156,6 +162,7 @@ static const struct {
 	HDMI_REG(VC4_HDMI_CEC_CNTRL_4),
 	HDMI_REG(VC4_HDMI_CEC_CNTRL_5),
 	HDMI_REG(VC4_HDMI_CPU_STATUS),
+	HDMI_REG(VC4_HDMI_CPU_MASK_STATUS),
 
 	HDMI_REG(VC4_HDMI_CEC_RX_DATA_1),
 	HDMI_REG(VC4_HDMI_CEC_RX_DATA_2),
@@ -232,8 +239,8 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 		if (gpio_get_value_cansleep(vc4->hdmi->hpd_gpio) ^
 		    vc4->hdmi->hpd_active_low)
 			return connector_status_connected;
-		else
-			return connector_status_disconnected;
+		cec_phys_addr_invalidate(vc4->hdmi->cec_adap);
+		return connector_status_disconnected;
 	}
 
 	if (drm_probe_ddc(vc4->hdmi->ddc))
@@ -241,8 +248,8 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 
 	if (HDMI_READ(VC4_HDMI_HOTPLUG) & VC4_HDMI_HOTPLUG_CONNECTED)
 		return connector_status_connected;
-	else
-		return connector_status_disconnected;
+	cec_phys_addr_invalidate(vc4->hdmi->cec_adap);
+	return connector_status_disconnected;
 }
 
 static void vc4_hdmi_connector_destroy(struct drm_connector *connector)
@@ -263,6 +270,7 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 	struct edid *edid;
 
 	edid = drm_get_edid(connector, vc4->hdmi->ddc);
+	cec_s_phys_addr_from_edid(vc4->hdmi->cec_adap, edid);
 	if (!edid)
 		return -ENODEV;
 
@@ -1137,6 +1145,165 @@ static void vc4_hdmi_audio_cleanup(struct vc4_hdmi *hdmi)
 		snd_soc_unregister_codec(dev);
 }
 
+#ifdef CONFIG_DRM_VC4_HDMI_CEC
+static irqreturn_t vc4_cec_irq_handler_thread(int irq, void *priv)
+{
+	struct vc4_dev *vc4 = priv;
+	struct vc4_hdmi *hdmi = vc4->hdmi;
+
+	if (hdmi->cec_irq_was_rx) {
+		if (hdmi->cec_rx_msg.len)
+			cec_received_msg(hdmi->cec_adap, &hdmi->cec_rx_msg);
+	} else if (hdmi->cec_tx_ok) {
+		cec_transmit_done(hdmi->cec_adap, CEC_TX_STATUS_OK,
+				  0, 0, 0, 0);
+	} else {
+		/*
+		 * This CEC implementation makes 1 retry, so if we
+		 * get a NACK, then that means it made 2 attempts.
+		 */
+		cec_transmit_done(hdmi->cec_adap, CEC_TX_STATUS_NACK,
+				  0, 2, 0, 0);
+	}
+	return IRQ_HANDLED;
+}
+
+static void vc4_cec_read_msg(struct vc4_dev *vc4, u32 cntrl1)
+{
+	struct cec_msg *msg = &vc4->hdmi->cec_rx_msg;
+	unsigned int i;
+
+	msg->len = 1 + ((cntrl1 & VC4_HDMI_CEC_REC_WRD_CNT_MASK) >>
+					VC4_HDMI_CEC_REC_WRD_CNT_SHIFT);
+	for (i = 0; i < msg->len; i += 4) {
+		u32 val = HDMI_READ(VC4_HDMI_CEC_RX_DATA_1 + i);
+
+		msg->msg[i] = val & 0xff;
+		msg->msg[i + 1] = (val >> 8) & 0xff;
+		msg->msg[i + 2] = (val >> 16) & 0xff;
+		msg->msg[i + 3] = (val >> 24) & 0xff;
+	}
+}
+
+static irqreturn_t vc4_cec_irq_handler(int irq, void *priv)
+{
+	struct vc4_dev *vc4 = priv;
+	struct vc4_hdmi *hdmi = vc4->hdmi;
+	u32 stat = HDMI_READ(VC4_HDMI_CPU_STATUS);
+	u32 cntrl1, cntrl5;
+
+	if (!(stat & VC4_HDMI_CPU_CEC))
+		return IRQ_NONE;
+	hdmi->cec_rx_msg.len = 0;
+	cntrl1 = HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
+	cntrl5 = HDMI_READ(VC4_HDMI_CEC_CNTRL_5);
+	hdmi->cec_irq_was_rx = cntrl5 & VC4_HDMI_CEC_RX_CEC_INT;
+	if (hdmi->cec_irq_was_rx) {
+		vc4_cec_read_msg(vc4, cntrl1);
+		cntrl1 |= VC4_HDMI_CEC_CLEAR_RECEIVE_OFF;
+		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, cntrl1);
+		cntrl1 &= ~VC4_HDMI_CEC_CLEAR_RECEIVE_OFF;
+	} else {
+		hdmi->cec_tx_ok = cntrl1 & VC4_HDMI_CEC_TX_STATUS_GOOD;
+		cntrl1 &= ~VC4_HDMI_CEC_START_XMIT_BEGIN;
+	}
+	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, cntrl1);
+	HDMI_WRITE(VC4_HDMI_CPU_CLEAR, VC4_HDMI_CPU_CEC);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct vc4_dev *vc4 = cec_get_drvdata(adap);
+	u32 hsm_clock = clk_get_rate(vc4->hdmi->hsm_clock);
+	u32 cntrl1 = HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
+	u32 divclk = cntrl1 & VC4_HDMI_CEC_DIV_CLK_CNT_MASK;
+	/* clock period in microseconds */
+	u32 usecs = 1000000 / (hsm_clock / divclk);
+	u32 val = HDMI_READ(VC4_HDMI_CEC_CNTRL_5);
+
+	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
+		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
+		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
+	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
+	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
+
+	if (enable) {
+		cntrl1 &= VC4_HDMI_CEC_DIV_CLK_CNT_MASK |
+			  VC4_HDMI_CEC_ADDR_MASK;
+
+		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_5, val |
+			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
+		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_5, val);
+		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_2,
+			 ((1500 / usecs) << VC4_HDMI_CEC_CNT_TO_1500_US_SHIFT) |
+			 ((1300 / usecs) << VC4_HDMI_CEC_CNT_TO_1300_US_SHIFT) |
+			 ((800 / usecs) << VC4_HDMI_CEC_CNT_TO_800_US_SHIFT) |
+			 ((600 / usecs) << VC4_HDMI_CEC_CNT_TO_600_US_SHIFT) |
+			 ((400 / usecs) << VC4_HDMI_CEC_CNT_TO_400_US_SHIFT));
+		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_3,
+			 ((2750 / usecs) << VC4_HDMI_CEC_CNT_TO_2750_US_SHIFT) |
+			 ((2400 / usecs) << VC4_HDMI_CEC_CNT_TO_2400_US_SHIFT) |
+			 ((2050 / usecs) << VC4_HDMI_CEC_CNT_TO_2050_US_SHIFT) |
+			 ((1700 / usecs) << VC4_HDMI_CEC_CNT_TO_1700_US_SHIFT));
+		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_4,
+			 ((4300 / usecs) << VC4_HDMI_CEC_CNT_TO_4300_US_SHIFT) |
+			 ((3900 / usecs) << VC4_HDMI_CEC_CNT_TO_3900_US_SHIFT) |
+			 ((3600 / usecs) << VC4_HDMI_CEC_CNT_TO_3600_US_SHIFT) |
+			 ((3500 / usecs) << VC4_HDMI_CEC_CNT_TO_3500_US_SHIFT));
+
+		HDMI_WRITE(VC4_HDMI_CPU_MASK_CLEAR, VC4_HDMI_CPU_CEC);
+	} else {
+		HDMI_WRITE(VC4_HDMI_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
+		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_5, val |
+			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
+	}
+	return 0;
+}
+
+static int vc4_hdmi_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
+{
+	struct vc4_dev *vc4 = cec_get_drvdata(adap);
+
+	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1,
+		   (HDMI_READ(VC4_HDMI_CEC_CNTRL_1) & ~VC4_HDMI_CEC_ADDR_MASK) |
+		   (log_addr & 0xf) << VC4_HDMI_CEC_ADDR_SHIFT);
+	return 0;
+}
+
+static int vc4_hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				      u32 signal_free_time, struct cec_msg *msg)
+{
+	struct vc4_dev *vc4 = cec_get_drvdata(adap);
+	u32 val;
+	unsigned int i;
+
+	for (i = 0; i < msg->len; i += 4)
+		HDMI_WRITE(VC4_HDMI_CEC_TX_DATA_1 + i,
+			   (msg->msg[i]) |
+			   (msg->msg[i + 1] << 8) |
+			   (msg->msg[i + 2] << 16) |
+			   (msg->msg[i + 3] << 24));
+
+	val = HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
+	val &= ~VC4_HDMI_CEC_START_XMIT_BEGIN;
+	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, val);
+	val &= ~VC4_HDMI_CEC_MESSAGE_LENGTH_MASK;
+	val |= (msg->len - 1) << VC4_HDMI_CEC_MESSAGE_LENGTH_SHIFT;
+	val |= VC4_HDMI_CEC_START_XMIT_BEGIN;
+
+	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, val);
+	return 0;
+}
+
+static const struct cec_adap_ops vc4_hdmi_cec_adap_ops = {
+	.adap_enable = vc4_hdmi_cec_adap_enable,
+	.adap_log_addr = vc4_hdmi_cec_adap_log_addr,
+	.adap_transmit = vc4_hdmi_cec_adap_transmit,
+};
+#endif
+
 static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -1247,6 +1414,26 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 		ret = PTR_ERR(hdmi->connector);
 		goto err_destroy_encoder;
 	}
+#ifdef CONFIG_DRM_VC4_HDMI_CEC
+	hdmi->cec_adap = cec_allocate_adapter(&vc4_hdmi_cec_adap_ops,
+		vc4, "vc4", CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, 1);
+	ret = PTR_ERR_OR_ZERO(hdmi->cec_adap);
+	if (ret < 0)
+		goto err_destroy_conn;
+	HDMI_WRITE(VC4_HDMI_CPU_MASK_SET, 0xffffffff);
+	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1,
+		   (HDMI_READ(VC4_HDMI_CEC_CNTRL_1) | VC4_HDMI_CEC_ADDR_MASK));
+	ret = devm_request_threaded_irq(dev, platform_get_irq(pdev, 0),
+					vc4_cec_irq_handler,
+					vc4_cec_irq_handler_thread, 0,
+					"vc4 hdmi cec", vc4);
+	if (ret)
+		goto err_delete_cec_adap;
+	ret = cec_register_adapter(hdmi->cec_adap, dev);
+	if (ret < 0)
+		goto err_delete_cec_adap;
+#endif
 
 	ret = vc4_hdmi_audio_init(hdmi);
 	if (ret)
@@ -1254,6 +1441,12 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 
 	return 0;
 
+#ifdef CONFIG_DRM_VC4_HDMI_CEC
+err_delete_cec_adap:
+	cec_delete_adapter(hdmi->cec_adap);
+err_destroy_conn:
+	vc4_hdmi_connector_destroy(hdmi->connector);
+#endif
 err_destroy_encoder:
 	vc4_hdmi_encoder_destroy(hdmi->encoder);
 err_unprepare_hsm:
@@ -1273,7 +1466,7 @@ static void vc4_hdmi_unbind(struct device *dev, struct device *master,
 	struct vc4_hdmi *hdmi = vc4->hdmi;
 
 	vc4_hdmi_audio_cleanup(hdmi);
-
+	cec_unregister_adapter(hdmi->cec_adap);
 	vc4_hdmi_connector_destroy(hdmi->connector);
 	vc4_hdmi_encoder_destroy(hdmi->encoder);
 
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index b18cc20ee185..55677bd50f66 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -595,6 +595,7 @@
 # define VC4_HDMI_CEC_ADDR_MASK			VC4_MASK(15, 12)
 # define VC4_HDMI_CEC_ADDR_SHIFT		12
 /* Divides off of HSM clock to generate CEC bit clock. */
+/* With the current defaults the CEC bit clock is 40 kHz = 25 usec */
 # define VC4_HDMI_CEC_DIV_CLK_CNT_MASK		VC4_MASK(11, 0)
 # define VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT		0
 
@@ -670,6 +671,10 @@
 # define VC4_HDMI_CPU_CEC			BIT(6)
 # define VC4_HDMI_CPU_HOTPLUG			BIT(0)
 
+#define VC4_HDMI_CPU_MASK_STATUS		0x34c
+#define VC4_HDMI_CPU_MASK_SET			0x350
+#define VC4_HDMI_CPU_MASK_CLEAR			0x354
+
 #define VC4_HDMI_GCP(x)				(0x400 + ((x) * 0x4))
 #define VC4_HDMI_RAM_PACKET(x)			(0x400 + ((x) * 0x24))
 #define VC4_HDMI_PACKET_STRIDE			0x24
-- 
2.11.0
