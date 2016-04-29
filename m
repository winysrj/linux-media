Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57446 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbcD2JjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 05:39:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: tomi.valkeinen@ti.com, dri-devel@lists.freedesktop.org
Subject: [RFC PATCH 1/3] drm/omap: fix OMAP4 hdmi_core_powerdown_disable()
Date: Fri, 29 Apr 2016 11:39:04 +0200
Message-Id: <1461922746-17521-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

hdmi_core_powerdown_disable() is supposed to disable HDMI core's
power-down mode. However, the function sets the power-down bit to 0,
which means "enable power-down".

This hasn't caused any issues as the PD seems to affect only interrupts
from HDMI core, and none of those interrupts are used at the moment. CEC
functionality requires core interrupts, and the PD mode needs to be
fixed.

This patch fixes hdmi_core_powerdown_disable() to actually disable the
PD mode.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
index fa72e73..ef3afe9 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
@@ -211,7 +211,7 @@ static void hdmi_core_init(struct hdmi_core_video_config *video_cfg)
 static void hdmi_core_powerdown_disable(struct hdmi_core_data *core)
 {
 	DSSDBG("Enter hdmi_core_powerdown_disable\n");
-	REG_FLD_MOD(core->base, HDMI_CORE_SYS_SYS_CTRL1, 0x0, 0, 0);
+	REG_FLD_MOD(core->base, HDMI_CORE_SYS_SYS_CTRL1, 0x1, 0, 0);
 }
 
 static void hdmi_core_swreset_release(struct hdmi_core_data *core)
-- 
2.8.1

