Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:59101 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1LUNoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 08:44:06 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>
Subject: [PATCH v7 1/8] davinci: vpif: remove machine specific inclusion from driver
Date: Wed, 21 Dec 2011 19:13:34 +0530
Message-ID: <1324475021-32509-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1324475021-32509-1-git-send-email-manjunath.hadli@ti.com>
References: <1324475021-32509-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

remove machine specific inclusion from the driver which
comes in the way of platform code consolidation.
currently was seen that these header inclusions were
not necessary.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LMML <linux-media@vger.kernel.org>
---
 drivers/media/video/davinci/vpif.h         |    2 --
 drivers/media/video/davinci/vpif_display.c |    2 --
 include/media/davinci/vpif_types.h         |    2 ++
 sound/soc/codecs/cq93vc.c                  |    2 --
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 25036cb..8bcac65 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -18,8 +18,6 @@
 
 #include <linux/io.h>
 #include <linux/videodev2.h>
-#include <mach/hardware.h>
-#include <mach/dm646x.h>
 #include <media/davinci/vpif_types.h>
 
 /* Maximum channel allowed */
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 286f029..7fa34b4 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -39,8 +39,6 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
 
-#include <mach/dm646x.h>
-
 #include "vpif_display.h"
 #include "vpif.h"
 
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index 9929b05..bd8217c 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -17,6 +17,8 @@
 #ifndef _VPIF_TYPES_H
 #define _VPIF_TYPES_H
 
+#include <linux/i2c.h>
+
 #define VPIF_CAPTURE_MAX_CHANNELS	2
 
 enum vpif_if_type {
diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
index 46dbfd0..ff4eb7a 100644
--- a/sound/soc/codecs/cq93vc.c
+++ b/sound/soc/codecs/cq93vc.c
@@ -38,8 +38,6 @@
 #include <sound/soc.h>
 #include <sound/initval.h>
 
-#include <mach/dm365.h>
-
 static inline unsigned int cq93vc_read(struct snd_soc_codec *codec,
 						unsigned int reg)
 {
-- 
1.6.2.4

