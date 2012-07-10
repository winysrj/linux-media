Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40177 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2GJLPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 07:15:06 -0400
Received: by pbbrp8 with SMTP id rp8so132133pbb.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 04:15:05 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, g.liakhovetski@gmx.de,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] V4L: Use NULL pointer instead of plain integer in v4l2-ctrls.c file
Date: Tue, 10 Jul 2012 16:44:46 +0530
Message-Id: <1341918886-7911-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:
drivers/media/video/v4l2-ctrls.c:2123:43: warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/v4l2-ctrls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9abd9ab..18101d6 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2120,7 +2120,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 	/* First zero the helper field in the master control references */
 	for (i = 0; i < cs->count; i++)
-		helpers[i].mref->helper = 0;
+		helpers[i].mref->helper = NULL;
 	for (i = 0, h = helpers; i < cs->count; i++, h++) {
 		struct v4l2_ctrl_ref *mref = h->mref;
 
-- 
1.7.4.1

