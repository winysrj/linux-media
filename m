Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1413 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbeIYQZR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 12:25:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, tfiga@chromium.org, bingbu.cao@intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tian.shu.qiu@intel.com, ricardo.ribalda@gmail.com,
        grundler@chromium.org, ping-chung.chen@intel.com,
        andy.yeh@intel.com, jim.lai@intel.com, helmut.grohne@intenta.de,
        laurent.pinchart@ideasonboard.com, snawrocki@kernel.org
Subject: [PATCH 4/5] v4l: controls: QUERY_EXT_CTRL support for base, prefix and unit
Date: Tue, 25 Sep 2018 13:14:33 +0300
Message-Id: <20180925101434.20327-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for conveying the information set by the driver to the user
space.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 3 +++
 include/media/v4l2-ctrls.h           | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ee006d34c19f0..8d2931b0a4701 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2732,6 +2732,9 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 	qc->minimum = ctrl->minimum;
 	qc->maximum = ctrl->maximum;
 	qc->default_value = ctrl->default_value;
+	qc->base = ctrl->base;
+	qc->prefix = ctrl->prefix;
+	qc->unit = ctrl->unit;
 	if (ctrl->type == V4L2_CTRL_TYPE_MENU
 	    || ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU)
 		qc->step = 1;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index f615ba1b29dd9..d6aaf45b70381 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -220,6 +220,8 @@ struct v4l2_ctrl {
 	u32 elem_size;
 	u32 dims[V4L2_CTRL_MAX_DIMS];
 	u32 nr_of_dims;
+	u8 base, unit;
+	u16 prefix;
 	union {
 		u64 step;
 		u64 menu_skip_mask;
-- 
2.11.0
