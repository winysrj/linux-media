Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:62171 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbeK3NTT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 08:19:19 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] v4l2: async: remove locking when initializing async notifier
Date: Fri, 30 Nov 2018 03:11:07 +0100
Message-Id: <20181130021107.32264-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to hold the list_lock when initializing the local
asd_list of a notifier. Remove the lock handling to simplify the code
and remove a potential LOCKDEP warning.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reported-by: Jacopo Mondi <jacopo@jmondi.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index a6d91370838d9342..15b0c44a76e7f6c3 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -424,11 +424,7 @@ static int v4l2_async_notifier_asd_valid(struct v4l2_async_notifier *notifier,
 
 void v4l2_async_notifier_init(struct v4l2_async_notifier *notifier)
 {
-	mutex_lock(&list_lock);
-
 	INIT_LIST_HEAD(&notifier->asd_list);
-
-	mutex_unlock(&list_lock);
 }
 EXPORT_SYMBOL(v4l2_async_notifier_init);
 
-- 
2.19.2
