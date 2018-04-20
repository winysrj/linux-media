Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40757 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754591AbeDTMcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 08:32:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] media: sta2x11_vip: allow build with COMPILE_TEST
Date: Fri, 20 Apr 2018 08:32:14 -0400
Message-Id: <6f15d235042be02ce77d153bb7e84998b32387ca.1524227382.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524227382.git.mchehab@s-opensource.com>
References: <cover.1524227382.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524227382.git.mchehab@s-opensource.com>
References: <cover.1524227382.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver doesn't use any weird API. So, allow building it
with COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/sta2x11/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index e03587b1af71..7af3f1cbcea8 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -1,6 +1,6 @@
 config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
-	depends on STA2X11
+	depends on STA2X11 || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
-- 
2.14.3
