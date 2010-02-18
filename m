Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:42997 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab0BRGEJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 01:04:09 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] v4l: soc_camera: fix bound checking of mbus_fmt[] index
Date: Thu, 18 Feb 2010 08:03:33 +0200
Message-Id: <f9972846401291b8619792d11869510e856ee202.1266472904.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When code <= V4L2_MBUS_FMT_FIXED soc_mbus_get_fmtdesc returns a pointer to
mbus_fmt[x], where x < 0. Fix this.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/media/video/soc_mediabus.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index f8d5c87..a2808e2 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -136,6 +136,8 @@ const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
 {
 	if ((unsigned int)(code - V4L2_MBUS_FMT_FIXED) > ARRAY_SIZE(mbus_fmt))
 		return NULL;
+	if ((unsigned int)code <= V4L2_MBUS_FMT_FIXED)
+		return NULL;
 	return mbus_fmt + code - V4L2_MBUS_FMT_FIXED - 1;
 }
 EXPORT_SYMBOL(soc_mbus_get_fmtdesc);
-- 
1.6.6.1

