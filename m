Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62514 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbeDEU36 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:29:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH v2 17/19] media: omap4iss: make it build with COMPILE_TEST
Date: Thu,  5 Apr 2018 16:29:44 -0400
Message-Id: <f6b45300aebbfc67100b000a91cbe80056bef306.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver compile as-is with COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/omap4iss/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index 46183464ee79..192ba0829128 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_OMAP4
 	tristate "OMAP 4 Camera support"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C && ARCH_OMAP4
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C
+	depends on ARCH_OMAP4 || COMPILE_TEST
 	depends on HAS_DMA
 	select MFD_SYSCON
 	select VIDEOBUF2_DMA_CONTIG
-- 
2.14.3
