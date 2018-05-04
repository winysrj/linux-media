Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64919 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbeEDMOD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 08:14:03 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH] media: vsp1: cleanup a false positive warning
Date: Fri,  4 May 2018 08:13:58 -0400
Message-Id: <a1bedd480c31bcc2f48cd6d965a9bb853e8786ee.1525436031.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the new vsp1 code changes introduced by changeset
f81f9adc4ee1 ("media: v4l: vsp1: Assign BRU and BRS to pipelines dynamically"),
smatch complains with:
	drivers/media/platform/vsp1/vsp1_drm.c:262 vsp1_du_pipeline_setup_bru() error: we previously assumed 'pipe->bru' could be null (see line 180)

This is a false positive, as, if pipe->bru is NULL, the brx
var will be different, with ends by calling a code that will
set pipe->bru to another value.

Yet, cleaning this false positive is as easy as adding an explicit
check if pipe->bru is NULL.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 095dc48aa25a..cb6b60843400 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -185,7 +185,7 @@ static int vsp1_du_pipeline_setup_brx(struct vsp1_device *vsp1,
 		brx = &vsp1->brs->entity;
 
 	/* Switch BRx if needed. */
-	if (brx != pipe->brx) {
+	if (brx != pipe->brx || !pipe->brx) {
 		struct vsp1_entity *released_brx = NULL;
 
 		/* Release our BRx if we have one. */
-- 
2.17.0
