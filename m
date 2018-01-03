Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:55846 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeACWgC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 17:36:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Hyungwoo Yang <hyungwoo.yang@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: intel-ipu3: cio2: fix building with large PAGE_SIZE
Date: Wed,  3 Jan 2018 23:35:31 +0100
Message-Id: <20180103223546.3546694-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver apparently assumes that the device uses the same page size
as the CPU, but also assumes that this is 4096 bytes. On architectures
with a larger page size like 65536 bytes, we get a warning about an
integer overflow:

drivers/media/pci/intel/ipu3/ipu3-cio2.c: In function 'cio2_fbpt_entry_init_dummy':
arch/arm64/include/asm/page-def.h:28:20: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
 #define PAGE_SIZE  (_AC(1, UL) << PAGE_SHIFT)
                    ^
drivers/media/pci/intel/ipu3/ipu3-cio2.h:404:26: note: in expansion of macro 'PAGE_SIZE'
 #define CIO2_PAGE_SIZE   PAGE_SIZE
                          ^~~~~~~~~
drivers/media/pci/intel/ipu3/ipu3-cio2.c:172:3: note: in expansion of macro 'CIO2_PAGE_SIZE'
   CIO2_PAGE_SIZE / sizeof(u32) * CIO2_MAX_LOPS;

Obviously this won't work, but the driver is also unlikely to ever be
used on such an architecture, so the easiest workaround is to define
the CIO2_PAGE_SIZE macro to the size that the hardware actually uses.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
index 1a559990920f..78a5799f08e7 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
@@ -401,7 +401,7 @@ struct cio2_device {
 					 sizeof(struct cio2_fbpt_entry))
 
 #define CIO2_FBPT_SUBENTRY_UNIT		4
-#define CIO2_PAGE_SIZE			PAGE_SIZE
+#define CIO2_PAGE_SIZE			4096
 
 /* cio2 fbpt first_entry ctrl status */
 #define CIO2_FBPT_CTRL_VALID		BIT(0)
-- 
2.9.0
