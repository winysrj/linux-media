Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58905 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbbF2TmA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 15:42:00 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>
Subject: [Patch 1/1] media: am437x-vpfe: Fix a race condition during release
Date: Mon, 29 Jun 2015 14:41:53 -0500
Message-ID: <1435606913-2279-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was a race condition where during cleanup/release operation
on-going streaming would cause a kernel panic because the hardware
module was disabled prematurely with IRQ still pending.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index a30cc2f..eb25c43 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1185,14 +1185,21 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe)
 static int vpfe_release(struct file *file)
 {
 	struct vpfe_device *vpfe = video_drvdata(file);
+	bool fh_singular = v4l2_fh_is_singular_file(file);
 	int ret;
 
 	mutex_lock(&vpfe->lock);
 
-	if (v4l2_fh_is_singular_file(file))
-		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
+	/* the release helper will cleanup any on-going streaming */
 	ret = _vb2_fop_release(file, NULL);
 
+	/*
+	 * If this was the last open file.
+	 * Then de-initialize hw module.
+	 */
+	if (fh_singular)
+		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
+
 	mutex_unlock(&vpfe->lock);
 
 	return ret;
-- 
1.8.5.1

