Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:33322 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753538Ab0HESD2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Aug 2010 14:03:28 -0400
Date: Thu, 5 Aug 2010 20:03:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH/RFC] V4L2: add a generic function to find the nearest discrete
 format
Message-ID: <Pine.LNX.4.64.1008051959330.26127@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many video drivers implement a discrete set of frame formats and thus face 
a task of finding the best match for a user-requested format. Implementing 
this in a generic function has also an advantage, that different drivers 
with similar supported format sets will select the same format for the 
user, which improves consistency across drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

I'm currently away from my hardware, so, this is only compile tested and 
run-time tested with a test application. In any case, reviews and 
suggestions welcome.

 drivers/media/video/v4l2-common.c |   26 ++++++++++++++++++++++++++
 include/linux/videodev2.h         |   10 ++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 4e53b0b..90727e6 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -1144,3 +1144,29 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
+
+struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct v4l2_discrete_probe *probe,
+						       s32 width, s32 height)
+{
+	int i;
+	u32 error, min_error = ~0;
+	struct v4l2_frmsize_discrete *size, *best = NULL;
+
+	if (!probe)
+		return best;
+
+	for (i = 0, size = probe->sizes; i < probe->num_sizes; i++, size++) {
+		if (probe->probe && !probe->probe(probe))
+			continue;
+		error = abs(size->width - width) + abs(size->height - height);
+		if (error < min_error) {
+			min_error = error;
+			best = size;
+		}
+		if (!error)
+			break;
+	}
+
+	return best;
+}
+EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 047f7e6..f622bba 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -394,6 +394,16 @@ struct v4l2_frmsize_discrete {
 	__u32			height;		/* Frame height [pixel] */
 };
 
+struct v4l2_discrete_probe {
+	struct v4l2_frmsize_discrete	*sizes;
+	int				num_sizes;
+	void				*priv;
+	bool				(*probe)(struct v4l2_discrete_probe *);
+};
+
+struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct v4l2_discrete_probe *probe,
+						       s32 width, s32 height);
+
 struct v4l2_frmsize_stepwise {
 	__u32			min_width;	/* Minimum frame width [pixel] */
 	__u32			max_width;	/* Maximum frame width [pixel] */
-- 
1.5.6

