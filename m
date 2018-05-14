Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38000 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932369AbeENNNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 09:13:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH 6/7] renesas-ceu: fix compiler warning
Date: Mon, 14 May 2018 15:13:45 +0200
Message-Id: <20180514131346.15795-7-hverkuil@xs4all.nl>
In-Reply-To: <20180514131346.15795-1-hverkuil@xs4all.nl>
References: <20180514131346.15795-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In function 'strncpy',
    inlined from 'ceu_notify_complete' at drivers/media/platform/renesas-ceu.c:1378:2:
include/linux/string.h:246:9: warning: '__builtin_strncpy' output truncated before terminating nul copying 11 bytes from a string of the same length [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/renesas-ceu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index 4879261857fc..fe4fe944592d 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -1375,7 +1375,7 @@ static int ceu_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 
 	/* Register the video device. */
-	strncpy(vdev->name, DRIVER_NAME, strlen(DRIVER_NAME));
+	strlcpy(vdev->name, DRIVER_NAME, sizeof(vdev->name));
 	vdev->v4l2_dev		= v4l2_dev;
 	vdev->lock		= &ceudev->mlock;
 	vdev->queue		= &ceudev->vb2_vq;
-- 
2.17.0
