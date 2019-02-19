Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C142C10F00
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F064F20665
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:24:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Ju0vLBVW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfBSQYF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 11:24:05 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49366 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729010AbfBSQYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 11:24:05 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 37ED254D;
        Tue, 19 Feb 2019 17:24:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550593443;
        bh=7AOS4nQ1b5bYmvOsToq+z63H9Bocy+OGnwRvPCXhOX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ju0vLBVW/MA+C0cerAMJravlk2TLYom6nQGbK/hkdlBg2WHBy6HcXAPiCWCdzYA4z
         SDIduviyDaxhd5sPM+5zfofZ7P56Ic12HZZQfaujx7Y0OK/K6ew1pQ7z+dd4r2Zc/T
         1eh6qk6BUuz227qQz2omILCXmt2jH8bvxLGGs0JQ=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH 2/2] Add support to reset device controls
Date:   Tue, 19 Feb 2019 18:23:55 +0200
Message-Id: <20190219162355.24991-2-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190219162355.24991-1-laurent.pinchart@ideasonboard.com>
References: <20181203120331.4097-1-kieran.bingham@ideasonboard.com>
 <20190219162355.24991-1-laurent.pinchart@ideasonboard.com>
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
 yavta.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/yavta.c b/yavta.c
index 607a2883af4c..1b5d55bb569b 100644
--- a/yavta.c
+++ b/yavta.c
@@ -540,7 +540,7 @@ static int get_control(struct device *dev, const struct v4l2_queryctrl *query,
 }
 
 static void set_control(struct device *dev, unsigned int id,
-		        int64_t val)
+		        int64_t val, bool verbose)
 {
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
@@ -590,8 +590,9 @@ static void set_control(struct device *dev, unsigned int id,
 		return;
 	}
 
-	printf("Control 0x%08x set to %" PRId64 ", is %" PRId64 "\n",
-	       id, old_val, val);
+	if (verbose)
+		printf("Control 0x%08x set to %" PRId64 ", is %" PRId64 "\n",
+		       id, old_val, val);
 }
 
 static int video_get_format(struct device *dev)
@@ -1250,6 +1251,32 @@ static void video_list_controls(struct device *dev)
 		printf("No control found.\n");
 }
 
+static int video_reset_control(struct device *dev, void *data __attribute__((__unused__)),
+			       const struct v4l2_queryctrl *query)
+{
+	if (query->flags & V4L2_CTRL_FLAG_DISABLED)
+		return 0;
+
+	if (query->type == V4L2_CTRL_TYPE_CTRL_CLASS)
+		return 0;
+
+	set_control(dev, query->id, query->default_value, false);
+
+	return 1;
+}
+
+static void video_reset_controls(struct device *dev)
+{
+	int ret;
+
+	ret = video_for_each_control(dev, video_reset_control, NULL);
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
@@ -1871,6 +1898,7 @@ static void usage(const char *argv0)
 	printf("    --premultiplied		Color components are premultiplied by alpha value\n");
 	printf("    --queue-late		Queue buffers after streamon, not before\n");
 	printf("    --requeue-last		Requeue the last buffers before streamoff\n");
+	printf("    --reset-controls		Reset all available controls to their default value\n");
 	printf("    --timestamp-source		Set timestamp source on output buffers [eof, soe]\n");
 	printf("    --skip n			Skip the first n frames\n");
 	printf("    --sleep-forever		Sleep forever after configuring the device\n");
@@ -1893,6 +1921,7 @@ static void usage(const char *argv0)
 #define OPT_PREMULTIPLIED	269
 #define OPT_QUEUE_LATE		270
 #define OPT_DATA_PREFIX		271
+#define OPT_RESET_CONTROLS	272
 
 static struct option opts[] = {
 	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
@@ -1921,6 +1950,7 @@ static struct option opts[] = {
 	{"queue-late", 0, 0, OPT_QUEUE_LATE},
 	{"get-control", 1, 0, 'r'},
 	{"requeue-last", 0, 0, OPT_REQUEUE_LAST},
+	{"reset-controls", 0, 0, OPT_RESET_CONTROLS},
 	{"realtime", 2, 0, 'R'},
 	{"size", 1, 0, 's'},
 	{"set-control", 1, 0, 'w'},
@@ -1948,6 +1978,7 @@ int main(int argc, char *argv[])
 	int do_enum_formats = 0, do_set_format = 0;
 	int do_enum_inputs = 0, do_set_input = 0;
 	int do_list_controls = 0, do_get_control = 0, do_set_control = 0;
+	int do_reset_controls = 0;
 	int do_sleep_forever = 0, do_requeue_last = 0;
 	int do_rt = 0, do_log_status = 0;
 	int no_query = 0, do_queue_late = 0;
@@ -2140,6 +2171,9 @@ int main(int argc, char *argv[])
 		case OPT_QUEUE_LATE:
 			do_queue_late = 1;
 			break;
+		case OPT_RESET_CONTROLS:
+			do_reset_controls = 1;
+			break;
 		case OPT_REQUEUE_LAST:
 			do_requeue_last = 1;
 			break;
@@ -2220,11 +2254,14 @@ int main(int argc, char *argv[])
 	}
 
 	if (do_set_control)
-		set_control(&dev, ctrl_name, ctrl_value);
+		set_control(&dev, ctrl_name, ctrl_value, true);
 
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

