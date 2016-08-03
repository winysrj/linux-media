Return-path: <linux-media-owner@vger.kernel.org>
Received: from leibniz.telenet-ops.be ([195.130.137.77]:58891 "EHLO
	leibniz.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbcHCSaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 14:30:20 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
	by leibniz.telenet-ops.be (Postfix) with ESMTP id 3s4Lkl0K4nzMrMQ4
	for <linux-media@vger.kernel.org>; Wed,  3 Aug 2016 20:12:15 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] [media] VIDEO_MEDIATEK_VPU should depend on HAS_DMA
Date: Wed,  3 Aug 2016 20:10:09 +0200
Message-Id: <1470247809-31212-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1470247809-31212-1-git-send-email-geert@linux-m68k.org>
References: <1470247809-31212-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If NO_DMA=y:

    ERROR: "bad_dma_ops" [drivers/media/platform/mtk-vpu/mtk-vpu.ko] undefined!

Add a dependency on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 552b635cfce7f02b..a6ed2e077ad0f2d2 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -155,7 +155,7 @@ config VIDEO_CODA
 
 config VIDEO_MEDIATEK_VPU
 	tristate "Mediatek Video Processor Unit"
-	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	---help---
 	    This driver provides downloading VPU firmware and
-- 
1.9.1

