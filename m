Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40479 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaB1XRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 18:17:39 -0500
Received: by mail-wi0-f180.google.com with SMTP id hm4so1203580wib.13
        for <linux-media@vger.kernel.org>; Fri, 28 Feb 2014 15:17:38 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 1/5] rc-main: add generic scancode filtering
Date: Fri, 28 Feb 2014 23:17:02 +0000
Message-Id: <1393629426-31341-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add generic scancode filtering of RC input events, and fall back to
permitting any RC_FILTER_NORMAL scancode filter to be set if no s_filter
callback exists. This allows raw IR decoder events to be filtered, and
potentially allows hardware decoders to set looser filters and rely on
generic code to filter out the corner cases.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/rc-main.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6448128..0a4f680 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -633,6 +633,7 @@ EXPORT_SYMBOL_GPL(rc_repeat);
 static void ir_do_keydown(struct rc_dev *dev, int scancode,
 			  u32 keycode, u8 toggle)
 {
+	struct rc_scancode_filter *filter;
 	bool new_event = !dev->keypressed ||
 			 dev->last_scancode != scancode ||
 			 dev->last_toggle != toggle;
@@ -640,6 +641,11 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
 	if (new_event && dev->keypressed)
 		ir_do_keyup(dev, false);
 
+	/* Generic scancode filtering */
+	filter = &dev->scancode_filters[RC_FILTER_NORMAL];
+	if (filter->mask && ((scancode ^ filter->data) & filter->mask))
+		return;
+
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
 
 	if (new_event && keycode != KEY_RESERVED) {
@@ -1019,9 +1025,7 @@ static ssize_t show_filter(struct device *device,
 		return -EINVAL;
 
 	mutex_lock(&dev->lock);
-	if (!dev->s_filter)
-		val = 0;
-	else if (fattr->mask)
+	if (fattr->mask)
 		val = dev->scancode_filters[fattr->type].mask;
 	else
 		val = dev->scancode_filters[fattr->type].data;
@@ -1069,7 +1073,7 @@ static ssize_t store_filter(struct device *device,
 		return ret;
 
 	/* Scancode filter not supported (but still accept 0) */
-	if (!dev->s_filter)
+	if (!dev->s_filter && fattr->type != RC_FILTER_NORMAL)
 		return val ? -EINVAL : count;
 
 	mutex_lock(&dev->lock);
@@ -1081,9 +1085,11 @@ static ssize_t store_filter(struct device *device,
 		local_filter.mask = val;
 	else
 		local_filter.data = val;
-	ret = dev->s_filter(dev, fattr->type, &local_filter);
-	if (ret < 0)
-		goto unlock;
+	if (dev->s_filter) {
+		ret = dev->s_filter(dev, fattr->type, &local_filter);
+		if (ret < 0)
+			goto unlock;
+	}
 
 	/* Success, commit the new filter */
 	*filter = local_filter;
-- 
1.8.3.2

