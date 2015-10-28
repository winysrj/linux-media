Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:41919 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965506AbbJ1Jm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2015 05:42:59 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] v4l2-clk: v4l2_clk_get() also need to find the of_fullname clock
Date: Wed, 28 Oct 2015 17:48:55 +0800
Message-ID: <1446025735-26849-5-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1446025735-26849-1-git-send-email-josh.wu@atmel.com>
References: <1446025735-26849-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The soc-camera host will be probed and register a v4l2_clk, but if on
that moment, the i2c device is not available, then the registered
v4l2_clk name is a OF string not a I2C string.

So when i2c sensor probed and call v4l2_clk_get(), it only search the
clock with I2C string, like "1-0030".

This patch will search the clock with OF string name if fail to find the
clock with I2C string name.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/v4l2-core/v4l2-clk.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-clk.c b/drivers/media/v4l2-core/v4l2-clk.c
index 34e416a..297e10e 100644
--- a/drivers/media/v4l2-core/v4l2-clk.c
+++ b/drivers/media/v4l2-core/v4l2-clk.c
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -39,6 +40,7 @@ struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
 {
 	struct v4l2_clk *clk;
 	struct clk *ccf_clk = clk_get(dev, id);
+	char clk_name[V4L2_CLK_NAME_SIZE];
 
 	if (PTR_ERR(ccf_clk) == -EPROBE_DEFER)
 		return ERR_PTR(-EPROBE_DEFER);
@@ -57,6 +59,13 @@ struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
 	mutex_lock(&clk_lock);
 	clk = v4l2_clk_find(dev_name(dev));
 
+	/* if dev_name is not found, try use the OF name to find again  */
+	if (PTR_ERR(clk) == -ENODEV && dev->of_node) {
+		v4l2_clk_name_of(clk_name, sizeof(clk_name),
+				 of_node_full_name(dev->of_node));
+		clk = v4l2_clk_find(clk_name);
+	}
+
 	if (!IS_ERR(clk))
 		atomic_inc(&clk->use_count);
 	mutex_unlock(&clk_lock);
-- 
1.9.1

