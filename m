Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:56047 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753319AbeAHUUJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 15:20:09 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] drivers/media/common/videobuf2: rename from videobuf
Message-ID: <1e1c91db-d439-f750-0bd2-249082298342@xs4all.nl>
Date: Mon, 8 Jan 2018 21:20:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This directory contains the videobuf2 framework, so name the
directory accordingly.

The name 'videobuf' typically refers to the old and deprecated
videobuf version 1 framework so that was confusing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/Kconfig                                        | 2 +-
 drivers/media/common/Makefile                                       | 2 +-
 drivers/media/common/{videobuf => videobuf2}/Kconfig                | 0
 drivers/media/common/{videobuf => videobuf2}/Makefile               | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-core.c       | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-dma-contig.c | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-dma-sg.c     | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-dvb.c        | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-memops.c     | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-v4l2.c       | 0
 drivers/media/common/{videobuf => videobuf2}/videobuf2-vmalloc.c    | 0
 11 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/media/common/{videobuf => videobuf2}/Kconfig (100%)
 rename drivers/media/common/{videobuf => videobuf2}/Makefile (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-core.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-dma-contig.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-dma-sg.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-dvb.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-memops.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-v4l2.c (100%)
 rename drivers/media/common/{videobuf => videobuf2}/videobuf2-vmalloc.c (100%)

diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
index cdfc905967dc..0cb7d819a5d2 100644
--- a/drivers/media/common/Kconfig
+++ b/drivers/media/common/Kconfig
@@ -16,7 +16,7 @@ config CYPRESS_FIRMWARE
 	tristate "Cypress firmware helper routines"
 	depends on USB

-source "drivers/media/common/videobuf/Kconfig"
+source "drivers/media/common/videobuf2/Kconfig"
 source "drivers/media/common/b2c2/Kconfig"
 source "drivers/media/common/saa7146/Kconfig"
 source "drivers/media/common/siano/Kconfig"
diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
index f24b5ed39982..e7bc17abbbbc 100644
--- a/drivers/media/common/Makefile
+++ b/drivers/media/common/Makefile
@@ -1,4 +1,4 @@
-obj-y += b2c2/ saa7146/ siano/ v4l2-tpg/ videobuf/
+obj-y += b2c2/ saa7146/ siano/ v4l2-tpg/ videobuf2/
 obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
 obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
 obj-$(CONFIG_CYPRESS_FIRMWARE) += cypress_firmware.o
diff --git a/drivers/media/common/videobuf/Kconfig b/drivers/media/common/videobuf2/Kconfig
similarity index 100%
rename from drivers/media/common/videobuf/Kconfig
rename to drivers/media/common/videobuf2/Kconfig
diff --git a/drivers/media/common/videobuf/Makefile b/drivers/media/common/videobuf2/Makefile
similarity index 100%
rename from drivers/media/common/videobuf/Makefile
rename to drivers/media/common/videobuf2/Makefile
diff --git a/drivers/media/common/videobuf/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
similarity index 100%
rename from drivers/media/common/videobuf/videobuf2-core.c
rename to drivers/media/common/videobuf2/videobuf2-core.c
diff --git a/drivers/media/common/videobuf/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
similarity index 100%
rename from drivers/media/common/videobuf/videobuf2-dma-contig.c
rename to drivers/media/common/videobuf2/videobuf2-dma-contig.c
diff --git a/drivers/media/common/videobuf/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
similarity index 100%
rename from drivers/media/common/videobuf/videobuf2-dma-sg.c
rename to drivers/media/common/videobuf2/videobuf2-dma-sg.c
diff --git a/drivers/media/common/videobuf/videobuf2-dvb.c b/drivers/media/common/videobuf2/videobuf2-dvb.c
similarity index 100%
rename from drivers/media/common/videobuf/videobuf2-dvb.c
rename to drivers/media/common/videobuf2/videobuf2-dvb.c
diff --git a/drivers/media/common/videobuf/videobuf2-memops.c b/drivers/media/common/videobuf2/videobuf2-memops.c
similarity index 100%
rename from drivers/media/common/videobuf/videobuf2-memops.c
rename to drivers/media/common/videobuf2/videobuf2-memops.c
diff --git a/drivers/media/common/videobuf/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
similarity index 100%
rename from drivers/media/common/videobuf/videobuf2-v4l2.c
rename to drivers/media/common/videobuf2/videobuf2-v4l2.c
diff --git a/drivers/media/common/videobuf/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
similarity index 100%
rename from drivers/media/common/videobuf/videobuf2-vmalloc.c
rename to drivers/media/common/videobuf2/videobuf2-vmalloc.c
-- 
2.15.1
