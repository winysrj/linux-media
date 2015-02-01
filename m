Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56407 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbbBALMh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2015 06:12:37 -0500
Date: Sun, 1 Feb 2015 12:12:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v4 2/2] V4L: add CCF support to the v4l2_clk API
In-Reply-To: <8420980.1Z1tGTCX4O@avalon>
Message-ID: <Pine.LNX.4.64.1502011211160.9534@axis700.grange>
References: <Pine.LNX.4.64.1502010007180.26661@axis700.grange>
 <Pine.LNX.4.64.1502010019380.26661@axis700.grange> <8420980.1Z1tGTCX4O@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 clocks, e.g. used by camera sensors for their master clock, do not
have to be supplied by a different V4L2 driver, they can also be
supplied by an independent source. In this case the standart kernel
clock API should be used to handle such clocks. This patch adds support
for such cases.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---

v4: sizeof(*clk) :)

 drivers/media/v4l2-core/v4l2-clk.c | 48 +++++++++++++++++++++++++++++++++++---
 include/media/v4l2-clk.h           |  2 ++
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-clk.c b/drivers/media/v4l2-core/v4l2-clk.c
index 3ff0b00..9f8cb20 100644
--- a/drivers/media/v4l2-core/v4l2-clk.c
+++ b/drivers/media/v4l2-core/v4l2-clk.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/list.h>
@@ -37,6 +38,21 @@ static struct v4l2_clk *v4l2_clk_find(const char *dev_id)
 struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
 {
 	struct v4l2_clk *clk;
+	struct clk *ccf_clk = clk_get(dev, id);
+
+	if (PTR_ERR(ccf_clk) == -EPROBE_DEFER)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	if (!IS_ERR_OR_NULL(ccf_clk)) {
+		clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+		if (!clk) {
+			clk_put(ccf_clk);
+			return ERR_PTR(-ENOMEM);
+		}
+		clk->clk = ccf_clk;
+
+		return clk;
+	}
 
 	mutex_lock(&clk_lock);
 	clk = v4l2_clk_find(dev_name(dev));
@@ -56,6 +72,12 @@ void v4l2_clk_put(struct v4l2_clk *clk)
 	if (IS_ERR(clk))
 		return;
 
+	if (clk->clk) {
+		clk_put(clk->clk);
+		kfree(clk);
+		return;
+	}
+
 	mutex_lock(&clk_lock);
 
 	list_for_each_entry(tmp, &clk_list, list)
@@ -93,8 +115,12 @@ static void v4l2_clk_unlock_driver(struct v4l2_clk *clk)
 
 int v4l2_clk_enable(struct v4l2_clk *clk)
 {
-	int ret = v4l2_clk_lock_driver(clk);
+	int ret;
 
+	if (clk->clk)
+		return clk_prepare_enable(clk->clk);
+
+	ret = v4l2_clk_lock_driver(clk);
 	if (ret < 0)
 		return ret;
 
@@ -120,6 +146,9 @@ void v4l2_clk_disable(struct v4l2_clk *clk)
 {
 	int enable;
 
+	if (clk->clk)
+		return clk_disable_unprepare(clk->clk);
+
 	mutex_lock(&clk->lock);
 
 	enable = --clk->enable;
@@ -137,8 +166,12 @@ EXPORT_SYMBOL(v4l2_clk_disable);
 
 unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk)
 {
-	int ret = v4l2_clk_lock_driver(clk);
+	int ret;
+
+	if (clk->clk)
+		return clk_get_rate(clk->clk);
 
+	ret = v4l2_clk_lock_driver(clk);
 	if (ret < 0)
 		return ret;
 
@@ -157,7 +190,16 @@ EXPORT_SYMBOL(v4l2_clk_get_rate);
 
 int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate)
 {
-	int ret = v4l2_clk_lock_driver(clk);
+	int ret;
+
+	if (clk->clk) {
+		long r = clk_round_rate(clk->clk, rate);
+		if (r < 0)
+			return r;
+		return clk_set_rate(clk->clk, r);
+	}
+
+	ret = v4l2_clk_lock_driver(clk);
 
 	if (ret < 0)
 		return ret;
diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
index 928045f..3ef6e3d 100644
--- a/include/media/v4l2-clk.h
+++ b/include/media/v4l2-clk.h
@@ -22,6 +22,7 @@
 struct module;
 struct device;
 
+struct clk;
 struct v4l2_clk {
 	struct list_head list;
 	const struct v4l2_clk_ops *ops;
@@ -29,6 +30,7 @@ struct v4l2_clk {
 	int enable;
 	struct mutex lock; /* Protect the enable count */
 	atomic_t use_count;
+	struct clk *clk;
 	void *priv;
 };
 
-- 
1.9.3

