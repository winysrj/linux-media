Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33024 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaFLRGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [RFC PATCH 13/26] [media] v4l2 async: remove from notifier list
Date: Thu, 12 Jun 2014 19:06:27 +0200
Message-Id: <1402592800-2925-14-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

In v4l2_async_notifier_register remove the notifier from the notifier
list in case of an error.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-async.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 85a6a34..1e1e58c 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -173,6 +173,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 
 		ret = v4l2_async_test_notify(notifier, sd, asd);
 		if (ret < 0) {
+			list_del(&notifier->list);
 			mutex_unlock(&list_lock);
 			return ret;
 		}
-- 
2.0.0.rc2

