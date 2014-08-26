Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34333 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaHZQi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 12:38:59 -0400
From: Mark Brown <broonie@kernel.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linaro-kernel@lists.linaro.org,
	Mark Brown <broonie@linaro.org>
Date: Tue, 26 Aug 2014 17:38:50 +0100
Message-Id: <1409071130-22183-1-git-send-email-broonie@kernel.org>
Subject: [PATCH] [media] v4l2-pci-skeleton: Only build if PCI is available
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mark Brown <broonie@linaro.org>

Currently arm64 does not support PCI but it does support v4l2. Since the
PCI skeleton driver is built unconditionally as a module with no dependency
on PCI this causes build failures for arm64 allmodconfig. Fix this by
defining a symbol VIDEO_PCI_SKELETON for the skeleton and conditionalising
the build on that.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 Documentation/video4linux/Makefile | 2 +-
 drivers/media/v4l2-core/Kconfig    | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/video4linux/Makefile b/Documentation/video4linux/Makefile
index d58101e788fc..65a351d75c95 100644
--- a/Documentation/video4linux/Makefile
+++ b/Documentation/video4linux/Makefile
@@ -1 +1 @@
-obj-m := v4l2-pci-skeleton.o
+obj-$(CONFIG_VIDEO_PCI_SKELETON) := v4l2-pci-skeleton.o
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 9ca0f8d59a14..2b368f711c9e 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -25,6 +25,13 @@ config VIDEO_FIXED_MINOR_RANGES
 
 	  When in doubt, say N.
 
+config VIDEO_PCI_SKELETON
+	tristate "Skeleton PCI V4L2 driver"
+	depends on PCI && COMPILE_TEST
+	---help---
+	  Enable build of the skeleton PCI driver, used as a reference
+	  when developign new drivers.
+
 # Used by drivers that need tuner.ko
 config VIDEO_TUNER
 	tristate
-- 
2.1.0.rc1

