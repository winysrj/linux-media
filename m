Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34685 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbaJVKEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:04:01 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/5] [media] vivid: select CONFIG_FB_CFB_FILLRECT/COPYAREA/IMAGEBLIT
Date: Wed, 22 Oct 2014 12:03:37 +0200
Message-Id: <1413972221-13669-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de>
References: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OSD simulation uses the framebuffer core functions, so vivid needs to
select the corresponding configuration options.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/vivid/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index d71139a..3bfda25 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -4,6 +4,9 @@ config VIDEO_VIVID
 	select FONT_SUPPORT
 	select FONT_8x16
 	select VIDEOBUF2_VMALLOC
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
 	default n
 	---help---
 	  Enables a virtual video driver. This driver emulates a webcam,
-- 
2.1.1

