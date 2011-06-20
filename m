Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:57309 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab1FTTPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:15:05 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/5] marvell-cam: include file cleanup
Date: Mon, 20 Jun 2011 13:14:37 -0600
Message-Id: <1308597280-138673-3-git-send-email-corbet@lwn.net>
In-Reply-To: <1308597280-138673-1-git-send-email-corbet@lwn.net>
References: <1308597280-138673-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Put the includes into a slightly more readable ordering and get rid of a
few unneeded ones.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 055d843..65d9c0f 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -11,22 +11,20 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <linux/videodev2.h>
 #include <linux/slab.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-chip-ident.h>
-#include <media/ov7670.h>
-#include <media/videobuf2-vmalloc.h>
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
-#include <linux/jiffies.h>
 #include <linux/vmalloc.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/ov7670.h>
+#include <media/videobuf2-vmalloc.h>
 
 #include "mcam-core.h"
 
-- 
1.7.5.4

