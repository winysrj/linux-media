Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34629 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752191AbdBOR4K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 12:56:10 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5/6] [media] vivid: improve subscribe event handling
Date: Wed, 15 Feb 2017 15:55:32 -0200
Message-Id: <20170215175533.6384-5-gustavo@padovan.org>
In-Reply-To: <20170215175533.6384-1-gustavo@padovan.org>
References: <20170215175533.6384-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

We already check for the V4L2_EVENT_CTRL inside
v4l2_ctrl_subscribe_event() so just move this fuction to the default:
branch of the switch and let it does the job for us.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/platform/vivid/vivid-vid-out.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 7ba52ee..1a33730 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -1172,14 +1172,12 @@ int vidioc_subscribe_event(struct v4l2_fh *fh,
 			const struct v4l2_event_subscription *sub)
 {
 	switch (sub->type) {
-	case V4L2_EVENT_CTRL:
-		return v4l2_ctrl_subscribe_event(fh, sub);
 	case V4L2_EVENT_SOURCE_CHANGE:
 		if (fh->vdev->vfl_dir == VFL_DIR_RX)
 			return v4l2_src_change_event_subscribe(fh, sub);
 		break;
 	default:
-		break;
+		return v4l2_ctrl_subscribe_event(fh, sub);
 	}
 	return -EINVAL;
 }
-- 
2.9.3
