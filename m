Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41178 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3EUISZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 04:18:25 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: v4l2-compliance fix: add bus_info prefix 'platform'
Date: Tue, 21 May 2013 10:18:22 +0200
Message-Id: <1369124302-12625-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 48b8d7a..d64908a 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -323,7 +323,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strlcpy(cap->driver, CODA_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, CODA_NAME, sizeof(cap->card));
-	strlcpy(cap->bus_info, CODA_NAME, sizeof(cap->bus_info));
+	strlcpy(cap->bus_info, "platform:" CODA_NAME, sizeof(cap->bus_info));
 	/*
 	 * This is only a mem-to-mem video device. The capture and output
 	 * device capability flags are left only for backward compatibility
-- 
1.8.2.rc2

