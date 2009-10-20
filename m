Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43811 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbZJTIOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:46 -0400
Message-Id: <20091020011215.061080010@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:14 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 04/14] v4l-subdev: Add pads operations
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=v4l-subdev-add-pad-ops.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a v4l2_subdev_pad_ops structure for the operations that need to be
performed at the pad level such as format-related operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/include/media/v4l2-subdev.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/media/v4l2-subdev.h
+++ v4l-dvb-mc/linux/include/media/v4l2-subdev.h
@@ -232,11 +232,21 @@ struct v4l2_subdev_video_ops {
 	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
 };
 
+struct v4l2_subdev_pad_ops {
+	int (*enum_fmt)(struct v4l2_subdev *sd, unsigned int pad, struct v4l2_fmtdesc *fmtdesc);
+	int (*enum_framesizes)(struct v4l2_subdev *sd, unsigned int pad, struct v4l2_frmsizeenum *fsize);
+	int (*enum_frameintervals)(struct v4l2_subdev *sd, unsigned int pad, struct v4l2_frmivalenum *fival);
+	int (*get_fmt)(struct v4l2_subdev *sd, unsigned int pad, struct v4l2_format *fmt);
+	int (*try_fmt)(struct v4l2_subdev *sd, unsigned int pad, struct v4l2_format *fmt);
+	int (*set_fmt)(struct v4l2_subdev *sd, unsigned int pad, struct v4l2_format *fmt);
+};
+
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops  *core;
 	const struct v4l2_subdev_tuner_ops *tuner;
 	const struct v4l2_subdev_audio_ops *audio;
 	const struct v4l2_subdev_video_ops *video;
+	const struct v4l2_subdev_pad_ops *pad;
 };
 
 #define V4L2_SUBDEV_NAME_SIZE 32


