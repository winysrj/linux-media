Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57972
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751629AbdFHPhO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 11:37:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, devel@driverdev.osuosl.org
Subject: [PATCH] [media] staging: css2400/Makefile: don't include makefiles
Date: Thu,  8 Jun 2017 12:36:47 -0300
Message-Id: <5af212ed8fba5ba38eeb605deac8c591f16dc3bc.1496936197.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The atomisp css2400/Makefile includes a Makefile.common:

	include $(srctree)/$(src)/../Makefile.common

Well, this file doesn't exist at the Kernel tree :-)

So, don't include it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/css2400/Makefile
index 04defaafa02c..ee5631b0e635 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/Makefile
@@ -1,4 +1,2 @@
 ccflags-y += -DISP2400B0
 ISP2400B0 := y
-
-include $(srctree)/$(src)/../Makefile.common
-- 
2.9.4
