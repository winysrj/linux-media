Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37051 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbZHKVCE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 17:02:04 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 3/4 - v2] V4L: ccdc driver - select MSP driver for CCDC input selection
Date: Tue, 11 Aug 2009 17:01:58 -0400
Message-Id: <1250024518-5118-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

There were no comments against v1 of this patch. So no change from v1 of the patch

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to V4L-DVB linux-next repository
 drivers/media/video/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 8460013..a70d75a 100644
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

