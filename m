Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:28651 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2DVKok (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 06:44:40 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com
Subject: [PATCH 1/1] s5p-fimc: media_entity_pipeline_start() may fail
Date: Sun, 22 Apr 2012 13:44:39 +0300
Message-Id: <1335091479-26943-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Take into account media_entity_pipeline_start() may fail. This patch is
dependent on "media: Add link_validate() op to check links to the sink pad".

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
(Just correct Sylwester's e-mail. Sorry for the noise.)

The dependent patch is part of my pull req to Mauro here:

<URL:http://www.spinics.net/lists/linux-media/msg46296.html>

 drivers/media/video/s5p-fimc/fimc-capture.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index dc18ba5..8fd8095 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -963,7 +963,9 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	media_entity_pipeline_start(&p->sensor->entity, p->pipe);
+	ret = media_entity_pipeline_start(&p->sensor->entity, p->pipe);
+	if (ret < 0)
+		return ret;
 
 	if (fimc->vid_cap.user_subdev_api) {
 		ret = fimc_pipeline_validate(fimc);
-- 
1.7.2.5

