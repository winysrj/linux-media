Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2319 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425804AbdD1MK2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 08:10:28 -0400
Subject: [PATCH 6/8] staging: atomisp: satm include directory is gone
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 28 Apr 2017 13:10:23 +0100
Message-ID: <149338142051.2556.6582354563681543425.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
References: <149338135275.2556.7708531564733886566.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

After the satm kernel was removed, we should no longer add the directory
to the search path. This was found with a 'make W=1' warning:

cc1: error: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/: No such file or directory [-Werror=missing-include-dirs]

Fixes: 184f8e0981ef ("atomisp: remove satm kernel")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/Makefile    |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index 7417dbd..3fa7c1c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -290,7 +290,6 @@ INCLUDES += \
 	-I$(atomisp)/css2400/isp/kernels/s3a/ \
 	-I$(atomisp)/css2400/isp/kernels/s3a/s3a_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/s3a_stat_ls/ \
-	-I$(atomisp)/css2400/isp/kernels/satm/ \
 	-I$(atomisp)/css2400/isp/kernels/scale/ \
 	-I$(atomisp)/css2400/isp/kernels/scale/scale_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/sc/ \
