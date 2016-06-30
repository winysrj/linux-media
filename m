Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:57651 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcF3MV4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 08:21:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Simon Horman <horms+renesas@verge.net.au>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [media] vsp1: clarify FCP dependency
Date: Thu, 30 Jun 2016 14:23:03 +0200
Message-Id: <20160630122325.4002029-2-arnd@arndb.de>
In-Reply-To: <20160630122325.4002029-1-arnd@arndb.de>
References: <20160630122325.4002029-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added FCP support in the vsp1 driver causes a link error
when CONFIG_RENESAS_FCP=m, since it's not reachable by built-in code:

drivers/media/built-in.o: In function `vsp1_remove':
:(.text+0xdeca0): undefined reference to `rcar_fcp_put'
drivers/media/built-in.o: In function `vsp1_probe':
:(.text+0xdef44): undefined reference to `rcar_fcp_get'

We already have a conditional dependency on FCP that requires
it for ARM64, so for all others we just have to prevent setting
RENESAS_VSP1=y when RENESAS_FCP=m by extending the FCP dependency.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 94fcdf829793 ("[media] v4l: vsp1: Add FCP support")
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 9d0a3ffe36d2..8b6ac7d08289 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -265,7 +265,7 @@ config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
-	depends on !ARM64 || VIDEO_RENESAS_FCP
+	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
-- 
2.9.0

