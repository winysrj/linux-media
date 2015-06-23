Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60669 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbbFWJV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 05:21:26 -0400
Message-ID: <558924D7.4010904@xs4all.nl>
Date: Tue, 23 Jun 2015 11:20:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] v4l2-event: v4l2_event_queue: do nothing if vdev == NULL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the vdev pointer == NULL, then just return.

This makes it easier for subdev drivers to use this function without having to
check if the sd->devnode pointer is NULL or not.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 8761aab..8d3171c 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -172,6 +172,9 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 	unsigned long flags;
 	struct timespec timestamp;

+	if (vdev == NULL)
+		return;
+
 	ktime_get_ts(&timestamp);

 	spin_lock_irqsave(&vdev->fh_lock, flags);
