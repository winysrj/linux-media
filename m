Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44934 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbeDEU35 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:29:57 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 11/19] media: davinci: allow building isif code
Date: Thu,  5 Apr 2018 16:29:38 -0400
Message-Id: <da9c37673dff87dd86d7c838f004bf795223eebc.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The only reason why this driver doesn't build with COMPILE_TEST
is because it includes mach/mux.h. It turns that none of the
macros defined there are used.

So, get rid of it, in order to allow it to build with
COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/Kconfig | 3 ++-
 drivers/media/platform/davinci/isif.c  | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 55982e681d77..babdb4877b3f 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -67,7 +67,8 @@ config VIDEO_DM355_CCDC
 
 config VIDEO_DM365_ISIF
 	tristate "TI DM365 ISIF video capture driver"
-	depends on VIDEO_V4L2 && ARCH_DAVINCI
+	depends on VIDEO_V4L2
+	depends on ARCH_DAVINCI || COMPILE_TEST
 	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index d5ff58494c1e..b14caadcd0df 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -31,8 +31,6 @@
 #include <linux/err.h>
 #include <linux/module.h>
 
-#include <mach/mux.h>
-
 #include <media/davinci/isif.h>
 #include <media/davinci/vpss.h>
 
-- 
2.14.3
