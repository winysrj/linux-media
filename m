Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:43306 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbcCCAXz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 19:23:55 -0500
From: Simon Horman <horms+renesas@verge.net.au>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v3] media: platform: rcar_jpu, vsp1: Use ARCH_RENESAS
Date: Thu,  3 Mar 2016 09:23:39 +0900
Message-Id: <1456964619-10734-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.

This is part of an ongoing process to migrate from ARCH_SHMOBILE to
ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

---
Based on media-tree/master

v3
* Update subject to not refer to sh_vou
* Added acks from Laurent Pinchart and Hans Verkuil

v2
* Do not update VIDEO_SH_VOU to use ARCH_RENESAS as this is
  used by some SH-based platforms and is not used by any ARM-based platforms
  so a dependency on ARCH_SHMOBILE is correct for that driver
* Added Geert Uytterhoeven's Ack
---
 drivers/media/platform/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 201f5c296a95..84e041c0a70e 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -238,7 +238,7 @@ config VIDEO_SH_VEU
 config VIDEO_RENESAS_JPU
 	tristate "Renesas JPEG Processing Unit"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
-	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -250,7 +250,7 @@ config VIDEO_RENESAS_JPU
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
-	depends on (ARCH_SHMOBILE && OF) || COMPILE_TEST
+	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
-- 
2.1.4

