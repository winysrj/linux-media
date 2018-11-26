Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58669 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbeK0FMj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 00:12:39 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: hverkuil@xs4all.nl
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH 1/2] [media] v4l2-pci-skeleton: depend on CONFIG_SAMPLES
Date: Mon, 26 Nov 2018 19:01:23 +0100
Message-Id: <20181126180124.15161-2-m.tretter@pengutronix.de>
In-Reply-To: <20181126180124.15161-1-m.tretter@pengutronix.de>
References: <20181126180124.15161-1-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 0185f8501762 ("[media] samples: v4l: from Documentation to
samples directory") moved the v4l2-pci-skeleton driver to the samples
directory. The samples are only be built, if CONFIG_SAMPLES is enabled.

Therefore, VIDEO_PCI_SKELETON is not enough to build the
v4l2-pci-skeleton driver, but SAMPLES needs to be enabled, too. Let
VIDEO_PCI_SKELETON depend on SAMPLES.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 drivers/media/v4l2-core/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index b97090e85996..c0940f5c69b4 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -30,6 +30,7 @@ config VIDEO_FIXED_MINOR_RANGES
 config VIDEO_PCI_SKELETON
 	tristate "Skeleton PCI V4L2 driver"
 	depends on PCI
+	depends on SAMPLES
 	depends on VIDEO_V4L2 && VIDEOBUF2_CORE
 	depends on VIDEOBUF2_MEMOPS && VIDEOBUF2_DMA_CONTIG
 	---help---
-- 
2.19.1
