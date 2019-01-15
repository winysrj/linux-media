Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC32C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 03:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A2E2085A
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 03:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfAODh4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 22:37:56 -0500
Received: from mga12.intel.com ([192.55.52.136]:58713 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbfAODh4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 22:37:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2019 19:37:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,480,1539673200"; 
   d="scan'208";a="114725373"
Received: from harojas-mobl1.amr.corp.intel.com (HELO yzhi-desktop.amr.corp.intel.com) ([10.254.10.3])
  by fmsmga007.fm.intel.com with ESMTP; 14 Jan 2019 19:37:54 -0800
From:   Yong Zhi <yong.zhi@intel.com>
To:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc:     tfiga@chromium.org, rajmohan.mani@intel.com,
        tian.shu.qiu@intel.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, mchehab@kernel.org, bingbu.cao@intel.com,
        dan.carpenter@oracle.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH 1/2] media: ipu3-imgu: Use MENU type for mode control
Date:   Mon, 14 Jan 2019 21:37:44 -0600
Message-Id: <1547523465-27807-1-git-send-email-yong.zhi@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This addresses the below TODO item.
- Use V4L2_CTRL_TYPE_MENU for dual-pipe mode control. (Sakari)

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/staging/media/ipu3/TODO                 |  2 --
 drivers/staging/media/ipu3/include/intel-ipu3.h |  6 ------
 drivers/staging/media/ipu3/ipu3-v4l2.c          | 18 +++++++++++++-----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/ipu3/TODO b/drivers/staging/media/ipu3/TODO
index 905bbb190217..0dc9a2e79978 100644
--- a/drivers/staging/media/ipu3/TODO
+++ b/drivers/staging/media/ipu3/TODO
@@ -11,8 +11,6 @@ staging directory.
 - Prefix imgu for all public APIs, i.e. change ipu3_v4l2_register() to
   imgu_v4l2_register(). (Sakari)
 
-- Use V4L2_CTRL_TYPE_MENU for dual-pipe mode control. (Sakari)
-
 - IPU3 driver documentation (Laurent)
   Add diagram in driver rst to describe output capability.
   Comments on configuring v4l2 subdevs for CIO2 and ImgU.
diff --git a/drivers/staging/media/ipu3/include/intel-ipu3.h b/drivers/staging/media/ipu3/include/intel-ipu3.h
index ec0b74829351..eb6f52aca992 100644
--- a/drivers/staging/media/ipu3/include/intel-ipu3.h
+++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
@@ -16,12 +16,6 @@
 #define V4L2_CID_INTEL_IPU3_BASE	(V4L2_CID_USER_BASE + 0x10c0)
 #define V4L2_CID_INTEL_IPU3_MODE	(V4L2_CID_INTEL_IPU3_BASE + 1)
 
-/* custom ctrl to set pipe mode */
-enum ipu3_running_mode {
-	IPU3_RUNNING_MODE_VIDEO = 0,
-	IPU3_RUNNING_MODE_STILL = 1,
-};
-
 /******************* ipu3_uapi_stats_3a *******************/
 
 #define IPU3_UAPI_MAX_STRIPES				2
diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index c7936032beb9..d2a0b62d5688 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -12,6 +12,9 @@
 
 /******************** v4l2_subdev_ops ********************/
 
+#define	IPU3_RUNNING_MODE_VIDEO		0
+#define	IPU3_RUNNING_MODE_STILL		1
+
 static int ipu3_subdev_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
@@ -1035,15 +1038,20 @@ static const struct v4l2_ctrl_ops ipu3_subdev_ctrl_ops = {
 	.s_ctrl = ipu3_sd_s_ctrl,
 };
 
+static const char * const ipu3_ctrl_mode_strings[] = {
+	"Video mode",
+	"Still mode",
+	NULL,
+};
+
 static const struct v4l2_ctrl_config ipu3_subdev_ctrl_mode = {
 	.ops = &ipu3_subdev_ctrl_ops,
 	.id = V4L2_CID_INTEL_IPU3_MODE,
 	.name = "IPU3 Pipe Mode",
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.min = IPU3_RUNNING_MODE_VIDEO,
-	.max = IPU3_RUNNING_MODE_STILL,
-	.step = 1,
-	.def = IPU3_RUNNING_MODE_VIDEO,
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = ARRAY_SIZE(ipu3_ctrl_mode_strings) - 2,
+	.def = 0,
+	.qmenu = ipu3_ctrl_mode_strings,
 };
 
 /******************** Framework registration ********************/
-- 
2.7.4

