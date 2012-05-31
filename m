Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1503 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2EaJWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 05:22:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/3] v4l2-subdev: hook up the new ioctls in v4l2-subdev.
Date: Thu, 31 May 2012 11:22:44 +0200
Message-Id: <63576281f33b0fce8b59823cb0e21b9329f3a26f.1338455197.git.hans.verkuil@cisco.com>
In-Reply-To: <1338456164-25080-1-git-send-email-hverkuil@xs4all.nl>
References: <1338456164-25080-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <87c4b987f7b13776196612029786df388f43ad0a.1338455197.git.hans.verkuil@cisco.com>
References: <87c4b987f7b13776196612029786df388f43ad0a.1338455197.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-subdev.c |    6 ++++++
 include/media/v4l2-subdev.h       |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index db6e859..3d46cd6 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -348,6 +348,12 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return v4l2_subdev_call(
 			sd, pad, set_selection, subdev_fh, sel);
 	}
+
+	case VIDIOC_SUBDEV_G_EDID:
+		return v4l2_subdev_call(sd, pad, get_edid, arg);
+
+	case VIDIOC_SUBDEV_S_EDID:
+		return v4l2_subdev_call(sd, pad, set_edid, arg);
 #endif
 	default:
 		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index c35a354..74c578f 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -476,6 +476,8 @@ struct v4l2_subdev_pad_ops {
 			     struct v4l2_subdev_selection *sel);
 	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			     struct v4l2_subdev_selection *sel);
+	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
+	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
 #ifdef CONFIG_MEDIA_CONTROLLER
 	int (*link_validate)(struct v4l2_subdev *sd, struct media_link *link,
 			     struct v4l2_subdev_format *source_fmt,
-- 
1.7.10

