Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:14220 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaIANSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 09:18:09 -0400
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] v4l: vsp1: fix driver dependencies
Date: Mon, 01 Sep 2014 15:18:02 +0200
Message-id: <25174054.f3JtKIKjvH@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Renesas VSP1 Video Processing Engine support should be available
only on Renesas ARM SoCs.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
---
 drivers/media/platform/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/media/platform/Kconfig
===================================================================
--- a/drivers/media/platform/Kconfig	2014-09-01 14:51:37.024553544 +0200
+++ b/drivers/media/platform/Kconfig	2014-09-01 15:17:34.284594657 +0200
@@ -213,6 +213,7 @@ config VIDEO_SH_VEU
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on ARCH_SHMOBILE || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.

