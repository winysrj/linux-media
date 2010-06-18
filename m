Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48294 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753814Ab0FRXCY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jun 2010 19:02:24 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1OPkZr-0003td-3W
	for linux-media@vger.kernel.org; Sat, 19 Jun 2010 01:02:23 +0200
Date: Sat, 19 Jun 2010 01:02:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] sh_mobile_ceu_camera: fix debugging message
Message-ID: <Pine.LNX.4.64.1006190101330.3118@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With enabled debugging sh_mobile_ceu_camera.c dereferences an invalid or a NULL
pointer. Thanks to James Wang for reporting.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 4ac3b48..3766e30 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1005,7 +1005,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 		xlate->code	= code;
 		xlate++;
 		dev_dbg(dev, "Providing format %s in pass-through mode\n",
-			xlate->host_fmt->name);
+			fmt->name);
 	}
 
 	return formats;
-- 
1.6.2.4

