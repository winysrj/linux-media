Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34832 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751747AbeEBXUE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 19:20:04 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/2] intel-ipu3: Kconfig coding style issue
Date: Wed,  2 May 2018 18:19:29 -0500
Message-Id: <1525303170-6303-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525303170-6303-1-git-send-email-brad@nextdimension.cc>
References: <1525303170-6303-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kconfig Help statements are two-spaced after a single tab.

The incorrect spacing breaks menuconfig on older kernels.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/intel/ipu3/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index a82d3fe..7f5b7a5 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -10,10 +10,10 @@ config VIDEO_IPU3_CIO2
 	select VIDEOBUF2_DMA_SG
 
 	---help---
-	This is the Intel IPU3 CIO2 CSI-2 receiver unit, found in Intel
-	Skylake and Kaby Lake SoCs and used for capturing images and
-	video from a camera sensor.
+	  This is the Intel IPU3 CIO2 CSI-2 receiver unit, found in Intel
+	  Skylake and Kaby Lake SoCs and used for capturing images and
+	  video from a camera sensor.
 
-	Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
-	connected camera.
-	The module will be called ipu3-cio2.
+	  Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
+	  connected camera.
+	  The module will be called ipu3-cio2.
-- 
2.7.4
