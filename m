Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37271 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932182AbdDDQKM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 12:10:12 -0400
Received: by mail-wm0-f48.google.com with SMTP id x124so32533375wmf.0
        for <linux-media@vger.kernel.org>; Tue, 04 Apr 2017 09:10:11 -0700 (PDT)
From: Lee Jones <lee.jones@linaro.org>
To: hans.verkuil@cisco.com, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-media@vger.kernel.org, benjamin.gaignard@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/2] [media] rc-core: Add inlined stubs for core rc_* functions
Date: Tue,  4 Apr 2017 17:10:04 +0100
Message-Id: <20170404161005.20884-1-lee.jones@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently users have to use all sorts of ugly #ifery within
their drivers in order to avoid linking issues at build time.
This patch allows users to safely call these functions when
!CONFIG_RC_CORE and make decisions based on the return value
instead.  This is a much more common and clean way of doing
things within the Linux kernel.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/media/rc-core.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 73ddd721..1f2043d 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -209,7 +209,14 @@ struct rc_dev {
  * @rc_driver_type: specifies the type of the RC output to be allocated
  * returns a pointer to struct rc_dev.
  */
+#ifdef CONFIG_RC_CORE
 struct rc_dev *rc_allocate_device(enum rc_driver_type);
+#else
+static inline struct rc_dev *rc_allocate_device(int unused)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+#endif
 
 /**
  * devm_rc_allocate_device - Managed RC device allocation
@@ -218,21 +225,42 @@ struct rc_dev *rc_allocate_device(enum rc_driver_type);
  * @rc_driver_type: specifies the type of the RC output to be allocated
  * returns a pointer to struct rc_dev.
  */
+#ifdef CONFIG_RC_CORE
 struct rc_dev *devm_rc_allocate_device(struct device *dev, enum rc_driver_type);
+#else
+static inline struct rc_dev *devm_rc_allocate_device(struct device *dev, int unused)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+#endif
 
 /**
  * rc_free_device - Frees a RC device
  *
  * @dev: pointer to struct rc_dev.
  */
+#ifdef CONFIG_RC_CORE
 void rc_free_device(struct rc_dev *dev);
+#else
+static inline void rc_free_device(struct rc_dev *dev)
+{
+	return;
+}
+#endif
 
 /**
  * rc_register_device - Registers a RC device
  *
  * @dev: pointer to struct rc_dev.
  */
+#ifdef CONFIG_RC_CORE
 int rc_register_device(struct rc_dev *dev);
+#else
+static inline int rc_register_device(struct rc_dev *dev)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 
 /**
  * devm_rc_register_device - Manageded registering of a RC device
@@ -240,14 +268,28 @@ int rc_register_device(struct rc_dev *dev);
  * @parent: pointer to struct device.
  * @dev: pointer to struct rc_dev.
  */
+#ifdef CONFIG_RC_CORE
 int devm_rc_register_device(struct device *parent, struct rc_dev *dev);
+#else
+static inline int devm_rc_register_device(struct device *parent, struct rc_dev *dev)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 
 /**
  * rc_unregister_device - Unregisters a RC device
  *
  * @dev: pointer to struct rc_dev.
  */
+#ifdef CONFIG_RC_CORE
 void rc_unregister_device(struct rc_dev *dev);
+#else
+static inline void rc_unregister_device(struct rc_dev *dev)
+{
+	return;
+}
+#endif
 
 /**
  * rc_open - Opens a RC device
-- 
2.9.3
