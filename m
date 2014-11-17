Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:44664 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaKQMSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 07:18:07 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [REVIEW PATCH 3/5] img-ir: Depend on METAG or MIPS or COMPILE_TEST
Date: Mon, 17 Nov 2014 12:17:47 +0000
Message-ID: <1416226669-2983-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
References: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ImgTec Infrared decoder block which img-ir drives is only used in
IMGWorks SoCs so far, such as the TZ1090 (Meta based) and the upcoming
Pistachio (MIPS based). Therefore make the driver depend on METAG (for
TZ1090) or MIPS (for Pistachio) or COMPILE_TEST (so that it is included
in x86 allmodconfig builds), to avoid cluttering the Kconfig menu with
drivers for hardware that isn't yet available on other platforms.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 03ba9fc170fb..580715c7fc5e 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -1,6 +1,7 @@
 config IR_IMG
 	tristate "ImgTec IR Decoder"
 	depends on RC_CORE
+	depends on METAG || MIPS || COMPILE_TEST
 	select IR_IMG_HW if !IR_IMG_RAW
 	help
 	   Say Y or M here if you want to use the ImgTec infrared decoder
-- 
2.0.4

