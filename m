Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51810 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab0HCK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:57:54 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 09/11] v4l2-mediabus: Add pixelcodes for BGR565 formats
Date: Tue,  3 Aug 2010 12:57:47 +0200
Message-Id: <1280833069-26993-10-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 include/media/v4l2-mediabus.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 0dbe02a..d0b7340 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -32,6 +32,8 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
 	V4L2_MBUS_FMT_RGB565_2X8_LE,
 	V4L2_MBUS_FMT_RGB565_2X8_BE,
+	V4L2_MBUS_FMT_BGR565_2X8_LE,
+	V4L2_MBUS_FMT_BGR565_2X8_BE,
 	V4L2_MBUS_FMT_SBGGR8_1X8,
 	V4L2_MBUS_FMT_SBGGR10_1X10,
 	V4L2_MBUS_FMT_GREY8_1X8,
-- 
1.7.1

