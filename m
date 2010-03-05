Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway06.websitewelcome.com ([69.56.195.6]:34888 "HELO
	gateway06.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755054Ab0CERfw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 12:35:52 -0500
Date: Fri, 5 Mar 2010 09:29:09 -0800 (PST)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv: cleanup of V4L2 controls
To: linux-media@vger.kernel.org
Message-ID: <tkrat.b0336c7b264c9ae7@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1267809968 28800
# Node ID bdfee5ee52c800a24e1231cd52eeeb91636c013c
# Parent  ff343fa70b4def92d35f9ef7ee56a953b012d169
s2255drv cleanup of V4L2 video controls

From: Dean Anderson <dean@sensoray.com>

s2255drv cleanup of V4L2 video controls

Priority: normal

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r ff343fa70b4d -r bdfee5ee52c8 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Thu Mar 04 15:43:28 2010 -0800
+++ b/linux/drivers/media/video/s2255drv.c	Fri Mar 05 09:26:08 2010 -0800
@@ -310,7 +310,7 @@
 /* Need DSP version 5+ for video status feature */
 #define S2255_MIN_DSP_STATUS    5
 #define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	16
+#define S2255_MINOR_VERSION	17
 #define S2255_RELEASE		0
 #define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
 					       S2255_MINOR_VERSION, \
@@ -384,49 +384,6 @@
 
 #define BUFFER_TIMEOUT msecs_to_jiffies(400)
 
-/* supported controls */
-static struct v4l2_queryctrl s2255_qctrl[] = {
-	{
-	.id = V4L2_CID_BRIGHTNESS,
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.name = "Brightness",
-	.minimum = -127,
-	.maximum = 128,
-	.step = 1,
-	.default_value = 0,
-	.flags = 0,
-	}, {
-	.id = V4L2_CID_CONTRAST,
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.name = "Contrast",
-	.minimum = 0,
-	.maximum = 255,
-	.step = 0x1,
-	.default_value = DEF_CONTRAST,
-	.flags = 0,
-	}, {
-	.id = V4L2_CID_SATURATION,
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.name = "Saturation",
-	.minimum = 0,
-	.maximum = 255,
-	.step = 0x1,
-	.default_value = DEF_SATURATION,
-	.flags = 0,
-	}, {
-	.id = V4L2_CID_HUE,
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.name = "Hue",
-	.minimum = 0,
-	.maximum = 255,
-	.step = 0x1,
-	.default_value = DEF_HUE,
-	.flags = 0,
-	}
-};
-
-static int qctl_regs[ARRAY_SIZE(s2255_qctrl)];
-
 /* image formats.  */
 static const struct s2255_fmt formats[] = {
 	{
@@ -1472,74 +1429,82 @@
 static int vidioc_queryctrl(struct file *file, void *priv,
 			    struct v4l2_queryctrl *qc)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(s2255_qctrl); i++)
-		if (qc->id && qc->id == s2255_qctrl[i].id) {
-			memcpy(qc, &(s2255_qctrl[i]), sizeof(*qc));
-			return 0;
-		}
-
-	dprintk(4, "query_ctrl -EINVAL %d\n", qc->id);
-	return -EINVAL;
+	switch (qc->id) {
+	case V4L2_CID_BRIGHTNESS:
+		v4l2_ctrl_query_fill(qc, -127, 127, 1, DEF_BRIGHT);
+		break;
+	case V4L2_CID_CONTRAST:
+		v4l2_ctrl_query_fill(qc, 0, 255, 1, DEF_CONTRAST);
+		break;
+	case V4L2_CID_SATURATION:
+		v4l2_ctrl_query_fill(qc, 0, 255, 1, DEF_SATURATION);
+		break;
+	case V4L2_CID_HUE:
+		v4l2_ctrl_query_fill(qc, 0, 255, 1, DEF_HUE);
+		break;
+	default:
+		return -EINVAL;
+	}
+	dprintk(4, "%s, id %d\n", __func__, qc->id);
+	return 0;
 }
 
 static int vidioc_g_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctrl)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(s2255_qctrl); i++)
-		if (ctrl->id == s2255_qctrl[i].id) {
-			ctrl->value = qctl_regs[i];
-			return 0;
-		}
-	dprintk(4, "g_ctrl -EINVAL\n");
-
-	return -EINVAL;
+	struct s2255_fh *fh = priv;
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		ctrl->value = fh->mode.bright;
+		break;
+	case V4L2_CID_CONTRAST:
+		ctrl->value = fh->mode.contrast;
+		break;
+	case V4L2_CID_SATURATION:
+		ctrl->value = fh->mode.saturation;
+		break;
+	case V4L2_CID_HUE:
+		ctrl->value = fh->mode.hue;
+		break;
+	default:
+		return -EINVAL;
+	}
+	dprintk(4, "%s, id %d val %d\n", __func__, ctrl->id, ctrl->value);
+	return 0;
 }
 
 static int vidioc_s_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctrl)
 {
-	int i;
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
 	struct s2255_mode *mode;
 	mode = &fh->mode;
-	dprintk(4, "vidioc_s_ctrl\n");
-	for (i = 0; i < ARRAY_SIZE(s2255_qctrl); i++) {
-		if (ctrl->id == s2255_qctrl[i].id) {
-			if (ctrl->value < s2255_qctrl[i].minimum ||
-			    ctrl->value > s2255_qctrl[i].maximum)
-				return -ERANGE;
-
-			qctl_regs[i] = ctrl->value;
-			/* update the mode to the corresponding value */
-			switch (ctrl->id) {
-			case V4L2_CID_BRIGHTNESS:
-				mode->bright = ctrl->value;
-				break;
-			case V4L2_CID_CONTRAST:
-				mode->contrast = ctrl->value;
-				break;
-			case V4L2_CID_HUE:
-				mode->hue = ctrl->value;
-				break;
-			case V4L2_CID_SATURATION:
-				mode->saturation = ctrl->value;
-				break;
-			}
-			mode->restart = 0;
-			/* set mode here.  Note: stream does not need restarted.
-			   some V4L programs restart stream unnecessarily
-			   after a s_crtl.
-			 */
-			s2255_set_mode(dev, fh->channel, mode);
-			return 0;
-		}
+	dprintk(4, "%s\n", __func__);
+	/* update the mode to the corresponding value */
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		mode->bright = ctrl->value;
+		break;
+	case V4L2_CID_CONTRAST:
+		mode->contrast = ctrl->value;
+		break;
+	case V4L2_CID_HUE:
+		mode->hue = ctrl->value;
+		break;
+	case V4L2_CID_SATURATION:
+		mode->saturation = ctrl->value;
+		break;
+	default:
+		return -EINVAL;
 	}
-	return -EINVAL;
+	mode->restart = 0;
+	/* set mode here.  Note: stream does not need restarted.
+	   some V4L programs restart stream unnecessarily
+	   after a s_crtl.
+	*/
+	s2255_set_mode(dev, fh->channel, mode);
+	return 0;
 }
 
 static int vidioc_g_jpegcomp(struct file *file, void *priv,
@@ -1701,18 +1666,11 @@
 	fh->width = LINE_SZ_4CIFS_NTSC;
 	fh->height = NUM_LINES_4CIFS_NTSC * 2;
 	fh->channel = cur_channel;
-
 	/* configure channel to default state */
 	if (!dev->chn_configured[cur_channel]) {
 		s2255_set_mode(dev, cur_channel, &fh->mode);
 		dev->chn_configured[cur_channel] = 1;
 	}
-
-
-	/* Put all controls at a sane state */
-	for (i = 0; i < ARRAY_SIZE(s2255_qctrl); i++)
-		qctl_regs[i] = s2255_qctrl[i].default_value;
-
 	dprintk(1, "s2255drv: open dev=%s type=%s users=%d\n",
 		video_device_node_name(vdev), v4l2_type_names[type],
 		dev->users[cur_channel]);

