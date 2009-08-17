Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47863 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZHQXSw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 19:18:52 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 2/5 - v3] V4L: ccdc driver - select MSP driver for CCDC input selection
Date: Mon, 17 Aug 2009 19:18:47 -0400
Message-Id: <1250551127-32512-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Just being recreated to apply cleanly and compile.

There were no comments against v1 of this patch. So no change from v1/v2 of the patch

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to V4L-DVB linux-next repository
 drivers/media/video/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index e8a6e4d..1fa3c87 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -565,13 +565,15 @@ config VIDEO_DM355_CCDC
 	tristate "DM355 CCDC HW module"
 	depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE
 	select VIDEO_VPSS_SYSTEM
+	select MFD_DM355EVM_MSP
 	default y
 	help
 	   Enables DM355 CCD hw module. DM355 CCDC hw interfaces
 	   with decoder modules such as TVP5146 over BT656 or
 	   sensor module such as MT9T001 over a raw interface. This
 	   module configures the interface and CCDC/ISIF to do
-	   video frame capture from a slave decoders
+	   video frame capture from a slave decoders. MFD_DM355EVM_MSP
+	   is enabled to select input to CCDC at run time.
 
 	   To compile this driver as a module, choose M here: the
 	   module will be called vpfe.
-- 
1.6.0.4

