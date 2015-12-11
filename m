Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37534 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbbLKRRB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:17:01 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 03/10] [media] omap3isp: rename single labels to just error
Date: Fri, 11 Dec 2015 14:16:29 -0300
Message-Id: <1449854196-13296-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit bc36b30fe06b ("[media] omap3isp: separate links creation from
entities init") moved the link creation logic from the entities init
functions and so removed the error_link labels from the error paths.

But after that, some functions have a single error label so it makes
more sense to rename the label to just "error" in thi case.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

This patch addresses the last remaining issue Laurent pointed in patch [0]:

1- Rename label to just "error" if there is a single error label.

[0]: https://patchwork.linuxtv.org/patch/31147/

 drivers/media/platform/omap3isp/ispccdc.c | 4 ++--
 drivers/media/platform/omap3isp/ispccp2.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 5e16b5f594b7..4eaf926d6073 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2669,11 +2669,11 @@ static int ccdc_init_entities(struct isp_ccdc_device *ccdc)
 
 	ret = omap3isp_video_init(&ccdc->video_out, "CCDC");
 	if (ret < 0)
-		goto error_video;
+		goto error;
 
 	return 0;
 
-error_video:
+error:
 	media_entity_cleanup(me);
 	return ret;
 }
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 27f5fe4edefc..ca095238510d 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1102,11 +1102,11 @@ static int ccp2_init_entities(struct isp_ccp2_device *ccp2)
 
 	ret = omap3isp_video_init(&ccp2->video_in, "CCP2");
 	if (ret < 0)
-		goto error_video;
+		goto error;
 
 	return 0;
 
-error_video:
+error:
 	media_entity_cleanup(&ccp2->subdev.entity);
 	return ret;
 }
-- 
2.4.3

