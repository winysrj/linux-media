Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38760
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750738AbdGLMcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 08:32:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@llwyncelyn.cymru>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] media: staging: atomisp: disable warnings with cc-disable-warning
Date: Wed, 12 Jul 2017 09:31:05 -0300
Message-Id: <5e7dbe75f7db3f47e1ed49bba6833dd81d6ce870.1499862654.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of directly using -Wno-foo, use cc-disable-warning, as it
checks if the compiler has the warnings we want to disable.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/Makefile | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index 726eaa293c55..2bd98f0667ec 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -354,7 +354,9 @@ ccflags-y += $(INCLUDES) $(DEFINES) -fno-common
 
 # HACK! While this driver is in bad shape, don't enable several warnings
 #       that would be otherwise enabled with W=1
-ccflags-y += -Wno-unused-const-variable -Wno-missing-prototypes \
-	     -Wno-unused-but-set-variable -Wno-missing-declarations \
-	     -Wno-suggest-attribute=format -Wno-missing-prototypes \
-	     -Wno-implicit-fallthrough
+ccflags-y += $(call cc-disable-warning, implicit-fallthrough)
+ccflags-y += $(call cc-disable-warning, missing-prototypes)
+ccflags-y += $(call cc-disable-warning, missing-declarations)
+ccflags-y += $(call cc-disable-warning, suggest-attribute=format)
+ccflags-y += $(call cc-disable-warning, unused-const-variable)
+ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
-- 
2.13.0
