Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:50964 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966698AbdDSRB2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 13:01:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] exynos_hdmi: improve MEDIA_CEC_NOTIFIER dependency
Date: Wed, 19 Apr 2017 19:00:19 +0200
Message-Id: <20170419170030.2869578-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the media subsystem is built as a loadable module, a built-in
DRM driver cannot use the cec notifiers:

drivers/gpu/drm/exynos/exynos_hdmi.o: In function `hdmi_get_modes':
exynos_hdmi.c:(.text.hdmi_get_modes+0x80): undefined reference to `cec_notifier_set_phys_addr_from_edid'
drivers/gpu/drm/exynos/exynos_hdmi.o: In function `hdmi_remove':
exynos_hdmi.c:(.text.hdmi_remove+0x24): undefined reference to `cec_notifier_set_phys_addr'
exynos_hdmi.c:(.text.hdmi_remove+0x38): undefined reference to `cec_notifier_put'

This adds a Kconfig dependency to enforce the HDMI driver to also
be a loadable module in this case.

Fixes: 278c811c5d05 ("[media] exynos_hdmi: add CEC notifier support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/exynos/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 1d185347c64c..65ba292f8e40 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -1,6 +1,7 @@
 config DRM_EXYNOS
 	tristate "DRM Support for Samsung SoC EXYNOS Series"
 	depends on OF && DRM && (ARCH_S3C64XX || ARCH_EXYNOS || ARCH_MULTIPLATFORM)
+	depends on (MEDIA_SUPPORT && MEDIA_CEC_NOTIFIER) || !MEDIA_CEC_NOTIFIER
 	select DRM_KMS_HELPER
 	select VIDEOMODE_HELPERS
 	help
-- 
2.9.0
