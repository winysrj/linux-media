Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45604 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752671AbeEUIzR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v14 16/36] v4l2-ctrls: Add documentation for control request support functions
Date: Mon, 21 May 2018 11:54:41 +0300
Message-Id: <20180521085501.16861-17-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add kerneldoc documentation for v4l2_ctrl_request_setup and
v4l2_ctrl_request_complete functions.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/v4l2-ctrls.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index a0f7c38d1a902..d2e5653df645e 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1077,8 +1077,34 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
  */
 __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
 
+/**
+ * v4l2_ctrl_request_setup - helper function to apply control values in a request
+ *
+ * @req: The request
+ * @hdl: The control handler
+ *
+ * This is a helper function to call the control handler's s_ctrl callback with
+ * the control values contained in the request. Do note that this approach of
+ * applying control values in a request is only applicable to memory-to-memory
+ * devices.
+ */
 void v4l2_ctrl_request_setup(struct media_request *req,
 			     struct v4l2_ctrl_handler *hdl);
+
+/**
+ * v4l2_ctrl_request_complete - Complete a control handler request object
+ *
+ * @req: The request
+ * @hdl: The control handler
+ *
+ * This function is to be called on each control handler that may have had a
+ * request object associated with it, i.e. control handlers of a driver that
+ * supports requests.
+ *
+ * The function first obtains the values of any volatile controls in the control
+ * handler and attach them to the request. Then, the function completes the
+ * request object.
+ */
 void v4l2_ctrl_request_complete(struct media_request *req,
 				struct v4l2_ctrl_handler *hdl);
 
-- 
2.11.0
