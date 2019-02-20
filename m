Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D875CC10F01
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A80062147C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="J513QDk4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfBTMvk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:51:40 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59620 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbfBTMvj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 07:51:39 -0500
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id DF09E9EE;
        Wed, 20 Feb 2019 13:51:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550667095;
        bh=cA+3pr0oclsPhMFer2BCY8lEBzcErm/NTJ3oFSbZO2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J513QDk46D8fLLwUcj2a968arSu/O4BDcrS5fHv7c7bfDYsPSF2g3OJr/hzqaTRe4
         qN08wCKyZNOVB8Dnd7N6XBm5h8Sf64hyL3FHuUzN+21C6vVy3d2Xr5YGlxhfVWQQtS
         AhXnv74xj7VbjKLBipnzZTvlDCGMtt9713BeOXM0=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH yavta 5/7] Add support to reset device controls
Date:   Wed, 20 Feb 2019 14:51:21 +0200
Message-Id: <20190220125123.9410-6-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

Provide a new option '--reset-controls' which will enumerate the
available controls on a device or sub-device, and re-initialise them to
defaults.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 3 deletions(-)

diff --git a/yavta.c b/yavta.c
index d1bfd380c03b..1490878c6f7e 100644
--- a/yavta.c
+++ b/yavta.c
@@ -527,7 +527,8 @@ static int query_control(struct device *dev, unsigned int id,
 
 static int get_control(struct device *dev,
 		       const struct v4l2_query_ext_ctrl *query,
-		       struct v4l2_ext_control *ctrl)
+		       struct v4l2_ext_control *ctrl,
+		       unsigned int which)
 {
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_control old;
@@ -536,7 +537,7 @@ static int get_control(struct device *dev,
 	memset(&ctrls, 0, sizeof(ctrls));
 	memset(ctrl, 0, sizeof(*ctrl));
 
-	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(query->id);
+	ctrls.which = which;
 	ctrls.count = 1;
 	ctrls.controls = ctrl;
 
@@ -1295,7 +1296,7 @@ static int video_get_control(struct device *dev,
 
 	printf("current ");
 
-	ret = get_control(dev, query, &ctrl);
+	ret = get_control(dev, query, &ctrl, V4L2_CTRL_WHICH_CUR_VAL);
 	if (ret < 0) {
 		printf("n/a\n");
 		printf("unable to get control 0x%8.8x: %s (%d).\n",
@@ -1478,6 +1479,51 @@ static void video_list_controls(struct device *dev)
 		printf("No control found.\n");
 }
 
+static int video_reset_control(struct device *dev,
+			       const struct v4l2_query_ext_ctrl *query)
+{
+       struct v4l2_ext_control ctrl = { .value = query->default_value, };
+       int ret;
+
+	if (query->flags & V4L2_CTRL_FLAG_DISABLED)
+		return 0;
+
+	if (query->type == V4L2_CTRL_TYPE_CTRL_CLASS)
+		return 0;
+
+	/*
+	 * For controls with payloads the default value must be retrieved with
+	 * a VIDIOC_G_EXT_CTRLS call. If the V4L2_CTRL_WHICH_DEF_VAL flag isn't
+	 * supported by the kernel (it got introduced in v4.5, while controls
+	 * with payloads were introduced in v3.17), there isn't much we can do,
+	 * so skip resetting the control.
+	 */
+	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD) {
+		ret = get_control(dev, query, &ctrl, V4L2_CTRL_WHICH_DEF_VAL);
+		if (ret < 0)
+			return 0;
+	}
+
+	set_control(dev, query, &ctrl);
+
+	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD)
+		free(ctrl.ptr);
+
+	return 1;
+}
+
+static void video_reset_controls(struct device *dev)
+{
+	int ret;
+
+	ret = video_for_each_control(dev, video_reset_control);
+	if (ret < 0)
+		return;
+
+	if (ret)
+		printf("%u control%s reset.\n", ret, ret > 1 ? "s" : "");
+}
+
 static void video_enum_frame_intervals(struct device *dev, __u32 pixelformat,
 	unsigned int width, unsigned int height)
 {
@@ -2099,6 +2145,7 @@ static void usage(const char *argv0)
 	printf("    --premultiplied		Color components are premultiplied by alpha value\n");
 	printf("    --queue-late		Queue buffers after streamon, not before\n");
 	printf("    --requeue-last		Requeue the last buffers before streamoff\n");
+	printf("    --reset-controls		Reset all available controls to their default value\n");
 	printf("    --timestamp-source		Set timestamp source on output buffers [eof, soe]\n");
 	printf("    --skip n			Skip the first n frames\n");
 	printf("    --sleep-forever		Sleep forever after configuring the device\n");
@@ -2121,6 +2168,7 @@ static void usage(const char *argv0)
 #define OPT_PREMULTIPLIED	269
 #define OPT_QUEUE_LATE		270
 #define OPT_DATA_PREFIX		271
+#define OPT_RESET_CONTROLS	272
 
 static struct option opts[] = {
 	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
@@ -2149,6 +2197,7 @@ static struct option opts[] = {
 	{"queue-late", 0, 0, OPT_QUEUE_LATE},
 	{"get-control", 1, 0, 'r'},
 	{"requeue-last", 0, 0, OPT_REQUEUE_LAST},
+	{"reset-controls", 0, 0, OPT_RESET_CONTROLS},
 	{"realtime", 2, 0, 'R'},
 	{"size", 1, 0, 's'},
 	{"set-control", 1, 0, 'w'},
@@ -2176,6 +2225,7 @@ int main(int argc, char *argv[])
 	int do_enum_formats = 0, do_set_format = 0;
 	int do_enum_inputs = 0, do_set_input = 0;
 	int do_list_controls = 0, do_get_control = 0, do_set_control = 0;
+	int do_reset_controls = 0;
 	int do_sleep_forever = 0, do_requeue_last = 0;
 	int do_rt = 0, do_log_status = 0;
 	int no_query = 0, do_queue_late = 0;
@@ -2364,6 +2414,9 @@ int main(int argc, char *argv[])
 		case OPT_QUEUE_LATE:
 			do_queue_late = 1;
 			break;
+		case OPT_RESET_CONTROLS:
+			do_reset_controls = 1;
+			break;
 		case OPT_REQUEUE_LAST:
 			do_requeue_last = 1;
 			break;
@@ -2449,6 +2502,9 @@ int main(int argc, char *argv[])
 	if (do_list_controls)
 		video_list_controls(&dev);
 
+	if (do_reset_controls)
+		video_reset_controls(&dev);
+
 	if (do_enum_formats) {
 		printf("- Available formats:\n");
 		video_enum_formats(&dev, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-- 
Regards,

Laurent Pinchart

