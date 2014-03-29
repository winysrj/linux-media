Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38303 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbaC2QLN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 12:11:13 -0400
Subject: [PATCH 05/11] rc-core: split dev->s_filter
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: james.hogan@imgtec.com, m.chehab@samsung.com
Date: Sat, 29 Mar 2014 17:11:11 +0100
Message-ID: <20140329161111.13234.73883.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Overloading dev->s_filter to do two different functions (set wakeup filters
and generic hardware filters) makes it impossible to tell what the
hardware actually supports, so create a separate dev->s_wakeup_filter and
make the distinction explicit.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/img-ir/img-ir-hw.c |   15 ++++++++++++++-
 drivers/media/rc/rc-main.c          |   31 +++++++++++++++++++------------
 include/media/rc-core.h             |    6 ++++--
 3 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index aec79f7..871a9b3 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -504,6 +504,18 @@ unlock:
 	return ret;
 }
 
+static int img_ir_set_normal_filter(struct rc_dev *dev,
+				    struct rc_scancode_filter *sc_filter)
+{
+	return img_ir_set_filter(dev, RC_FILTER_NORMAL, sc_filter); 
+}
+
+static int img_ir_set_wakeup_filter(struct rc_dev *dev,
+				    struct rc_scancode_filter *sc_filter)
+{
+	return img_ir_set_filter(dev, RC_FILTER_WAKEUP, sc_filter);
+}
+
 /**
  * img_ir_set_decoder() - Set the current decoder.
  * @priv:	IR private data.
@@ -988,7 +1000,8 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
 	rdev->map_name = RC_MAP_EMPTY;
 	rc_set_allowed_protocols(rdev, img_ir_allowed_protos(priv));
 	rdev->input_name = "IMG Infrared Decoder";
-	rdev->s_filter = img_ir_set_filter;
+	rdev->s_filter = img_ir_set_normal_filter;
+	rdev->s_wakeup_filter = img_ir_set_wakeup_filter;
 
 	/* Register hardware decoder */
 	error = rc_register_device(rdev);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index c0bfd50..ba955ac 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -929,6 +929,7 @@ static ssize_t store_protocols(struct device *device,
 	int rc, i, count = 0;
 	ssize_t ret;
 	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
+	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
 	struct rc_scancode_filter local_filter, *filter;
 
 	/* Device is being removed */
@@ -1013,24 +1014,27 @@ static ssize_t store_protocols(struct device *device,
 	 * Fall back to clearing the filter.
 	 */
 	filter = &dev->scancode_filters[fattr->type];
+	set_filter = (fattr->type == RC_FILTER_NORMAL)
+		? dev->s_filter : dev->s_wakeup_filter;
+
 	if (old_type != type && filter->mask) {
 		local_filter = *filter;
 		if (!type) {
 			/* no protocol => clear filter */
 			ret = -1;
-		} else if (!dev->s_filter) {
+		} else if (!set_filter) {
 			/* generic filtering => accept any filter */
 			ret = 0;
 		} else {
 			/* hardware filtering => try setting, otherwise clear */
-			ret = dev->s_filter(dev, fattr->type, &local_filter);
+			ret = set_filter(dev, &local_filter);
 		}
 		if (ret < 0) {
 			/* clear the filter */
 			local_filter.data = 0;
 			local_filter.mask = 0;
-			if (dev->s_filter)
-				dev->s_filter(dev, fattr->type, &local_filter);
+			if (set_filter)
+				set_filter(dev, &local_filter);
 		}
 
 		/* commit the new filter */
@@ -1112,6 +1116,7 @@ static ssize_t store_filter(struct device *device,
 	struct rc_scancode_filter local_filter, *filter;
 	int ret;
 	unsigned long val;
+	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
 
 	/* Device is being removed */
 	if (!dev)
@@ -1121,9 +1126,11 @@ static ssize_t store_filter(struct device *device,
 	if (ret < 0)
 		return ret;
 
-	/* Scancode filter not supported (but still accept 0) */
-	if (!dev->s_filter && fattr->type != RC_FILTER_NORMAL)
-		return val ? -EINVAL : count;
+	/* Can the scancode filter be set? */
+	set_filter = (fattr->type == RC_FILTER_NORMAL)
+		? dev->s_filter : dev->s_wakeup_filter;
+	if (!set_filter)
+		return -EINVAL;
 
 	mutex_lock(&dev->lock);
 
@@ -1134,16 +1141,16 @@ static ssize_t store_filter(struct device *device,
 		local_filter.mask = val;
 	else
 		local_filter.data = val;
+
 	if (!dev->enabled_protocols[fattr->type] && local_filter.mask) {
 		/* refuse to set a filter unless a protocol is enabled */
 		ret = -EINVAL;
 		goto unlock;
 	}
-	if (dev->s_filter) {
-		ret = dev->s_filter(dev, fattr->type, &local_filter);
-		if (ret < 0)
-			goto unlock;
-	}
+
+	ret = set_filter(dev, &local_filter);
+	if (ret < 0)
+		goto unlock;
 
 	/* Success, commit the new filter */
 	*filter = local_filter;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index dbbe63e..8c31e4a 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -113,7 +113,8 @@ enum rc_filter_type {
  *	device doesn't interrupt host until it sees IR pulses
  * @s_learning_mode: enable wide band receiver used for learning
  * @s_carrier_report: enable carrier reports
- * @s_filter: set the scancode filter of a given type
+ * @s_filter: set the scancode filter 
+ * @s_wakeup_filter: set the wakeup scancode filter
  */
 struct rc_dev {
 	struct device			dev;
@@ -161,8 +162,9 @@ struct rc_dev {
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
 	int				(*s_filter)(struct rc_dev *dev,
-						    enum rc_filter_type type,
 						    struct rc_scancode_filter *filter);
+	int				(*s_wakeup_filter)(struct rc_dev *dev,
+							   struct rc_scancode_filter *filter);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)

