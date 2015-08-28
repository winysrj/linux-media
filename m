Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:43934 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbbH1Ltj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 07:49:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, ricardo.ribalda@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 7/8] saa7164: fix input and tuner compliance problems
Date: Fri, 28 Aug 2015 13:48:32 +0200
Message-Id: <1440762513-30457-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
References: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- the frequency range was never set
- there was no initial frequency
- missing index/tuner checks
- inconsistent standard reporting
- removed unnecessary tuner type checks (the core handles that)
- clamp frequency to the valid frequency range as per the V4L2 spec

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 24 +++++++++++++++---------
 drivers/media/pci/saa7164/saa7164.h         |  6 +++++-
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 10f4d77..ca936e2 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -246,11 +246,12 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 static int vidioc_enum_input(struct file *file, void *priv,
 	struct v4l2_input *i)
 {
+	static const char * const inputs[] = {
+		"tuner", "composite", "svideo", "aux",
+		"composite 2", "svideo 2", "aux 2"
+	};
 	int n;
 
-	char *inputs[] = { "tuner", "composite", "svideo", "aux",
-		"composite 2", "svideo 2", "aux 2" };
-
 	if (i->index >= 7)
 		return -EINVAL;
 
@@ -313,8 +314,9 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 
 	strcpy(t->name, "tuner");
-	t->type = V4L2_TUNER_ANALOG_TV;
 	t->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO;
+	t->rangelow = SAA7164_TV_MIN_FREQ;
+	t->rangehigh = SAA7164_TV_MAX_FREQ;
 
 	dprintk(DBGLVL_ENC, "VIDIOC_G_TUNER: tuner type %d\n", t->type);
 
@@ -324,6 +326,9 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 static int vidioc_s_tuner(struct file *file, void *priv,
 	const struct v4l2_tuner *t)
 {
+	if (0 != t->index)
+		return -EINVAL;
+
 	/* Update the A/V core */
 	return 0;
 }
@@ -334,7 +339,9 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct saa7164_encoder_fh *fh = file->private_data;
 	struct saa7164_port *port = fh->port;
 
-	f->type = V4L2_TUNER_ANALOG_TV;
+	if (f->tuner)
+		return -EINVAL;
+
 	f->frequency = port->freq;
 
 	return 0;
@@ -364,10 +371,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	if (f->tuner != 0)
 		return -EINVAL;
 
-	if (f->type != V4L2_TUNER_ANALOG_TV)
-		return -EINVAL;
-
-	port->freq = f->frequency;
+	port->freq = clamp(f->frequency,
+			   SAA7164_TV_MIN_FREQ, SAA7164_TV_MAX_FREQ);
 
 	/* Update the hardware */
 	if (port->nr == SAA7164_PORT_ENC1)
@@ -1012,6 +1017,7 @@ int saa7164_encoder_register(struct saa7164_port *port)
 	port->video_format = EU_VIDEO_FORMAT_MPEG_2;
 	port->audio_format = 0;
 	port->video_resolution = 0;
+	port->freq = SAA7164_TV_MIN_FREQ;
 
 	v4l2_ctrl_handler_init(hdl, 14);
 	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index a2e9fa7..9e3256c 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -117,7 +117,11 @@
 #define DBGLVL_CPU 8192
 
 #define SAA7164_NORMS \
-	(V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP |  V4L2_STD_NTSC_443)
+	(V4L2_STD_NTSC_M | V4L2_STD_NTSC_M_JP)
+
+/* TV frequency range copied from tuner-core.c */
+#define SAA7164_TV_MIN_FREQ (44U * 16U)
+#define SAA7164_TV_MAX_FREQ (958U * 16U)
 
 enum port_t {
 	SAA7164_MPEG_UNDEFINED = 0,
-- 
2.1.4

