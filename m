Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34896 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbbDUM7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 08:59:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 01/15] videodev2.h: add max_reqs to struct v4l2_query_ext_ctrl
Date: Tue, 21 Apr 2015 14:58:44 +0200
Message-Id: <1429621138-17213-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

struct v4l2_query_ext_ctrl is extended with a new 'max_reqs' field to store
the maximum number of outstanding requests that contain this control.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 5 +++--
 include/uapi/linux/videodev2.h       | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa407cb..119121f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -535,12 +535,13 @@ static void v4l_print_query_ext_ctrl(const void *arg, bool write_only)
 
 	pr_cont("id=0x%x, type=%d, name=%.*s, min/max=%lld/%lld, "
 		"step=%lld, default=%lld, flags=0x%08x, elem_size=%u, elems=%u, "
-		"nr_of_dims=%u, dims=%u,%u,%u,%u\n",
+		"nr_of_dims=%u, dims=%u,%u,%u,%u, max_reqs=%u, request=%u\n",
 			p->id, p->type, (int)sizeof(p->name), p->name,
 			p->minimum, p->maximum,
 			p->step, p->default_value, p->flags,
 			p->elem_size, p->elems, p->nr_of_dims,
-			p->dims[0], p->dims[1], p->dims[2], p->dims[3]);
+			p->dims[0], p->dims[1], p->dims[2], p->dims[3],
+			p->max_reqs, p->request);
 }
 
 static void v4l_print_querymenu(const void *arg, bool write_only)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fa376f7..2269152 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1439,7 +1439,9 @@ struct v4l2_query_ext_ctrl {
 	__u32                elems;
 	__u32                nr_of_dims;
 	__u32                dims[V4L2_CTRL_MAX_DIMS];
-	__u32		     reserved[32];
+	__u32                max_reqs;
+	__u32                request;
+	__u32		     reserved[30];
 };
 
 /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
-- 
2.1.4

