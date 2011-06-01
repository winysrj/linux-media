Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58326 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1FAQlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 12:41:45 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-media@vger.kernel.org>
Cc: <laurent.pinchart@ideasonboard.com>, <linux-omap@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] media: omap3isp: fix a pontential NULL deref
Date: Wed,  1 Jun 2011 19:39:46 +0300
Message-Id: <1306946386-31869-1-git-send-email-ohad@wizery.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix a potential NULL pointer dereference by skipping registration of
external entities in case none are provided.

This is useful at least when testing mere memory-to-memory scenarios.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/media/video/omap3isp/isp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 2a5fbe6..367ced3 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1756,7 +1756,7 @@ static int isp_register_entities(struct isp_device *isp)
 		goto done;
 
 	/* Register external entities */
-	for (subdevs = pdata->subdevs; subdevs->subdevs; ++subdevs) {
+	for (subdevs = pdata->subdevs; subdevs && subdevs->subdevs; ++subdevs) {
 		struct v4l2_subdev *sensor;
 		struct media_entity *input;
 		unsigned int flags;
-- 
1.7.1

