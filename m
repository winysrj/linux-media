Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42229 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752247AbdFUIIe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 04:08:34 -0400
From: Johannes Thumshirn <jthumshirn@suse.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH RESEND 2/7] video: fbdev: don't use KERNEL_VERSION macro for MEDIA_REVISION
Date: Wed, 21 Jun 2017 10:08:07 +0200
Message-Id: <20170621080812.6817-3-jthumshirn@suse.de>
In-Reply-To: <20170621080812.6817-1-jthumshirn@suse.de>
References: <20170621080812.6817-1-jthumshirn@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't use the KERNEL_VERSION() macro for the v4l2 capabilities, use
MEDIA_REVISION instead.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/video/fbdev/matrox/matroxfb_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
index 11eb094396ae..eb92a325033c 100644
--- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -113,6 +113,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/media.h>
 
 #ifdef CONFIG_PPC_PMAC
 #include <asm/machdep.h>
@@ -1091,7 +1092,7 @@ static int matroxfb_ioctl(struct fb_info *info,
 				strcpy(r.driver, "matroxfb");
 				strcpy(r.card, "Matrox");
 				sprintf(r.bus_info, "PCI:%s", pci_name(minfo->pcidev));
-				r.version = KERNEL_VERSION(1,0,0);
+				r.version = MEDIA_REVISION(1, 0, 0);
 				r.capabilities = V4L2_CAP_VIDEO_OUTPUT;
 				if (copy_to_user(argp, &r, sizeof(r)))
 					return -EFAULT;
-- 
2.12.3
