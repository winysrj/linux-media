Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60898 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753413AbeDLPY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 12/17] media: staging: atomisp: add missing include
Date: Thu, 12 Apr 2018 11:24:04 -0400
Message-Id: <5b99e13b739298fc5b47fe106890a70001cec6b4.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two functions used externally:
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:866:6: warning: symbol 'atomisp_do_compat_ioctl' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:1110:6: warning: symbol 'atomisp_compat_ioctl32' was not declared. Should it be static?

whose include header is missing. Add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
index d7c0ef1f9584..15546b1f843d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
@@ -21,6 +21,7 @@
 
 #include "atomisp_internal.h"
 #include "atomisp_compat.h"
+#include "atomisp_ioctl.h"
 #include "atomisp_compat_ioctl32.h"
 
 static int get_atomisp_histogram32(struct atomisp_histogram *kp,
@@ -863,8 +864,8 @@ static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-long atomisp_do_compat_ioctl(struct file *file,
-			    unsigned int cmd, unsigned long arg)
+static long atomisp_do_compat_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	union {
 		struct atomisp_histogram his;
-- 
2.14.3
