Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3CHLZ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 06:25:29 -0500
Date: Fri, 8 Mar 2013 12:25:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH] soc-camera: fix typos in the default format-conversion table
Message-ID: <Pine.LNX.4.64.1303081222490.24912@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The default format conversion table mbus_fmt[] in soc_mediabus.c lists
"natural" conversions between media-bus and fourcc pixel formats, that are
achieved by storing data from the bus in RAM exactly as it arrives, only
possibly padding missing high or low bits. Such data acquisition mode
cannot change data endianness, therefore two locations with opposite
endianness are erroneous. This change might affest the omap1-camera driver,
existing configurations should be verified.

Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_mediabus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index a397812..1f6d695 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -73,7 +73,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.name			= "RGB555X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
-		.order			= SOC_MBUS_ORDER_LE,
+		.order			= SOC_MBUS_ORDER_BE,
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
@@ -93,7 +93,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.name			= "RGB565X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
-		.order			= SOC_MBUS_ORDER_LE,
+		.order			= SOC_MBUS_ORDER_BE,
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-- 
1.7.2.5

