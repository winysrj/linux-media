Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:32953 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdF0GnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 02:43:14 -0400
Received: by mail-pg0-f48.google.com with SMTP id f127so11199860pgc.0
        for <linux-media@vger.kernel.org>; Mon, 26 Jun 2017 23:43:13 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Pallardy <loic.pallardy@st.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-remoteproc@vger.kernel.org
Subject: [PATCH] rpmsg: Solve circular dependencies involving RPMSG_VIRTIO
Date: Mon, 26 Jun 2017 23:43:09 -0700
Message-Id: <20170627064309.16507-1-bjorn.andersson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While it's very common to use RPMSG for communicating with firmware
running on these remoteprocs there is no functional dependency on RPMSG.
As such RPMSG should be selected by the system integrator and not
automatically by the remoteproc drivers.

This does solve problems reported with circular Kconfig dependencies for
Davinci and Keystone remoteproc drivers.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/media/platform/Kconfig |  2 +-
 drivers/remoteproc/Kconfig     |  4 ----
 drivers/rpmsg/Kconfig          | 20 +++++++++-----------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 1313cd533436..cb2f31cd0088 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -382,10 +382,10 @@ config VIDEO_STI_DELTA_DRIVER
 	tristate
 	depends on VIDEO_STI_DELTA
 	depends on VIDEO_STI_DELTA_MJPEG
+	depends on RPMSG
 	default VIDEO_STI_DELTA_MJPEG
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	select RPMSG
 
 endif # VIDEO_STI_DELTA
 
diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index b950e6cd4ba2..3b16f422d30c 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -21,7 +21,6 @@ config OMAP_REMOTEPROC
 	depends on REMOTEPROC
 	select MAILBOX
 	select OMAP2PLUS_MBOX
-	select RPMSG_VIRTIO
 	help
 	  Say y here to support OMAP's remote processors (dual M3
 	  and DSP on OMAP4) via the remote processor framework.
@@ -53,7 +52,6 @@ config DA8XX_REMOTEPROC
 	depends on ARCH_DAVINCI_DA8XX
 	depends on REMOTEPROC
 	depends on DMA_CMA
-	select RPMSG_VIRTIO
 	help
 	  Say y here to support DA8xx/OMAP-L13x remote processors via the
 	  remote processor framework.
@@ -76,7 +74,6 @@ config KEYSTONE_REMOTEPROC
 	depends on ARCH_KEYSTONE
 	depends on RESET_CONTROLLER
 	depends on REMOTEPROC
-	select RPMSG_VIRTIO
 	help
 	  Say Y here here to support Keystone remote processors (DSP)
 	  via the remote processor framework.
@@ -133,7 +130,6 @@ config ST_REMOTEPROC
 	depends on REMOTEPROC
 	select MAILBOX
 	select STI_MBOX
-	select RPMSG_VIRTIO
 	help
 	  Say y here to support ST's adjunct processors via the remote
 	  processor framework.
diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
index 2a5d2b446de2..46f3f2431d68 100644
--- a/drivers/rpmsg/Kconfig
+++ b/drivers/rpmsg/Kconfig
@@ -1,8 +1,5 @@
-menu "Rpmsg drivers"
-
-# RPMSG always gets selected by whoever wants it
-config RPMSG
-	tristate
+menuconfig RPMSG
+	tristate "Rpmsg drivers"
 
 config RPMSG_CHAR
 	tristate "RPMSG device interface"
@@ -15,7 +12,7 @@ config RPMSG_CHAR
 
 config RPMSG_QCOM_GLINK_RPM
 	tristate "Qualcomm RPM Glink driver"
-	select RPMSG
+	depends on RPMSG
 	depends on HAS_IOMEM
 	depends on MAILBOX
 	help
@@ -26,16 +23,17 @@ config RPMSG_QCOM_GLINK_RPM
 config RPMSG_QCOM_SMD
 	tristate "Qualcomm Shared Memory Driver (SMD)"
 	depends on QCOM_SMEM
-	select RPMSG
+	depends on RPMSG
 	help
 	  Say y here to enable support for the Qualcomm Shared Memory Driver
 	  providing communication channels to remote processors in Qualcomm
 	  platforms.
 
 config RPMSG_VIRTIO
-	tristate
-	select RPMSG
+	tristate "Virtio remote processor messaging driver (RPMSG)"
+	depends on RPMSG
 	select VIRTIO
 	select VIRTUALIZATION
-
-endmenu
+	help
+	  Say y here to enable support for the Virtio remote processor
+	  messaging protocol (RPMSG).
-- 
2.12.0
