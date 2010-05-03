Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:28544 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab0ECPmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 11:42:55 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] V4L: Events: Replace bad WARN_ON() with assert_spin_locked()
Date: Mon,  3 May 2010 18:42:46 +0300
Message-Id: <1272901366-7127-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4BDEEEDF.7050905@maxwell.research.nokia.com>
References: <4BDEEEDF.7050905@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

spin_is_locked() always returns zero when spinlock debugging is
disabled on a single CPU machine. Replace WARN_ON() with
assert_spin_locked().

Thanks to Laurent Pinchart for spotting this!

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 170e40f..91bb1c8 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -152,7 +152,7 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 	struct v4l2_events *events = fh->events;
 	struct v4l2_subscribed_event *sev;
 
-	WARN_ON(!spin_is_locked(&fh->vdev->fh_lock));
+	assert_spin_locked(&fh->vdev->fh_lock);
 
 	list_for_each_entry(sev, &events->subscribed, list) {
 		if (sev->type == type)
-- 
1.5.6.5

