Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53300 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbaCZVK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 17:10:57 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so2345377wib.10
        for <linux-media@vger.kernel.org>; Wed, 26 Mar 2014 14:10:56 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 1/3] rc-main: Revert generic scancode filtering support
Date: Wed, 26 Mar 2014 21:08:31 +0000
Message-Id: <1395868113-17950-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1395868113-17950-1-git-send-email-james.hogan@imgtec.com>
References: <1395868113-17950-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit b8c7d915087c ([media] rc-main: add generic scancode
filtering), and removes certain parts of commit 6bea25af147f ([media]
rc-main: automatically refresh filter on protocol change) where generic
filtering is taken into account when refreshing filters on a protocol
change, but that code cannot be reached any longer since the filter mask
will always be zero if the s_filter callback is NULL.

Generic scancode filtering had questionable value and as David said:
> given how difficult it is to remove functionality that is in a
> released kernel...I think that particular part (i.e. the software
> filtering) should be removed until it has had further discussion.

Reported-by: David Härdeman <david@hardeman.nu>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: David Härdeman <david@hardeman.nu>
Cc: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/rc-main.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 99697aa..e067fee 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -633,7 +633,6 @@ EXPORT_SYMBOL_GPL(rc_repeat);
 static void ir_do_keydown(struct rc_dev *dev, int scancode,
 			  u32 keycode, u8 toggle)
 {
-	struct rc_scancode_filter *filter;
 	bool new_event = !dev->keypressed ||
 			 dev->last_scancode != scancode ||
 			 dev->last_toggle != toggle;
@@ -641,11 +640,6 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
 	if (new_event && dev->keypressed)
 		ir_do_keyup(dev, false);
 
-	/* Generic scancode filtering */
-	filter = &dev->scancode_filters[RC_FILTER_NORMAL];
-	if (filter->mask && ((scancode ^ filter->data) & filter->mask))
-		return;
-
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
 
 	if (new_event && keycode != KEY_RESERVED) {
@@ -1012,9 +1006,6 @@ static ssize_t store_protocols(struct device *device,
 		if (!type) {
 			/* no protocol => clear filter */
 			ret = -1;
-		} else if (!dev->s_filter) {
-			/* generic filtering => accept any filter */
-			ret = 0;
 		} else {
 			/* hardware filtering => try setting, otherwise clear */
 			ret = dev->s_filter(dev, fattr->type, &local_filter);
@@ -1023,8 +1014,7 @@ static ssize_t store_protocols(struct device *device,
 			/* clear the filter */
 			local_filter.data = 0;
 			local_filter.mask = 0;
-			if (dev->s_filter)
-				dev->s_filter(dev, fattr->type, &local_filter);
+			dev->s_filter(dev, fattr->type, &local_filter);
 		}
 
 		/* commit the new filter */
@@ -1068,7 +1058,9 @@ static ssize_t show_filter(struct device *device,
 		return -EINVAL;
 
 	mutex_lock(&dev->lock);
-	if (fattr->mask)
+	if (!dev->s_filter)
+		val = 0;
+	else if (fattr->mask)
 		val = dev->scancode_filters[fattr->type].mask;
 	else
 		val = dev->scancode_filters[fattr->type].data;
@@ -1116,7 +1108,7 @@ static ssize_t store_filter(struct device *device,
 		return ret;
 
 	/* Scancode filter not supported (but still accept 0) */
-	if (!dev->s_filter && fattr->type != RC_FILTER_NORMAL)
+	if (!dev->s_filter)
 		return val ? -EINVAL : count;
 
 	mutex_lock(&dev->lock);
@@ -1133,11 +1125,9 @@ static ssize_t store_filter(struct device *device,
 		ret = -EINVAL;
 		goto unlock;
 	}
-	if (dev->s_filter) {
-		ret = dev->s_filter(dev, fattr->type, &local_filter);
-		if (ret < 0)
-			goto unlock;
-	}
+	ret = dev->s_filter(dev, fattr->type, &local_filter);
+	if (ret < 0)
+		goto unlock;
 
 	/* Success, commit the new filter */
 	*filter = local_filter;
-- 
1.8.3.2

