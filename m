Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8E5C282DB
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 17:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A64621726
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 17:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbfBAR34 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 12:29:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:40186 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730769AbfBAR34 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 12:29:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2019 09:29:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,549,1539673200"; 
   d="scan'208";a="296551850"
Received: from yzhi-z87x-ud5h.jf.intel.com ([134.134.159.168])
  by orsmga005.jf.intel.com with ESMTP; 01 Feb 2019 09:29:55 -0800
From:   Yong Zhi <yong.zhi@intel.com>
To:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc:     rajmohan.mani@intel.com, tfiga@chromium.org,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        mchehab@kernel.org, tian.shu.qiu@intel.com, bingbu.cao@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v3 1/2] media: ipu3-imgu: Use MENU type for mode control
Date:   Fri,  1 Feb 2019 09:23:36 -0800
Message-Id: <1549041817-3862-1-git-send-email-yong.zhi@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This addresses the below TODO item.
- Use V4L2_CTRL_TYPE_MENU for dual-pipe mode control. (Sakari)

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/ipu3/TODO                 |  2 --
 drivers/staging/media/ipu3/include/intel-ipu3.h |  6 ------
 drivers/staging/media/ipu3/ipu3-v4l2.c          | 15 +++++++++++----
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/ipu3/TODO b/drivers/staging/media/ipu3/TODO
index 905bbb1..0dc9a2e 100644
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
index ec0b748..eb6f52a 100644
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
index c793603..e758a65 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -12,6 +12,9 @@
 
 /******************** v4l2_subdev_ops ********************/
 
+#define IPU3_RUNNING_MODE_VIDEO		0
+#define IPU3_RUNNING_MODE_STILL		1
+
 static int ipu3_subdev_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
@@ -1035,15 +1038,19 @@ static const struct v4l2_ctrl_ops ipu3_subdev_ctrl_ops = {
 	.s_ctrl = ipu3_sd_s_ctrl,
 };
 
+static const char * const ipu3_ctrl_mode_strings[] = {
+	"Video mode",
+	"Still mode",
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
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = ARRAY_SIZE(ipu3_ctrl_mode_strings) - 1,
 	.def = IPU3_RUNNING_MODE_VIDEO,
+	.qmenu = ipu3_ctrl_mode_strings,
 };
 
 /******************** Framework registration ********************/
-- 
2.7.4

