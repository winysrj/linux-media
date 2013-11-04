Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48333 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KDAG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 13/18] v4l: omap4iss: Remove unneeded status variable
Date: Mon,  4 Nov 2013 01:06:38 +0100
Message-Id: <1383523603-3907-14-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The failure variable is initialized with 0 and used as a return value
without ever being modified. Remove it and return 0 directly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 243fcb8..320bfd4 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -560,7 +560,6 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe)
 	struct media_entity *entity;
 	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
-	int failure = 0;
 
 	entity = &pipe->output->video.entity;
 	while (1) {
@@ -579,7 +578,7 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe)
 		v4l2_subdev_call(subdev, video, s_stream, 0);
 	}
 
-	return failure;
+	return 0;
 }
 
 /*
-- 
1.8.1.5

