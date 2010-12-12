Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2120 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab0LLRcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:11 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MP002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:09 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 17/19] v4l: fix handling of v4l2_input.capabilities
Date: Sun, 12 Dec 2010 18:31:59 +0100
Message-Id: <43c5f9f75ee40a1f11de09f3bb5773c9c6363072.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The v4l core sets the v4l2_input.capabilities field based on the supplied
v4l2_ioctl_ops. However, several drivers do a memset or memcpy of the v4l2_input
struct, thus overwriting that field incorrectly.

Either remove the memset (which is already done by the v4l core), or add the
proper capabilities field in case of a memcpy.

The same is also true for v4l2_output, but that only affected the ivtv driver.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/dvb/ttpci/av7110_v4l.c         |    4 ++++
 drivers/media/dvb/ttpci/budget-av.c          |    6 ++++--
 drivers/media/video/cx18/cx18-cards.c        |    1 -
 drivers/media/video/cx23885/cx23885-video.c  |    1 -
 drivers/media/video/et61x251/et61x251_core.c |    1 +
 drivers/media/video/hexium_gemini.c          |   18 +++++++++---------
 drivers/media/video/hexium_orion.c           |   18 +++++++++---------
 drivers/media/video/ivtv/ivtv-cards.c        |    2 --
 drivers/media/video/mxb.c                    |    8 ++++----
 drivers/media/video/saa7134/saa7134-video.c  |    1 -
 drivers/media/video/sn9c102/sn9c102_core.c   |    1 +
 drivers/media/video/timblogiw.c              |    1 -
 drivers/media/video/vino.c                   |    3 ---
 drivers/media/video/zoran/zoran_driver.c     |    6 ------
 drivers/staging/cx25821/cx25821-video.c      |    2 --
 15 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/dvb/ttpci/av7110_v4l.c
index ac20c5b..cdd31ca 100644
--- a/drivers/media/dvb/ttpci/av7110_v4l.c
+++ b/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -100,6 +100,7 @@ static struct v4l2_input inputs[4] = {
 		.tuner		= 0, /* ignored */
 		.std		= V4L2_STD_PAL_BG|V4L2_STD_NTSC_M,
 		.status		= 0,
+		.capabilities	= V4L2_IN_CAP_STD,
 	}, {
 		.index		= 1,
 		.name		= "Television",
@@ -108,6 +109,7 @@ static struct v4l2_input inputs[4] = {
 		.tuner		= 0,
 		.std		= V4L2_STD_PAL_BG|V4L2_STD_NTSC_M,
 		.status		= 0,
+		.capabilities	= V4L2_IN_CAP_STD,
 	}, {
 		.index		= 2,
 		.name		= "Video",
@@ -116,6 +118,7 @@ static struct v4l2_input inputs[4] = {
 		.tuner		= 0,
 		.std		= V4L2_STD_PAL_BG|V4L2_STD_NTSC_M,
 		.status		= 0,
+		.capabilities	= V4L2_IN_CAP_STD,
 	}, {
 		.index		= 3,
 		.name		= "Y/C",
@@ -124,6 +127,7 @@ static struct v4l2_input inputs[4] = {
 		.tuner		= 0,
 		.std		= V4L2_STD_PAL_BG|V4L2_STD_NTSC_M,
 		.status		= 0,
+		.capabilities	= V4L2_IN_CAP_STD,
 	}
 };
 
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index 97afc01..e957d76 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -1406,8 +1406,10 @@ static int budget_av_detach(struct saa7146_dev *dev)
 
 #define KNC1_INPUTS 2
 static struct v4l2_input knc1_inputs[KNC1_INPUTS] = {
-	{0, "Composite", V4L2_INPUT_TYPE_TUNER, 1, 0, V4L2_STD_PAL_BG | V4L2_STD_NTSC_M, 0},
-	{1, "S-Video", V4L2_INPUT_TYPE_CAMERA, 2, 0, V4L2_STD_PAL_BG | V4L2_STD_NTSC_M, 0},
+	{ 0, "Composite", V4L2_INPUT_TYPE_TUNER, 1, 0,
+		V4L2_STD_PAL_BG | V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 1, "S-Video", V4L2_INPUT_TYPE_CAMERA, 2, 0,
+		V4L2_STD_PAL_BG | V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
 };
 
 static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
diff --git a/drivers/media/video/cx18/cx18-cards.c b/drivers/media/video/cx18/cx18-cards.c
index 52ba913..8717773 100644
--- a/drivers/media/video/cx18/cx18-cards.c
+++ b/drivers/media/video/cx18/cx18-cards.c
@@ -546,7 +546,6 @@ int cx18_get_input(struct cx18 *cx, u16 index, struct v4l2_input *input)
 		"Component 1"
 	};
 
-	memset(input, 0, sizeof(*input));
 	if (index >= cx->nof_inputs)
 		return -EINVAL;
 	input->index = index;
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 8b2fb8a..fa08ea3 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1155,7 +1155,6 @@ static int cx23885_enum_input(struct cx23885_dev *dev, struct v4l2_input *i)
 	if (0 == INPUT(n)->type)
 		return -EINVAL;
 
-	memset(i, 0, sizeof(*i));
 	i->index = n;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, iname[INPUT(n)->type]);
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index a5cfc76..f5892ee 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -1610,6 +1610,7 @@ et61x251_vidioc_enuminput(struct et61x251_device* cam, void __user * arg)
 	memset(&i, 0, sizeof(i));
 	strcpy(i.name, "Camera");
 	i.type = V4L2_INPUT_TYPE_CAMERA;
+	i.capabilities = V4L2_IN_CAP_STD;
 
 	if (copy_to_user(arg, &i, sizeof(i)))
 		return -EFAULT;
diff --git a/drivers/media/video/hexium_gemini.c b/drivers/media/video/hexium_gemini.c
index 7ae9636..cdf8b19 100644
--- a/drivers/media/video/hexium_gemini.c
+++ b/drivers/media/video/hexium_gemini.c
@@ -37,15 +37,15 @@ static int hexium_num;
 
 #define HEXIUM_INPUTS	9
 static struct v4l2_input hexium_inputs[HEXIUM_INPUTS] = {
-	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
+	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
 };
 
 #define HEXIUM_AUDIOS	0
diff --git a/drivers/media/video/hexium_orion.c b/drivers/media/video/hexium_orion.c
index b72d0f0..6ad7e1c 100644
--- a/drivers/media/video/hexium_orion.c
+++ b/drivers/media/video/hexium_orion.c
@@ -38,15 +38,15 @@ static int hexium_num;
 
 #define HEXIUM_INPUTS	9
 static struct v4l2_input hexium_inputs[HEXIUM_INPUTS] = {
-	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
+	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
 };
 
 #define HEXIUM_AUDIOS	0
diff --git a/drivers/media/video/ivtv/ivtv-cards.c b/drivers/media/video/ivtv/ivtv-cards.c
index 87afbbe..b6f2a2b 100644
--- a/drivers/media/video/ivtv/ivtv-cards.c
+++ b/drivers/media/video/ivtv/ivtv-cards.c
@@ -1313,7 +1313,6 @@ int ivtv_get_input(struct ivtv *itv, u16 index, struct v4l2_input *input)
 		"Composite 3"
 	};
 
-	memset(input, 0, sizeof(*input));
 	if (index >= itv->nof_inputs)
 		return -EINVAL;
 	input->index = index;
@@ -1331,7 +1330,6 @@ int ivtv_get_output(struct ivtv *itv, u16 index, struct v4l2_output *output)
 {
 	const struct ivtv_card_output *card_output = itv->card->video_outputs + index;
 
-	memset(output, 0, sizeof(*output));
 	if (index >= itv->card->nof_outputs)
 		return -EINVAL;
 	output->index = index;
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index 4e8fd96..e8846a0 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -59,10 +59,10 @@ MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
 enum { TUNER, AUX1, AUX3, AUX3_YC };
 
 static struct v4l2_input mxb_inputs[MXB_INPUTS] = {
-	{ TUNER,	"Tuner",		V4L2_INPUT_TYPE_TUNER,	1, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ AUX1,		"AUX1",			V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ AUX3,		"AUX3 Composite",	V4L2_INPUT_TYPE_CAMERA,	4, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
-	{ AUX3_YC,	"AUX3 S-Video",		V4L2_INPUT_TYPE_CAMERA,	4, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0 },
+	{ TUNER,	"Tuner",		V4L2_INPUT_TYPE_TUNER,	1, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ AUX1,		"AUX1",			V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ AUX3,		"AUX3 Composite",	V4L2_INPUT_TYPE_CAMERA,	4, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ AUX3_YC,	"AUX3 S-Video",		V4L2_INPUT_TYPE_CAMERA,	4, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
 };
 
 /* this array holds the information, which port of the saa7146 each
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index f0b1573..25e5af4 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1748,7 +1748,6 @@ static int saa7134_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 	if (NULL == card_in(dev, i->index).name)
 		return -EINVAL;
-	memset(i, 0, sizeof(*i));
 	i->index = n;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, card_in(dev, n).name);
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index 28e19da..b5ca3b8 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -2189,6 +2189,7 @@ sn9c102_vidioc_enuminput(struct sn9c102_device* cam, void __user * arg)
 	memset(&i, 0, sizeof(i));
 	strcpy(i.name, "Camera");
 	i.type = V4L2_INPUT_TYPE_CAMERA;
+	i.capabilities = V4L2_IN_CAP_STD;
 
 	if (copy_to_user(arg, &i, sizeof(i)))
 		return -EFAULT;
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index cf48aa9..67911c0 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -369,7 +369,6 @@ static int timblogiw_enuminput(struct file *file, void  *priv,
 	if (inp->index != 0)
 		return -EINVAL;
 
-	memset(inp, 0, sizeof(*inp));
 	inp->index = 0;
 
 	strncpy(inp->name, "Timb input 1", sizeof(inp->name) - 1);
diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
index 7e7eec4..d63e9d9 100644
--- a/drivers/media/video/vino.c
+++ b/drivers/media/video/vino.c
@@ -2954,9 +2954,6 @@ static int vino_enum_input(struct file *file, void *__fh,
 	if (input == VINO_INPUT_NONE)
 		return -EINVAL;
 
-	memset(i, 0, sizeof(struct v4l2_input));
-
-	i->index = index;
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	i->std = vino_inputs[input].std;
 	strcpy(i->name, vino_inputs[input].name);
diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index 67a52e8..dc17acb 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -2766,11 +2766,6 @@ static int zoran_enum_input(struct file *file, void *__fh,
 
 	if (inp->index >= zr->card.inputs)
 		return -EINVAL;
-	else {
-		int id = inp->index;
-		memset(inp, 0, sizeof(*inp));
-		inp->index = id;
-	}
 
 	strncpy(inp->name, zr->card.input[inp->index].name,
 		sizeof(inp->name) - 1);
@@ -2820,7 +2815,6 @@ static int zoran_enum_output(struct file *file, void *__fh,
 	if (outp->index != 0)
 		return -EINVAL;
 
-	memset(outp, 0, sizeof(*outp));
 	outp->index = 0;
 	outp->type = V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY;
 	strncpy(outp->name, "Autodetect", sizeof(outp->name)-1);
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 4e184e8..596f414 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1300,8 +1300,6 @@ int cx25821_enum_input(struct cx25821_dev *dev, struct v4l2_input *i)
 	if (0 == INPUT(n)->type)
 		return -EINVAL;
 
-	memset(i, 0, sizeof(*i));
-	i->index = n;
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, iname[INPUT(n)->type]);
 
-- 
1.7.0.4

