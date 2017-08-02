Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56373 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752396AbdHBIyO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:54:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 4/9] omapdrm: hdmi4: prepare irq handling for HDMI CEC support
Date: Wed,  2 Aug 2017 10:54:03 +0200
Message-Id: <20170802085408.16204-5-hverkuil@xs4all.nl>
In-Reply-To: <20170802085408.16204-1-hverkuil@xs4all.nl>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Pass struct omap_hdmi to the irq handler since it will need access
to hdmi.core.

Do not clear the IRQ_HDMI_CORE bit: that will be controlled by the
HDMI CEC code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
index 99af926ca0f5..eb9c6636f660 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
@@ -71,7 +71,8 @@ static void hdmi_runtime_put(void)
 
 static irqreturn_t hdmi_irq_handler(int irq, void *data)
 {
-	struct hdmi_wp_data *wp = data;
+	struct omap_hdmi *hdmi = data;
+	struct hdmi_wp_data *wp = &hdmi->wp;
 	u32 irqstatus;
 
 	irqstatus = hdmi_wp_get_irqstatus(wp);
@@ -167,8 +168,8 @@ static int hdmi_power_on_full(struct omap_dss_device *dssdev)
 		return r;
 
 	/* disable and clear irqs */
-	hdmi_wp_clear_irqenable(wp, 0xffffffff);
-	hdmi_wp_set_irqstatus(wp, 0xffffffff);
+	hdmi_wp_clear_irqenable(wp, ~HDMI_IRQ_CORE);
+	hdmi_wp_set_irqstatus(wp, ~HDMI_IRQ_CORE);
 
 	vm = &hdmi.cfg.vm;
 
@@ -243,7 +244,7 @@ static void hdmi_power_off_full(struct omap_dss_device *dssdev)
 {
 	enum omap_channel channel = dssdev->dispc_channel;
 
-	hdmi_wp_clear_irqenable(&hdmi.wp, 0xffffffff);
+	hdmi_wp_clear_irqenable(&hdmi.wp, ~HDMI_IRQ_CORE);
 
 	hdmi_wp_video_stop(&hdmi.wp);
 
@@ -725,7 +726,7 @@ static int hdmi4_bind(struct device *dev, struct device *master, void *data)
 
 	r = devm_request_threaded_irq(&pdev->dev, irq,
 			NULL, hdmi_irq_handler,
-			IRQF_ONESHOT, "OMAP HDMI", &hdmi.wp);
+			IRQF_ONESHOT, "OMAP HDMI", &hdmi);
 	if (r) {
 		DSSERR("HDMI IRQ request failed\n");
 		goto err;
-- 
2.13.2
