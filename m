Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABD9C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51BBA2133F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfCRTQ4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:16:56 -0400
Received: from retiisi.org.uk ([95.216.213.190]:55200 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727559AbfCRTQ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 15:16:56 -0400
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 25669634C7F;
        Mon, 18 Mar 2019 21:15:03 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Subject: [RFC 2/8] v4l2-async: Add v4l2_async_notifier_add_fwnode_remote_subdev
Date:   Mon, 18 Mar 2019 21:16:47 +0200
Message-Id: <20190318191653.7197-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
References: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

v4l2_async_notifier_add_fwnode_remote_subdev is a convenience function for
parsing information on V4L2 fwnode subdevs.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 23 +++++++++++++++++++++++
 include/media/v4l2-async.h           | 24 ++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 4cb49d5f8c03..9c1937d6ce17 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -608,6 +608,29 @@ v4l2_async_notifier_add_fwnode_subdev(struct v4l2_async_notifier *notifier,
 }
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_fwnode_subdev);
 
+int
+v4l2_async_notifier_add_fwnode_remote_subdev(struct v4l2_async_notifier *notif,
+					     struct fwnode_handle *endpoint,
+					     struct v4l2_async_subdev *asd)
+{
+	struct fwnode_handle *remote_ep;
+	int ret;
+
+	remote_ep = fwnode_graph_get_remote_endpoint(endpoint);
+	if (!remote_ep)
+		return -ENOTCONN;
+
+	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+	asd->match.fwnode = remote_ep;
+
+	ret = v4l2_async_notifier_add_subdev(notif, asd);
+	if (ret)
+		fwnode_handle_put(remote_ep);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_fwnode_remote_subdev);
+
 struct v4l2_async_subdev *
 v4l2_async_notifier_add_i2c_subdev(struct v4l2_async_notifier *notifier,
 				   int adapter_id, unsigned short address,
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 1497bda66c3b..215e73eddfc3 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -184,6 +184,30 @@ v4l2_async_notifier_add_fwnode_subdev(struct v4l2_async_notifier *notifier,
 				      unsigned int asd_struct_size);
 
 /**
+ * v4l2_async_notifier_add_fwnode_remote_subdev - Allocate and add a fwnode
+ *						  remote async subdev to the
+ *						  notifier's master asd_list.
+ *
+ * @notifier: pointer to &struct v4l2_async_notifier
+ * @endpoint: local endpoint the remote sub-device to be matched
+ * @asd_struct_size: size of the driver's async sub-device struct, including
+ *		     sizeof(struct v4l2_async_subdev). The &struct
+ *		     v4l2_async_subdev shall be the first member of
+ *		     the driver's async sub-device struct, i.e. both
+ *		     begin at the same memory address.
+ *
+ * Allocate a fwnode-matched asd of size asd_struct_size, and add it
+ * to the notifiers @asd_list.
+ *
+ * This is just like @v4l2_async_notifier_add_fwnode_subdev, but with the
+ * exception that the fwnode refers to a local endpoint, not the remote one.
+ */
+int
+v4l2_async_notifier_add_fwnode_remote_subdev(struct v4l2_async_notifier *notif,
+					     struct fwnode_handle *endpoint,
+					     struct v4l2_async_subdev *asd);
+
+/**
  * v4l2_async_notifier_add_i2c_subdev - Allocate and add an i2c async
  *				subdev to the notifier's master asd_list.
  *
-- 
2.11.0

