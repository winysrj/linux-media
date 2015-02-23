Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42769 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbbBWPUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:20 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 05/12] [media] coda: use strlcpy instead of snprintf
Date: Mon, 23 Feb 2015 16:20:06 +0100
Message-Id: <1424704813-20792-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to take the detour through a "%s" format string
to create a copy of a string.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 37bbd57..04130ea 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1908,8 +1908,7 @@ static int coda_register_device(struct coda_dev *dev, int i)
 	if (i >= dev->devtype->num_vdevs)
 		return -EINVAL;
 
-	snprintf(vfd->name, sizeof(vfd->name), "%s",
-		 dev->devtype->vdevs[i]->name);
+	strlcpy(vfd->name, dev->devtype->vdevs[i]->name, sizeof(vfd->name));
 	vfd->fops	= &coda_fops;
 	vfd->ioctl_ops	= &coda_ioctl_ops;
 	vfd->release	= video_device_release_empty,
-- 
2.1.4

