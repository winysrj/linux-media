Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:52806 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524AbZJOOn7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 10:43:59 -0400
From: santiago.nunez@ridgerun.com
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com,
	Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Date: Thu, 15 Oct 2009 08:43:28 -0600
Message-Id: <1255617808-1429-1-git-send-email-santiago.nunez@ridgerun.com>
Subject: [PATCH 3/6 v5] Support for TVP7002 in VPFE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>

This patch adds support for TVP7002 in the DM365 VPFE inteface.
Added video modes.

Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 402ce43..4820091 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -73,6 +73,7 @@
 #include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <linux/io.h>
+#include <media/davinci/videohd.h>
 #include <media/davinci/vpfe_capture.h>
 #include "ccdc_hw_device.h"
 
@@ -131,6 +132,14 @@ static struct ccdc_config *ccdc_cfg;
 const struct vpfe_standard vpfe_standards[] = {
 	{V4L2_STD_525_60, 720, 480, {11, 10}, 1},
 	{V4L2_STD_625_50, 720, 576, {54, 59}, 1},
+	{V4L2_STD_525P_60, 720, 480, {11, 10}, 0},
+	{V4L2_STD_625P_50, 720, 576, {54, 59}, 0},
+	{V4L2_STD_720P_50, 1280, 720, {1, 1}, 0},
+	{V4L2_STD_720P_60, 1280, 720, {1, 1}, 0},
+	{V4L2_STD_1080I_50, 1920, 1080, {1, 1}, 1},
+	{V4L2_STD_1080I_60, 1920, 1080, {1, 1}, 1},
+	{V4L2_STD_1080P_50, 1920, 1080, {1, 1}, 0},
+	{V4L2_STD_1080P_60, 1920, 1080, {1, 1}, 0},
 };
 
 /* Used when raw Bayer image from ccdc is directly captured to SDRAM */
-- 
1.6.0.4

