Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45513 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750835AbdH3IjC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 04:39:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] atomisp: fix small Kconfig issues
Message-ID: <b4315425-a96e-8c33-2f2c-6a1d9f1c9722@xs4all.nl>
Date: Wed, 30 Aug 2017 10:39:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The help text should be indented by at least two spaces after the
'help' separator. This is both good practice and the media_build system
for building media drivers makes this assumption.

Fix this for the atomisp/i2c/Kconfig and fix the atomisp/pci/Kconfig
that didn't align the help separator with the preceding keywords.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/staging/media/atomisp/i2c/Kconfig b/drivers/staging/media/atomisp/i2c/Kconfig
index b80d29d53e65..e628b5c37455 100644
--- a/drivers/staging/media/atomisp/i2c/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/Kconfig
@@ -75,8 +75,8 @@ config VIDEO_GC0310
 	tristate "GC0310 sensor support"
         depends on I2C && VIDEO_V4L2
         ---help---
-         This is a Video4Linux2 sensor-level driver for the Galaxycore
-         GC0310 0.3MP sensor.
+          This is a Video4Linux2 sensor-level driver for the Galaxycore
+          GC0310 0.3MP sensor.
 	
 config VIDEO_OV2680
        tristate "Omnivision OV2680 sensor support"
diff --git a/drivers/staging/media/atomisp/pci/Kconfig b/drivers/staging/media/atomisp/pci/Kconfig
index a72421431c7a..6b2203e6d511 100644
--- a/drivers/staging/media/atomisp/pci/Kconfig
+++ b/drivers/staging/media/atomisp/pci/Kconfig
@@ -3,11 +3,11 @@
 #

 config VIDEO_ATOMISP
-       tristate "Intel Atom Image Signal Processor Driver"
-       depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-       select VIDEOBUF_VMALLOC
-        ---help---
-          Say Y here if your platform supports Intel Atom SoC
-          camera imaging subsystem.
-          To compile this driver as a module, choose M here: the
-          module will be called atomisp
+	tristate "Intel Atom Image Signal Processor Driver"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select VIDEOBUF_VMALLOC
+	---help---
+	  Say Y here if your platform supports Intel Atom SoC
+	  camera imaging subsystem.
+	  To compile this driver as a module, choose M here: the
+	  module will be called atomisp
