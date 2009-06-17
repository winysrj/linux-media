Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57389 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757780AbZFQJRe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 05:17:34 -0400
Date: Wed, 17 Jun 2009 11:17:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l: add cropping prototypes to struct v4l2_subdev_video_ops
Message-ID: <Pine.LNX.4.64.0906171116540.4218@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add g_crop, s_crop and cropcap methods to video v4l2-subdev operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Hans, is this all that's needed?

 include/media/v4l2-subdev.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1785608..673a4e1 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -215,6 +215,9 @@ struct v4l2_subdev_video_ops {
 	int (*g_fmt)(struct v4l2_subdev *sd, struct v4l2_format *fmt);
 	int (*try_fmt)(struct v4l2_subdev *sd, struct v4l2_format *fmt);
 	int (*s_fmt)(struct v4l2_subdev *sd, struct v4l2_format *fmt);
+	int (*cropcap)(struct v4l2_subdev *sd, struct v4l2_cropcap *cc);
+	int (*g_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
+	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
-- 
1.6.2.4

