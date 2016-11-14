Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34523 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752941AbcKNPXG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 10:23:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [RFCv2 PATCH 4/5] drm/bridge: add dw-hdmi cec driver using Hans Verkuil's CEC code
Date: Mon, 14 Nov 2016 16:22:47 +0100
Message-Id: <1479136968-24477-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl>
References: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@arm.linux.org.uk>

Add a CEC driver for the dw-hdmi hardware using Hans Verkuil's CEC
implementation.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/gpu/drm/bridge/Kconfig            |   7 +
 drivers/gpu/drm/bridge/Makefile           |   1 +
 drivers/gpu/drm/bridge/dw-hdmi-cec.c      | 346 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/bridge/dw-hdmi.c          |  64 +++++-
 include/linux/platform_data/dw_hdmi-cec.h |  16 ++
 5 files changed, 423 insertions(+), 11 deletions(-)
 create mode 100644 drivers/gpu/drm/bridge/dw-hdmi-cec.c
 create mode 100644 include/linux/platform_data/dw_hdmi-cec.h

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 5f4ebe9..4ab137e 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -40,6 +40,13 @@ config DRM_DW_HDMI_AHB_AUDIO
 	  Designware HDMI block.  This is used in conjunction with
 	  the i.MX6 HDMI driver.
 
+config DRM_DW_HDMI_CEC
+	tristate "Synopsis Designware CEC interface"
+	depends on DRM_DW_HDMI && MEDIA_CEC_SUPPORT
+	help
+	  Support the CE interface which is part of the Synopsis
+	  Designware HDMI block.
+
 config DRM_NXP_PTN3460
 	tristate "NXP PTN3460 DP/LVDS bridge"
 	depends on OF
diff --git a/drivers/gpu/drm/bridge/Makefile b/drivers/gpu/drm/bridge/Makefile
index cdf3a3c..6bdd8b9 100644
--- a/drivers/gpu/drm/bridge/Makefile
+++ b/drivers/gpu/drm/bridge/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_DRM_ANALOGIX_ANX78XX) += analogix-anx78xx.o
 obj-$(CONFIG_DRM_DUMB_VGA_DAC) += dumb-vga-dac.o
 obj-$(CONFIG_DRM_DW_HDMI) += dw-hdmi.o
 obj-$(CONFIG_DRM_DW_HDMI_AHB_AUDIO) += dw-hdmi-ahb-audio.o
+obj-$(CONFIG_DRM_DW_HDMI_CEC) += dw-hdmi-cec.o
 obj-$(CONFIG_DRM_NXP_PTN3460) += nxp-ptn3460.o
 obj-$(CONFIG_DRM_PARADE_PS8622) += parade-ps8622.o
 obj-$(CONFIG_DRM_SII902X) += sii902x.o
diff --git a/drivers/gpu/drm/bridge/dw-hdmi-cec.c b/drivers/gpu/drm/bridge/dw-hdmi-cec.c
new file mode 100644
index 0000000..e7e12b5
--- /dev/null
+++ b/drivers/gpu/drm/bridge/dw-hdmi-cec.c
@@ -0,0 +1,346 @@
+/* http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git/
+ * tree/drivers/mxc/hdmi-cec/mxc_hdmi-cec.c?h=imx_3.0.35_4.1.0 */
+#include <linux/hdmi-notifier.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/platform_data/dw_hdmi-cec.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <drm/drm_edid.h>
+
+#include <media/cec.h>
+#include <media/cec-edid.h>
+
+#define DEV_NAME "mxc_hdmi_cec"
+
+enum {
+	HDMI_IH_CEC_STAT0	= 0x0106,
+	HDMI_IH_MUTE_CEC_STAT0	= 0x0186,
+
+	HDMI_CEC_CTRL		= 0x7d00,
+	CEC_CTRL_START		= BIT(0),
+	CEC_CTRL_NORMAL		= 1 << 1,
+
+	HDMI_CEC_STAT		= 0x7d01,
+	CEC_STAT_DONE		= BIT(0),
+	CEC_STAT_EOM		= BIT(1),
+	CEC_STAT_NACK		= BIT(2),
+	CEC_STAT_ARBLOST	= BIT(3),
+	CEC_STAT_ERROR_INIT	= BIT(4),
+	CEC_STAT_ERROR_FOLL	= BIT(5),
+	CEC_STAT_WAKEUP		= BIT(6),
+
+	HDMI_CEC_MASK		= 0x7d02,
+	HDMI_CEC_POLARITY	= 0x7d03,
+	HDMI_CEC_INT		= 0x7d04,
+	HDMI_CEC_ADDR_L		= 0x7d05,
+	HDMI_CEC_ADDR_H		= 0x7d06,
+	HDMI_CEC_TX_CNT		= 0x7d07,
+	HDMI_CEC_RX_CNT		= 0x7d08,
+	HDMI_CEC_TX_DATA0	= 0x7d10,
+	HDMI_CEC_RX_DATA0	= 0x7d20,
+	HDMI_CEC_LOCK		= 0x7d30,
+	HDMI_CEC_WKUPCTRL	= 0x7d31,
+};
+
+struct dw_hdmi_cec {
+	void __iomem *base;
+	u32 addresses;
+	struct cec_adapter *adap;
+	struct cec_msg rx_msg;
+	unsigned int tx_status;
+	bool tx_done;
+	bool rx_done;
+	const struct dw_hdmi_cec_ops *ops;
+	void *ops_data;
+	int retries;
+	int irq;
+	struct hdmi_notifier *n;
+	struct notifier_block nb;
+};
+
+static int dw_hdmi_cec_log_addr(struct cec_adapter *adap, u8 logical_addr)
+{
+	struct dw_hdmi_cec *cec = adap->priv;
+	u32 addresses;
+
+	if (logical_addr == CEC_LOG_ADDR_INVALID)
+		addresses = cec->addresses = BIT(15);
+	else
+		addresses = cec->addresses |= BIT(logical_addr);
+
+	writeb_relaxed(addresses & 255, cec->base + HDMI_CEC_ADDR_L);
+	writeb_relaxed(addresses >> 8, cec->base + HDMI_CEC_ADDR_H);
+
+	return 0;
+}
+
+static int dw_hdmi_cec_transmit(struct cec_adapter *adap, u8 attempts,
+				u32 signal_free_time, struct cec_msg *msg)
+{
+	struct dw_hdmi_cec *cec = adap->priv;
+	unsigned i;
+
+	cec->retries = attempts;
+
+	for (i = 0; i < msg->len; i++)
+		writeb_relaxed(msg->msg[i], cec->base + HDMI_CEC_TX_DATA0 + i);
+
+	writeb_relaxed(msg->len, cec->base + HDMI_CEC_TX_CNT);
+	writeb_relaxed(CEC_CTRL_NORMAL | CEC_CTRL_START, cec->base + HDMI_CEC_CTRL);
+
+	return 0;
+}
+
+static irqreturn_t dw_hdmi_cec_hardirq(int irq, void *data)
+{
+	struct cec_adapter *adap = data;
+	struct dw_hdmi_cec *cec = adap->priv;
+	unsigned stat = readb_relaxed(cec->base + HDMI_IH_CEC_STAT0);
+	irqreturn_t ret = IRQ_HANDLED;
+
+	if (stat == 0)
+		return IRQ_NONE;
+
+	writeb_relaxed(stat, cec->base + HDMI_IH_CEC_STAT0);
+
+	if (stat & CEC_STAT_ERROR_INIT) {
+		if (cec->retries) {
+			unsigned v = readb_relaxed(cec->base + HDMI_CEC_CTRL);
+			writeb_relaxed(v | CEC_CTRL_START, cec->base + HDMI_CEC_CTRL);
+			cec->retries -= 1;
+		} else {
+			cec->tx_status = CEC_TX_STATUS_MAX_RETRIES;
+			cec->tx_done = true;
+			ret = IRQ_WAKE_THREAD;
+		}
+	} else if (stat & CEC_STAT_DONE) {
+		cec->tx_status = CEC_TX_STATUS_OK;
+		cec->tx_done = true;
+		ret = IRQ_WAKE_THREAD;
+	} else if (stat & CEC_STAT_NACK) {
+		cec->tx_status = CEC_TX_STATUS_NACK;
+		cec->tx_done = true;
+		ret = IRQ_WAKE_THREAD;
+	}
+
+	if (stat & CEC_STAT_EOM) {
+		unsigned len, i;
+		void *base = cec->base;
+
+		len = readb_relaxed(base + HDMI_CEC_RX_CNT);
+		if (len > sizeof(cec->rx_msg.msg))
+			len = sizeof(cec->rx_msg.msg);
+
+		for (i = 0; i < len; i++)
+			cec->rx_msg.msg[i] =
+				readb_relaxed(base + HDMI_CEC_RX_DATA0 + i);
+
+		writeb_relaxed(0, base + HDMI_CEC_LOCK);
+
+		cec->rx_msg.len = len;
+		smp_wmb();
+		cec->rx_done = true;
+
+		ret = IRQ_WAKE_THREAD;
+	}
+
+	return ret;
+}
+
+static irqreturn_t dw_hdmi_cec_thread(int irq, void *data)
+{
+	struct cec_adapter *adap = data;
+	struct dw_hdmi_cec *cec = adap->priv;
+
+	if (cec->tx_done) {
+		cec->tx_done = false;
+		cec_transmit_done(adap, cec->tx_status, 0, 0, 0, 0);
+	}
+	if (cec->rx_done) {
+		cec->rx_done = false;
+		smp_rmb();
+		cec_received_msg(adap, &cec->rx_msg);
+	}
+	return IRQ_HANDLED;
+}
+
+static int dw_hdmi_cec_enable(struct cec_adapter *adap, bool enable)
+{
+	struct dw_hdmi_cec *cec = adap->priv;
+
+	if (!enable) {
+		writeb_relaxed(~0, cec->base + HDMI_CEC_MASK);
+		writeb_relaxed(~0, cec->base + HDMI_IH_MUTE_CEC_STAT0);
+		writeb_relaxed(0, cec->base + HDMI_CEC_POLARITY);
+
+		cec->ops->disable(cec->ops_data);
+	} else {
+		unsigned irqs;
+
+		writeb_relaxed(0, cec->base + HDMI_CEC_CTRL);
+		writeb_relaxed(~0, cec->base + HDMI_IH_CEC_STAT0);
+		writeb_relaxed(0, cec->base + HDMI_CEC_LOCK);
+
+		dw_hdmi_cec_log_addr(cec->adap, CEC_LOG_ADDR_INVALID);
+
+		cec->ops->enable(cec->ops_data);
+
+		irqs = CEC_STAT_ERROR_INIT | CEC_STAT_NACK | CEC_STAT_EOM |
+		       CEC_STAT_DONE;
+		writeb_relaxed(irqs, cec->base + HDMI_CEC_POLARITY);
+		writeb_relaxed(~irqs, cec->base + HDMI_CEC_MASK);
+		writeb_relaxed(~irqs, cec->base + HDMI_IH_MUTE_CEC_STAT0);
+	}
+	return 0;
+}
+
+static const struct cec_adap_ops dw_hdmi_cec_ops = {
+	.adap_enable = dw_hdmi_cec_enable,
+	.adap_log_addr = dw_hdmi_cec_log_addr,
+	.adap_transmit = dw_hdmi_cec_transmit,
+};
+
+static unsigned int parse_hdmi_addr(const struct edid *edid)
+{
+	if (!edid || edid->extensions == 0)
+		return (u16)~0;
+
+	return cec_get_edid_phys_addr((u8 *)edid,
+				EDID_LENGTH * (edid->extensions + 1), NULL);
+}
+
+static int dw_hdmi_cec_notify(struct notifier_block *nb, unsigned long event,
+			      void *data)
+{
+	struct dw_hdmi_cec *cec = container_of(nb, struct dw_hdmi_cec, nb);
+	struct hdmi_notifier *n = data;
+	unsigned int phys;
+
+	dev_info(cec->adap->devnode.parent, "event %lu\n", event);
+
+	switch (event) {
+	case HDMI_CONNECTED:
+		break;
+
+	case HDMI_DISCONNECTED:
+		cec_s_phys_addr(cec->adap, CEC_PHYS_ADDR_INVALID, false);
+		break;
+
+	case HDMI_NEW_EDID:
+		phys = parse_hdmi_addr(n->edid);
+		cec_s_phys_addr(cec->adap, phys, false);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static void dw_hdmi_cec_del(void *data)
+{
+	struct dw_hdmi_cec *cec = data;
+
+	cec_delete_adapter(cec->adap);
+}
+
+static int dw_hdmi_cec_probe(struct platform_device *pdev)
+{
+	struct dw_hdmi_cec_data *data = dev_get_platdata(&pdev->dev);
+	struct dw_hdmi_cec *cec;
+	int ret;
+
+	if (!data)
+		return -ENXIO;
+
+	/*
+	 * Our device is just a convenience - we want to link to the real
+	 * hardware device here, so that userspace can see the association
+	 * between the HDMI hardware and its associated CEC chardev.
+	 */
+	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
+	if (!cec)
+		return -ENOMEM;
+
+	cec->base = data->base;
+	cec->irq = data->irq;
+	cec->ops = data->ops;
+	cec->ops_data = data->ops_data;
+	cec->nb.notifier_call = dw_hdmi_cec_notify;
+
+	platform_set_drvdata(pdev, cec);
+
+	writeb_relaxed(0, cec->base + HDMI_CEC_TX_CNT);
+	writeb_relaxed(~0, cec->base + HDMI_CEC_MASK);
+	writeb_relaxed(~0, cec->base + HDMI_IH_MUTE_CEC_STAT0);
+	writeb_relaxed(0, cec->base + HDMI_CEC_POLARITY);
+
+	cec->adap = cec_allocate_adapter(&dw_hdmi_cec_ops, cec, "dw_hdmi",
+					 CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
+					 CEC_CAP_RC, CEC_MAX_LOG_ADDRS,
+					 pdev->dev.parent);
+	if (IS_ERR(cec->adap))
+		return PTR_ERR(cec->adap);
+
+	/* override the module pointer */
+	cec->adap->owner = THIS_MODULE;
+
+	ret = devm_add_action(&pdev->dev, dw_hdmi_cec_del, cec);
+	if (ret) {
+		cec_delete_adapter(cec->adap);
+		return ret;
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, cec->irq,
+					dw_hdmi_cec_hardirq,
+					dw_hdmi_cec_thread, IRQF_SHARED,
+					DEV_NAME, cec->adap);
+	if (ret < 0)
+		return ret;
+
+	ret = cec_register_adapter(cec->adap);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * CEC documentation says we must not call cec_delete_adapter
+	 * after a successful call to cec_register_adapter().
+	 */
+	devm_remove_action(&pdev->dev, dw_hdmi_cec_del, cec);
+
+	cec->n = hdmi_notifier_get(cec->adap->devnode.parent);
+	if (!cec->n)
+		return -ENOMEM;
+	hdmi_notifier_register(cec->n, &cec->nb);
+
+	return 0;
+}
+
+static int dw_hdmi_cec_remove(struct platform_device *pdev)
+{
+	struct dw_hdmi_cec *cec = platform_get_drvdata(pdev);
+
+	hdmi_notifier_unregister(cec->n, &cec->nb);
+	hdmi_notifier_put(cec->n);
+	cec_unregister_adapter(cec->adap);
+
+	return 0;
+}
+
+static struct platform_driver dw_hdmi_cec_driver = {
+	.probe	= dw_hdmi_cec_probe,
+	.remove	= dw_hdmi_cec_remove,
+	.driver = {
+		.name = "dw-hdmi-cec",
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(dw_hdmi_cec_driver);
+
+MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
+MODULE_DESCRIPTION("Synopsis Designware HDMI CEC driver for i.MX");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS(PLATFORM_MODULE_PREFIX "dw-hdmi-cec");
diff --git a/drivers/gpu/drm/bridge/dw-hdmi.c b/drivers/gpu/drm/bridge/dw-hdmi.c
index bd02da5..06191b4 100644
--- a/drivers/gpu/drm/bridge/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/dw-hdmi.c
@@ -19,6 +19,7 @@
 #include <linux/hdmi-notifier.h>
 #include <linux/mutex.h>
 #include <linux/of_device.h>
+#include <linux/platform_data/dw_hdmi-cec.h>
 #include <linux/spinlock.h>
 
 #include <drm/drm_of.h>
@@ -108,6 +109,7 @@ struct dw_hdmi {
 	struct drm_bridge *bridge;
 
 	struct platform_device *audio;
+	struct platform_device *cec;
 	enum dw_hdmi_devtype dev_type;
 	struct device *dev;
 	struct clk *isfr_clk;
@@ -120,6 +122,7 @@ struct dw_hdmi {
 	int vic;
 
 	u8 edid[HDMI_EDID_LEN];
+	u8 mc_clkdis;
 	bool cable_plugin;
 
 	bool phy_enabled;
@@ -1110,8 +1113,6 @@ static void dw_hdmi_phy_disable(struct dw_hdmi *hdmi)
 /* HDMI Initialization Step B.4 */
 static void dw_hdmi_enable_video_path(struct dw_hdmi *hdmi)
 {
-	u8 clkdis;
-
 	/* control period minimum duration */
 	hdmi_writeb(hdmi, 12, HDMI_FC_CTRLDUR);
 	hdmi_writeb(hdmi, 32, HDMI_FC_EXCTRLDUR);
@@ -1123,23 +1124,28 @@ static void dw_hdmi_enable_video_path(struct dw_hdmi *hdmi)
 	hdmi_writeb(hdmi, 0x21, HDMI_FC_CH2PREAM);
 
 	/* Enable pixel clock and tmds data path */
-	clkdis = 0x7F;
-	clkdis &= ~HDMI_MC_CLKDIS_PIXELCLK_DISABLE;
-	hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+	hdmi->mc_clkdis |= HDMI_MC_CLKDIS_HDCPCLK_DISABLE |
+			   HDMI_MC_CLKDIS_CSCCLK_DISABLE |
+			   HDMI_MC_CLKDIS_AUDCLK_DISABLE |
+			   HDMI_MC_CLKDIS_PREPCLK_DISABLE |
+			   HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_PIXELCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 
-	clkdis &= ~HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
-	hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_TMDSCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 
 	/* Enable csc path */
 	if (is_color_space_conversion(hdmi)) {
-		clkdis &= ~HDMI_MC_CLKDIS_CSCCLK_DISABLE;
-		hdmi_writeb(hdmi, clkdis, HDMI_MC_CLKDIS);
+		hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_CSCCLK_DISABLE;
+		hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 	}
 }
 
 static void hdmi_enable_audio_clk(struct dw_hdmi *hdmi)
 {
-	hdmi_modb(hdmi, 0, HDMI_MC_CLKDIS_AUDCLK_DISABLE, HDMI_MC_CLKDIS);
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_AUDCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
 }
 
 /* Workaround to clear the overflow condition */
@@ -1299,7 +1305,6 @@ static void initialize_hdmi_ih_mutes(struct dw_hdmi *hdmi)
 	hdmi_writeb(hdmi, 0xff, HDMI_AUD_HBR_MASK);
 	hdmi_writeb(hdmi, 0xff, HDMI_GP_MASK);
 	hdmi_writeb(hdmi, 0xff, HDMI_A_APIINTMSK);
-	hdmi_writeb(hdmi, 0xff, HDMI_CEC_MASK);
 	hdmi_writeb(hdmi, 0xff, HDMI_I2CM_INT);
 	hdmi_writeb(hdmi, 0xff, HDMI_I2CM_CTLINT);
 
@@ -1640,6 +1645,27 @@ static int dw_hdmi_register(struct drm_device *drm, struct dw_hdmi *hdmi)
 	return 0;
 }
 
+static void dw_hdmi_cec_enable(void *data)
+{
+	struct dw_hdmi *hdmi = data;
+
+	hdmi->mc_clkdis &= ~HDMI_MC_CLKDIS_CECCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
+}
+
+static void dw_hdmi_cec_disable(void *data)
+{
+	struct dw_hdmi *hdmi = data;
+
+	hdmi->mc_clkdis |= HDMI_MC_CLKDIS_CECCLK_DISABLE;
+	hdmi_writeb(hdmi, hdmi->mc_clkdis, HDMI_MC_CLKDIS);
+}
+
+static const struct dw_hdmi_cec_ops dw_hdmi_cec_ops = {
+	.enable = dw_hdmi_cec_enable,
+	.disable = dw_hdmi_cec_disable,
+};
+
 int dw_hdmi_bind(struct device *dev, struct device *master,
 		 void *data, struct drm_encoder *encoder,
 		 struct resource *iores, int irq,
@@ -1650,6 +1676,7 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
 	struct platform_device_info pdevinfo;
 	struct device_node *ddc_node;
 	struct dw_hdmi_audio_data audio;
+	struct dw_hdmi_cec_data cec;
 	struct dw_hdmi *hdmi;
 	int ret;
 	u32 val = 1;
@@ -1668,6 +1695,7 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
 	hdmi->disabled = true;
 	hdmi->rxsense = true;
 	hdmi->phy_mask = (u8)~(HDMI_PHY_HPD | HDMI_PHY_RX_SENSE);
+	hdmi->mc_clkdis = 0x7f;
 
 	mutex_init(&hdmi->mutex);
 	mutex_init(&hdmi->audio_mutex);
@@ -1800,6 +1828,18 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
 		hdmi->audio = platform_device_register_full(&pdevinfo);
 	}
 
+	cec.base = hdmi->regs;
+	cec.irq = irq;
+	cec.ops = &dw_hdmi_cec_ops;
+	cec.ops_data = hdmi;
+
+	pdevinfo.name = "dw-hdmi-cec";
+	pdevinfo.data = &cec;
+	pdevinfo.size_data = sizeof(cec);
+	pdevinfo.dma_mask = 0;
+
+	hdmi->cec = platform_device_register_full(&pdevinfo);
+
 	dev_set_drvdata(dev, hdmi);
 
 	return 0;
@@ -1821,6 +1861,8 @@ void dw_hdmi_unbind(struct device *dev, struct device *master, void *data)
 
 	if (hdmi->audio && !IS_ERR(hdmi->audio))
 		platform_device_unregister(hdmi->audio);
+	if (!IS_ERR(hdmi->cec))
+		platform_device_unregister(hdmi->cec);
 
 	hdmi_notifier_put(hdmi->n);
 
diff --git a/include/linux/platform_data/dw_hdmi-cec.h b/include/linux/platform_data/dw_hdmi-cec.h
new file mode 100644
index 0000000..5ff40cc
--- /dev/null
+++ b/include/linux/platform_data/dw_hdmi-cec.h
@@ -0,0 +1,16 @@
+#ifndef DW_HDMI_CEC_H
+#define DW_HDMI_CEC_H
+
+struct dw_hdmi_cec_ops {
+	void (*enable)(void *);
+	void (*disable)(void *);
+};
+
+struct dw_hdmi_cec_data {
+	void __iomem *base;
+	int irq;
+	const struct dw_hdmi_cec_ops *ops;
+	void *ops_data;
+};
+
+#endif
-- 
2.8.1

