Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12358C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D667220C01
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="I3Z7xVlw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfBTMvg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:51:36 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59610 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfBTMvf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 07:51:35 -0500
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5B226993;
        Wed, 20 Feb 2019 13:51:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550667093;
        bh=OCobH14UDOZ2S0r3PDw3juATZk2nBWfdh7vbPmQ397c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3Z7xVlwcBTJfsHyfYI5tlSLmoI0ZYcGMcLB/30EC5x58r20JHPiD82EWihzJbuCD
         CCFRifnmOsSaSkofw/35l8jcWaHqXjvKu1ZAACAjZjGkTwNierkKbTF/CsvYcyjEKw
         D+lfepnDRZQ7Nk6Cd1U6Ntu+fdjdyLXaJIILdBrE=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH yavta 2/7] Implement VIDIOC_QUERY_EXT_CTRL support
Date:   Wed, 20 Feb 2019 14:51:18 +0200
Message-Id: <20190220125123.9410-3-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use the new extended control query ioctl when available with an
automatic fall back to VIDIOC_QUERYCTRL.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 63 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff --git a/yavta.c b/yavta.c
index 98bc09810ff1..eb50d592736f 100644
--- a/yavta.c
+++ b/yavta.c
@@ -476,25 +476,56 @@ static void video_log_status(struct device *dev)
 }
 
 static int query_control(struct device *dev, unsigned int id,
-			 struct v4l2_queryctrl *query)
+			 struct v4l2_query_ext_ctrl *query)
 {
+	struct v4l2_queryctrl q;
 	int ret;
 
 	memset(query, 0, sizeof(*query));
 	query->id = id;
 
-	ret = ioctl(dev->fd, VIDIOC_QUERYCTRL, query);
+	ret = ioctl(dev->fd, VIDIOC_QUERY_EXT_CTRL, query);
+	if (ret < 0)
+		ret = -errno;
+	if (!ret || ret == -EINVAL)
+		return ret;
+
+	if (ret != -ENOTTY) {
+		printf("unable to query control 0x%8.8x: %s (%d).\n",
+		       id, strerror(-ret), -ret);
+		return ret;
+	}
+
+	/*
+	 * If VIDIOC_QUERY_EXT_CTRL isn't available emulate it using
+	 * VIDIOC_QUERYCTRL.
+	 */
+	memset(&q, 0, sizeof(q));
+	q.id = id;
+
+	ret = ioctl(dev->fd, VIDIOC_QUERYCTRL, &q);
 	if (ret < 0) {
 		ret = -errno;
-		if (ret != -EINVAL)
-			printf("unable to query control 0x%8.8x: %s (%d).\n",
-			       id, strerror(errno), errno);
+		printf("unable to query control 0x%8.8x: %s (%d).\n",
+		       id, strerror(-ret), -ret);
+		return ret;
 	}
 
-	return ret;
+	memset(query, 0, sizeof(*query));
+	query->id = q.id;
+	query->type = q.type;
+	memcpy(query->name, q.name, sizeof(query->name));
+	query->minimum = q.minimum;
+	query->maximum = q.maximum;
+	query->step = q.step;
+	query->default_value = q.default_value;
+	query->flags = q.flags;
+
+	return 0;
 }
 
-static int get_control(struct device *dev, const struct v4l2_queryctrl *query,
+static int get_control(struct device *dev,
+		       const struct v4l2_query_ext_ctrl *query,
 		       struct v4l2_ext_control *ctrl)
 {
 	struct v4l2_ext_controls ctrls;
@@ -544,7 +575,7 @@ static void set_control(struct device *dev, unsigned int id,
 {
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
-	struct v4l2_queryctrl query;
+	struct v4l2_query_ext_ctrl query;
 	int64_t old_val = val;
 	int is_64;
 	int ret;
@@ -1124,9 +1155,9 @@ static int video_enable(struct device *dev, int enable)
 }
 
 static int video_for_each_control(struct device *dev,
-				  int(*callback)(struct device *dev, const struct v4l2_queryctrl *query))
+				  int(*callback)(struct device *dev, const struct v4l2_query_ext_ctrl *query))
 {
-	struct v4l2_queryctrl query;
+	struct v4l2_query_ext_ctrl query;
 	unsigned int nctrls = 0;
 	unsigned int id;
 	int ret;
@@ -1161,7 +1192,8 @@ static int video_for_each_control(struct device *dev,
 	return nctrls;
 }
 
-static void video_query_menu(struct device *dev, const struct v4l2_queryctrl *query,
+static void video_query_menu(struct device *dev,
+			     const struct v4l2_query_ext_ctrl *query,
 			     unsigned int value)
 {
 	struct v4l2_querymenu menu;
@@ -1184,7 +1216,8 @@ static void video_query_menu(struct device *dev, const struct v4l2_queryctrl *qu
 }
 
 static int video_print_control(struct device *dev,
-			       const struct v4l2_queryctrl *query, bool full)
+			       const struct v4l2_query_ext_ctrl *query,
+			       bool full)
 {
 	struct v4l2_ext_control ctrl;
 	char sval[24];
@@ -1210,7 +1243,7 @@ static int video_print_control(struct device *dev,
 		sprintf(sval, "%d", ctrl.value);
 
 	if (full)
-		printf("control 0x%08x `%s' min %d max %d step %d default %d current %s.\n",
+		printf("control 0x%08x `%s' min %lld max %lld step %lld default %lld current %s.\n",
 			query->id, query->name, query->minimum, query->maximum,
 			query->step, query->default_value, current);
 	else
@@ -1230,7 +1263,7 @@ static int video_print_control(struct device *dev,
 }
 
 static int __video_print_control(struct device *dev,
-				 const struct v4l2_queryctrl *query)
+				 const struct v4l2_query_ext_ctrl *query)
 {
 	return video_print_control(dev, query, true);
 }
@@ -2211,7 +2244,7 @@ int main(int argc, char *argv[])
 		video_log_status(&dev);
 
 	if (do_get_control) {
-		struct v4l2_queryctrl query;
+		struct v4l2_query_ext_ctrl query;
 
 		ret = query_control(&dev, ctrl_name, &query);
 		if (ret == 0)
-- 
Regards,

Laurent Pinchart

