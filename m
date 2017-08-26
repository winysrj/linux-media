Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:49969 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751589AbdHZBxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 21:53:05 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 2/2] build: Fixed backports/v3.3_eprobe_defer.patch
Date: Sat, 26 Aug 2017 03:52:57 +0200
Message-Id: <1503712377-31405-3-git-send-email-jasmin@anw.at>
In-Reply-To: <1503712377-31405-1-git-send-email-jasmin@anw.at>
References: <1503712377-31405-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/v3.3_eprobe_defer.patch | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/backports/v3.3_eprobe_defer.patch b/backports/v3.3_eprobe_defer.patch
index ec949cc..327979d 100644
--- a/backports/v3.3_eprobe_defer.patch
+++ b/backports/v3.3_eprobe_defer.patch
@@ -10,7 +10,7 @@ index 297e10e69898..0ea394e985c7 100644
  	struct clk *ccf_clk = clk_get(dev, id);
  	char clk_name[V4L2_CLK_NAME_SIZE];
  
-@@ -55,17 +56,17 @@ struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
+@@ -55,16 +56,16 @@ struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
  
  		return clk;
  	}
@@ -22,8 +22,7 @@ index 297e10e69898..0ea394e985c7 100644
 +#if 0
  	/* if dev_name is not found, try use the OF name to find again  */
  	if (PTR_ERR(clk) == -ENODEV && dev->of_node) {
- 		v4l2_clk_name_of(clk_name, sizeof(clk_name),
- 				 of_node_full_name(dev->of_node));
+ 		v4l2_clk_name_of(clk_name, sizeof(clk_name), dev->of_node);
  		clk = v4l2_clk_find(clk_name);
  	}
 -
@@ -31,7 +30,7 @@ index 297e10e69898..0ea394e985c7 100644
  	if (!IS_ERR(clk))
  		atomic_inc(&clk->use_count);
  	mutex_unlock(&clk_lock);
-@@ -126,8 +127,10 @@ int v4l2_clk_enable(struct v4l2_clk *clk)
+@@ -125,8 +126,10 @@ int v4l2_clk_enable(struct v4l2_clk *clk)
  {
  	int ret;
  
@@ -42,7 +41,7 @@ index 297e10e69898..0ea394e985c7 100644
  
  	ret = v4l2_clk_lock_driver(clk);
  	if (ret < 0)
-@@ -155,8 +158,10 @@ void v4l2_clk_disable(struct v4l2_clk *clk)
+@@ -154,8 +157,10 @@ void v4l2_clk_disable(struct v4l2_clk *clk)
  {
  	int enable;
  
-- 
2.7.4
