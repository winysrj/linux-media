Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46712 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751234AbdGPKsH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 06:48:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Eric Anholt <eric@anholt.net>,
        boris.brezillon@free-electrons.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/3] drm/vc4: add HDMI CEC support
Date: Sun, 16 Jul 2017 12:48:04 +0200
Message-Id: <20170716104804.48308-4-hverkuil@xs4all.nl>
In-Reply-To: <20170716104804.48308-1-hverkuil@xs4all.nl>
References: <20170716104804.48308-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch adds support to VC4 for CEC.

Thanks to Eric Anholt for providing me with the CEC register information.

To prevent the firmware from eating the CEC interrupts you need to add this to
your config.txt:

mask_gpu_interrupt1=0x100

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/gpu/drm/vc4/Kconfig    |   8 ++
 drivers/gpu/drm/vc4/vc4_hdmi.c | 227 +++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/vc4/vc4_regs.h | 113 ++++++++++++++++++++
 3 files changed, 342 insertions(+), 6 deletions(-)

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
index e0104f96011e..761b95f5deed 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -57,9 +57,14 @@
 #include <sound/pcm_drm_eld.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
+#include "media/cec.h"
 #include "vc4_drv.h"
 #include "vc4_regs.h"
 
+#define HSM_CLOCK_FREQ 163682864
+#define CEC_CLOCK_FREQ 40000
+#define CEC_CLOCK_DIV  (HSM_CLOCK_FREQ / CEC_CLOCK_FREQ)
+
 /* HDMI audio information */
 struct vc4_hdmi_audio {
 	struct snd_soc_card card;
@@ -85,6 +90,11 @@ struct vc4_hdmi {
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
@@ -149,6 +159,23 @@ static const struct {
 	HDMI_REG(VC4_HDMI_VERTB1),
 	HDMI_REG(VC4_HDMI_TX_PHY_RESET_CTL),
 	HDMI_REG(VC4_HDMI_TX_PHY_CTL0),
+
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_1),
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_2),
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_3),
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_4),
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_5),
+	HDMI_REG(VC4_HDMI_CPU_STATUS),
+	HDMI_REG(VC4_HDMI_CPU_MASK_STATUS),
+
+	HDMI_REG(VC4_HDMI_CEC_RX_DATA_1),
+	HDMI_REG(VC4_HDMI_CEC_RX_DATA_2),
+	HDMI_REG(VC4_HDMI_CEC_RX_DATA_3),
+	HDMI_REG(VC4_HDMI_CEC_RX_DATA_4),
+	HDMI_REG(VC4_HDMI_CEC_TX_DATA_1),
+	HDMI_REG(VC4_HDMI_CEC_TX_DATA_2),
+	HDMI_REG(VC4_HDMI_CEC_TX_DATA_3),
+	HDMI_REG(VC4_HDMI_CEC_TX_DATA_4),
 };
 
 static const struct {
@@ -216,8 +243,8 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 		if (gpio_get_value_cansleep(vc4->hdmi->hpd_gpio) ^
 		    vc4->hdmi->hpd_active_low)
 			return connector_status_connected;
-		else
-			return connector_status_disconnected;
+		cec_phys_addr_invalidate(vc4->hdmi->cec_adap);
+		return connector_status_disconnected;
 	}
 
 	if (drm_probe_ddc(vc4->hdmi->ddc))
@@ -225,8 +252,8 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 
 	if (HDMI_READ(VC4_HDMI_HOTPLUG) & VC4_HDMI_HOTPLUG_CONNECTED)
 		return connector_status_connected;
-	else
-		return connector_status_disconnected;
+	cec_phys_addr_invalidate(vc4->hdmi->cec_adap);
+	return connector_status_disconnected;
 }
 
 static void vc4_hdmi_connector_destroy(struct drm_connector *connector)
@@ -247,6 +274,7 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 	struct edid *edid;
 
 	edid = drm_get_edid(connector, vc4->hdmi->ddc);
+	cec_s_phys_addr_from_edid(vc4->hdmi->cec_adap, edid);
 	if (!edid)
 		return -ENODEV;
 
@@ -1121,6 +1149,159 @@ static void vc4_hdmi_audio_cleanup(struct vc4_hdmi *hdmi)
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
+	/* clock period in microseconds */
+	const u32 usecs = 1000000 / CEC_CLOCK_FREQ;
+	u32 val = HDMI_READ(VC4_HDMI_CEC_CNTRL_5);
+
+	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
+		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
+		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
+	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
+	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
+
+	if (enable) {
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
@@ -1180,7 +1361,7 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 	 * needs to be a bit higher than the pixel clock rate
 	 * (generally 148.5Mhz).
 	 */
-	ret = clk_set_rate(hdmi->hsm_clock, 163682864);
+	ret = clk_set_rate(hdmi->hsm_clock, HSM_CLOCK_FREQ);
 	if (ret) {
 		DRM_ERROR("Failed to set HSM clock rate: %d\n", ret);
 		goto err_put_i2c;
@@ -1231,6 +1412,34 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
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
+	value = HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
+	value &= ~VC4_HDMI_CEC_DIV_CLK_CNT_MASK;
+	/*
+	 * Set the logical address to Unregistered and set the clock
+	 * divider: the hsm_clock rate and this divider setting will
+	 * give a 40 kHz CEC clock.
+	 */
+	value |= VC4_HDMI_CEC_ADDR_MASK |
+		 (4091 << VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT);
+	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, value);
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
@@ -1238,6 +1447,12 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 
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
@@ -1257,7 +1472,7 @@ static void vc4_hdmi_unbind(struct device *dev, struct device *master,
 	struct vc4_hdmi *hdmi = vc4->hdmi;
 
 	vc4_hdmi_audio_cleanup(hdmi);
-
+	cec_unregister_adapter(hdmi->cec_adap);
 	vc4_hdmi_connector_destroy(hdmi->connector);
 	vc4_hdmi_encoder_destroy(hdmi->encoder);
 
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index d382c34c1b9e..55677bd50f66 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -561,16 +561,129 @@
 # define VC4_HDMI_VERTB_VBP_MASK		VC4_MASK(8, 0)
 # define VC4_HDMI_VERTB_VBP_SHIFT		0
 
+#define VC4_HDMI_CEC_CNTRL_1			0x0e8
+/* Set when the transmission has ended. */
+# define VC4_HDMI_CEC_TX_EOM			BIT(31)
+/* If set, transmission was acked on the 1st or 2nd attempt (only one
+ * retry is attempted).  If in continuous mode, this means TX needs to
+ * be filled if !TX_EOM.
+ */
+# define VC4_HDMI_CEC_TX_STATUS_GOOD		BIT(30)
+# define VC4_HDMI_CEC_RX_EOM			BIT(29)
+# define VC4_HDMI_CEC_RX_STATUS_GOOD		BIT(28)
+/* Number of bytes received for the message. */
+# define VC4_HDMI_CEC_REC_WRD_CNT_MASK		VC4_MASK(27, 24)
+# define VC4_HDMI_CEC_REC_WRD_CNT_SHIFT		24
+/* Sets continuous receive mode.  Generates interrupt after each 8
+ * bytes to signal that RX_DATA should be consumed, and at RX_EOM.
+ *
+ * If disabled, maximum 16 bytes will be received (including header),
+ * and interrupt at RX_EOM.  Later bytes will be acked but not put
+ * into the RX_DATA.
+ */
+# define VC4_HDMI_CEC_RX_CONTINUE		BIT(23)
+# define VC4_HDMI_CEC_TX_CONTINUE		BIT(22)
+/* Set this after a CEC interrupt. */
+# define VC4_HDMI_CEC_CLEAR_RECEIVE_OFF		BIT(21)
+/* Starts a TX.  Will wait for appropriate idel time before CEC
+ * activity. Must be cleared in between transmits.
+ */
+# define VC4_HDMI_CEC_START_XMIT_BEGIN		BIT(20)
+# define VC4_HDMI_CEC_MESSAGE_LENGTH_MASK	VC4_MASK(19, 16)
+# define VC4_HDMI_CEC_MESSAGE_LENGTH_SHIFT	16
+/* Device's CEC address */
+# define VC4_HDMI_CEC_ADDR_MASK			VC4_MASK(15, 12)
+# define VC4_HDMI_CEC_ADDR_SHIFT		12
+/* Divides off of HSM clock to generate CEC bit clock. */
+/* With the current defaults the CEC bit clock is 40 kHz = 25 usec */
+# define VC4_HDMI_CEC_DIV_CLK_CNT_MASK		VC4_MASK(11, 0)
+# define VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT		0
+
+/* Set these fields to how many bit clock cycles get to that many
+ * microseconds.
+ */
+#define VC4_HDMI_CEC_CNTRL_2			0x0ec
+# define VC4_HDMI_CEC_CNT_TO_1500_US_MASK	VC4_MASK(30, 24)
+# define VC4_HDMI_CEC_CNT_TO_1500_US_SHIFT	24
+# define VC4_HDMI_CEC_CNT_TO_1300_US_MASK	VC4_MASK(23, 17)
+# define VC4_HDMI_CEC_CNT_TO_1300_US_SHIFT	17
+# define VC4_HDMI_CEC_CNT_TO_800_US_MASK	VC4_MASK(16, 11)
+# define VC4_HDMI_CEC_CNT_TO_800_US_SHIFT	11
+# define VC4_HDMI_CEC_CNT_TO_600_US_MASK	VC4_MASK(10, 5)
+# define VC4_HDMI_CEC_CNT_TO_600_US_SHIFT	5
+# define VC4_HDMI_CEC_CNT_TO_400_US_MASK	VC4_MASK(4, 0)
+# define VC4_HDMI_CEC_CNT_TO_400_US_SHIFT	0
+
+#define VC4_HDMI_CEC_CNTRL_3			0x0f0
+# define VC4_HDMI_CEC_CNT_TO_2750_US_MASK	VC4_MASK(31, 24)
+# define VC4_HDMI_CEC_CNT_TO_2750_US_SHIFT	24
+# define VC4_HDMI_CEC_CNT_TO_2400_US_MASK	VC4_MASK(23, 16)
+# define VC4_HDMI_CEC_CNT_TO_2400_US_SHIFT	16
+# define VC4_HDMI_CEC_CNT_TO_2050_US_MASK	VC4_MASK(15, 8)
+# define VC4_HDMI_CEC_CNT_TO_2050_US_SHIFT	8
+# define VC4_HDMI_CEC_CNT_TO_1700_US_MASK	VC4_MASK(7, 0)
+# define VC4_HDMI_CEC_CNT_TO_1700_US_SHIFT	0
+
+#define VC4_HDMI_CEC_CNTRL_4			0x0f4
+# define VC4_HDMI_CEC_CNT_TO_4300_US_MASK	VC4_MASK(31, 24)
+# define VC4_HDMI_CEC_CNT_TO_4300_US_SHIFT	24
+# define VC4_HDMI_CEC_CNT_TO_3900_US_MASK	VC4_MASK(23, 16)
+# define VC4_HDMI_CEC_CNT_TO_3900_US_SHIFT	16
+# define VC4_HDMI_CEC_CNT_TO_3600_US_MASK	VC4_MASK(15, 8)
+# define VC4_HDMI_CEC_CNT_TO_3600_US_SHIFT	8
+# define VC4_HDMI_CEC_CNT_TO_3500_US_MASK	VC4_MASK(7, 0)
+# define VC4_HDMI_CEC_CNT_TO_3500_US_SHIFT	0
+
+#define VC4_HDMI_CEC_CNTRL_5			0x0f8
+# define VC4_HDMI_CEC_TX_SW_RESET		BIT(27)
+# define VC4_HDMI_CEC_RX_SW_RESET		BIT(26)
+# define VC4_HDMI_CEC_PAD_SW_RESET		BIT(25)
+# define VC4_HDMI_CEC_MUX_TP_OUT_CEC		BIT(24)
+# define VC4_HDMI_CEC_RX_CEC_INT		BIT(23)
+# define VC4_HDMI_CEC_CLK_PRELOAD_MASK		VC4_MASK(22, 16)
+# define VC4_HDMI_CEC_CLK_PRELOAD_SHIFT		16
+# define VC4_HDMI_CEC_CNT_TO_4700_US_MASK	VC4_MASK(15, 8)
+# define VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT	8
+# define VC4_HDMI_CEC_CNT_TO_4500_US_MASK	VC4_MASK(7, 0)
+# define VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT	0
+
+/* Transmit data, first byte is low byte of the 32-bit reg.  MSB of
+ * each byte transmitted first.
+ */
+#define VC4_HDMI_CEC_TX_DATA_1			0x0fc
+#define VC4_HDMI_CEC_TX_DATA_2			0x100
+#define VC4_HDMI_CEC_TX_DATA_3			0x104
+#define VC4_HDMI_CEC_TX_DATA_4			0x108
+#define VC4_HDMI_CEC_RX_DATA_1			0x10c
+#define VC4_HDMI_CEC_RX_DATA_2			0x110
+#define VC4_HDMI_CEC_RX_DATA_3			0x114
+#define VC4_HDMI_CEC_RX_DATA_4			0x118
+
 #define VC4_HDMI_TX_PHY_RESET_CTL		0x2c0
 
 #define VC4_HDMI_TX_PHY_CTL0			0x2c4
 # define VC4_HDMI_TX_PHY_RNG_PWRDN		BIT(25)
 
+/* Interrupt status bits */
+#define VC4_HDMI_CPU_STATUS			0x340
+#define VC4_HDMI_CPU_SET			0x344
+#define VC4_HDMI_CPU_CLEAR			0x348
+# define VC4_HDMI_CPU_CEC			BIT(6)
+# define VC4_HDMI_CPU_HOTPLUG			BIT(0)
+
+#define VC4_HDMI_CPU_MASK_STATUS		0x34c
+#define VC4_HDMI_CPU_MASK_SET			0x350
+#define VC4_HDMI_CPU_MASK_CLEAR			0x354
+
 #define VC4_HDMI_GCP(x)				(0x400 + ((x) * 0x4))
 #define VC4_HDMI_RAM_PACKET(x)			(0x400 + ((x) * 0x24))
 #define VC4_HDMI_PACKET_STRIDE			0x24
 
 #define VC4_HD_M_CTL				0x00c
+/* Debug: Current receive value on the CEC pad. */
+# define VC4_HD_CECRXD				BIT(9)
+/* Debug: Override CEC output to 0. */
+# define VC4_HD_CECOVR				BIT(8)
 # define VC4_HD_M_REGISTER_FILE_STANDBY		(3 << 6)
 # define VC4_HD_M_RAM_STANDBY			(3 << 4)
 # define VC4_HD_M_SW_RST			BIT(2)
-- 
2.13.2
