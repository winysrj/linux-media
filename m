Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59636 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab3J1Xqw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 19:46:52 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 07/19] v4l: sh_vou: Enable the driver on all ARM platforms
Date: Tue, 29 Oct 2013 00:46:55 +0100
Message-Id: <1383004027-25036-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1383004027-25036-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1383004027-25036-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Renesas ARM platforms are transitioning from single-platform to
multi-platform kernels using the new ARCH_SHMOBILE_MULTI. Make the
driver available on all ARM platforms to enable it on both ARCH_SHMOBILE
and ARCH_SHMOBILE_MULTI and increase build testing coverage.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c7caf94..a726f86 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -36,7 +36,7 @@ source "drivers/media/platform/blackfin/Kconfig"
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
-	depends on VIDEO_DEV && ARCH_SHMOBILE && I2C
+	depends on VIDEO_DEV && ARM && I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
 	  Support for the Video Output Unit (VOU) on SuperH SoCs.
-- 
1.8.1.5

