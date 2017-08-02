Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:36912 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752533AbdHBIyO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:54:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 6/9] omapdrm: hdmi4: refcount hdmi_power_on/off_core
Date: Wed,  2 Aug 2017 10:54:05 +0200
Message-Id: <20170802085408.16204-7-hverkuil@xs4all.nl>
In-Reply-To: <20170802085408.16204-1-hverkuil@xs4all.nl>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The hdmi_power_on/off_core functions can be called multiple times:
when the HPD changes and when the HDMI CEC support needs to power
the HDMI core.

So use a counter to know when to really power on or off the HDMI core.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
index bf91cbef78c1..166aa4df7688 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
@@ -125,9 +125,12 @@ static int hdmi_power_on_core(struct omap_dss_device *dssdev)
 {
 	int r;
 
+	if (hdmi.core.core_pwr_cnt++)
+		return 0;
+
 	r = regulator_enable(hdmi.vdda_reg);
 	if (r)
-		return r;
+		goto err_reg_enable;
 
 	r = hdmi_runtime_get();
 	if (r)
@@ -144,12 +147,17 @@ static int hdmi_power_on_core(struct omap_dss_device *dssdev)
 
 err_runtime_get:
 	regulator_disable(hdmi.vdda_reg);
+err_reg_enable:
+	hdmi.core.core_pwr_cnt--;
 
 	return r;
 }
 
 static void hdmi_power_off_core(struct omap_dss_device *dssdev)
 {
+	if (--hdmi.core.core_pwr_cnt)
+		return;
+
 	hdmi.core_enabled = false;
 
 	hdmi_runtime_put();
-- 
2.13.2
