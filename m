Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57776 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653Ab2CULDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:03:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 5/9] soc-camera: Fix bytes per line computation for planar formats
Date: Wed, 21 Mar 2012 12:03:24 +0100
Message-Id: <1332327808-6056-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 specification defines bytesperline for planar formats as the
number of bytes per line for the largest plane. Modify
soc_mbus_bytes_per_line() accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/soc_mediabus.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index 44dba6c..a707314 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -378,6 +378,9 @@ EXPORT_SYMBOL(soc_mbus_samples_per_pixel);
 
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 {
+	if (mf->layout != SOC_MBUS_LAYOUT_PACKED)
+		return width * mf->bits_per_sample / 8;
+
 	switch (mf->packing) {
 	case SOC_MBUS_PACKING_NONE:
 		return width * mf->bits_per_sample / 8;
-- 
1.7.3.4

