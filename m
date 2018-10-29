Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54106 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730863AbeJ3HvV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 03:51:21 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/4] tw9910: No SoC camera dependency
Date: Tue, 30 Oct 2018 01:00:27 +0200
Message-Id: <20181029230029.14630-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tw9910 driver does not depend on SoC camera framework. Don't include
the header, but instead include media/v4l2-async.h which the driver really
needs.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/tw9910.c | 1 +
 include/media/i2c/tw9910.h | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index 7087ce946af1..6478bd41afb8 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -27,6 +27,7 @@
 #include <linux/videodev2.h>
 
 #include <media/i2c/tw9910.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-subdev.h>
 
 #define GET_ID(val)  ((val & 0xF8) >> 3)
diff --git a/include/media/i2c/tw9910.h b/include/media/i2c/tw9910.h
index bec8f7bce745..2f93799d5a21 100644
--- a/include/media/i2c/tw9910.h
+++ b/include/media/i2c/tw9910.h
@@ -16,8 +16,6 @@
 #ifndef __TW9910_H__
 #define __TW9910_H__
 
-#include <media/soc_camera.h>
-
 /**
  * tw9910_mpout_pin - MPOUT (multi-purpose output) pin functions
  */
-- 
2.11.0
