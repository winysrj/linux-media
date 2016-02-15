Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23918 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbcBOOgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 09:36:45 -0500
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 4/7] atmel-isi: fix IS_ERR_VALUE usage
Date: Mon, 15 Feb 2016 15:35:22 +0100
Message-id: <1455546925-22119-5-git-send-email-a.hajda@samsung.com>
In-reply-to: <1455546925-22119-1-git-send-email-a.hajda@samsung.com>
References: <1455546925-22119-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IS_ERR_VALUE macro should be used only with unsigned long type.
For signed types comparison 'ret < 0' should be used.

The patch follows conclusion from discussion on LKML [1][2].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2120927
[2]: http://permalink.gmane.org/gmane.linux.kernel/2150581

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 1af779e..ab2d9b9 100644
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
1.9.1

