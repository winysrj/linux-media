Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F974C10F01
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2761220C01
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="p5VqkFbA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfBTMvi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:51:38 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59610 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbfBTMvh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 07:51:37 -0500
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 61A812D1;
        Wed, 20 Feb 2019 13:51:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550667094;
        bh=Klv2Wrqy0hne6bN0+D7KOX+Hr8vxwnLrK0YuyX342uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5VqkFbAS582DYso5dyNRh2rG/ilmJTGdMDUTnKxh4qxEQCuBLEj9iaI69fwpLZMd
         1P92kftr9Oo3aLI/i9ymfiJYfpyhVNoWuHkVOFRbNiabFgDDlVGhCs8jEoEjWoGGcf
         tdpewXJ2Sa/3pVDUfSKxnBHISFk8yYGO1rXCjGU8=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH yavta 4/7] Implement compound control set support
Date:   Wed, 20 Feb 2019 14:51:20 +0200
Message-Id: <20190220125123.9410-5-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Only arrays of integer types are supported.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 228 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 172 insertions(+), 56 deletions(-)

diff --git a/yavta.c b/yavta.c
index 6428c22f88d7..d1bfd380c03b 100644
--- a/yavta.c
+++ b/yavta.c
@@ -19,6 +19,7 @@
 
 #define __STDC_FORMAT_MACROS
 
+#include <ctype.h>
 #include <stdio.h>
 #include <string.h>
 #include <fcntl.h>
@@ -569,59 +570,38 @@ static int get_control(struct device *dev,
 	return 0;
 }
 
-static void set_control(struct device *dev, unsigned int id,
-		        int64_t val)
+static int set_control(struct device *dev,
+		       const struct v4l2_query_ext_ctrl *query,
+		       struct v4l2_ext_control *ctrl)
 {
 	struct v4l2_ext_controls ctrls;
-	struct v4l2_ext_control ctrl;
-	struct v4l2_query_ext_ctrl query;
-	int64_t old_val = val;
-	int is_64;
+	struct v4l2_control old;
 	int ret;
 
-	ret = query_control(dev, id, &query);
-	if (ret < 0)
-		return;
-
-	is_64 = query.type == V4L2_CTRL_TYPE_INTEGER64;
-
 	memset(&ctrls, 0, sizeof(ctrls));
-	memset(&ctrl, 0, sizeof(ctrl));
 
-	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(id);
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl->id);
 	ctrls.count = 1;
-	ctrls.controls = &ctrl;
+	ctrls.controls = ctrl;
 
-	ctrl.id = id;
-	if (is_64)
-		ctrl.value64 = val;
-	else
-		ctrl.value = val;
+	ctrl->id = query->id;
 
 	ret = ioctl(dev->fd, VIDIOC_S_EXT_CTRLS, &ctrls);
-	if (ret != -1) {
-		if (is_64)
-			val = ctrl.value64;
-		else
-			val = ctrl.value;
-	} else if (!is_64 && query.type != V4L2_CTRL_TYPE_STRING &&
-		   (errno == EINVAL || errno == ENOTTY)) {
-		struct v4l2_control old;
+	if (ret != -1)
+		return 0;
 
-		old.id = id;
-		old.value = val;
-		ret = ioctl(dev->fd, VIDIOC_S_CTRL, &old);
-		if (ret != -1)
-			val = old.value;
-	}
-	if (ret == -1) {
-		printf("unable to set control 0x%8.8x: %s (%d).\n",
-			id, strerror(errno), errno);
-		return;
-	}
+	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD ||
+	    query->type == V4L2_CTRL_TYPE_INTEGER64 ||
+	    (errno != EINVAL && errno != ENOTTY))
+		return -1;
 
-	printf("Control 0x%08x set to %" PRId64 ", is %" PRId64 "\n",
-	       id, old_val, val);
+	old.id = ctrl->id;
+	old.value = ctrl->value;
+	ret = ioctl(dev->fd, VIDIOC_S_CTRL, &old);
+	if (ret != -1)
+		ctrl->value = old.value;
+
+	return ret;
 }
 
 static int video_get_format(struct device *dev)
@@ -1278,9 +1258,9 @@ static void video_print_control_value(const struct v4l2_query_ext_ctrl *query,
 	}
 }
 
-static int video_print_control(struct device *dev,
-			       const struct v4l2_query_ext_ctrl *query,
-			       bool full)
+static int video_get_control(struct device *dev,
+			     const struct v4l2_query_ext_ctrl *query,
+			     bool full)
 {
 	struct v4l2_ext_control ctrl;
 	unsigned int i;
@@ -1338,17 +1318,157 @@ static int video_print_control(struct device *dev,
 	return 1;
 }
 
-static int __video_print_control(struct device *dev,
-				 const struct v4l2_query_ext_ctrl *query)
+static int __video_get_control(struct device *dev,
+			       const struct v4l2_query_ext_ctrl *query)
 {
-	return video_print_control(dev, query, true);
+	return video_get_control(dev, query, true);
+}
+
+static int video_parse_control_array(const struct v4l2_query_ext_ctrl *query,
+				     struct v4l2_ext_control *ctrl,
+				     const char *val)
+{
+	unsigned int i;
+	char *endptr;
+	__u32 value;
+
+	for ( ; isspace(*val); ++val) { };
+	if (*val++ != '{')
+		return -EINVAL;
+
+	for (i = 0; i < query->elems; ++i) {
+		for ( ; isspace(*val); ++val) { };
+
+		switch (query->type) {
+		case V4L2_CTRL_TYPE_U8:
+		case V4L2_CTRL_TYPE_U16:
+		case V4L2_CTRL_TYPE_U32:
+		default:
+			value = strtoul(val, &endptr, 0);
+			break;
+		}
+
+		if (endptr == NULL)
+			return -EINVAL;
+
+		switch (query->type) {
+		case V4L2_CTRL_TYPE_U8:
+			ctrl->p_u8[i] = value;
+			break;
+		case V4L2_CTRL_TYPE_U16:
+			ctrl->p_u16[i] = value;
+			break;
+		case V4L2_CTRL_TYPE_U32:
+			ctrl->p_u32[i] = value;
+			break;
+		}
+
+		val = endptr;
+		for ( ; isspace(*val); ++val) { };
+		if (*val++ != ',')
+			break;
+	} 
+
+	if (i < query->elems - 1)
+		return -EINVAL;
+
+	for ( ; isspace(*val); ++val) { };
+	if (*val++ != '}')
+		return -EINVAL;
+
+	for ( ; isspace(*val); ++val) { };
+	if (*val++ != '\0')
+		return -EINVAL;
+
+	return 0;
+}
+
+static void video_set_control(struct device *dev, unsigned int id,
+			      const char *val)
+{
+	struct v4l2_query_ext_ctrl query;
+	struct v4l2_ext_control ctrl;
+	char *endptr;
+	int ret;
+
+	ret = query_control(dev, id, &query);
+	if (ret < 0)
+		return;
+
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	if (query.nr_of_dims == 0) {
+		switch (query.type) {
+		case V4L2_CTRL_TYPE_INTEGER:
+		case V4L2_CTRL_TYPE_BOOLEAN:
+		case V4L2_CTRL_TYPE_MENU:
+		case V4L2_CTRL_TYPE_INTEGER_MENU:
+		case V4L2_CTRL_TYPE_BITMASK:
+			ctrl.value = strtol(val, &endptr, 0);
+			if (*endptr != 0) {
+				printf("Invalid control value '%s'\n", val);
+				return;
+			}
+			break;
+		case V4L2_CTRL_TYPE_INTEGER64:
+			ctrl.value64 = strtoll(val, &endptr, 0);
+			if (*endptr != 0) {
+				printf("Invalid control value '%s'\n", val);
+				return;
+			}
+			break;
+		case V4L2_CTRL_TYPE_STRING:
+			ctrl.size = query.elem_size;
+			ctrl.ptr = malloc(ctrl.size);
+			if (ctrl.ptr == NULL)
+				return;
+			strncpy(ctrl.string, val, ctrl.size);
+			break;
+		default:
+			printf("Unsupported control type\n");
+			return;
+		}
+	} else {
+		switch (query.type) {
+		case V4L2_CTRL_TYPE_U8:
+		case V4L2_CTRL_TYPE_U16:
+		case V4L2_CTRL_TYPE_U32:
+			ctrl.size = query.elem_size * query.elems;
+			ctrl.ptr = malloc(ctrl.size);
+			if (ctrl.ptr == NULL)
+				return;
+			ret = video_parse_control_array(&query, &ctrl, val);
+			if (ret < 0) {
+				printf("Invalid compound control value '%s'\n", val);
+				return;
+			}
+			break;
+		default:
+			printf("Unsupported control type %u\n", query.type);
+			break;
+		}
+	}
+
+	ret = set_control(dev, &query, &ctrl);
+	if (ret < 0) {
+		printf("unable to set control 0x%8.8x: %s (%d).\n",
+			id, strerror(errno), errno);
+	} else {
+		printf("Control 0x%08x set to %s, is ", id, val);
+
+		video_print_control_value(&query, &ctrl);
+		printf("\n");
+	}
+
+	if ((query.flags & V4L2_CTRL_FLAG_HAS_PAYLOAD) && ctrl.ptr)
+		free(ctrl.ptr);
 }
 
 static void video_list_controls(struct device *dev)
 {
 	int ret;
 
-	ret = video_for_each_control(dev, __video_print_control);
+	ret = video_for_each_control(dev, __video_get_control);
 	if (ret < 0)
 		return;
 
@@ -2064,7 +2184,7 @@ int main(int argc, char *argv[])
 
 	/* Controls */
 	int ctrl_name = 0;
-	int ctrl_value = 0;
+	const char *ctrl_value = NULL;
 
 	/* Video buffers */
 	enum v4l2_memory memtype = V4L2_MEMORY_MMAP;
@@ -2204,11 +2324,7 @@ int main(int argc, char *argv[])
 				printf("Invalid control name '%s'\n", optarg);
 				return 1;
 			}
-			ctrl_value = strtol(endptr + 1, &endptr, 0);
-			if (*endptr != 0) {
-				printf("Invalid control value '%s'\n", optarg);
-				return 1;
-			}
+			ctrl_value = endptr + 1;
 			do_set_control = 1;
 			break;
 		case OPT_BUFFER_SIZE:
@@ -2324,11 +2440,11 @@ int main(int argc, char *argv[])
 
 		ret = query_control(&dev, ctrl_name, &query);
 		if (ret == 0)
-			video_print_control(&dev, &query, false);
+			video_get_control(&dev, &query, false);
 	}
 
 	if (do_set_control)
-		set_control(&dev, ctrl_name, ctrl_value);
+		video_set_control(&dev, ctrl_name, ctrl_value);
 
 	if (do_list_controls)
 		video_list_controls(&dev);
-- 
Regards,

Laurent Pinchart

