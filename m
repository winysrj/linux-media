Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:65233 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab3COV2U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 17:28:20 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v6 1/7] media: V4L2: add temporary clock helpers
Date: Fri, 15 Mar 2013 22:27:47 +0100
Message-Id: <1363382873-20077-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Typical video devices like camera sensors require an external clock source.
Many such devices cannot even access their hardware registers without a
running clock. These clock sources should be controlled by their consumers.
This should be performed, using the generic clock framework. Unfortunately
so far only very few systems have been ported to that framework. This patch
adds a set of temporary helpers, mimicking the generic clock API, to V4L2.
Platforms, adopting the clock API, should switch to using it. Eventually
this temporary API should be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v6: changed clock name to just <I2C adapter ID>-<I2C address> to avoid 
having to wait for an I2C subdevice driver to probe. Added a subdevice 
pointer to struct v4l2_clk for subdevice and bridge binding.

 drivers/media/v4l2-core/Makefile   |    2 +-
 drivers/media/v4l2-core/v4l2-clk.c |  184 ++++++++++++++++++++++++++++++++++++
 include/media/v4l2-clk.h           |   55 +++++++++++
 3 files changed, 240 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
 create mode 100644 include/media/v4l2-clk.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index a9d3552..aea7aea 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -5,7 +5,7 @@
 tuner-objs	:=	tuner-core.o
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
-			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
+			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o
 ifeq ($(CONFIG_COMPAT),y)
   videodev-objs += v4l2-compat-ioctl32.o
 endif
diff --git a/drivers/media/v4l2-core/v4l2-clk.c b/drivers/media/v4l2-core/v4l2-clk.c
new file mode 100644
index 0000000..3505972
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-clk.c
@@ -0,0 +1,184 @@
+/*
+ * V4L2 clock service
+ *
+ * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/atomic.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/string.h>
+
+#include <media/v4l2-clk.h>
+#include <media/v4l2-subdev.h>
+
+static DEFINE_MUTEX(clk_lock);
+static LIST_HEAD(clk_list);
+
+static struct v4l2_clk *v4l2_clk_find(const struct v4l2_subdev *sd,
+				      const char *dev_id, const char *id)
+{
+	struct v4l2_clk *clk;
+
+	list_for_each_entry(clk, &clk_list, list) {
+		if (!sd || !(sd->flags & V4L2_SUBDEV_FL_IS_I2C)) {
+			if (strcmp(dev_id, clk->dev_id))
+				continue;
+		} else {
+			char *i2c = strstr(dev_id, clk->dev_id);
+			if (!i2c || i2c == dev_id || *(i2c - 1) != ' ')
+				continue;
+		}
+
+		if (!id || !clk->id || !strcmp(clk->id, id))
+			return clk;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
+struct v4l2_clk *v4l2_clk_get(struct v4l2_subdev *sd, const char *id)
+{
+	struct v4l2_clk *clk;
+
+	mutex_lock(&clk_lock);
+	clk = v4l2_clk_find(sd, sd->name, id);
+
+	if (!IS_ERR(clk) && !try_module_get(clk->ops->owner))
+		clk = ERR_PTR(-ENODEV);
+	mutex_unlock(&clk_lock);
+
+	if (!IS_ERR(clk)) {
+		clk->subdev = sd;
+		atomic_inc(&clk->use_count);
+	}
+
+	return clk;
+}
+EXPORT_SYMBOL(v4l2_clk_get);
+
+void v4l2_clk_put(struct v4l2_clk *clk)
+{
+	if (!IS_ERR(clk)) {
+		atomic_dec(&clk->use_count);
+		module_put(clk->ops->owner);
+	}
+}
+EXPORT_SYMBOL(v4l2_clk_put);
+
+int v4l2_clk_enable(struct v4l2_clk *clk)
+{
+	int ret;
+	mutex_lock(&clk->lock);
+	if (++clk->enable == 1 && clk->ops->enable) {
+		ret = clk->ops->enable(clk);
+		if (ret < 0)
+			clk->enable--;
+	} else {
+		ret = 0;
+	}
+	mutex_unlock(&clk->lock);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_clk_enable);
+
+void v4l2_clk_disable(struct v4l2_clk *clk)
+{
+	int enable;
+
+	mutex_lock(&clk->lock);
+	enable = --clk->enable;
+	if (WARN(enable < 0, "Unbalanced %s() on %s:%s!\n", __func__,
+		 clk->dev_id, clk->id))
+		clk->enable++;
+	else if (!enable && clk->ops->disable)
+		clk->ops->disable(clk);
+	mutex_unlock(&clk->lock);
+}
+EXPORT_SYMBOL(v4l2_clk_disable);
+
+unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk)
+{
+	if (!clk->ops->get_rate)
+		return -ENOSYS;
+
+	return clk->ops->get_rate(clk);
+}
+EXPORT_SYMBOL(v4l2_clk_get_rate);
+
+int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate)
+{
+	if (!clk->ops->set_rate)
+		return -ENOSYS;
+
+	return clk->ops->set_rate(clk, rate);
+}
+EXPORT_SYMBOL(v4l2_clk_set_rate);
+
+struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
+				   const char *dev_id,
+				   const char *id, void *priv)
+{
+	struct v4l2_clk *clk;
+	int ret;
+
+	if (!ops || !dev_id)
+		return ERR_PTR(-EINVAL);
+
+	clk = kzalloc(sizeof(struct v4l2_clk), GFP_KERNEL);
+	if (!clk)
+		return ERR_PTR(-ENOMEM);
+
+	clk->id = kstrdup(id, GFP_KERNEL);
+	clk->dev_id = kstrdup(dev_id, GFP_KERNEL);
+	if ((id && !clk->id) || !clk->dev_id) {
+		ret = -ENOMEM;
+		goto ealloc;
+	}
+	clk->ops = ops;
+	clk->priv = priv;
+	atomic_set(&clk->use_count, 0);
+	mutex_init(&clk->lock);
+
+	mutex_lock(&clk_lock);
+	if (!IS_ERR(v4l2_clk_find(NULL, dev_id, id))) {
+		mutex_unlock(&clk_lock);
+		ret = -EEXIST;
+		goto eexist;
+	}
+	list_add_tail(&clk->list, &clk_list);
+	mutex_unlock(&clk_lock);
+
+	return clk;
+
+eexist:
+ealloc:
+	kfree(clk->id);
+	kfree(clk->dev_id);
+	kfree(clk);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(v4l2_clk_register);
+
+void v4l2_clk_unregister(struct v4l2_clk *clk)
+{
+	if (WARN(atomic_read(&clk->use_count),
+		 "%s(): Refusing to unregister ref-counted %s:%s clock!\n",
+		 __func__, clk->dev_id, clk->id))
+		return;
+
+	mutex_lock(&clk_lock);
+	list_del(&clk->list);
+	mutex_unlock(&clk_lock);
+
+	kfree(clk->id);
+	kfree(clk->dev_id);
+	kfree(clk);
+}
+EXPORT_SYMBOL(v4l2_clk_unregister);
diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
new file mode 100644
index 0000000..6d3c2e2
--- /dev/null
+++ b/include/media/v4l2-clk.h
@@ -0,0 +1,55 @@
+/*
+ * V4L2 clock service
+ *
+ * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * ATTENTION: This is a temporary API and it shall be replaced by the generic
+ * clock API, when the latter becomes widely available.
+ */
+
+#ifndef MEDIA_V4L2_CLK_H
+#define MEDIA_V4L2_CLK_H
+
+#include <linux/atomic.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+
+struct module;
+struct v4l2_subdev;
+
+struct v4l2_clk {
+	struct list_head list;
+	const struct v4l2_clk_ops *ops;
+	const char *dev_id;
+	const char *id;
+	int enable;
+	struct mutex lock; /* Protect the enable count */
+	atomic_t use_count;
+	struct v4l2_subdev *subdev;
+	void *priv;
+};
+
+struct v4l2_clk_ops {
+	struct module	*owner;
+	int		(*enable)(struct v4l2_clk *clk);
+	void		(*disable)(struct v4l2_clk *clk);
+	unsigned long	(*get_rate)(struct v4l2_clk *clk);
+	int		(*set_rate)(struct v4l2_clk *clk, unsigned long);
+};
+
+struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
+				   const char *dev_name,
+				   const char *name, void *priv);
+void v4l2_clk_unregister(struct v4l2_clk *clk);
+struct v4l2_clk *v4l2_clk_get(struct v4l2_subdev *sd, const char *id);
+void v4l2_clk_put(struct v4l2_clk *clk);
+int v4l2_clk_enable(struct v4l2_clk *clk);
+void v4l2_clk_disable(struct v4l2_clk *clk);
+unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk);
+int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate);
+
+#endif
-- 
1.7.2.5

