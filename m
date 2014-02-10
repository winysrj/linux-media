Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:35753 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaBJVcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 16:32:08 -0500
Received: by mail-we0-f173.google.com with SMTP id x55so4665580wes.18
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 13:32:07 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] rc-main: store_filter: pass errors to userland
Date: Mon, 10 Feb 2014 21:31:56 +0000
Message-Id: <1392067916-29681-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Propagate errors returned by drivers from the s_filter callback back to
userland when updating scancode filters. This allows userland to see
when the filter couldn't be updated, usually because it's not a valid
filter for the hardware.

Previously the filter was being updated conditionally on success of
s_filter, but the write always reported success back to userland.

Reported-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/rc-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 2ec60f8..6448128 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1090,7 +1090,7 @@ static ssize_t store_filter(struct device *device,
 
 unlock:
 	mutex_unlock(&dev->lock);
-	return count;
+	return (ret < 0) ? ret : count;
 }
 
 static void rc_dev_release(struct device *device)
-- 
1.8.3.2

