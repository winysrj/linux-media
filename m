Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35453 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbcAOAPg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 19:15:36 -0500
Received: by mail-lf0-f53.google.com with SMTP id c192so273411942lfe.2
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2016 16:15:35 -0800 (PST)
From: Anders Roxell <anders.roxell@linaro.org>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
	Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] drivers/media: vsp1_video: fix compile error
Date: Fri, 15 Jan 2016 01:09:43 +0100
Message-Id: <1452816583-11036-1-git-send-email-anders.roxell@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was found with the -RT patch enabled, but the fix should apply to
non-RT also.

Compilation error without this fix:
../drivers/media/platform/vsp1/vsp1_video.c: In function
'vsp1_pipeline_stopped':
../drivers/media/platform/vsp1/vsp1_video.c:524:2: error: expected
expression before 'do'
  spin_unlock_irqrestore(&pipe->irqlock, flags);
    ^

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 637d0d6..b4dca57 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -515,7 +515,7 @@ static bool vsp1_pipeline_stopped(struct vsp1_pipeline *pipe)
 	bool stopped;
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
-	stopped = pipe->state == VSP1_PIPELINE_STOPPED,
+	stopped = pipe->state == VSP1_PIPELINE_STOPPED;
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 
 	return stopped;
-- 
2.1.4

