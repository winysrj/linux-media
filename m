Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:52077 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbcEKNaV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 09:30:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND^3] [media] staging/davinci_vfpe: allow modular build
Date: Wed, 11 May 2016 15:29:44 +0200
Message-Id: <1462973405-1254895-1-git-send-email-arnd@arndb.de>
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
order to configure this one, and it was clearly only ever tested
as built-in with mainline kernels, if at all.

The solution is really easy: this patch changes the Makefile to
link all files into one module. As discussed previously, the
driver has never before used successfully as a loadable module,
but there is no reason to prevent that configuration.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: http://lkml.iu.edu/hypermail/linux/kernel/1512.1/02383.html
---
I keep running into this bug roughly every 10000 randconfig builds,
please apply the fix.

 drivers/staging/media/davinci_vpfe/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
-- 
2.7.0

