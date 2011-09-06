Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:62817 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab1IFLII (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 07:08:08 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [RFC/PATCH 1/1] v4l: Ignore ctrl_class
Date: Tue,  6 Sep 2011 14:08:02 +0300
Message-Id: <1315307282-22731-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20110906110742.GE1393@valkosipuli.localdomain>
References: <20110906110742.GE1393@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Back in the old days there was probably a reason to require that controls
that are being used to access using VIDIOC_{TRY,G,S}_EXT_CTRLS belonged to
the same class. These days such reason does not exist, or at least cannot be
remembered, and concrete examples of the opposite can be seen: a single
(sub)device may well offer controls that belong to different classes and
there is no reason to deny changing them atomically.

Remove all checks of ctrl_class in existing drivers and the control
framework.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   41 +++++-------
 drivers/media/radio/si4713-i2c.c                   |    6 --
 drivers/media/video/cx231xx/cx231xx-417.c          |    6 --
 drivers/media/video/cx23885/cx23885-417.c          |    8 --
 drivers/media/video/cx88/cx88-blackbird.c          |    7 --
 drivers/media/video/hdpvr/hdpvr-video.c            |   70 ++++++++------------
 drivers/media/video/saa7134/saa6752hs.c            |    6 --
 drivers/media/video/saa7134/saa7134-empress.c      |    5 --
 drivers/media/video/saa7164/saa7164-encoder.c      |   70 ++++++++------------
 drivers/media/video/saa7164/saa7164-vbi.c          |   70 ++++++++------------
 drivers/media/video/tlg2300/pd-radio.c             |    6 --
 drivers/media/video/v4l2-ctrls.c                   |   18 ++----
 drivers/media/video/v4l2-ioctl.c                   |   12 ++--
 13 files changed, 111 insertions(+), 214 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index 5122ce8..d22a26e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -55,9 +55,7 @@ VIDIOC_TRY_EXT_CTRLS</para>
     <title>Description</title>
 
     <para>These ioctls allow the caller to get or set multiple
-controls atomically. Control IDs are grouped into control classes (see
-<xref linkend="ctrl-class" />) and all controls in the control array
-must belong to the same control class.</para>
+controls atomically.</para>
 
     <para>Applications must always fill in the
 <structfield>count</structfield>,
@@ -69,10 +67,10 @@ initialize the &v4l2-ext-control; array pointed to by the
 
     <para>To get the current value of a set of controls applications
 initialize the <structfield>id</structfield>,
-<structfield>size</structfield> and <structfield>reserved2</structfield> fields
-of each &v4l2-ext-control; and call the
-<constant>VIDIOC_G_EXT_CTRLS</constant> ioctl. String controls controls
-must also set the <structfield>string</structfield> field.</para>
+<structfield>size</structfield>, <structfield>ctrl_class</structfield> and
+<structfield>reserved2</structfield> fields of each &v4l2-ext-control; and
+call the <constant>VIDIOC_G_EXT_CTRLS</constant> ioctl. String controls
+controls must also set the <structfield>string</structfield> field.</para>
 
     <para>If the <structfield>size</structfield> is too small to
 receive the control result (only relevant for pointer-type controls
@@ -87,7 +85,7 @@ value. It is guaranteed that that is sufficient memory.
 
     <para>To change the value of a set of controls applications
 initialize the <structfield>id</structfield>, <structfield>size</structfield>,
-<structfield>reserved2</structfield> and
+<structfield>ctrl_class</structfield>, <structfield>reserved2</structfield> and
 <structfield>value/string</structfield> fields of each &v4l2-ext-control; and
 call the <constant>VIDIOC_S_EXT_CTRLS</constant> ioctl. The controls
 will only be set if <emphasis>all</emphasis> control values are
@@ -95,19 +93,12 @@ valid.</para>
 
     <para>To check if a set of controls have correct values applications
 initialize the <structfield>id</structfield>, <structfield>size</structfield>,
-<structfield>reserved2</structfield> and
+<structfield>ctrl_class</structfield>, <structfield>reserved2</structfield> and
 <structfield>value/string</structfield> fields of each &v4l2-ext-control; and
 call the <constant>VIDIOC_TRY_EXT_CTRLS</constant> ioctl. It is up to
 the driver whether wrong values are automatically adjusted to a valid
 value or if an error is returned.</para>
 
-    <para>When the <structfield>id</structfield> or
-<structfield>ctrl_class</structfield> is invalid drivers return an
-&EINVAL;. When the value is out of bounds drivers can choose to take
-the closest valid value or return an &ERANGE;, whatever seems more
-appropriate. In the first case the new value is set in
-&v4l2-ext-control;.</para>
-
     <para>The driver will only set/get these controls if all control
 values are correct. This prevents the situation where only some of the
 controls were set/get. Only low-level errors (&eg; a failed i2c
@@ -182,8 +173,11 @@ applications must set the array to zero.</entry>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>ctrl_class</structfield></entry>
-	    <entry>The control class to which all controls belong, see
-<xref linkend="ctrl-class" />.</entry>
+	    <entry>
+	      <structfield>ctrl_class</structfield> must be set to zero by
+	      the applications.
+	    </entry>
+
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -270,12 +264,11 @@ These controls are described in <xref
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The &v4l2-ext-control; <structfield>id</structfield>
-is invalid or the &v4l2-ext-controls;
-<structfield>ctrl_class</structfield> is invalid. This error code is
-also returned by the <constant>VIDIOC_S_EXT_CTRLS</constant> and
-<constant>VIDIOC_TRY_EXT_CTRLS</constant> ioctls if two or more
-control values are in conflict.</para>
+	  <para>The &v4l2-ext-control; <structfield>id</structfield> is
+invalid. This error code is also returned by the
+<constant>VIDIOC_S_EXT_CTRLS</constant> and
+<constant>VIDIOC_TRY_EXT_CTRLS</constant> ioctls if two or more control
+values are in conflict.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index c9f4a8e..b6417bb 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1531,9 +1531,6 @@ static int si4713_s_ext_ctrls(struct v4l2_subdev *sd,
 	struct si4713_device *sdev = to_si4713_device(sd);
 	int i;
 
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
-		return -EINVAL;
-
 	for (i = 0; i < ctrls->count; i++) {
 		int err;
 
@@ -1569,9 +1566,6 @@ static int si4713_g_ext_ctrls(struct v4l2_subdev *sd,
 	struct si4713_device *sdev = to_si4713_device(sd);
 	int i;
 
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
-		return -EINVAL;
-
 	for (i = 0; i < ctrls->count; i++) {
 		int err;
 
diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
index f8f0e59..21fceb4 100644
--- a/drivers/media/video/cx231xx/cx231xx-417.c
+++ b/drivers/media/video/cx231xx/cx231xx-417.c
@@ -1825,8 +1825,6 @@ static int vidioc_g_ext_ctrls(struct file *file, void *priv,
 	struct cx231xx_fh  *fh  = priv;
 	struct cx231xx *dev = fh->dev;
 	dprintk(3, "enter vidioc_g_ext_ctrls()\n");
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
 	dprintk(3, "exit vidioc_g_ext_ctrls()\n");
 	return cx2341x_ext_ctrls(&dev->mpeg_params, 0, f, VIDIOC_G_EXT_CTRLS);
 }
@@ -1839,8 +1837,6 @@ static int vidioc_s_ext_ctrls(struct file *file, void *priv,
 	struct cx2341x_mpeg_params p;
 	int err;
 	dprintk(3, "enter vidioc_s_ext_ctrls()\n");
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
 
 	p = dev->mpeg_params;
 	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_TRY_EXT_CTRLS);
@@ -1864,8 +1860,6 @@ static int vidioc_try_ext_ctrls(struct file *file, void *priv,
 	struct cx2341x_mpeg_params p;
 	int err;
 	dprintk(3, "enter vidioc_try_ext_ctrls()\n");
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
 
 	p = dev->mpeg_params;
 	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_TRY_EXT_CTRLS);
diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index 67c4a59..c95bc00 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1486,8 +1486,6 @@ static int vidioc_g_ext_ctrls(struct file *file, void *priv,
 	struct cx23885_fh  *fh  = priv;
 	struct cx23885_dev *dev = fh->dev;
 
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
 	return cx2341x_ext_ctrls(&dev->mpeg_params, 0, f, VIDIOC_G_EXT_CTRLS);
 }
 
@@ -1499,9 +1497,6 @@ static int vidioc_s_ext_ctrls(struct file *file, void *priv,
 	struct cx2341x_mpeg_params p;
 	int err;
 
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
 	p = dev->mpeg_params;
 	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_S_EXT_CTRLS);
 
@@ -1521,9 +1516,6 @@ static int vidioc_try_ext_ctrls(struct file *file, void *priv,
 	struct cx2341x_mpeg_params p;
 	int err;
 
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
 	p = dev->mpeg_params;
 	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_TRY_EXT_CTRLS);
 	return err;
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index e46446a..7e66d5e 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -848,8 +848,6 @@ static int vidioc_g_ext_ctrls (struct file *file, void *priv,
 {
 	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
 
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
 	return cx2341x_ext_ctrls(&dev->params, 0, f, VIDIOC_G_EXT_CTRLS);
 }
 
@@ -860,9 +858,6 @@ static int vidioc_s_ext_ctrls (struct file *file, void *priv,
 	struct cx2341x_mpeg_params p;
 	int err;
 
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
 	if (dev->mpeg_active)
 		blackbird_stop_codec(dev);
 
@@ -882,8 +877,6 @@ static int vidioc_try_ext_ctrls (struct file *file, void *priv,
 	struct cx2341x_mpeg_params p;
 	int err;
 
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
 	p = dev->params;
 	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_TRY_EXT_CTRLS);
 
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 087f7c0..73d3ea9 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -912,21 +912,16 @@ static int vidioc_g_ext_ctrls(struct file *file, void *priv,
 	struct hdpvr_device *dev = fh->dev;
 	int i, err = 0;
 
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
-			err = hdpvr_get_ctrl(&dev->options, ctrl);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
+		err = hdpvr_get_ctrl(&dev->options, ctrl);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
 		}
-		return err;
-
 	}
-
-	return -EINVAL;
+	return err;
 }
 
 
@@ -984,21 +979,17 @@ static int vidioc_try_ext_ctrls(struct file *file, void *priv,
 	struct hdpvr_device *dev = fh->dev;
 	int i, err = 0;
 
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
-			err = hdpvr_try_ctrl(ctrl,
-					     dev->flags & HDPVR_FLAG_AC3_CAP);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
+		err = hdpvr_try_ctrl(ctrl,
+				     dev->flags & HDPVR_FLAG_AC3_CAP);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
 		}
-		return err;
 	}
-
-	return -EINVAL;
+	return err;
 }
 
 
@@ -1082,27 +1073,22 @@ static int vidioc_s_ext_ctrls(struct file *file, void *priv,
 	struct hdpvr_device *dev = fh->dev;
 	int i, err = 0;
 
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
-			err = hdpvr_try_ctrl(ctrl,
-					     dev->flags & HDPVR_FLAG_AC3_CAP);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-			err = hdpvr_set_ctrl(dev, ctrl);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
+		err = hdpvr_try_ctrl(ctrl,
+				     dev->flags & HDPVR_FLAG_AC3_CAP);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
+		}
+		err = hdpvr_set_ctrl(dev, ctrl);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
 		}
-		return err;
-
 	}
-
-	return -EINVAL;
+	return err;
 }
 
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *private_data,
diff --git a/drivers/media/video/saa7134/saa6752hs.c b/drivers/media/video/saa7134/saa6752hs.c
index f9f29cc..37ef9c8 100644
--- a/drivers/media/video/saa7134/saa6752hs.c
+++ b/drivers/media/video/saa7134/saa6752hs.c
@@ -799,9 +799,6 @@ static int saa6752hs_do_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_contro
 	struct saa6752hs_mpeg_params params;
 	int i;
 
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
 	params = h->params;
 	for (i = 0; i < ctrls->count; i++) {
 		int err = handle_ctrl(h->has_ac3, &params, ctrls->controls + i, set);
@@ -831,9 +828,6 @@ static int saa6752hs_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_control
 	struct saa6752hs_state *h = to_state(sd);
 	int i;
 
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
 	for (i = 0; i < ctrls->count; i++) {
 		int err = get_ctrl(h->has_ac3, &h->params, ctrls->controls + i);
 
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index dde361a..c71f1ba 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -317,9 +317,6 @@ static int empress_s_ext_ctrls(struct file *file, void *priv,
 	if (ctrls->count == 0)
 		return 0;
 
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
 	err = saa_call_empress(dev, core, s_ext_ctrls, ctrls);
 	ts_init_encoder(dev);
 
@@ -331,8 +328,6 @@ static int empress_g_ext_ctrls(struct file *file, void *priv,
 {
 	struct saa7134_dev *dev = file->private_data;
 
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
 	return saa_call_empress(dev, core, g_ext_ctrls, ctrls);
 }
 
diff --git a/drivers/media/video/saa7164/saa7164-encoder.c b/drivers/media/video/saa7164/saa7164-encoder.c
index 2fd38a0..cfd71f8 100644
--- a/drivers/media/video/saa7164/saa7164-encoder.c
+++ b/drivers/media/video/saa7164/saa7164-encoder.c
@@ -528,21 +528,16 @@ static int vidioc_g_ext_ctrls(struct file *file, void *priv,
 	struct saa7164_port *port = fh->port;
 	int i, err = 0;
 
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = saa7164_get_ctrl(port, ctrl);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-		}
-		return err;
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
+		err = saa7164_get_ctrl(port, ctrl);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
+		}
 	}
-
-	return -EINVAL;
+	return err;
 }
 
 static int saa7164_try_ctrl(struct v4l2_ext_control *ctrl, int ac3)
@@ -602,20 +597,16 @@ static int vidioc_try_ext_ctrls(struct file *file, void *priv,
 {
 	int i, err = 0;
 
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
-			err = saa7164_try_ctrl(ctrl, 0);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
+		err = saa7164_try_ctrl(ctrl, 0);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
 		}
-		return err;
 	}
-
-	return -EINVAL;
+	return err;
 }
 
 static int saa7164_set_ctrl(struct saa7164_port *port,
@@ -677,26 +668,21 @@ static int vidioc_s_ext_ctrls(struct file *file, void *priv,
 	struct saa7164_port *port = fh->port;
 	int i, err = 0;
 
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
-			err = saa7164_try_ctrl(ctrl, 0);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-			err = saa7164_set_ctrl(port, ctrl);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
+		err = saa7164_try_ctrl(ctrl, 0);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
+		}
+		err = saa7164_set_ctrl(port, ctrl);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
 		}
-		return err;
-
 	}
-
-	return -EINVAL;
+	return err;
 }
 
 static int vidioc_querycap(struct file *file, void  *priv,
diff --git a/drivers/media/video/saa7164/saa7164-vbi.c b/drivers/media/video/saa7164/saa7164-vbi.c
index e2e0341..4524429 100644
--- a/drivers/media/video/saa7164/saa7164-vbi.c
+++ b/drivers/media/video/saa7164/saa7164-vbi.c
@@ -491,21 +491,16 @@ static int vidioc_g_ext_ctrls(struct file *file, void *priv,
 	struct saa7164_port *port = fh->port;
 	int i, err = 0;
 
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = saa7164_get_ctrl(port, ctrl);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-		}
-		return err;
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
+		err = saa7164_get_ctrl(port, ctrl);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
+		}
 	}
-
-	return -EINVAL;
+	return err;
 }
 
 static int saa7164_try_ctrl(struct v4l2_ext_control *ctrl, int ac3)
@@ -550,20 +545,16 @@ static int vidioc_try_ext_ctrls(struct file *file, void *priv,
 {
 	int i, err = 0;
 
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
-			err = saa7164_try_ctrl(ctrl, 0);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
+		err = saa7164_try_ctrl(ctrl, 0);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
 		}
-		return err;
 	}
-
-	return -EINVAL;
+	return err;
 }
 
 static int saa7164_set_ctrl(struct saa7164_port *port,
@@ -616,26 +607,21 @@ static int vidioc_s_ext_ctrls(struct file *file, void *priv,
 	struct saa7164_port *port = fh->port;
 	int i, err = 0;
 
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
-			err = saa7164_try_ctrl(ctrl, 0);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-			err = saa7164_set_ctrl(port, ctrl);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
+		err = saa7164_try_ctrl(ctrl, 0);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
+		}
+		err = saa7164_set_ctrl(port, ctrl);
+		if (err) {
+			ctrls->error_idx = i;
+			break;
 		}
-		return err;
-
 	}
-
-	return -EINVAL;
+	return err;
 }
 
 static int vidioc_querycap(struct file *file, void  *priv,
diff --git a/drivers/media/video/tlg2300/pd-radio.c b/drivers/media/video/tlg2300/pd-radio.c
index 4fad1df..65674b1 100644
--- a/drivers/media/video/tlg2300/pd-radio.c
+++ b/drivers/media/video/tlg2300/pd-radio.c
@@ -271,9 +271,6 @@ static int tlg_fm_vidioc_g_exts_ctrl(struct file *file, void *fh,
 	struct poseidon *p = file->private_data;
 	int i;
 
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
-		return -EINVAL;
-
 	for (i = 0; i < ctrls->count; i++) {
 		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
@@ -291,9 +288,6 @@ static int tlg_fm_vidioc_s_exts_ctrl(struct file *file, void *fh,
 {
 	int i;
 
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
-		return -EINVAL;
-
 	for (i = 0; i < ctrls->count; i++) {
 		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 06b6014..e5bde4f 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1841,9 +1841,6 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		cs->error_idx = i;
 
-		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
-			return -EINVAL;
-
 		/* Old-style private controls are not allowed for
 		   extended controls */
 		if (id >= V4L2_CID_PRIVATE_BASE)
@@ -1904,13 +1901,10 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 }
 
 /* Handles the corner case where cs->count == 0. It checks whether the
-   specified control class exists. If that class ID is 0, then it checks
-   whether there are any controls at all. */
-static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
+   there are any controls at all. */
+static int handler_check(struct v4l2_ctrl_handler *hdl)
 {
-	if (ctrl_class == 0)
-		return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
-	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
+	return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
 }
 
 
@@ -1924,13 +1918,12 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	int i, j;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
 
 	if (hdl == NULL)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return handler_check(hdl);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
@@ -2131,13 +2124,12 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	int ret;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
 
 	if (hdl == NULL)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return handler_check(hdl);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 9f80e9d..75e31f6 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -391,7 +391,6 @@ static inline void v4l_print_ext_ctrls(unsigned int cmd,
 	if (!(vfd->debug & V4L2_DEBUG_IOCTL_ARG))
 		return;
 	dbgarg(cmd, "");
-	printk(KERN_CONT "class=0x%x", c->ctrl_class);
 	for (i = 0; i < c->count; i++) {
 		if (show_vals && !c->controls[i].size)
 			printk(KERN_CONT " id/val=0x%x/0x%x",
@@ -417,11 +416,12 @@ static inline int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	   Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
 	   is it allowed for backwards compatibility.
 	 */
-	if (!allow_priv && c->ctrl_class == V4L2_CID_PRIVATE_BASE)
-		return 0;
-	/* Check that all controls are from the same control class. */
+	if (allow_priv)
+		return 1;
+	/* Check that none of the controls are private. */
 	for (i = 0; i < c->count; i++) {
-		if (V4L2_CTRL_ID2CLASS(c->controls[i].id) != c->ctrl_class) {
+		if (V4L2_CTRL_ID2CLASS(c->controls[i].id) ==
+		    V4L2_CID_PRIVATE_BASE) {
 			c->error_idx = i;
 			return 0;
 		}
@@ -1467,7 +1467,6 @@ static long __video_do_ioctl(struct file *file,
 			struct v4l2_ext_controls ctrls;
 			struct v4l2_ext_control ctrl;
 
-			ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
 			ctrls.count = 1;
 			ctrls.controls = &ctrl;
 			ctrl.id = p->id;
@@ -1512,7 +1511,6 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_s_ext_ctrls)
 			break;
 
-		ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
 		ctrls.count = 1;
 		ctrls.controls = &ctrl;
 		ctrl.id = p->id;
-- 
1.7.2.5

