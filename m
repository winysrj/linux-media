Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:54821 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037649AbdDUKtH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 06:49:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: atomisp: satm include directory is gone
Date: Fri, 21 Apr 2017 12:48:34 +0200
Message-Id: <20170421104903.815637-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After the satm kernel was removed, we should no longer add the directory
to the search path. This was found with a 'make W=1' warning:

cc1: error: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/: No such file or directory [-Werror=missing-include-dirs]

Fixes: 184f8e0981ef ("atomisp: remove satm kernel")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/pci/atomisp2/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index 96a7bd0fa96e..5e8646c976a6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -301,7 +301,6 @@ INCLUDES += \
 	-I$(atomisp)/css2400/isp/kernels/s3a/ \
 	-I$(atomisp)/css2400/isp/kernels/s3a/s3a_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/s3a_stat_ls/ \
-	-I$(atomisp)/css2400/isp/kernels/satm/ \
 	-I$(atomisp)/css2400/isp/kernels/scale/ \
 	-I$(atomisp)/css2400/isp/kernels/scale/scale_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/sc/ \
-- 
2.9.0
