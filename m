Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:50587 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751105AbdKTLmW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 06:42:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Carlos Santa <carlos.santa@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 1/3] drm: add support for DisplayPort CEC-Tunneling-over-AUX
Date: Mon, 20 Nov 2017 12:42:09 +0100
Message-Id: <20171120114211.21825-2-hverkuil@xs4all.nl>
In-Reply-To: <20171120114211.21825-1-hverkuil@xs4all.nl>
References: <20171120114211.21825-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This adds support for the DisplayPort CEC-Tunneling-over-AUX
feature that is part of the DisplayPort 1.3 standard.

Unfortunately, not all DisplayPort/USB-C to HDMI adapters with a
chip that has this capability actually hook up the CEC pin, so
even though a CEC device is created, it may not actually work.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v4:

- Updated comment at the start of drm_dp_cec.c
- Add edid pointer to drm_dp_cec_configure_adapter
---
 drivers/gpu/drm/Kconfig      |  10 ++
 drivers/gpu/drm/Makefile     |   1 +
 drivers/gpu/drm/drm_dp_cec.c | 304 +++++++++++++++++++++++++++++++++++++++++++
 include/drm/drm_dp_helper.h  |  27 ++++
 4 files changed, 342 insertions(+)
 create mode 100644 drivers/gpu/drm/drm_dp_cec.c

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 83cb2a88c204..1f2708df5c4e 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -120,6 +120,16 @@ config DRM_LOAD_EDID_FIRMWARE
 	  default case is N. Details and instructions how to build your own
 	  EDID data are given in Documentation/EDID/HOWTO.txt.
 
+config DRM_DP_CEC
+	bool "Enable DisplayPort CEC-Tunneling-over-AUX HDMI support"
+	select CEC_CORE
+	help
+	  Choose this option if you want to enable HDMI CEC support for
+	  DisplayPort/USB-C to HDMI adapters.
+
+	  Note: not all adapters support this feature, and even for those
+	  that do support this they often do not hook up the CEC pin.
+
 config DRM_TTM
 	tristate
 	depends on DRM && MMU
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 8ce07039bb89..6f0cd526703e 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -41,6 +41,7 @@ drm_kms_helper-$(CONFIG_DRM_LOAD_EDID_FIRMWARE) += drm_edid_load.o
 drm_kms_helper-$(CONFIG_DRM_FBDEV_EMULATION) += drm_fb_helper.o
 drm_kms_helper-$(CONFIG_DRM_KMS_CMA_HELPER) += drm_fb_cma_helper.o
 drm_kms_helper-$(CONFIG_DRM_DP_AUX_CHARDEV) += drm_dp_aux_dev.o
+drm_kms_helper-$(CONFIG_DRM_DP_CEC) += drm_dp_cec.o
 
 obj-$(CONFIG_DRM_KMS_HELPER) += drm_kms_helper.o
 obj-$(CONFIG_DRM_DEBUG_MM_SELFTEST) += selftests/
diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
new file mode 100644
index 000000000000..e72051bfa18c
--- /dev/null
+++ b/drivers/gpu/drm/drm_dp_cec.c
@@ -0,0 +1,304 @@
+/*
+ * DisplayPort CEC-Tunneling-over-AUX support
+ *
+ * Copyright 2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <drm/drm_dp_helper.h>
+#include <media/cec.h>
+
+/*
+ * Unfortunately it turns out that we have a chicken-and-egg situation
+ * here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
+ * have a converter chip that supports CEC-Tunneling-over-AUX (usually the
+ * Parade PS176 or MegaChips MCDP2900), but they do not wire up the CEC pin,
+ * thus making CEC useless.
+ *
+ * Sadly there is no way for this driver to know this. What happens is
+ * that a /dev/cecX device is created that is isolated and unable to see
+ * any of the other CEC devices. Quite literally the CEC wire is cut
+ * (or in this case, never connected in the first place).
+ *
+ * I suspect that the reason so few adapters support this is that this
+ * tunneling protocol was never supported by any OS. So there was no
+ * easy way of testing it, and no incentive to correctly wire up the
+ * CEC pin.
+ *
+ * Hopefully by creating this driver it will be easier for vendors to
+ * finally fix their adapters and test the CEC functionality.
+ *
+ * I keep a list of known working adapters here:
+ *
+ * https://hverkuil.home.xs4all.nl/cec-status.txt
+ *
+ * Please mail me (hverkuil@xs4all.nl) if you find an adapter that works
+ * and is not yet listed there.
+ *
+ * Note that the current implementation does not support CEC over an MST hub.
+ * As far as I can see there is no mechanism defined in the DisplayPort
+ * standard to transport CEC interrupts over an MST device. It might be
+ * possible to do this through polling, but I have not been able to get that
+ * to work.
+ */
+
+/**
+ * DOC: dp cec helpers
+ *
+ * These functions take care of supporting the CEC-Tunneling-over-AUX
+ * feature of DisplayPort-to-HDMI adapters.
+ */
+
+static int drm_dp_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct drm_dp_aux *aux = cec_get_drvdata(adap);
+	u32 val = enable ? DP_CEC_TUNNELING_ENABLE : 0;
+	ssize_t err = 0;
+
+	err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL, val);
+	return (enable && err < 0) ? err : 0;
+}
+
+static int drm_dp_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
+{
+	struct drm_dp_aux *aux = cec_get_drvdata(adap);
+	/* Bit 15 (logical address 15) should always be set */
+	u16 la_mask = 1 << CEC_LOG_ADDR_BROADCAST;
+	u8 mask[2];
+	ssize_t err;
+
+	if (addr != CEC_LOG_ADDR_INVALID)
+		la_mask |= adap->log_addrs.log_addr_mask | (1 << addr);
+	mask[0] = la_mask & 0xff;
+	mask[1] = la_mask >> 8;
+	err = drm_dp_dpcd_write(aux, DP_CEC_LOGICAL_ADDRESS_MASK, mask, 2);
+	return (addr != CEC_LOG_ADDR_INVALID && err < 0) ? err : 0;
+}
+
+static int drm_dp_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				    u32 signal_free_time, struct cec_msg *msg)
+{
+	struct drm_dp_aux *aux = cec_get_drvdata(adap);
+	unsigned int retries = min(5, attempts - 1);
+	ssize_t err;
+
+	err = drm_dp_dpcd_write(aux, DP_CEC_TX_MESSAGE_BUFFER,
+				msg->msg, msg->len);
+	if (err < 0)
+		return err;
+
+	err = drm_dp_dpcd_writeb(aux, DP_CEC_TX_MESSAGE_INFO,
+				 (msg->len - 1) | (retries << 4) |
+				 DP_CEC_TX_MESSAGE_SEND);
+	return err < 0 ? err : 0;
+}
+
+static int drm_dp_cec_adap_monitor_all_enable(struct cec_adapter *adap,
+					      bool enable)
+{
+	struct drm_dp_aux *aux = cec_get_drvdata(adap);
+	ssize_t err;
+	u8 val;
+
+	if (!(adap->capabilities & CEC_CAP_MONITOR_ALL))
+		return 0;
+
+	err = drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_CONTROL, &val);
+	if (err >= 0) {
+		if (enable)
+			val |= DP_CEC_SNOOPING_ENABLE;
+		else
+			val &= ~DP_CEC_SNOOPING_ENABLE;
+		err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL, val);
+	}
+	return (enable && err < 0) ? err : 0;
+}
+
+static void drm_dp_cec_adap_status(struct cec_adapter *adap,
+				   struct seq_file *file)
+{
+	struct drm_dp_aux *aux = cec_get_drvdata(adap);
+	struct drm_dp_desc desc;
+	struct drm_dp_dpcd_ident *id = &desc.ident;
+
+	if (drm_dp_read_desc(aux, &desc, true))
+		return;
+	seq_printf(file, "OUI: %*pdH\n",
+		   (int)sizeof(id->oui), id->oui);
+	seq_printf(file, "ID: %*pE\n",
+		   (int)strnlen(id->device_id, sizeof(id->device_id)),
+		   id->device_id);
+	seq_printf(file, "HW Rev: %d.%d\n", id->hw_rev >> 4, id->hw_rev & 0xf);
+	/*
+	 * Show this both in decimal and hex: at least one vendor
+	 * always reports this in hex.
+	 */
+	seq_printf(file, "FW/SW Rev: %d.%d (0x%02x.0x%02x)\n",
+		   id->sw_major_rev, id->sw_minor_rev,
+		   id->sw_major_rev, id->sw_minor_rev);
+}
+
+static const struct cec_adap_ops drm_dp_cec_adap_ops = {
+	.adap_enable = drm_dp_cec_adap_enable,
+	.adap_log_addr = drm_dp_cec_adap_log_addr,
+	.adap_transmit = drm_dp_cec_adap_transmit,
+	.adap_monitor_all_enable = drm_dp_cec_adap_monitor_all_enable,
+	.adap_status = drm_dp_cec_adap_status,
+};
+
+static int drm_dp_cec_received(struct drm_dp_aux *aux)
+{
+	struct cec_adapter *adap = aux->cec_adap;
+	struct cec_msg msg;
+	u8 rx_msg_info;
+	ssize_t err;
+
+	err = drm_dp_dpcd_readb(aux, DP_CEC_RX_MESSAGE_INFO, &rx_msg_info);
+	if (err < 0)
+		return err;
+
+	if (!(rx_msg_info & DP_CEC_RX_MESSAGE_ENDED))
+		return 0;
+
+	msg.len = (rx_msg_info & DP_CEC_RX_MESSAGE_LEN_MASK) + 1;
+	err = drm_dp_dpcd_read(aux, DP_CEC_RX_MESSAGE_BUFFER, msg.msg, msg.len);
+	if (err < 0)
+		return err;
+
+	cec_received_msg(adap, &msg);
+	return 0;
+}
+
+static bool drm_dp_cec_handle_irq(struct drm_dp_aux *aux)
+{
+	struct cec_adapter *adap = aux->cec_adap;
+	u8 flags;
+
+	if (drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_IRQ_FLAGS, &flags) < 0)
+		return false;
+
+	if (flags & DP_CEC_RX_MESSAGE_INFO_VALID)
+		drm_dp_cec_received(aux);
+
+	if (flags & DP_CEC_TX_MESSAGE_SENT)
+		cec_transmit_attempt_done(adap, CEC_TX_STATUS_OK);
+	else if (flags & DP_CEC_TX_LINE_ERROR)
+		cec_transmit_attempt_done(adap, CEC_TX_STATUS_ERROR |
+						CEC_TX_STATUS_MAX_RETRIES);
+	else if (flags &
+		 (DP_CEC_TX_ADDRESS_NACK_ERROR | DP_CEC_TX_DATA_NACK_ERROR))
+		cec_transmit_attempt_done(adap, CEC_TX_STATUS_NACK |
+						CEC_TX_STATUS_MAX_RETRIES);
+	drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_IRQ_FLAGS, flags);
+	return true;
+}
+
+/**
+ * drm_dp_cec_irq() - handle CEC interrupt, if any
+ * @aux: DisplayPort AUX channel
+ *
+ * Should be called when handling an IRQ_HPD request. If CEC-tunneling-over-AUX
+ * is present, then it will check for a CEC_IRQ and handle it accordingly.
+ *
+ * Returns true if an interrupt was handled successfully or false otherwise.
+ */
+bool drm_dp_cec_irq(struct drm_dp_aux *aux)
+{
+	bool handled;
+	u8 cec_irq;
+	int ret;
+
+	if (!aux->cec_adap)
+		return false;
+
+	ret = drm_dp_dpcd_readb(aux, DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
+				&cec_irq);
+	if (ret < 0 || !(cec_irq & DP_CEC_IRQ))
+		return false;
+
+	handled = drm_dp_cec_handle_irq(aux);
+	drm_dp_dpcd_writeb(aux, DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1, DP_CEC_IRQ);
+	return handled;
+}
+EXPORT_SYMBOL(drm_dp_cec_irq);
+
+/**
+ * drm_dp_cec_configure_adapter() - configure the CEC adapter
+ * @aux: DisplayPort AUX channel
+ * @name: name of the CEC adapter
+ * @parent: parent device
+ * @edid: initial EDID, may be NULL (== invalid physical address)
+ *
+ * Checks if this is a DisplayPort-to-HDMI adapter that supports
+ * CEC-tunneling-over-AUX, and if so it creates a CEC adapter.
+ *
+ * If a CEC adapter was already created, then check if the capabilities
+ * have changed. If not, then only update the EDID for the existing
+ * CEC adapter. Otherwise destroy the old CEC adapter (if any) and create
+ * a new CEC adapter and set the initial EDID for that adapter.
+ *
+ * This can happen when one DP-to-HDMI adapter is disconnected and
+ * replaced by another adapter with different CEC capabilities.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux, const char *name,
+				 struct device *parent, const struct edid *edid)
+{
+	u32 cec_caps = CEC_CAP_DEFAULTS | CEC_CAP_NEEDS_HPD;
+	unsigned int num_las = 1;
+	int err;
+	u8 cap;
+
+	if (drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_CAPABILITY, &cap) != 1 ||
+	    !(cap & DP_CEC_TUNNELING_CAPABLE)) {
+		cec_unregister_adapter(aux->cec_adap);
+		aux->cec_adap = NULL;
+		return -ENODEV;
+	}
+
+	if (cap & DP_CEC_SNOOPING_CAPABLE)
+		cec_caps |= CEC_CAP_MONITOR_ALL;
+	if (cap & DP_CEC_MULTIPLE_LA_CAPABLE)
+		num_las = CEC_MAX_LOG_ADDRS;
+
+	if (aux->cec_adap) {
+		if (aux->cec_adap->capabilities == cec_caps &&
+		    aux->cec_adap->available_log_addrs == num_las) {
+			cec_s_phys_addr_from_edid(aux->cec_adap, edid);
+			return 0;
+		}
+		cec_unregister_adapter(aux->cec_adap);
+	}
+
+	aux->cec_adap = cec_allocate_adapter(&drm_dp_cec_adap_ops,
+			 aux, name, cec_caps, num_las);
+	if (IS_ERR(aux->cec_adap)) {
+		err = PTR_ERR(aux->cec_adap);
+		aux->cec_adap = NULL;
+		return err;
+	}
+	err = cec_register_adapter(aux->cec_adap, parent);
+	if (err) {
+		cec_delete_adapter(aux->cec_adap);
+		aux->cec_adap = NULL;
+	}
+	cec_s_phys_addr_from_edid(aux->cec_adap, edid);
+	return err;
+}
+EXPORT_SYMBOL(drm_dp_cec_configure_adapter);
diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
index b17476a6909c..9bac0c47f62b 100644
--- a/include/drm/drm_dp_helper.h
+++ b/include/drm/drm_dp_helper.h
@@ -952,6 +952,9 @@ struct drm_dp_aux_msg {
 	size_t size;
 };
 
+struct cec_adapter;
+struct edid;
+
 /**
  * struct drm_dp_aux - DisplayPort AUX channel
  * @name: user-visible name of this AUX channel and the I2C-over-AUX adapter
@@ -1010,6 +1013,10 @@ struct drm_dp_aux {
 	 * @i2c_defer_count: Counts I2C DEFERs, used for DP validation.
 	 */
 	unsigned i2c_defer_count;
+	/**
+	 * @cec_adap: the CEC adapter for CEC-Tunneling-over-AUX support.
+	 */
+	struct cec_adapter *cec_adap;
 };
 
 ssize_t drm_dp_dpcd_read(struct drm_dp_aux *aux, unsigned int offset,
@@ -1132,4 +1139,24 @@ drm_dp_has_quirk(const struct drm_dp_desc *desc, enum drm_dp_quirk quirk)
 	return desc->quirks & BIT(quirk);
 }
 
+#ifdef CONFIG_DRM_DP_CEC
+bool drm_dp_cec_irq(struct drm_dp_aux *aux);
+int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux, const char *name,
+				 struct device *parent,
+				 const struct edid *edid);
+#else
+static inline bool drm_dp_cec_irq(struct drm_dp_aux *aux)
+{
+	return false;
+}
+
+static inline int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux,
+					       const char *name,
+					       struct device *parent,
+					       const struct edid *edid)
+{
+	return -ENODEV;
+}
+#endif
+
 #endif /* _DRM_DP_HELPER_H_ */
-- 
2.14.1
