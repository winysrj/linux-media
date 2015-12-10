Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:51797 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbbLJOaZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 09:30:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] [media] staging/davinci_vfpe: allow modular build
Date: Thu, 10 Dec 2015 15:29:38 +0100
Message-ID: <2029571.PWO4DcqdUl@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It has never been possible to actually build this driver as
a loadable module, only built-in because the Makefile attempts
to build each file into its own module and fails:

ERROR: "mbus_to_pix" [drivers/staging/media/davinci_vpfe/vpfe_video.ko] undefined!
ERROR: "vpfe_resizer_register_entities" [drivers/staging/media/davinci_vpfe/vpfe_mc_capture.ko] undefined!
ERROR: "rsz_enable" [drivers/staging/media/davinci_vpfe/dm365_resizer.ko] undefined!
ERROR: "config_ipipe_hw" [drivers/staging/media/davinci_vpfe/dm365_ipipe.ko] undefined!
ERROR: "ipipe_set_lutdpc_regs" [drivers/staging/media/davinci_vpfe/dm365_ipipe.ko] undefined!

It took a long time to catch this bug with randconfig builds
because at least 14 other Kconfig symbols have to be enabled in
order to configure this one.

The solution is really easy: this patch changes the Makefile to
link all files into one module.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

diff --git a/drivers/staging/media/davinci_vpfe/Makefile b/drivers/staging/media/davinci_vpfe/Makefile
index c64515c644cd..3019c9ecd548 100644
--- a/drivers/staging/media/davinci_vpfe/Makefile
+++ b/drivers/staging/media/davinci_vpfe/Makefile
@@ -1,3 +1,5 @@
-obj-$(CONFIG_VIDEO_DM365_VPFE) += \
+obj-$(CONFIG_VIDEO_DM365_VPFE) += davinci-vfpe.o
+
+davinci-vfpe-objs := \
 	dm365_isif.o dm365_ipipe_hw.o dm365_ipipe.o \
 	dm365_resizer.o dm365_ipipeif.o vpfe_mc_capture.o vpfe_video.o

