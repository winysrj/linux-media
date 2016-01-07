Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45262 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbcAGS14 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 13:27:56 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Nikhil Devshatwar <nikhil.nd@ti.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/8] [media] v4l: of: Correct v4l2_of_parse_endpoint() kernel-doc
Date: Thu,  7 Jan 2016 15:27:15 -0300
Message-Id: <1452191248-15847-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
References: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_parse_endpoint function kernel-doc says that the return value
is always 0. But that is not true since the function can fail and a error
negative code is returned on failure. So correct the kernel-doc to match.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/v4l2-core/v4l2-of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index b27cbb1f5afe..93b33681776c 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -146,7 +146,7 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
  * variable without a low fixed limit. Please use
  * v4l2_of_alloc_parse_endpoint() in new drivers instead.
  *
- * Return: 0.
+ * Return: 0 on success or a negative error code on failure.
  */
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint)
-- 
2.4.3

