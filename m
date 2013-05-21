Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45224 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3EUIYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 04:24:20 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: set umask 0644 on debug module param
Date: Tue, 21 May 2013 10:24:16 +0200
Message-Id: <1369124656-17579-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise module/coda/parameters/coda_debug won't show up in sysfs.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 0e29379..5e8e8ae 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -67,7 +67,7 @@
 #define fh_to_ctx(__fh)	container_of(__fh, struct coda_ctx, fh)
 
 static int coda_debug;
-module_param(coda_debug, int, 0);
+module_param(coda_debug, int, 0644);
 MODULE_PARM_DESC(coda_debug, "Debug level (0-1)");
 
 enum {
-- 
1.8.2.rc2

