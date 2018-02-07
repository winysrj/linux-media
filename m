Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:45846 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753010AbeBGBsw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 20:48:52 -0500
Received: by mail-pg0-f65.google.com with SMTP id m136so1867749pga.12
        for <linux-media@vger.kernel.org>; Tue, 06 Feb 2018 17:48:52 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv3 07/17] v4l2-ctrls: prepare internal structs for request API
Date: Wed,  7 Feb 2018 10:48:11 +0900
Message-Id: <20180207014821.164536-8-acourbot@chromium.org>
In-Reply-To: <20180207014821.164536-1-acourbot@chromium.org>
References: <20180207014821.164536-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a refcount and is_request bool to struct v4l2_ctrl_handler:
this is used to refcount a handler that represents a request.

Add a p_req field to struct v4l2_ctrl_ref that will store the
request value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 1 +
 include/media/v4l2-ctrls.h           | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 2e58381444d1..1ff8fc59fff5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1761,6 +1761,7 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
 				      sizeof(hdl->buckets[0]),
 				      GFP_KERNEL | __GFP_ZERO);
 	hdl->error = hdl->buckets ? 0 : -ENOMEM;
+	hdl->is_request = false;
 	return hdl->error;
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_init_class);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index a4750a8090e3..22b6be78057f 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -18,6 +18,7 @@
 #define _V4L2_CTRLS_H
 
 #include <linux/list.h>
+#include <linux/kref.h>
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 
@@ -257,6 +258,7 @@ struct v4l2_ctrl_ref {
 	struct v4l2_ctrl_ref *next;
 	struct v4l2_ctrl *ctrl;
 	struct v4l2_ctrl_helper *helper;
+	union v4l2_ctrl_ptr p_req;
 	bool from_other_dev;
 };
 
@@ -292,7 +294,9 @@ struct v4l2_ctrl_handler {
 	v4l2_ctrl_notify_fnc notify;
 	void *notify_priv;
 	u16 nr_of_buckets;
+	bool is_request;
 	int error;
+	struct kref ref;
 };
 
 /**
-- 
2.16.0.rc1.238.g530d649a79-goog
