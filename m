Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:40017 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752369AbdHBIyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:54:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/9] omapdrm: hdmi.h: extend hdmi_core_data with CEC fields
Date: Wed,  2 Aug 2017 10:54:01 +0200
Message-Id: <20170802085408.16204-3-hverkuil@xs4all.nl>
In-Reply-To: <20170802085408.16204-1-hverkuil@xs4all.nl>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Extend the hdmi_core_data struct with the additional fields needed
for CEC.

Also fix a simple typo in a comment.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/hdmi.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi.h b/drivers/gpu/drm/omapdrm/dss/hdmi.h
index fb6cccd02374..3913859146b9 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi.h
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi.h
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/hdmi.h>
 #include <sound/omap-hdmi-audio.h>
+#include <media/cec.h>
 
 #include "omapdss.h"
 #include "dss.h"
@@ -254,6 +255,9 @@ struct hdmi_phy_data {
 
 struct hdmi_core_data {
 	void __iomem *base;
+	struct hdmi_wp_data *wp;
+	unsigned int core_pwr_cnt;
+	struct cec_adapter *adap;
 };
 
 static inline void hdmi_write_reg(void __iomem *base_addr, const u32 idx,
@@ -361,7 +365,7 @@ struct omap_hdmi {
 	bool audio_configured;
 	struct omap_dss_audio audio_config;
 
-	/* This lock should be taken when booleans bellow are touched. */
+	/* This lock should be taken when booleans below are touched. */
 	spinlock_t audio_playing_lock;
 	bool audio_playing;
 	bool display_enabled;
-- 
2.13.2
