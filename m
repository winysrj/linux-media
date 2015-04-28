Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53946 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbbD1GlI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 02:41:08 -0400
Message-ID: <553F2B7C.20506@xs4all.nl>
Date: Tue, 28 Apr 2015 08:41:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] v4l2-of: fix compiler errors if CONFIG_OF is undefined
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You must use static inline otherwise you get these errors if CONFIG_OF is not defined:

In file included from drivers/media/platform/soc_camera/soc_camera.c:39:0:
include/media/v4l2-of.h:112:13: warning: 'v4l2_of_free_endpoint' defined but not used [-Wunused-function]
 static void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
             ^
In file included from drivers/media/platform/soc_camera/atmel-isi.c:28:0:
include/media/v4l2-of.h:112:13: warning: 'v4l2_of_free_endpoint' defined but not used [-Wunused-function]
 static void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
             ^
In file included from drivers/media/platform/soc_camera/rcar_vin.c:36:0:
include/media/v4l2-of.h:112:13: warning: 'v4l2_of_free_endpoint' defined but not used [-Wunused-function]
 static void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
             ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 241e98a..4dc34b2 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -103,13 +103,13 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
-struct v4l2_of_endpoint *v4l2_of_alloc_parse_endpoint(
+static inline struct v4l2_of_endpoint *v4l2_of_alloc_parse_endpoint(
 	const struct device_node *node)
 {
 	return NULL;
 }
 
-static void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
+static inline void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
 {
 }
 
