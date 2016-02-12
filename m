Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35826 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbcBLKxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 05:53:38 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
	linux-media@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Benoit Parrot <bparrot@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] media: ti-vpe: add dependency of HAS_DMA
Date: Fri, 12 Feb 2016 16:23:28 +0530
Message-Id: <1455274408-23978-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The build of m32r allmodconfig fails with the error:
 drivers/media/v4l2-core/videobuf2-dma-contig.c:492:28: error: implicit
	declaration of function 'dma_get_cache_alignment'

The build of videobuf2-dma-contig.c depends on HAS_DMA and it is
correctly mentioned in the Kconfig but the symbol VIDEO_TI_CAL also
selects VIDEOBUF2_DMA_CONTIG, so it is trying to compile
videobuf2-dma-contig.c even though HAS_DMA is not defined.

Fixes: 343e89a792a5 ("[media] media: ti-vpe: Add CAL v4l2 camera capture driver")
Cc: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

build log of next-20160212 is at:
https://travis-ci.org/sudipm-mukherjee/parport/jobs/108716158

 drivers/media/platform/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index fd4fcd5..16dbe3d 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -124,6 +124,7 @@ config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on SOC_DRA7XX || COMPILE_TEST
+	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	---help---
-- 
1.9.1

