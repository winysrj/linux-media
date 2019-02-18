Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61811C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DE2721872
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfBRUP5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:15:57 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40866 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729465AbfBRUP4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 15:15:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id A770627FD0A
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 4/4] media: v4l: ctrls: Add debug messages
Date:   Mon, 18 Feb 2019 17:15:28 -0300
Message-Id: <20190218201528.21545-5-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190218201528.21545-1-ezequiel@collabora.com>
References: <20190218201528.21545-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Currently, the v4l2 control code is a bit silent on errors.
To ease debugging of the control logic, add debug messages
on (hopefully) most of the error paths.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 63 +++++++++++++++++++++++-----
 include/media/v4l2-ioctl.h           |  2 +
 2 files changed, 54 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 99308dac2daa..c9f4e00f2229 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -18,6 +18,8 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) "v4l2-ctrls: " fmt
+
 #include <linux/ctype.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -28,6 +30,14 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-dev.h>
 
+extern unsigned int videodev_debug;
+
+#define dprintk(fmt, arg...) do {					\
+	if (videodev_debug & V4L2_DEV_DEBUG_CTRL)			\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__, ##arg);				\
+} while (0)
+
 #define has_op(master, op) \
 	(master->ops && master->ops->op)
 #define call_op(master, op) \
@@ -1952,8 +1962,11 @@ static int validate_new(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr p_new)
 	unsigned idx;
 	int err = 0;
 
-	for (idx = 0; !err && idx < ctrl->elems; idx++)
+	for (idx = 0; !err && idx < ctrl->elems; idx++) {
 		err = ctrl->type_ops->validate(ctrl, idx, p_new);
+		if (err)
+			dprintk("failed to validate control id 0x%x (%d)\n", ctrl->id, err);
+	}
 	return err;
 }
 
@@ -3136,20 +3149,28 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		if (cs->which &&
 		    cs->which != V4L2_CTRL_WHICH_DEF_VAL &&
 		    cs->which != V4L2_CTRL_WHICH_REQUEST_VAL &&
-		    V4L2_CTRL_ID2WHICH(id) != cs->which)
+		    V4L2_CTRL_ID2WHICH(id) != cs->which) {
+			dprintk("invalid which 0x%x or control id 0x%x\n", cs->which, id);
 			return -EINVAL;
+		}
 
 		/* Old-style private controls are not allowed for
 		   extended controls */
-		if (id >= V4L2_CID_PRIVATE_BASE)
+		if (id >= V4L2_CID_PRIVATE_BASE) {
+			dprintk("old-style private controls not allowed for extended controls\n");
 			return -EINVAL;
+		}
 		ref = find_ref_lock(hdl, id);
-		if (ref == NULL)
+		if (ref == NULL) {
+			dprintk("cannot find control id 0x%x\n", id);
 			return -EINVAL;
+		}
 		h->ref = ref;
 		ctrl = ref->ctrl;
-		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
+		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED) {
+			dprintk("control id 0x%x is disabled\n", id);
 			return -EINVAL;
+		}
 
 		if (ctrl->cluster[0]->ncontrols > 1)
 			have_clusters = true;
@@ -3159,10 +3180,16 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			unsigned tot_size = ctrl->elems * ctrl->elem_size;
 
 			if (c->size < tot_size) {
+				/*
+				 * In the get case the application first queries
+				 * to obtain the size of the control.
+				 */
 				if (get) {
 					c->size = tot_size;
 					return -ENOSPC;
 				}
+				dprintk("pointer control id 0x%x size too small, %d bytes but %d bytes needed\n",
+					id, c->size, tot_size);
 				return -EFAULT;
 			}
 			c->size = tot_size;
@@ -3534,16 +3561,20 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
 
 		cs->error_idx = i;
 
-		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
+		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY) {
+			dprintk("control id 0x%x is read-only\n", ctrl->id);
 			return -EACCES;
+		}
 		/* This test is also done in try_set_control_cluster() which
 		   is called in atomic context, so that has the final say,
 		   but it makes sense to do an up-front check as well. Once
 		   an error occurs in try_set_control_cluster() some other
 		   controls may have been set already and we want to do a
 		   best-effort to avoid that. */
-		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
+		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED)) {
+			dprintk("control id 0x%x is grabbed, cannot set\n", ctrl->id);
 			return -EBUSY;
+		}
 		/*
 		 * Skip validation for now if the payload needs to be copied
 		 * from userspace into kernelspace. We'll validate those later.
@@ -3588,13 +3619,17 @@ static int try_set_ext_ctrls_common(struct v4l2_fh *fh,
 	cs->error_idx = cs->count;
 
 	/* Default value cannot be changed */
-	if (cs->which == V4L2_CTRL_WHICH_DEF_VAL)
+	if (cs->which == V4L2_CTRL_WHICH_DEF_VAL) {
+		dprintk("cannot change default value\n");
 		return -EINVAL;
+	}
 
 	cs->which = V4L2_CTRL_ID2WHICH(cs->which);
 
-	if (hdl == NULL)
+	if (hdl == NULL) {
+		dprintk("invalid null control handler\n");
 		return -EINVAL;
+	}
 
 	if (cs->count == 0)
 		return class_check(hdl, cs->which);
@@ -3700,21 +3735,27 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
 	int ret;
 
 	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
-		if (!mdev || cs->request_fd < 0)
+		if (!mdev || cs->request_fd < 0) {
+			dprintk("missing media device or invalid request fd\n");
 			return -EINVAL;
+		}
 
 		req = media_request_get_by_fd(mdev, cs->request_fd);
-		if (IS_ERR(req))
+		if (IS_ERR(req)) {
+			dprintk("cannot find request fd %d\n", cs->request_fd);
 			return PTR_ERR(req);
+		}
 
 		ret = media_request_lock_for_update(req);
 		if (ret) {
+			dprintk("cannot lock request fd %d\n", cs->request_fd);
 			media_request_put(req);
 			return ret;
 		}
 
 		obj = v4l2_ctrls_find_req_obj(hdl, req, set);
 		if (IS_ERR(obj)) {
+			dprintk("cannot find request object for request fd %d\n", cs->request_fd);
 			media_request_unlock_for_update(req);
 			media_request_put(req);
 			return PTR_ERR(obj);
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 8533ece5026e..0ecd4e3e76a4 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -612,6 +612,8 @@ struct v4l2_ioctl_ops {
 #define V4L2_DEV_DEBUG_STREAMING	0x08
 /* Log poll() */
 #define V4L2_DEV_DEBUG_POLL		0x10
+/* Log controls */
+#define V4L2_DEV_DEBUG_CTRL		0x20
 
 /*  Video standard functions  */
 
-- 
2.20.1

