Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:64672 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966966AbdDSRAY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 13:00:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Vincent Abriou <vincent.abriou@st.com>,
        David Airlie <airlied@linux.ie>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] sti: hdmi: improve MEDIA_CEC_NOTIFIER dependency
Date: Wed, 19 Apr 2017 18:59:23 +0200
Message-Id: <20170419165936.2836426-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the media subsystem is built as a loadable module, a built-in
DRM driver cannot use the cec notifiers:

drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_remove':
sti_hdmi.c:(.text.sti_hdmi_remove+0x28): undefined reference to `cec_notifier_set_phys_addr'
sti_hdmi.c:(.text.sti_hdmi_remove+0x50): undefined reference to `cec_notifier_put'
drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_connector_get_modes':
sti_hdmi.c:(.text.sti_hdmi_connector_get_modes+0x84): undefined reference to `cec_notifier_set_phys_addr_from_edid'
drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_probe':
sti_hdmi.c:(.text.sti_hdmi_probe+0x1a8): undefined reference to `cec_notifier_get'
drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_connector_detect':
sti_hdmi.c:(.text.sti_hdmi_connector_detect+0x68): undefined reference to `cec_notifier_set_phys_addr'
drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_disable':
sti_hdmi.c:(.text.sti_hdmi_disable+0xec): undefined reference to `cec_notifier_set_phys_addr'

This adds a Kconfig dependency to enforce the HDMI driver to also
be a loadable module in this case.

Fixes: bca55958ea87 ("[media] sti: hdmi: add CEC notifier support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/sti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
index acd72865feac..adac4c3e142e 100644
--- a/drivers/gpu/drm/sti/Kconfig
+++ b/drivers/gpu/drm/sti/Kconfig
@@ -1,6 +1,7 @@
 config DRM_STI
 	tristate "DRM Support for STMicroelectronics SoC stiH4xx Series"
 	depends on DRM && (ARCH_STI || ARCH_MULTIPLATFORM)
+	depends on (MEDIA_SUPPORT && MEDIA_CEC_NOTIFIER) || !MEDIA_CEC_NOTIFIER
 	select RESET_CONTROLLER
 	select DRM_KMS_HELPER
 	select DRM_GEM_CMA_HELPER
-- 
2.9.0
