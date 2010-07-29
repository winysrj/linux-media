Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:59666 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752766Ab0G2HcP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 03:32:15 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1OeNbM-00054r-1E
	for linux-media@vger.kernel.org; Thu, 29 Jul 2010 09:32:24 +0200
Date: Thu, 29 Jul 2010 09:32:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: fix a comment in a driver
Message-ID: <Pine.LNX.4.64.1007290930250.16266@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RJ54N1CB0C is a Sharp camera sensor.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/rj54n1cb0c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index bbd9c11..6457d5a 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -1,5 +1,5 @@
 /*
- * Driver for RJ54N1CB0C CMOS Image Sensor from Micron
+ * Driver for RJ54N1CB0C CMOS Image Sensor from Sharp
  *
  * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
  *
-- 
1.7.2

