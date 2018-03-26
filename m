Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40564 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbeCZVLC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Derek Robson <robsonde@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 06/18] media: staging: atomisp: add a missing include
Date: Mon, 26 Mar 2018 17:10:39 -0400
Message-Id: <4fb9eb181750030d9acc21feb6247c7b24bc996f.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

atomisp_drvfs.c is not including its own header, causing those
warnings:
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c:185:5: warning: symbol 'atomisp_drvfs_init' was not declared. Should it be static?
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c:201:6: warning: symbol 'atomisp_drvfs_exit' was not declared. Should it be static?

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
index ceedb82b6beb..a815c768bda9 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
@@ -22,6 +22,7 @@
 #include "atomisp_compat.h"
 #include "atomisp_internal.h"
 #include "atomisp_ioctl.h"
+#include "atomisp_drvfs.h"
 #include "hmm/hmm.h"
 
 /*
-- 
2.14.3
