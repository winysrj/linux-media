Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40774 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbaDDWGD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Apr 2014 18:06:03 -0400
Subject: [PATCH 2/3] rc-core: split dev->s_filter
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: james.hogan@imgtec.com, m.chehab@samsung.com
Date: Sat, 05 Apr 2014 00:06:01 +0200
Message-ID: <20140404220601.5068.52062.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140404220404.5068.3669.stgit@zeus.muc.hardeman.nu>
References: <20140404220404.5068.3669.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Overloading dev->s_filter to do two different functions (set wakeup filters
and generic hardware filters) makes it impossible to tell what the
hardware actually supports, so create a separate dev->s_wakeup_filter and
make the distinction explicit.

v2: hopefully address James' comments on what should be moved from this to the
next patch.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/img-ir/img-ir-hw.c |   15 ++++++++++++++-
 drivers/media/rc/rc-main.c          |   24 +++++++++++++++++-------
 include/media/rc-core.h             |    6 ++++--
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 579a52b..0127dd2 100644
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
@@ -986,7 +998,8 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
 	rdev->map_name = RC_MAP_EMPTY;
 	rc_set_allowed_protocols(rdev, img_ir_allowed_protos(priv));
 	rdev->input_name = "IMG Infrared Decoder";
-	rdev->s_filter = img_ir_set_filter;
+	rdev->s_filter = img_ir_set_normal_filter;
+	rdev->s_wakeup_filter = img_ir_set_wakeup_filter;
 
 	/* Register hardware decoder */
 	error = rc_register_device(rdev);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 99697aa..ecbc20c 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -923,6 +923,7 @@ static ssize_t store_protocols(struct device *device,
 	int rc, i, count = 0;
 	ssize_t ret;
 	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
+	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
 	struct rc_scancode_filter local_filter, *filter;
 
 	/* Device is being removed */
@@ -1007,24 +1008,27 @@ static ssize_t store_protocols(struct device *device,
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
@@ -1106,6 +1110,7 @@ static ssize_t store_filter(struct device *device,
 	struct rc_scancode_filter local_filter, *filter;
 	int ret;
 	unsigned long val;
+	int (*set_filter)(struct rc_dev *dev, struct rc_scancode_filter *filter);
 
 	/* Device is being removed */
 	if (!dev)
@@ -1115,8 +1120,11 @@ static ssize_t store_filter(struct device *device,
 	if (ret < 0)
 		return ret;
 
+	set_filter = (fattr->type == RC_FILTER_NORMAL) ? dev->s_filter :
+							 dev->s_wakeup_filter;
+
 	/* Scancode filter not supported (but still accept 0) */
-	if (!dev->s_filter && fattr->type != RC_FILTER_NORMAL)
+	if (!set_filter && fattr->type == RC_FILTER_WAKEUP)
 		return val ? -EINVAL : count;
 
 	mutex_lock(&dev->lock);
@@ -1128,13 +1136,15 @@ static ssize_t store_filter(struct device *device,
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
+
+	if (set_filter) {
+		ret = set_filter(dev, &local_filter);
 		if (ret < 0)
 			goto unlock;
 	}
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0b9f890..6dbc7c1 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -112,7 +112,8 @@ enum rc_filter_type {
  *	device doesn't interrupt host until it sees IR pulses
  * @s_learning_mode: enable wide band receiver used for learning
  * @s_carrier_report: enable carrier reports
- * @s_filter: set the scancode filter of a given type
+ * @s_filter: set the scancode filter 
+ * @s_wakeup_filter: set the wakeup scancode filter
  */
 struct rc_dev {
 	struct device			dev;
@@ -159,8 +160,9 @@ struct rc_dev {
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
 	int				(*s_filter)(struct rc_dev *dev,
-						    enum rc_filter_type type,
 						    struct rc_scancode_filter *filter);
+	int				(*s_wakeup_filter)(struct rc_dev *dev,
+							   struct rc_scancode_filter *filter);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)

