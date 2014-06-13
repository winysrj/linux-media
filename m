Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44455 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaFMQJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:08 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 14/30] [media] coda: select GENERIC_ALLOCATOR
Date: Fri, 13 Jun 2014 18:08:40 +0200
Message-Id: <1402675736-15379-15-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver uses the genalloc API, which doesn't have stubs in
case GENERIC_ALLOCATOR is disabled.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 20f1655..1d2ac9d 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -140,6 +140,7 @@ config VIDEO_CODA
 	select SRAM
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
+	select GENERIC_ALLOCATOR
 	---help---
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
-- 
2.0.0.rc2

