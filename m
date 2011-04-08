Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:40507 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757977Ab1DHX6x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Apr 2011 19:58:53 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2.6.39] soc_camera: OMAP1: fix missing bytesperline and sizeimage initialization
Date: Sat, 9 Apr 2011 01:57:38 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Message-Id: <201104090158.04827.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Since commit 0e4c180d3e2cc11e248f29d4c604b6194739d05a, bytesperline and 
sizeimage memebers of v4l2_pix_format structure have no longer been 
calculated inside soc_camera_g_fmt_vid_cap(), but rather passed via 
soc_camera_device structure from a host driver callback invoked by 
soc_camera_set_fmt().

OMAP1 camera host driver has never been providing these parameters, so 
it no longer works correctly. Fix it by adding suitable assignments to 
omap1_cam_set_fmt().

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 drivers/media/video/omap1_camera.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.39-rc2/drivers/media/video/omap1_camera.c.orig	2011-04-06 14:30:37.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/omap1_camera.c	2011-04-09 00:16:36.000000000 +0200
@@ -1292,6 +1292,12 @@ static int omap1_cam_set_fmt(struct soc_
 	pix->colorspace  = mf.colorspace;
 	icd->current_fmt = xlate;
 
+	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
+						    xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
+	pix->sizeimage = pix->height * pix->bytesperline;
+
 	return 0;
 }
 
