Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6108C10F01
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B35120C01
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="fEBlqqyO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfBTMvf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:51:35 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59606 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbfBTMvf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 07:51:35 -0500
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0B4ED54D;
        Wed, 20 Feb 2019 13:51:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550667092;
        bh=FUKIuiMAMLvpRjdLSzCuLRN2p8GNOkmCUvU8habRU1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEBlqqyOdFI+pJuYEXWnlKJ5n2XEQ+rcJoi1Hqe6CkbtJk64q96FjELD0UHs3AD7T
         Kh3c9A6i+nBHNABQZxflWojZwOmxd9yEiKIaZasbKfeOzlKwE523c+K9SA4q5vi6Q8
         SLlXWgCmsb7owaJP1w3X39zadQuGqqT3IMsAJeps=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH yavta 1/7] yavta: Refactor video_list_controls()
Date:   Wed, 20 Feb 2019 14:51:17 +0200
Message-Id: <20190220125123.9410-2-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
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
 yavta.c | 133 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 82 insertions(+), 51 deletions(-)

diff --git a/yavta.c b/yavta.c
index 2d3b2d096f7d..98bc09810ff1 100644
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
@@ -1120,7 +1123,45 @@ static int video_enable(struct device *dev, int enable)
 	return 0;
 }
 
-static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
+static int video_for_each_control(struct device *dev,
+				  int(*callback)(struct device *dev, const struct v4l2_queryctrl *query))
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
+		ret = callback(dev, &query);
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
@@ -1142,83 +1183,68 @@ static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
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
+		return 0;
 
-	if (query.flags & V4L2_CTRL_FLAG_DISABLED)
-		return query.id;
-
-	if (query.type == V4L2_CTRL_TYPE_CTRL_CLASS) {
-		printf("--- %s (class 0x%08x) ---\n", query.name, query.id);
-		return query.id;
+	if (query->type == V4L2_CTRL_TYPE_CTRL_CLASS) {
+		printf("--- %s (class 0x%08x) ---\n", query->name, query->id);
+		return 0;
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
+static int __video_print_control(struct device *dev,
+				 const struct v4l2_queryctrl *query)
+{
+	return video_print_control(dev, query, true);
 }
 
 static void video_list_controls(struct device *dev)
 {
-	unsigned int nctrls = 0;
-	unsigned int id;
 	int ret;
 
-#ifndef V4L2_CTRL_FLAG_NEXT_CTRL
-	unsigned int i;
+	ret = video_for_each_control(dev, __video_print_control);
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
@@ -2184,8 +2210,13 @@ int main(int argc, char *argv[])
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

