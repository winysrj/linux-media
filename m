Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:46716 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaISLcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 07:32:55 -0400
Received: by mail-yh0-f52.google.com with SMTP id i57so480672yha.11
        for <linux-media@vger.kernel.org>; Fri, 19 Sep 2014 04:32:54 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: m.chehab@samsung.com
Cc: k.debski@samsung.com, p.zabel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] coda: coda-bit: Include "<linux/slab.h>"
Date: Fri, 19 Sep 2014 08:32:30 -0300
Message-Id: <1411126350-5936-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

coda-bit uses kmalloc/kfree functions, so the slab header needs to be included
in order to fix the following build errors:

drivers/media/platform/coda/coda-bit.c: In function 'coda_fill_bitstream':
drivers/media/platform/coda/coda-bit.c:231:4: error: implicit declaration of function 'kmalloc' [-Werror=implicit-function-declaration]
drivers/media/platform/coda/coda-bit.c: In function 'coda_alloc_framebuffers':
drivers/media/platform/coda/coda-bit.c:312:3: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda/coda-bit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 07fc91a..9b8ea8b 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 
 #include <media/v4l2-common.h>
-- 
1.9.1

