Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35752 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdHXI6c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 04:58:32 -0400
From: Maciej Purski <m.purski@samsung.com>
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, sean@mess.org,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, b.zolnierkie@samsung.com,
        Maciej Purski <m.purski@samsung.com>
Subject: [PATCH v4] drm/bridge/sii8620: add remote control support
Date: Thu, 24 Aug 2017 10:58:07 +0200
Message-id: <1503565087-19730-1-git-send-email-m.purski@samsung.com>
References: <CGME20170824085828eucas1p1b3d00ffc06f14cf7c8b9fe84a8f7a0c9@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MHL specification defines Remote Control Protocol(RCP) to
send input events between MHL devices.
The driver now recognizes RCP messages and reacts to them
by reporting key events to input subsystem, allowing
a user to control a device using TV remote control.

Signed-off-by: Maciej Purski <m.purski@samsung.com>
---

Changes in v2:
- use RC subsystem (including CEC keymap)
- RC device initialized in attach drm_bridge callback and
  removed in detach callback. This is necessary, because RC_CORE,
  which is needed during rc_dev init, is loaded after sii8620.
  DRM bridge is binded later which solves the problem.
- add RC_CORE dependency

Changes in v3:
- fix error handling in init_rcp and in attach callback

Changes in v4:
- usage of rc-core API compatible with upcoming changes
- fix error handling in init_rcp
- fix commit message
---
 drivers/gpu/drm/bridge/Kconfig       |  2 +-
 drivers/gpu/drm/bridge/sil-sii8620.c | 96 ++++++++++++++++++++++++++++++++++--
 include/drm/bridge/mhl.h             |  4 ++
 3 files changed, 96 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index adf9ae0..6ef901c 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -71,7 +71,7 @@ config DRM_PARADE_PS8622
 
 config DRM_SIL_SII8620
 	tristate "Silicon Image SII8620 HDMI/MHL bridge"
-	depends on OF
+	depends on OF && RC_CORE
 	select DRM_KMS_HELPER
 	help
 	  Silicon Image SII8620 HDMI/MHL bridge chip driver.
diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
index 2d51a22..ecb26c4 100644
--- a/drivers/gpu/drm/bridge/sil-sii8620.c
+++ b/drivers/gpu/drm/bridge/sil-sii8620.c
@@ -28,6 +28,8 @@
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 
+#include <media/rc-core.h>
+
 #include "sil-sii8620.h"
 
 #define SII8620_BURST_BUF_LEN 288
@@ -58,6 +60,7 @@ enum sii8620_mt_state {
 struct sii8620 {
 	struct drm_bridge bridge;
 	struct device *dev;
+	struct rc_dev *rc_dev;
 	struct clk *clk_xtal;
 	struct gpio_desc *gpio_reset;
 	struct gpio_desc *gpio_int;
@@ -431,6 +434,16 @@ static void sii8620_mt_rap(struct sii8620 *ctx, u8 code)
 	sii8620_mt_msc_msg(ctx, MHL_MSC_MSG_RAP, code);
 }
 
+static void sii8620_mt_rcpk(struct sii8620 *ctx, u8 code)
+{
+	sii8620_mt_msc_msg(ctx, MHL_MSC_MSG_RCPK, code);
+}
+
+static void sii8620_mt_rcpe(struct sii8620 *ctx, u8 code)
+{
+	sii8620_mt_msc_msg(ctx, MHL_MSC_MSG_RCPE, code);
+}
+
 static void sii8620_mt_read_devcap_send(struct sii8620 *ctx,
 					struct sii8620_mt_msg *msg)
 {
@@ -1753,6 +1766,25 @@ static void sii8620_send_features(struct sii8620 *ctx)
 	sii8620_write_buf(ctx, REG_MDT_XMIT_WRITE_PORT, buf, ARRAY_SIZE(buf));
 }
 
+static bool sii8620_rcp_consume(struct sii8620 *ctx, u8 scancode)
+{
+	bool pressed = !(scancode & MHL_RCP_KEY_RELEASED_MASK);
+
+	scancode &= MHL_RCP_KEY_ID_MASK;
+
+	if (!ctx->rc_dev) {
+		dev_dbg(ctx->dev, "RCP input device not initialized\n");
+		return false;
+	}
+
+	if (pressed)
+		rc_keydown(ctx->rc_dev, RC_PROTO_CEC, scancode, 0);
+	else
+		rc_keyup(ctx->rc_dev);
+
+	return true;
+}
+
 static void sii8620_msc_mr_set_int(struct sii8620 *ctx)
 {
 	u8 ints[MHL_INT_SIZE];
@@ -1804,19 +1836,25 @@ static void sii8620_msc_mt_done(struct sii8620 *ctx)
 
 static void sii8620_msc_mr_msc_msg(struct sii8620 *ctx)
 {
-	struct sii8620_mt_msg *msg = sii8620_msc_msg_first(ctx);
+	struct sii8620_mt_msg *msg;
 	u8 buf[2];
 
-	if (!msg)
-		return;
-
 	sii8620_read_buf(ctx, REG_MSC_MR_MSC_MSG_RCVD_1ST_DATA, buf, 2);
 
 	switch (buf[0]) {
 	case MHL_MSC_MSG_RAPK:
+		msg = sii8620_msc_msg_first(ctx);
+		if (!msg)
+			return;
 		msg->ret = buf[1];
 		ctx->mt_state = MT_STATE_DONE;
 		break;
+	case MHL_MSC_MSG_RCP:
+		if (!sii8620_rcp_consume(ctx, buf[1]))
+			sii8620_mt_rcpe(ctx,
+					MHL_RCPE_STATUS_INEFFECTIVE_KEY_CODE);
+		sii8620_mt_rcpk(ctx, buf[1]);
+		break;
 	default:
 		dev_err(ctx->dev, "%s message type %d,%d not supported",
 			__func__, buf[0], buf[1]);
@@ -2102,11 +2140,57 @@ static void sii8620_cable_in(struct sii8620 *ctx)
 	enable_irq(to_i2c_client(ctx->dev)->irq);
 }
 
+static void sii8620_init_rcp_input_dev(struct sii8620 *ctx)
+{
+	struct rc_dev *rc_dev;
+	int ret;
+
+	rc_dev = rc_allocate_device(RC_DRIVER_SCANCODE);
+	if (!rc_dev) {
+		dev_err(ctx->dev, "Failed to allocate RC device\n");
+		ctx->error = -ENOMEM;
+		return;
+	}
+
+	rc_dev->input_phys = "sii8620/input0";
+	rc_dev->input_id.bustype = BUS_VIRTUAL;
+	rc_dev->map_name = RC_MAP_CEC;
+	rc_dev->allowed_protocols = RC_PROTO_BIT_CEC;
+	rc_dev->driver_name = "sii8620";
+	rc_dev->device_name = "sii8620";
+
+	ret = rc_register_device(rc_dev);
+
+	if (ret) {
+		dev_err(ctx->dev, "Failed to register RC device\n");
+		ctx->error = ret;
+		rc_free_device(ctx->rc_dev);
+		return;
+	}
+	ctx->rc_dev = rc_dev;
+}
+
 static inline struct sii8620 *bridge_to_sii8620(struct drm_bridge *bridge)
 {
 	return container_of(bridge, struct sii8620, bridge);
 }
 
+static int sii8620_attach(struct drm_bridge *bridge)
+{
+	struct sii8620 *ctx = bridge_to_sii8620(bridge);
+
+	sii8620_init_rcp_input_dev(ctx);
+
+	return sii8620_clear_error(ctx);
+}
+
+static void sii8620_detach(struct drm_bridge *bridge)
+{
+	struct sii8620 *ctx = bridge_to_sii8620(bridge);
+
+	rc_unregister_device(ctx->rc_dev);
+}
+
 static bool sii8620_mode_fixup(struct drm_bridge *bridge,
 			       const struct drm_display_mode *mode,
 			       struct drm_display_mode *adjusted_mode)
@@ -2151,6 +2235,8 @@ static bool sii8620_mode_fixup(struct drm_bridge *bridge,
 }
 
 static const struct drm_bridge_funcs sii8620_bridge_funcs = {
+	.attach = sii8620_attach,
+	.detach = sii8620_detach,
 	.mode_fixup = sii8620_mode_fixup,
 };
 
@@ -2217,8 +2303,8 @@ static int sii8620_remove(struct i2c_client *client)
 	struct sii8620 *ctx = i2c_get_clientdata(client);
 
 	disable_irq(to_i2c_client(ctx->dev)->irq);
-	drm_bridge_remove(&ctx->bridge);
 	sii8620_hw_off(ctx);
+	drm_bridge_remove(&ctx->bridge);
 
 	return 0;
 }
diff --git a/include/drm/bridge/mhl.h b/include/drm/bridge/mhl.h
index fbdfc8d..96a5e0f 100644
--- a/include/drm/bridge/mhl.h
+++ b/include/drm/bridge/mhl.h
@@ -262,6 +262,10 @@ enum {
 #define MHL_RAPK_UNSUPPORTED	0x02	/* Rcvd RAP action code not supported */
 #define MHL_RAPK_BUSY		0x03	/* Responder too busy to respond */
 
+/* Bit masks for RCP messages */
+#define MHL_RCP_KEY_RELEASED_MASK	0x80
+#define MHL_RCP_KEY_ID_MASK		0x7F
+
 /*
  * Error status codes for RCPE messages
  */
-- 
2.7.4
