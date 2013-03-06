Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:47705 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3CFW3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 17:29:35 -0500
Received: by mail-la0-f51.google.com with SMTP id fo13so8039736lab.38
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 14:29:33 -0800 (PST)
Date: Thu, 7 Mar 2013 02:22:08 +0400
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, volokh84@gmail.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/2] hverkuil/go7007: media: i2c: Fix compilation errors
Message-ID: <20130306222208.GC10958@Volokh.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix warnings as errors:
error: implicit declaration of function ‘kzalloc’ [-Werror=implicit-function-declaration]
error: implicit declaration of function ‘kfree’ [-Werror=implicit-function-declaration]

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/media/i2c/ov7640.c        |    1 +
 drivers/media/i2c/tw9903.c        |    1 +
 drivers/media/i2c/uda1342.c       |    1 +
 drivers/media/tuners/sony-tuner.c |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/i2c/ov7640.c b/drivers/media/i2c/ov7640.c
index 535cf29..224d7cd 100644
--- a/drivers/media/i2c/ov7640.c
+++ b/drivers/media/i2c/ov7640.c
@@ -21,6 +21,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <linux/slab.h>
 
 MODULE_DESCRIPTION("OmniVision ov7640 sensor driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/i2c/tw9903.c b/drivers/media/i2c/tw9903.c
index f859d3a..0c39d38 100644
--- a/drivers/media/i2c/tw9903.c
+++ b/drivers/media/i2c/tw9903.c
@@ -22,6 +22,7 @@
 #include <linux/ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <linux/slab.h>
 
 MODULE_DESCRIPTION("TW9903 I2C subdev driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/i2c/uda1342.c b/drivers/media/i2c/uda1342.c
index 82319d0..7800236 100644
--- a/drivers/media/i2c/uda1342.c
+++ b/drivers/media/i2c/uda1342.c
@@ -21,6 +21,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/uda1342.h>
+#include <linux/slab.h>
 
 static int write_reg(struct i2c_client *client, int reg, int value)
 {
diff --git a/drivers/media/tuners/sony-tuner.c b/drivers/media/tuners/sony-tuner.c
index 1b77529..8411e97 100644
--- a/drivers/media/tuners/sony-tuner.c
+++ b/drivers/media/tuners/sony-tuner.c
@@ -23,6 +23,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
+#include <linux/slab.h>
 
 MODULE_DESCRIPTION("Sony TV Tuner driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.7.6

