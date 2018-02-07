Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:41773 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753317AbeBGBtM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 20:49:12 -0500
Received: by mail-pf0-f195.google.com with SMTP id 68so1476478pfj.8
        for <linux-media@vger.kernel.org>; Tue, 06 Feb 2018 17:49:12 -0800 (PST)
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
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv3 14/17] v4l2-ctrls: support requests in EXT_CTRLS ioctls
Date: Wed,  7 Feb 2018 10:48:18 +0900
Message-Id: <20180207014821.164536-15-acourbot@chromium.org>
In-Reply-To: <20180207014821.164536-1-acourbot@chromium.org>
References: <20180207014821.164536-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Read and use the request_fd field of struct v4l2_ext_controls to apply
VIDIOC_G_EXT_CTRLS or VIDIOC_S_EXT_CTRLS to a request when asked by
userspace.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 235acdde3111..cbaefcad9694 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -30,6 +30,7 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-mc.h>
 #include <media/media-request.h>
+#include <media/v4l2-request.h>
 
 #include <trace/events/v4l2.h>
 
@@ -2158,6 +2159,24 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
+
+	if (p->request_fd > 0) {
+		struct media_request *req = NULL;
+		struct media_request_entity_data *_data;
+		struct media_request_v4l2_entity_data *data;
+		int ret;
+
+		req = check_request(p->request_fd, file, fh, &_data);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+		data = to_v4l2_entity_data(_data);
+
+		ret = v4l2_g_ext_ctrls(&data->ctrls, p);
+
+		media_request_put(req);
+		return ret;
+	}
+
 	if (vfh && vfh->ctrl_handler)
 		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
 	if (vfd->ctrl_handler)
@@ -2177,6 +2196,23 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
+	if (p->request_fd > 0) {
+		struct media_request *req = NULL;
+		struct media_request_entity_data *_data;
+		struct media_request_v4l2_entity_data *data;
+		int ret;
+
+		req = check_request(p->request_fd, file, fh, &_data);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+		data = to_v4l2_entity_data(_data);
+
+		ret = v4l2_s_ext_ctrls(vfh, &data->ctrls, p);
+
+		media_request_put(req);
+		return ret;
+	}
+
 	if (vfh && vfh->ctrl_handler)
 		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
 	if (vfd->ctrl_handler)
-- 
2.16.0.rc1.238.g530d649a79-goog
