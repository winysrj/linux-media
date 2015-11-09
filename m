Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45338 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbKIWBt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 17:01:49 -0500
Received: from avalon.bb.dnainternet.fi (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 39E09200DE
	for <linux-media@vger.kernel.org>; Mon,  9 Nov 2015 23:01:16 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: omap4iss: Make module stop timeout print a warning message
Date: Tue, 10 Nov 2015 00:01:56 +0200
Message-Id: <1447106517-27086-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Module stop timeouts are serious enough that they deserve a proper
warning message, not a debug message that will go unnoticed.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 0b03cb7c59d5..b7e82eed8aad 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -601,8 +601,8 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe,
 		subdev = media_entity_to_v4l2_subdev(entity);
 		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
 		if (ret < 0) {
-			dev_dbg(iss->dev, "%s: module stop timeout.\n",
-				subdev->name);
+			dev_warn(iss->dev, "%s: module stop timeout.\n",
+				 subdev->name);
 			/* If the entity failed to stopped, assume it has
 			 * crashed. Mark it as such, the ISS will be reset when
 			 * applications will release it.
-- 
Regards,

Laurent Pinchart

