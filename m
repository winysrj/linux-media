Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:57569 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaB1XRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 18:17:43 -0500
Received: by mail-we0-f181.google.com with SMTP id q58so1068604wes.26
        for <linux-media@vger.kernel.org>; Fri, 28 Feb 2014 15:17:41 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 3/5] rc: add allowed/enabled wakeup protocol masks
Date: Fri, 28 Feb 2014 23:17:04 +0000
Message-Id: <1393629426-31341-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only a single allowed and enabled protocol mask currently exists in
struct rc_dev, however to support a separate wakeup filter protocol two
of each are needed, ideally as an array.

Therefore make both rc_dev::allowed_protos and rc_dev::enabled_protocols
arrays, update all users to reference the first element
(RC_FILTER_NORMAL), and add a couple more helper functions for drivers
to use for setting the allowed and enabled wakeup protocols.

We also rename allowed_protos to allowed_protocols while we're at it,
which is more consistent with enabled_protocols.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/rc-main.c | 10 +++++-----
 include/media/rc-core.h    | 32 ++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 0a4f680..309d791 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -830,9 +830,9 @@ static ssize_t show_protocols(struct device *device,
 
 	mutex_lock(&dev->lock);
 
-	enabled = dev->enabled_protocols;
+	enabled = dev->enabled_protocols[RC_FILTER_NORMAL];
 	if (dev->driver_type == RC_DRIVER_SCANCODE)
-		allowed = dev->allowed_protos;
+		allowed = dev->allowed_protocols[RC_FILTER_NORMAL];
 	else if (dev->raw)
 		allowed = ir_raw_get_allowed_protocols();
 	else {
@@ -906,7 +906,7 @@ static ssize_t store_protocols(struct device *device,
 		ret = -EINVAL;
 		goto out;
 	}
-	type = dev->enabled_protocols;
+	type = dev->enabled_protocols[RC_FILTER_NORMAL];
 
 	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
 		if (!*tmp)
@@ -964,7 +964,7 @@ static ssize_t store_protocols(struct device *device,
 		}
 	}
 
-	dev->enabled_protocols = type;
+	dev->enabled_protocols[RC_FILTER_NORMAL] = type;
 	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
 		   (long long)type);
 
@@ -1316,7 +1316,7 @@ int rc_register_device(struct rc_dev *dev)
 		rc = dev->change_protocol(dev, &rc_type);
 		if (rc < 0)
 			goto out_raw;
-		dev->enabled_protocols = rc_type;
+		dev->enabled_protocols[RC_FILTER_NORMAL] = rc_type;
 	}
 
 	mutex_unlock(&dev->lock);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 6f3c3d9..f165115 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -73,8 +73,10 @@ enum rc_filter_type {
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
- * @allowed_protos: bitmask with the supported RC_BIT_* protocols
- * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
+ * @allowed_protocols: bitmask with the supported RC_BIT_* protocols for each
+ *	filter type
+ * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols for each
+ *	filter type
  * @scanmask: some hardware decoders are not capable of providing the full
  *	scancode to the application. As this is a hardware limit, we can't do
  *	anything with it. Yet, as the same keycode table can be used with other
@@ -124,8 +126,8 @@ struct rc_dev {
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
 	bool				idle;
-	u64				allowed_protos;
-	u64				enabled_protocols;
+	u64				allowed_protocols[RC_FILTER_MAX];
+	u64				enabled_protocols[RC_FILTER_MAX];
 	u32				users;
 	u32				scanmask;
 	void				*priv;
@@ -162,24 +164,38 @@ struct rc_dev {
 
 static inline bool rc_protocols_allowed(struct rc_dev *rdev, u64 protos)
 {
-	return rdev->allowed_protos & protos;
+	return rdev->allowed_protocols[RC_FILTER_NORMAL] & protos;
 }
 
 /* should be called prior to registration or with mutex held */
 static inline void rc_set_allowed_protocols(struct rc_dev *rdev, u64 protos)
 {
-	rdev->allowed_protos = protos;
+	rdev->allowed_protocols[RC_FILTER_NORMAL] = protos;
 }
 
 static inline bool rc_protocols_enabled(struct rc_dev *rdev, u64 protos)
 {
-	return rdev->enabled_protocols & protos;
+	return rdev->enabled_protocols[RC_FILTER_NORMAL] & protos;
 }
 
 /* should be called prior to registration or with mutex held */
 static inline void rc_set_enabled_protocols(struct rc_dev *rdev, u64 protos)
 {
-	rdev->enabled_protocols = protos;
+	rdev->enabled_protocols[RC_FILTER_NORMAL] = protos;
+}
+
+/* should be called prior to registration or with mutex held */
+static inline void rc_set_allowed_wakeup_protocols(struct rc_dev *rdev,
+						   u64 protos)
+{
+	rdev->allowed_protocols[RC_FILTER_WAKEUP] = protos;
+}
+
+/* should be called prior to registration or with mutex held */
+static inline void rc_set_enabled_wakeup_protocols(struct rc_dev *rdev,
+						   u64 protos)
+{
+	rdev->enabled_protocols[RC_FILTER_WAKEUP] = protos;
 }
 
 /*
-- 
1.8.3.2

