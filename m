Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,URIBL_SBL,
	URIBL_SBL_A,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B447C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 11:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 364E320870
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 11:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Ml4MwZLl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 364E320870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbeLJLSO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 06:18:14 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:56070 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbeLJLSO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 06:18:14 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id E061A549;
        Mon, 10 Dec 2018 12:18:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544440692;
        bh=8kuKSQDPcj+R+DI/9UQ8pye6KIyr6wevsopG6ipX8aI=;
        h=From:To:Cc:Subject:Date:From;
        b=Ml4MwZLlQUxCkPaw72tTwh5S92vnviXBE5iQ3ytfU/Kt4P8AkIaMVckaKVoKF6hZn
         9KnTT+xRa6gCJG+wJZbetrkMuv06ENKyOwGjw4j15vtrYqJ/4Cooi+FQdJ49nwniuU
         15eJz3gEe0KYdGERq5+qS9aa43+HWqYP8uvLbbDs=
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2] Add support to reset device controls
Date:   Mon, 10 Dec 2018 11:18:08 +0000
Message-Id: <20181210111808.10890-1-kieran.bingham@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Provide a new option '--reset-controls' which will enumerate the
available controls on a device or sub-device, and re-initialise them to
defaults.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

---

v2:
 - Rebase and rework to sit on top of the compound control changes

With this patch, and the updated VSP-Tests series, the M3-N now
successfully passes all of the tests using the VSP1.

This patch is available on the 'vsp' branch at:
  https://github.com/kbingham/yavta.git


 yavta.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/yavta.c b/yavta.c
index 625a93ba879d..656ead0f0a37 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1547,7 +1547,43 @@ static void video_set_control(struct device *dev, unsigned int id,
 		free(ctrl.ptr);
 }
 
-static void video_list_controls(struct device *dev)
+static int video_reset_control(struct device *dev, unsigned int id)
+{
+	struct v4l2_query_ext_ctrl query;
+	struct v4l2_ext_control ctrl;
+	int ret;
+
+	ret = query_control(dev, id, &query);
+	if (ret < 0)
+		return ret;
+
+	if (query.type == V4L2_CTRL_TYPE_CTRL_CLASS)
+		return query.id;
+
+	/* Skip controls that we cannot (or should not) update. */
+	if (query.flags & (V4L2_CTRL_FLAG_DISABLED
+			|  V4L2_CTRL_FLAG_VOLATILE
+			|  V4L2_CTRL_FLAG_READ_ONLY))
+		return query.id;
+
+	ctrl.id = query.id;
+	ctrl.value = query.default_value;
+
+	ret = set_control(dev, &query, &ctrl);
+	if (ret < 0) {
+		printf("unable to reset control 0x%8.8x: %s (%d).\n",
+			id, strerror(errno), errno);
+	} else {
+		printf("control 0x%08x reset to ", id);
+
+		video_print_control_value(&query, &ctrl);
+		printf("\n");
+	}
+
+	return query.id;
+}
+
+static void video_list_controls(struct device *dev, bool reset)
 {
 	unsigned int nctrls = 0;
 	unsigned int id;
@@ -1568,6 +1604,12 @@ static void video_list_controls(struct device *dev)
 		if (ret < 0)
 			break;
 
+		if (reset) {
+			ret = video_reset_control(dev, id);
+			if (ret < 0)
+				break;
+		}
+
 		id = ret;
 		nctrls++;
 	}
@@ -2206,6 +2248,7 @@ static void usage(const char *argv0)
 	printf("    --offset			User pointer buffer offset from page start\n");
 	printf("    --premultiplied		Color components are premultiplied by alpha value\n");
 	printf("    --queue-late		Queue buffers after streamon, not before\n");
+	printf("    --reset-controls		Enumerate available controls and reset to defaults\n");
 	printf("    --requeue-last		Requeue the last buffers before streamoff\n");
 	printf("    --timestamp-source		Set timestamp source on output buffers [eof, soe]\n");
 	printf("    --skip n			Skip the first n frames\n");
@@ -2229,6 +2272,7 @@ static void usage(const char *argv0)
 #define OPT_PREMULTIPLIED	269
 #define OPT_QUEUE_LATE		270
 #define OPT_DATA_PREFIX		271
+#define OPT_RESET_CONTROLS	272
 
 static struct option opts[] = {
 	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
@@ -2257,6 +2301,7 @@ static struct option opts[] = {
 	{"queue-late", 0, 0, OPT_QUEUE_LATE},
 	{"get-control", 1, 0, 'r'},
 	{"requeue-last", 0, 0, OPT_REQUEUE_LAST},
+	{"reset-controls", 0, 0, OPT_RESET_CONTROLS},
 	{"realtime", 2, 0, 'R'},
 	{"size", 1, 0, 's'},
 	{"set-control", 1, 0, 'w'},
@@ -2284,6 +2329,7 @@ int main(int argc, char *argv[])
 	int do_enum_formats = 0, do_set_format = 0;
 	int do_enum_inputs = 0, do_set_input = 0;
 	int do_list_controls = 0, do_get_control = 0, do_set_control = 0;
+	int do_reset_controls = 0;
 	int do_sleep_forever = 0, do_requeue_last = 0;
 	int do_rt = 0, do_log_status = 0;
 	int no_query = 0, do_queue_late = 0;
@@ -2476,6 +2522,9 @@ int main(int argc, char *argv[])
 		case OPT_QUEUE_LATE:
 			do_queue_late = 1;
 			break;
+		case OPT_RESET_CONTROLS:
+			do_reset_controls = 1;
+			break;
 		case OPT_REQUEUE_LAST:
 			do_requeue_last = 1;
 			break;
@@ -2560,7 +2609,10 @@ int main(int argc, char *argv[])
 		video_set_control(&dev, ctrl_name, ctrl_value);
 
 	if (do_list_controls)
-		video_list_controls(&dev);
+		video_list_controls(&dev, false);
+
+	if (do_reset_controls)
+		video_list_controls(&dev, true);
 
 	if (do_enum_formats) {
 		printf("- Available formats:\n");
-- 
2.17.1

