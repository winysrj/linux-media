Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40636 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752724AbeFHVTO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 17:19:14 -0400
To: linux-media <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -next] media/platform/cadence: add <linux/slab.h> to fix build
 error
Message-ID: <2feda2a7-8008-f36d-67fa-a4aa38ea75ae@infradead.org>
Date: Fri, 8 Jun 2018 14:19:06 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Add #include <linux/slab.h> to fix build errors.
This driver uses kzalloc() and kfree() so it needs to #include
the appropriate header file for those interfaces.

Fixes these build errors:

../drivers/media/platform/cadence/cdns-csi2rx.c: In function 'csi2rx_probe':
../drivers/media/platform/cadence/cdns-csi2rx.c:421:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
  csi2rx = kzalloc(sizeof(*csi2rx), GFP_KERNEL);
../drivers/media/platform/cadence/cdns-csi2rx.c:421:9: warning: assignment makes pointer from integer without a cast [enabled by default]
  csi2rx = kzalloc(sizeof(*csi2rx), GFP_KERNEL);
../drivers/media/platform/cadence/cdns-csi2rx.c:466:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
  kfree(csi2rx);

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/platform/cadence/cdns-csi2rx.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20180608.orig/drivers/media/platform/cadence/cdns-csi2rx.c
+++ linux-next-20180608/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -13,6 +13,7 @@
 #include <linux/of_graph.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
