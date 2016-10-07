Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59644 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932719AbcJGQBQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 05/22] [media] v4l2-async: add new subdevices to the tail of subdev_list
Date: Fri,  7 Oct 2016 18:00:50 +0200
Message-Id: <20161007160107.5074-6-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That way the asynchronous notifier will pick them up in the order they
were registered.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-async.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 404eeea..1a62ed7 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -371,7 +371,7 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	}
 
 	/* None matched, wait for hot-plugging */
-	list_add(&sd->async_list, &subdev_list);
+	list_add_tail(&sd->async_list, &subdev_list);
 
 	mutex_unlock(&list_lock);
 
-- 
2.9.3

