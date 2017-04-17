Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35179 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751854AbdDQKWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 06:22:43 -0400
From: Vincent Legoll <vincent.legoll@gmail.com>
To: linux-kernel@vger.kernel.org, sumit.semwal@linaro.org,
        daniel.vetter@intel.com, jani.nikula@linux.intel.com,
        seanpaul@chromium.org, airlied@linux.ie, robdclark@gmail.com,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org
Cc: Vincent Legoll <vincent.legoll@gmail.com>
Subject: [PATCH] Make DMABUF a menuconfig to ease disabling it all
Date: Mon, 17 Apr 2017 12:22:21 +0200
Message-Id: <20170417102221.5096-1-vincent.legoll@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to get into the submenu to disable all DMABUF-related config entries

Make the selecters also select the new DMABUF menuconfig

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
---
 drivers/dma-buf/Kconfig     | 7 ++++---
 drivers/gpu/drm/Kconfig     | 1 +
 drivers/gpu/drm/msm/Kconfig | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index ed3b785..ad5075f 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -1,8 +1,10 @@
-menu "DMABUF options"
+menuconfig DMABUF
+	bool "DMABUF options"
 
 config SYNC_FILE
 	bool "Explicit Synchronization Framework"
 	default n
+	depends on DMABUF
 	select ANON_INODES
 	select DMA_SHARED_BUFFER
 	---help---
@@ -20,6 +22,7 @@ config SYNC_FILE
 config SW_SYNC
 	bool "Sync File Validation Framework"
 	default n
+	depends on DMABUF
 	depends on SYNC_FILE
 	depends on DEBUG_FS
 	---help---
@@ -29,5 +32,3 @@ config SW_SYNC
 
 	  WARNING: improper use of this can result in deadlocking kernel
 	  drivers from userspace. Intended for test and debug only.
-
-endmenu
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 88e01e08e..c9c21c8 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -12,6 +12,7 @@ menuconfig DRM
 	select I2C
 	select I2C_ALGOBIT
 	select DMA_SHARED_BUFFER
+	select DMABUF
 	select SYNC_FILE
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
index 5b8e23d..fdc621b 100644
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@ -12,6 +12,7 @@ config DRM_MSM
 	select TMPFS
 	select QCOM_SCM
 	select SND_SOC_HDMI_CODEC if SND_SOC
+	select DMABUF
 	select SYNC_FILE
 	default y
 	help
-- 
2.9.3
