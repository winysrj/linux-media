Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:36612 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750980AbeEMJrq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 05:47:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/4] gspca: fix g/s_parm handling
Date: Sun, 13 May 2018 11:47:39 +0200
Message-Id: <20180513094741.25096-3-hverkuil@xs4all.nl>
In-Reply-To: <20180513094741.25096-1-hverkuil@xs4all.nl>
References: <20180513094741.25096-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix v4l2-compliance error: s_parm never set V4L2_CAP_TIMEPERFRAME.
Also various g/s_parm-related cleanups.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/gspca/gspca.c | 29 ++++++++++++++++-------------
 drivers/media/usb/gspca/ov534.c |  1 -
 drivers/media/usb/gspca/topro.c |  1 -
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 96f409676ba3..a383058b0cb3 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1254,14 +1254,15 @@ static int vidioc_g_parm(struct file *filp, void *priv,
 {
 	struct gspca_dev *gspca_dev = video_drvdata(filp);
 
-	parm->parm.capture.readbuffers = 2;
+	parm->parm.capture.readbuffers = gspca_dev->queue.min_buffers_needed;
 
-	if (gspca_dev->sd_desc->get_streamparm) {
-		gspca_dev->usb_err = 0;
-		gspca_dev->sd_desc->get_streamparm(gspca_dev, parm);
-		return gspca_dev->usb_err;
-	}
-	return 0;
+	if (!gspca_dev->sd_desc->get_streamparm)
+		return 0;
+
+	parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
+	gspca_dev->usb_err = 0;
+	gspca_dev->sd_desc->get_streamparm(gspca_dev, parm);
+	return gspca_dev->usb_err;
 }
 
 static int vidioc_s_parm(struct file *filp, void *priv,
@@ -1269,15 +1270,17 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 {
 	struct gspca_dev *gspca_dev = video_drvdata(filp);
 
-	parm->parm.capture.readbuffers = 2;
+	parm->parm.capture.readbuffers = gspca_dev->queue.min_buffers_needed;
 
-	if (gspca_dev->sd_desc->set_streamparm) {
-		gspca_dev->usb_err = 0;
-		gspca_dev->sd_desc->set_streamparm(gspca_dev, parm);
-		return gspca_dev->usb_err;
+	if (!gspca_dev->sd_desc->set_streamparm) {
+		parm->parm.capture.capability = 0;
+		return 0;
 	}
 
-	return 0;
+	parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
+	gspca_dev->usb_err = 0;
+	gspca_dev->sd_desc->set_streamparm(gspca_dev, parm);
+	return gspca_dev->usb_err;
 }
 
 static int gspca_queue_setup(struct vb2_queue *vq,
diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index f293921a1f2b..d06dc0755b9a 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -1476,7 +1476,6 @@ static void sd_get_streamparm(struct gspca_dev *gspca_dev,
 	struct v4l2_fract *tpf = &cp->timeperframe;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	cp->capability |= V4L2_CAP_TIMEPERFRAME;
 	tpf->numerator = 1;
 	tpf->denominator = sd->frame_rate;
 }
diff --git a/drivers/media/usb/gspca/topro.c b/drivers/media/usb/gspca/topro.c
index 82e2be14cad8..6f3ec0366a2f 100644
--- a/drivers/media/usb/gspca/topro.c
+++ b/drivers/media/usb/gspca/topro.c
@@ -4780,7 +4780,6 @@ static void sd_get_streamparm(struct gspca_dev *gspca_dev,
 	struct v4l2_fract *tpf = &cp->timeperframe;
 	int fr, i;
 
-	cp->capability |= V4L2_CAP_TIMEPERFRAME;
 	tpf->numerator = 1;
 	i = get_fr_idx(gspca_dev);
 	if (i & 0x80) {
-- 
2.17.0
