Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:47472 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216Ab2FTWbA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 18:31:00 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH] media: remove unused element datawidth from struct mt9m111
Date: Thu, 21 Jun 2012 00:30:58 +0200
Message-Id: <1340231458-16460-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 drivers/media/video/mt9m111.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index b0c5299..863d722 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -214,7 +214,6 @@ struct mt9m111 {
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
 	int lastpage;	/* PageMap cache value */
-	unsigned char datawidth;
 };
 
 /* Find a data format by a pixel code */
-- 
1.7.9.5

