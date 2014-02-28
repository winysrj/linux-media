Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:65159 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaB1XRp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 18:17:45 -0500
Received: by mail-we0-f177.google.com with SMTP id t61so1115969wes.36
        for <linux-media@vger.kernel.org>; Fri, 28 Feb 2014 15:17:43 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 5/5] rc-main: automatically refresh filter on protocol change
Date: Fri, 28 Feb 2014 23:17:06 +0000
Message-Id: <1393629426-31341-6-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When either of the normal or wakeup filter protocols are changed,
refresh the corresponding scancode filter, i.e. try and set the same
scancode filter with the new protocol. If that fails clear the filter
instead.

If no protocol was selected the filter is just cleared, and if no
s_filter callback exists the filter is left unmodified.

Similarly clear the filter mask when the filter is set if no protocol is
currently selected.

This simplifies driver code which no longer has to explicitly worry
about modifying the filter on a protocol change. This also allows the
change_wakeup_protocol callback to be omitted entirely if there is only
a single available wakeup protocol at a time, since selecting no
protocol will automatically clear the wakeup filter, disabling wakeup.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/rc-main.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index e6e3ec7..b1a6900 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -918,11 +918,12 @@ static ssize_t store_protocols(struct device *device,
 	struct rc_filter_attribute *fattr = to_rc_filter_attr(mattr);
 	bool enable, disable;
 	const char *tmp;
-	u64 type;
+	u64 old_type, type;
 	u64 mask;
 	int rc, i, count = 0;
 	ssize_t ret;
 	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
+	struct rc_scancode_filter local_filter, *filter;
 
 	/* Device is being removed */
 	if (!dev)
@@ -935,7 +936,8 @@ static ssize_t store_protocols(struct device *device,
 		ret = -EINVAL;
 		goto out;
 	}
-	type = dev->enabled_protocols[fattr->type];
+	old_type = dev->enabled_protocols[fattr->type];
+	type = old_type;
 
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
 		if (!*tmp)
@@ -999,6 +1001,36 @@ static ssize_t store_protocols(struct device *device,
 	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
 		   (long long)type);
 
+	/*
+	 * If the protocol is changed the filter needs updating.
+	 * Try setting the same filter with the new protocol (if any).
+	 * Fall back to clearing the filter.
+	 */
+	filter = &dev->scancode_filters[fattr->type];
+	if (old_type != type && filter->mask) {
+		local_filter = *filter;
+		if (!type) {
+			/* no protocol => clear filter */
+			ret = -1;
+		} else if (!dev->s_filter) {
+			/* generic filtering => accept any filter */
+			ret = 0;
+		} else {
+			/* hardware filtering => try setting, otherwise clear */
+			ret = dev->s_filter(dev, fattr->type, &local_filter);
+		}
+		if (ret < 0) {
+			/* clear the filter */
+			local_filter.data = 0;
+			local_filter.mask = 0;
+			if (dev->s_filter)
+				dev->s_filter(dev, fattr->type, &local_filter);
+		}
+
+		/* commit the new filter */
+		*filter = local_filter;
+	}
+
 	ret = len;
 
 out:
@@ -1096,6 +1128,11 @@ static ssize_t store_filter(struct device *device,
 		local_filter.mask = val;
 	else
 		local_filter.data = val;
+	if (!dev->enabled_protocols[fattr->type] && local_filter.mask) {
+		/* refuse to set a filter unless a protocol is enabled */
+		ret = -EINVAL;
+		goto unlock;
+	}
 	if (dev->s_filter) {
 		ret = dev->s_filter(dev, fattr->type, &local_filter);
 		if (ret < 0)
-- 
1.8.3.2

