Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46745 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758877AbbLBRAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2015 12:00:18 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/5] [media] coda: make to_coda_video_device static
Date: Wed,  2 Dec 2015 17:58:50 +0100
Message-Id: <1449075534-8072-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is not used outside coda-common.c.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 15516a6..03b46de 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -293,7 +293,8 @@ static void coda_get_max_dimensions(struct coda_dev *dev,
 		*max_h = h;
 }
 
-const struct coda_video_device *to_coda_video_device(struct video_device *vdev)
+static const struct coda_video_device *to_coda_video_device(struct video_device
+							    *vdev)
 {
 	struct coda_dev *dev = video_get_drvdata(vdev);
 	unsigned int i = vdev - dev->vfd;
-- 
2.6.2

