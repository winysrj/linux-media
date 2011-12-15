Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56712 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab1LOMMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 07:12:24 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>
Subject: [PATCH v6 01/11] davinci: vpif: remove obsolete header file inclusion
Date: Thu, 15 Dec 2011 17:41:50 +0530
Message-ID: <1323951120-15876-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1323951120-15876-1-git-send-email-manjunath.hadli@ti.com>
References: <1323951120-15876-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

remove inclusion of header files from vpif.h and vpif_dispaly.c
and add appropriate header file for building.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LMML <linux-media@vger.kernel.org>
---
 drivers/media/video/davinci/vpif.h         |    2 +-
 drivers/media/video/davinci/vpif_display.c |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 25036cb..c96268a 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -19,7 +19,7 @@
 #include <linux/io.h>
 #include <linux/videodev2.h>
 #include <mach/hardware.h>
-#include <mach/dm646x.h>
+#include <linux/i2c.h>
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
 
-- 
1.6.2.4

