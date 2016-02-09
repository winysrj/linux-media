Return-path: <linux-media-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:34856 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbcBIOnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 09:43:45 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-testers@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] [media] atmel-isi: Fix bad usage of IS_ERR_VALUE
Date: Tue,  9 Feb 2016 06:43:42 -0800
Message-Id: <1455029022-8234-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IS_ERR_VALUE() assumes that its parameter is an unsigned long.
It can not be used to check if an unsigned int reflects an error.
Doing so can result in the following build warning.

drivers/media/platform/soc_camera/atmel-isi.c:
	In function ‘atmel_isi_probe’:
	include/linux/err.h:21:38: warning:
		comparison is always false due to limited range of data type
drivers/media/platform/soc_camera/atmel-isi.c:1089:6: note:
	in expansion of macro ‘IS_ERR_VALUE’

If that warning is seen, the return value from platform_get_irq() is not
checked for errors.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 1af779ee3c74..ab2d9b9b1f5d 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -1026,7 +1026,7 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
 
 static int atmel_isi_probe(struct platform_device *pdev)
 {
-	unsigned int irq;
+	int irq;
 	struct atmel_isi *isi;
 	struct resource *regs;
 	int ret, i;
@@ -1086,7 +1086,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		isi->width_flags |= 1 << 9;
 
 	irq = platform_get_irq(pdev, 0);
-	if (IS_ERR_VALUE(irq)) {
+	if (irq < 0) {
 		ret = irq;
 		goto err_req_irq;
 	}
-- 
2.5.0

