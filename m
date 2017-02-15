Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33459 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752553AbdBORz6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 12:55:58 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 6/6] [media] go7007: improve subscribe event handling
Date: Wed, 15 Feb 2017 15:55:33 -0200
Message-Id: <20170215175533.6384-6-gustavo@padovan.org>
In-Reply-To: <20170215175533.6384-1-gustavo@padovan.org>
References: <20170215175533.6384-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

We already check for the V4L2_EVENT_CTRL inside
v4l2_ctrl_subscribe_event() so just move this function to the default:
branch of the switch and let it does the job for us.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/usb/go7007/go7007-v4l2.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 4eaba0c..ed5ec97 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -792,14 +792,13 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
 {
 
 	switch (sub->type) {
-	case V4L2_EVENT_CTRL:
-		return v4l2_ctrl_subscribe_event(fh, sub);
 	case V4L2_EVENT_MOTION_DET:
 		/* Allow for up to 30 events (1 second for NTSC) to be
 		 * stored. */
 		return v4l2_event_subscribe(fh, sub, 30, NULL);
+	default:
+		return v4l2_ctrl_subscribe_event(fh, sub);
 	}
-	return -EINVAL;
 }
 
 
-- 
2.9.3
