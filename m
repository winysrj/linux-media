Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:55274 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0IOVbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 17:31:10 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] V4L/DVB: v4l: fsl-viu.c: add slab.h include to fix compile breakage
Date: Wed, 15 Sep 2010 23:31:09 +0200
Message-Id: <1284586269-8623-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

mpc512x kernel configurations without SPI support do not build:

drivers/media/video/fsl-viu.c: In function 'viu_open':
drivers/media/video/fsl-viu.c:1248: error: implicit declaration of function 'kzalloc'
drivers/media/video/fsl-viu.c:1248: warning: assignment makes pointer from integer without a cast
drivers/media/video/fsl-viu.c: In function 'viu_release':
drivers/media/video/fsl-viu.c:1335: error: implicit declaration of function 'kfree'

If CONFIG_SPI is enabled, the slab.h will be included in
linux/spi/spi.h which is included by media/v4l2-common.h
and the fsl_viu.c driver builds.

Let's incluce linux/slab.h directly to fix the build breakage.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/fsl-viu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index 43d208f..0b318be 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/of_platform.h>
+#include <linux/slab.h>
 #include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
-- 
1.7.0.4

