Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751500AbeBUXlP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 18:41:15 -0500
From: James Hogan <jhogan@kernel.org>
To: linux-metag@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Hogan <jhogan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 12/13] media: img-ir: Drop METAG dependency
Date: Wed, 21 Feb 2018 23:38:24 +0000
Message-Id: <20180221233825.10024-13-jhogan@kernel.org>
In-Reply-To: <20180221233825.10024-1-jhogan@kernel.org>
References: <20180221233825.10024-1-jhogan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that arch/metag/ has been removed, remove the METAG dependency from
the IMG IR device driver. The hardware is also present on MIPS SoCs so
the driver still has value.

Signed-off-by: James Hogan <jhogan@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-metag@vger.kernel.org
---
 drivers/media/rc/img-ir/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index a896d3c83a1c..d2c6617d468e 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -1,7 +1,7 @@
 config IR_IMG
 	tristate "ImgTec IR Decoder"
 	depends on RC_CORE
-	depends on METAG || MIPS || COMPILE_TEST
+	depends on MIPS || COMPILE_TEST
 	select IR_IMG_HW if !IR_IMG_RAW
 	help
 	   Say Y or M here if you want to use the ImgTec infrared decoder
-- 
2.13.6
