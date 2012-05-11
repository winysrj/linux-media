Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2417 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab2EKHze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 14/16] hexium-gemini: remove B&W control, fix input table.
Date: Fri, 11 May 2012 09:55:08 +0200
Message-Id: <9fd3d182f195f2bf89b96161a516306bc2ca29ef.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The B&W control never worked, and you get the same effect by setting saturation to the
lowest value. So it has been removed. Also fixed some incorrect entries in the input
table. This driver now passes v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/hexium_gemini.c |  123 +++--------------------------------
 1 file changed, 10 insertions(+), 113 deletions(-)

diff --git a/drivers/media/video/hexium_gemini.c b/drivers/media/video/hexium_gemini.c
index 2265032..366434f 100644
--- a/drivers/media/video/hexium_gemini.c
+++ b/drivers/media/video/hexium_gemini.c
@@ -40,15 +40,15 @@ static int hexium_num;
 
 #define HEXIUM_INPUTS	9
 static struct v4l2_input hexium_inputs[HEXIUM_INPUTS] = {
-	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
 };
 
 #define HEXIUM_AUDIOS	0
@@ -59,11 +59,6 @@ struct hexium_data
 	u8 byte;
 };
 
-#define HEXIUM_CONTROLS	1
-static struct v4l2_queryctrl hexium_controls[] = {
-	{ V4L2_CID_PRIVATE_BASE, V4L2_CTRL_TYPE_BOOLEAN, "B/W", 0, 1, 1, 0, 0 },
-};
-
 #define HEXIUM_GEMINI_V_1_0		1
 #define HEXIUM_GEMINI_DUAL_V_1_0	2
 
@@ -76,7 +71,6 @@ struct hexium
 
 	int 		cur_input;	/* current input */
 	v4l2_std_id 	cur_std;	/* current standard */
-	int		cur_bw;		/* current black/white status */
 };
 
 /* Samsung KS0127B decoder default registers */
@@ -119,18 +113,10 @@ static struct hexium_data hexium_pal[] = {
 	{ 0x01, 0x52 }, { 0x12, 0x64 }, { 0x2D, 0x2C }, { 0x2E, 0x9B }, { -1 , 0xFF }
 };
 
-static struct hexium_data hexium_pal_bw[] = {
-	{ 0x01, 0x52 },	{ 0x12, 0x64 },	{ 0x2D, 0x2C },	{ 0x2E, 0x9B },	{ -1 , 0xFF }
-};
-
 static struct hexium_data hexium_ntsc[] = {
 	{ 0x01, 0x53 }, { 0x12, 0x04 }, { 0x2D, 0x23 }, { 0x2E, 0x81 }, { -1 , 0xFF }
 };
 
-static struct hexium_data hexium_ntsc_bw[] = {
-	{ 0x01, 0x53 }, { 0x12, 0x04 }, { 0x2D, 0x23 }, { 0x2E, 0x81 }, { -1 , 0xFF }
-};
-
 static struct hexium_data hexium_secam[] = {
 	{ 0x01, 0x52 }, { 0x12, 0x64 }, { 0x2D, 0x2C }, { 0x2E, 0x9B }, { -1 , 0xFF }
 };
@@ -264,93 +250,6 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 	return 0;
 }
 
-/* the saa7146 provides some controls (brightness, contrast, saturation)
-   which gets registered *after* this function. because of this we have
-   to return with a value != 0 even if the function succeeded.. */
-static int vidioc_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *qc)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	int i;
-
-	for (i = HEXIUM_CONTROLS - 1; i >= 0; i--) {
-		if (hexium_controls[i].id == qc->id) {
-			*qc = hexium_controls[i];
-			DEB_D("VIDIOC_QUERYCTRL %d\n", qc->id);
-			return 0;
-		}
-	}
-	return dev->ext_vv_data->core_ops->vidioc_queryctrl(file, fh, qc);
-}
-
-static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *vc)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-	int i;
-
-	for (i = HEXIUM_CONTROLS - 1; i >= 0; i--) {
-		if (hexium_controls[i].id == vc->id)
-			break;
-	}
-
-	if (i < 0)
-		return dev->ext_vv_data->core_ops->vidioc_g_ctrl(file, fh, vc);
-
-	if (vc->id == V4L2_CID_PRIVATE_BASE) {
-		vc->value = hexium->cur_bw;
-		DEB_D("VIDIOC_G_CTRL BW:%d\n", vc->value);
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *vc)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-	int i = 0;
-
-	for (i = HEXIUM_CONTROLS - 1; i >= 0; i--) {
-		if (hexium_controls[i].id == vc->id)
-			break;
-	}
-
-	if (i < 0)
-		return dev->ext_vv_data->core_ops->vidioc_s_ctrl(file, fh, vc);
-
-	if (vc->id == V4L2_CID_PRIVATE_BASE)
-		hexium->cur_bw = vc->value;
-
-	DEB_D("VIDIOC_S_CTRL BW:%d\n", hexium->cur_bw);
-
-	if (0 == hexium->cur_bw && V4L2_STD_PAL == hexium->cur_std) {
-		hexium_set_standard(hexium, hexium_pal);
-		return 0;
-	}
-	if (0 == hexium->cur_bw && V4L2_STD_NTSC == hexium->cur_std) {
-		hexium_set_standard(hexium, hexium_ntsc);
-		return 0;
-	}
-	if (0 == hexium->cur_bw && V4L2_STD_SECAM == hexium->cur_std) {
-		hexium_set_standard(hexium, hexium_secam);
-		return 0;
-	}
-	if (1 == hexium->cur_bw && V4L2_STD_PAL == hexium->cur_std) {
-		hexium_set_standard(hexium, hexium_pal_bw);
-		return 0;
-	}
-	if (1 == hexium->cur_bw && V4L2_STD_NTSC == hexium->cur_std) {
-		hexium_set_standard(hexium, hexium_ntsc_bw);
-		return 0;
-	}
-	if (1 == hexium->cur_bw && V4L2_STD_SECAM == hexium->cur_std)
-		/* fixme: is there no bw secam mode? */
-		return -EINVAL;
-
-	return -EINVAL;
-}
-
-
 static struct saa7146_ext_vv vv_data;
 
 /* this function only gets called when the probing was successful */
@@ -399,9 +298,7 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	hexium->cur_input = 0;
 
 	saa7146_vv_init(dev, &vv_data);
-	vv_data.vid_ops.vidioc_queryctrl = vidioc_queryctrl;
-	vv_data.vid_ops.vidioc_g_ctrl = vidioc_g_ctrl;
-	vv_data.vid_ops.vidioc_s_ctrl = vidioc_s_ctrl;
+
 	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
 	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
 	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
-- 
1.7.10

