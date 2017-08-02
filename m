Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:60028 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752479AbdHBIyO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:54:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org, Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv2 5/9] omapdrm: hdmi4: move hdmi4_core_powerdown_disable to hdmi_power_on_core()
Date: Wed,  2 Aug 2017 10:54:04 +0200
Message-Id: <20170802085408.16204-6-hverkuil@xs4all.nl>
In-Reply-To: <20170802085408.16204-1-hverkuil@xs4all.nl>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Call hdmi4_core_powerdown_disable() in hdmi_power_on_core() to
power up the HDMI core (needed for CEC). The same call can now be dropped
in hdmi4_configure().

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4.c      | 2 ++
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.c | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
index eb9c6636f660..bf91cbef78c1 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
@@ -133,6 +133,8 @@ static int hdmi_power_on_core(struct omap_dss_device *dssdev)
 	if (r)
 		goto err_runtime_get;
 
+	hdmi4_core_powerdown_disable(&hdmi.core);
+
 	/* Make selection of HDMI in DSS */
 	dss_select_hdmi_venc_clk_source(DSS_HDMI_M_PCLK);
 
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
index b91244378ed1..ca3f2cf773d1 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
@@ -335,9 +335,6 @@ void hdmi4_configure(struct hdmi_core_data *core,
 	 */
 	hdmi_core_swreset_assert(core);
 
-	/* power down off */
-	hdmi4_core_powerdown_disable(core);
-
 	v_core_cfg.pkt_mode = HDMI_PACKETMODE24BITPERPIXEL;
 	v_core_cfg.hdmi_dvi = cfg->hdmi_dvi_mode;
 
-- 
2.13.2
