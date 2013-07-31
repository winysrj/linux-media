Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15854 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3GaQpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 12:45:50 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQT001B17WCM590@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Aug 2013 01:45:48 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, prabhakar.csengg@gmail.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] v4l2-async: Use proper list head for iteration over registered
 subdevs
Date: Wed, 31 Jul 2013 18:45:29 +0200
Message-id: <1375289129-8665-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes regression introduced in commit b426b3a660c85faf6e1ca1c92c6d
[media] V4L: Merge struct v4l2_async_subdev_list with struct v4l2_subdev

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/v4l2-async.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index a90d42b..cbfdd36 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -221,7 +221,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 
 	list_del(&notifier->list);
 
-	list_for_each_entry_safe(sd, tmp, &notifier->done, list) {
+	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
 		dev[i] = get_device(sd->dev);
 
 		v4l2_async_cleanup(sd);
-- 
1.7.9.5

