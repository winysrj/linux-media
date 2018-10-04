Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbeJEFJU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 01:09:20 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 3/3] media: v4l2-fwnode: simplify v4l2_fwnode_reference_parse_int_props() call
Date: Thu,  4 Oct 2018 18:13:48 -0400
Message-Id: <463ae4be895e592aa575d55530a615e22a1934b3.1538690587.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1538690587.git.mchehab+samsung@kernel.org>
References: <cover.1538690587.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1538690587.git.mchehab+samsung@kernel.org>
References: <cover.1538690587.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_fwnode_reference_parse_int_props() has a big name, causing
it to cause coding style warnings. Also, it depends on a const
struct embedded indide a function.

Rearrange the logic in order to move the struct declaration out
of such function and use it inside this function.

That cleans up some coding style issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index a7c2487154a4..e0cd119d6f5c 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -1006,6 +1006,12 @@ v4l2_fwnode_reference_get_int_prop(struct fwnode_handle *fwnode,
 	return fwnode;
 }
 
+struct v4l2_fwnode_int_props {
+	const char *name;
+	const char * const *props;
+	unsigned int nprops;
+};
+
 /*
  * v4l2_fwnode_reference_parse_int_props - parse references for async
  *					   sub-devices
@@ -1032,13 +1038,14 @@ v4l2_fwnode_reference_get_int_prop(struct fwnode_handle *fwnode,
 static int
 v4l2_fwnode_reference_parse_int_props(struct device *dev,
 				      struct v4l2_async_notifier *notifier,
-				      const char *prop,
-				      const char * const *props,
-				      unsigned int nprops)
+				      const struct v4l2_fwnode_int_props *p)
 {
 	struct fwnode_handle *fwnode;
 	unsigned int index;
 	int ret;
+	const char *prop = p->name;
+	const char * const *props = p->props;
+	unsigned int nprops = p->nprops;
 
 	index = 0;
 	do {
@@ -1092,16 +1099,12 @@ v4l2_fwnode_reference_parse_int_props(struct device *dev,
 int v4l2_async_notifier_parse_fwnode_sensor_common(struct device *dev,
 						   struct v4l2_async_notifier *notifier)
 {
+	unsigned int i;
 	static const char * const led_props[] = { "led" };
-	static const struct {
-		const char *name;
-		const char * const *props;
-		unsigned int nprops;
-	} props[] = {
+	static const struct v4l2_fwnode_int_props props[] = {
 		{ "flash-leds", led_props, ARRAY_SIZE(led_props) },
 		{ "lens-focus", NULL, 0 },
 	};
-	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(props); i++) {
 		int ret;
@@ -1109,9 +1112,7 @@ int v4l2_async_notifier_parse_fwnode_sensor_common(struct device *dev,
 		if (props[i].props && is_acpi_node(dev_fwnode(dev)))
 			ret = v4l2_fwnode_reference_parse_int_props(dev,
 								    notifier,
-								    props[i].name,
-								    props[i].props,
-								    props[i].nprops);
+								    &props[i]);
 		else
 			ret = v4l2_fwnode_reference_parse(dev, notifier,
 							  props[i].name);
-- 
2.17.1
