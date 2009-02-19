Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37892 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751667AbZBSPUv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 10:20:51 -0500
Date: Thu, 19 Feb 2009 16:20:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: morimoto.kuninori@renesas.com
Subject: [PATCH 2/2] soc-camera: configure drivers with a default format on
 open
In-Reply-To: <Pine.LNX.4.64.0902191615000.5156@axis700.grange>
Message-ID: <Pine.LNX.4.64.0902191616340.5156@axis700.grange>
References: <Pine.LNX.4.64.0902191615000.5156@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently soc-camera doesn't set up any image format without an explicit S_FMT.
It seems this should be supported, since, for example, capture-example.c from
v4l2-apps by default doesn't issue an S_FMT. This patch configures a default
image format on open().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Morimoto-san, please, have a look how far these two patches take you, I 
lost the track of the problems a bit:-) Does capture-example work for you 
now without the "-f"?

 drivers/media/video/soc_camera.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 9939b04..4e88c7f 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -30,6 +30,10 @@
 #include <media/videobuf-core.h>
 #include <media/soc_camera.h>
 
+/* Default to VGA resolution */
+#define DEFAULT_WIDTH	640
+#define DEFAULT_HEIGHT	480
+
 static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);
@@ -297,6 +301,15 @@ static int soc_camera_open(struct file *file)
 
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
+		struct v4l2_format f = {
+			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			.fmt.pix = {
+				.width		= DEFAULT_WIDTH,
+				.height		= DEFAULT_HEIGHT,
+				.field		= V4L2_FIELD_ANY,
+			},
+		};
+
 		ret = soc_camera_init_user_formats(icd);
 		if (ret < 0)
 			goto eiufmt;
@@ -305,6 +318,18 @@ static int soc_camera_open(struct file *file)
 			dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
 			goto eiciadd;
 		}
+
+		f.fmt.pix.pixelformat	= icd->current_fmt->fourcc;
+		f.fmt.pix.colorspace	= icd->current_fmt->colorspace;
+
+		/* Try to configure with default parameters */
+		ret = ici->ops->set_fmt(icd, &f);
+		if (!ret) {
+			icd->width		= f.fmt.pix.width;
+			icd->height		= f.fmt.pix.height;
+			icf->vb_vidq.field	= f.fmt.pix.field;
+			ici->ops->set_bus_param(icd, f.fmt.pix.pixelformat);
+		}
 	}
 
 	mutex_unlock(&icd->video_lock);
@@ -444,8 +469,8 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		goto unlock;
 	}
 
-	icd->width		= f->fmt.pix.width;
-	icd->height		= f->fmt.pix.height;
+	icd->width		= pix->width;
+	icd->height		= pix->height;
 	icf->vb_vidq.field	= pix->field;
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
@@ -642,8 +667,8 @@ static int soc_camera_cropcap(struct file *file, void *fh,
 	a->bounds.height		= icd->height_max;
 	a->defrect.left			= icd->x_min;
 	a->defrect.top			= icd->y_min;
-	a->defrect.width		= 640;
-	a->defrect.height		= 480;
+	a->defrect.width		= DEFAULT_WIDTH;
+	a->defrect.height		= DEFAULT_HEIGHT;
 	a->pixelaspect.numerator	= 1;
 	a->pixelaspect.denominator	= 1;
 
-- 
1.5.4

