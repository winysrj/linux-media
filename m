Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55077 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab1IIRnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 13:43:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id D12CB18B03B
	for <linux-media@vger.kernel.org>; Fri,  9 Sep 2011 19:43:38 +0200 (CEST)
Date: Fri, 9 Sep 2011 19:43:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] V4L: replace soc-camera specific soc_mediabus.h with
 v4l2-mediabus.h
In-Reply-To: <Pine.LNX.4.64.1109091917260.915@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109091922500.915@axis700.grange>
References: <Pine.LNX.4.64.1109091917260.915@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most users of the <media/soc_mediabus.h> header only need pixel code
definitions, which are now located in the generic <linux/v4l2-mediabus.h>
header. Switch over to reduce soc-camera dependencies.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/imx074.c     |    2 +-
 drivers/media/video/mt9m111.c    |    2 +-
 drivers/media/video/mt9t031.c    |    2 +-
 drivers/media/video/mt9t112.c    |    2 +-
 drivers/media/video/ov2640.c     |    2 +-
 drivers/media/video/ov5642.c     |    2 +-
 drivers/media/video/ov6650.c     |    2 +-
 drivers/media/video/ov772x.c     |    2 +-
 drivers/media/video/ov9640.c     |    2 +-
 drivers/media/video/ov9740.c     |    2 +-
 drivers/media/video/rj54n1cb0c.c |    2 +-
 drivers/media/video/tw9910.c     |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 4f3ce7f..8775e26 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -12,11 +12,11 @@
 
 #include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/v4l2-mediabus.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 9feeb0c..f023cc0 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -13,9 +13,9 @@
 #include <linux/log2.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
+#include <linux/v4l2-mediabus.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-chip-ident.h>
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 0226486..7ee84cc 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -13,10 +13,10 @@
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
+#include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index 5b045a1..32114a3 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -22,11 +22,11 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
 #include <media/mt9t112.h>
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
 
diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index d37a5cc..b5247cb 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -18,10 +18,10 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 2a26602..54178cb 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -19,9 +19,9 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
+#include <linux/v4l2-mediabus.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 
diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index 957949a..717771a 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -28,9 +28,9 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/v4l2-mediabus.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index a2146c3..9f6ce3d 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -20,11 +20,11 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
 #include <media/ov772x.h>
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index f9babf3..a4f9979 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -24,10 +24,10 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index 9558aca..d9a9f71 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -14,9 +14,9 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/v4l2-mediabus.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index fcb14d9..6afc616 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -11,11 +11,11 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
 #include <media/rj54n1cb0c.h>
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index efce537..a514fa6 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -22,10 +22,10 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
+#include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
 #include <media/tw9910.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
-- 
1.7.2.5

