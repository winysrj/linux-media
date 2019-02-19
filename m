Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62EEC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73C6520665
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:24:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="fQxpJ4Ex"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbfBSQYE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 11:24:04 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49362 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbfBSQYE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 11:24:04 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id DCB3B329;
        Tue, 19 Feb 2019 17:24:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550593443;
        bh=RKLv8gKUgOzZ3r/86p0IAp2ULVQy2t7mdO03f97GySQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQxpJ4Ex36ldHBzHWUoxIPxs7D02ib2MiiHLpZjv/lQutM4BsRPSHF+r2plJbastL
         WOWtQB/fOOs2VNqGHnKwDpKwUOO2jWhs3Q9EroUcJyfKrtyQjatlm6dlocDWa/fde7
         JpAtHWEpFzzJ8w6NkSIIn2Z4dwACODnheg8PTv94=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH 1/2] yavta: Refactor video_list_controls()
Date:   Tue, 19 Feb 2019 18:23:54 +0200
Message-Id: <20190219162355.24991-1-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181203120331.4097-1-kieran.bingham@ideasonboard.com>
References: <20181203120331.4097-1-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Separate iteration over controls from printing, in order to reuse the
iteration to implement control reset.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 134 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 83 insertions(+), 51 deletions(-)

diff --git a/yavta.c b/yavta.c
index 2d3b2d096f7d..607a2883af4c 100644
--- a/yavta.c
+++ b/yavta.c
@@ -484,9 +484,12 @@ static int query_control(struct device *dev, unsigned int id,
 	query->id = id;
 
 	ret = ioctl(dev->fd, VIDIOC_QUERYCTRL, query);
-	if (ret < 0 && errno != EINVAL)
-		printf("unable to query control 0x%8.8x: %s (%d).\n",
-		       id, strerror(errno), errno);
+	if (ret < 0) {
+		ret = -errno;
+		if (ret != -EINVAL)
+			printf("unable to query control 0x%8.8x: %s (%d).\n",
+			       id, strerror(errno), errno);
+	}
 
 	return ret;
 }
@@ -1120,7 +1123,46 @@ static int video_enable(struct device *dev, int enable)
 	return 0;
 }
 
-static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
+static int video_for_each_control(struct device *dev,
+				  int(*callback)(struct device *dev, void *data, const struct v4l2_queryctrl *query),
+				  void *data)
+{
+	struct v4l2_queryctrl query;
+	unsigned int nctrls = 0;
+	unsigned int id;
+	int ret;
+
+#ifndef V4L2_CTRL_FLAG_NEXT_CTRL
+	unsigned int i;
+
+	for (i = V4L2_CID_BASE; i <= V4L2_CID_LASTP1; ++i) {
+		id = i;
+#else
+	id = 0;
+	while (1) {
+		id |= V4L2_CTRL_FLAG_NEXT_CTRL;
+#endif
+
+		ret = query_control(dev, id, &query);
+		if (ret == -EINVAL)
+			break;
+		if (ret < 0)
+			return ret;
+
+		id = query.id;
+
+		ret = callback(dev, data, &query);
+		if (ret < 0)
+			return ret;
+
+		if (ret)
+			nctrls++;
+	}
+
+	return nctrls;
+}
+
+static void video_query_menu(struct device *dev, const struct v4l2_queryctrl *query,
 			     unsigned int value)
 {
 	struct v4l2_querymenu menu;
@@ -1142,83 +1184,68 @@ static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
 	};
 }
 
-static int video_print_control(struct device *dev, unsigned int id, bool full)
+static int video_print_control(struct device *dev,
+			       const struct v4l2_queryctrl *query, bool full)
 {
 	struct v4l2_ext_control ctrl;
-	struct v4l2_queryctrl query;
 	char sval[24];
 	char *current = sval;
 	int ret;
 
-	ret = query_control(dev, id, &query);
-	if (ret < 0)
-		return ret;
+	if (query->flags & V4L2_CTRL_FLAG_DISABLED)
+		return 1;
 
-	if (query.flags & V4L2_CTRL_FLAG_DISABLED)
-		return query.id;
-
-	if (query.type == V4L2_CTRL_TYPE_CTRL_CLASS) {
-		printf("--- %s (class 0x%08x) ---\n", query.name, query.id);
-		return query.id;
+	if (query->type == V4L2_CTRL_TYPE_CTRL_CLASS) {
+		printf("--- %s (class 0x%08x) ---\n", query->name, query->id);
+		return 1;
 	}
 
-	ret = get_control(dev, &query, &ctrl);
+	ret = get_control(dev, query, &ctrl);
 	if (ret < 0)
 		strcpy(sval, "n/a");
-	else if (query.type == V4L2_CTRL_TYPE_INTEGER64)
+	else if (query->type == V4L2_CTRL_TYPE_INTEGER64)
 		sprintf(sval, "%lld", ctrl.value64);
-	else if (query.type == V4L2_CTRL_TYPE_STRING)
+	else if (query->type == V4L2_CTRL_TYPE_STRING)
 		current = ctrl.string;
 	else
 		sprintf(sval, "%d", ctrl.value);
 
 	if (full)
 		printf("control 0x%08x `%s' min %d max %d step %d default %d current %s.\n",
-			query.id, query.name, query.minimum, query.maximum,
-			query.step, query.default_value, current);
+			query->id, query->name, query->minimum, query->maximum,
+			query->step, query->default_value, current);
 	else
-		printf("control 0x%08x current %s.\n", query.id, current);
+		printf("control 0x%08x current %s.\n", query->id, current);
 
-	if (query.type == V4L2_CTRL_TYPE_STRING)
+	if (query->type == V4L2_CTRL_TYPE_STRING)
 		free(ctrl.string);
 
 	if (!full)
-		return query.id;
+		return 1;
 
-	if (query.type == V4L2_CTRL_TYPE_MENU ||
-	    query.type == V4L2_CTRL_TYPE_INTEGER_MENU)
-		video_query_menu(dev, &query, ctrl.value);
+	if (query->type == V4L2_CTRL_TYPE_MENU ||
+	    query->type == V4L2_CTRL_TYPE_INTEGER_MENU)
+		video_query_menu(dev, query, ctrl.value);
 
-	return query.id;
+	return 1;
+}
+
+static int __video_print_control(struct device *dev, void *data,
+				 const struct v4l2_queryctrl *query)
+{
+	return video_print_control(dev, query, (bool)data);
 }
 
 static void video_list_controls(struct device *dev)
 {
-	unsigned int nctrls = 0;
-	unsigned int id;
 	int ret;
 
-#ifndef V4L2_CTRL_FLAG_NEXT_CTRL
-	unsigned int i;
+	ret = video_for_each_control(dev, __video_print_control, (void *)true);
+	if (ret < 0)
+		return;
 
-	for (i = V4L2_CID_BASE; i <= V4L2_CID_LASTP1; ++i) {
-		id = i;
-#else
-	id = 0;
-	while (1) {
-		id |= V4L2_CTRL_FLAG_NEXT_CTRL;
-#endif
-
-		ret = video_print_control(dev, id, true);
-		if (ret < 0)
-			break;
-
-		id = ret;
-		nctrls++;
-	}
-
-	if (nctrls)
-		printf("%u control%s found.\n", nctrls, nctrls > 1 ? "s" : "");
+	if (ret)
+		printf("%u control%s found.\n", ret, ret > 1 ? "s" : "");
 	else
 		printf("No control found.\n");
 }
@@ -2184,8 +2211,13 @@ int main(int argc, char *argv[])
 	if (do_log_status)
 		video_log_status(&dev);
 
-	if (do_get_control)
-		video_print_control(&dev, ctrl_name, false);
+	if (do_get_control) {
+		struct v4l2_queryctrl query;
+
+		ret = query_control(&dev, ctrl_name, &query);
+		if (ret == 0)
+			video_print_control(&dev, &query, false);
+	}
 
 	if (do_set_control)
 		set_control(&dev, ctrl_name, ctrl_value);
-- 
Regards,

Laurent Pinchart

