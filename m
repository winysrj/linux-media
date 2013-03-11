Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1962 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3CKLrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 30/42] go7007: standardize MPEG handling support.
Date: Mon, 11 Mar 2013 12:46:08 +0100
Message-Id: <395419ee5b86b3be7312fc657f78b06e7a5322f7.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The go7007 produces elementary streams, so we shouldn't use the STREAM_TYPE
control, since that is for multiplexed streams.

Instead use V4L2_PIX_FMT_MPEG1/2/4.

Initially set up all the values for MPEG-2 dvd-mode, and select the dvd_mode
field if those values match that setup precisely.

Clean up lots of obsolete code relating to the custom ioctls for the MPEG
support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-driver.c |   16 +-
 drivers/staging/media/go7007/go7007-fw.c     |   78 ++--
 drivers/staging/media/go7007/go7007-priv.h   |   13 +-
 drivers/staging/media/go7007/go7007-v4l2.c   |  507 +++++++-------------------
 drivers/staging/media/go7007/go7007.h        |   74 ----
 5 files changed, 181 insertions(+), 507 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index eac91bc..732b452 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -433,12 +433,12 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 	spin_lock(&go->spinlock);
 
 	switch (go->format) {
-	case GO7007_FORMAT_MPEG4:
+	case V4L2_PIX_FMT_MPEG4:
 		seq_start_code = 0xB0;
 		frame_start_code = 0xB6;
 		break;
-	case GO7007_FORMAT_MPEG1:
-	case GO7007_FORMAT_MPEG2:
+	case V4L2_PIX_FMT_MPEG1:
+	case V4L2_PIX_FMT_MPEG2:
 		seq_start_code = 0xB3;
 		frame_start_code = 0x00;
 		break;
@@ -518,9 +518,9 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 			}
 			/* If this is the start of a new MPEG frame,
 			 * get a new buffer */
-			if ((go->format == GO7007_FORMAT_MPEG1 ||
-					go->format == GO7007_FORMAT_MPEG2 ||
-					go->format == GO7007_FORMAT_MPEG4) &&
+			if ((go->format == V4L2_PIX_FMT_MPEG1 ||
+			     go->format == V4L2_PIX_FMT_MPEG2 ||
+			     go->format == V4L2_PIX_FMT_MPEG4) &&
 					(buf[i] == seq_start_code ||
 						buf[i] == 0xB8 || /* GOP code */
 						buf[i] == frame_start_code)) {
@@ -577,7 +577,7 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 				/* go->state remains STATE_FF */
 				break;
 			case 0xD8:
-				if (go->format == GO7007_FORMAT_MJPEG)
+				if (go->format == V4L2_PIX_FMT_MJPEG)
 					frame_boundary(go);
 				/* fall through */
 			default:
@@ -654,8 +654,8 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	go->encoder_h_halve = 0;
 	go->encoder_v_halve = 0;
 	go->encoder_subsample = 0;
+	go->format = V4L2_PIX_FMT_MJPEG;
 	go->streaming = 0;
-	go->format = GO7007_FORMAT_MJPEG;
 	go->bitrate = 1500000;
 	go->fps_scale = 1;
 	go->pali = 0;
diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
index a5ede1c..524ba48 100644
--- a/drivers/staging/media/go7007/go7007-fw.c
+++ b/drivers/staging/media/go7007/go7007-fw.c
@@ -455,9 +455,9 @@ static int mpeg1_frame_header(struct go7007 *go, unsigned char *buf,
 
 	CODE_ADD(c, frame == PFRAME ? 0x2 : 0x3, 13);
 	CODE_ADD(c, 0xffff, 16);
-	CODE_ADD(c, go->format == GO7007_FORMAT_MPEG2 ? 0x7 : 0x4, 4);
+	CODE_ADD(c, go->format == V4L2_PIX_FMT_MPEG2 ? 0x7 : 0x4, 4);
 	if (frame != PFRAME)
-		CODE_ADD(c, go->format == GO7007_FORMAT_MPEG2 ? 0x7 : 0x4, 4);
+		CODE_ADD(c, go->format == V4L2_PIX_FMT_MPEG2 ? 0x7 : 0x4, 4);
 	else
 		CODE_ADD(c, 0, 4); /* Is this supposed to be here?? */
 	CODE_ADD(c, 0, 3); /* What is this?? */
@@ -466,7 +466,7 @@ static int mpeg1_frame_header(struct go7007 *go, unsigned char *buf,
 	if (j != 8)
 		CODE_ADD(c, 0, j);
 
-	if (go->format == GO7007_FORMAT_MPEG2) {
+	if (go->format == V4L2_PIX_FMT_MPEG2) {
 		CODE_ADD(c, 0x1, 24);
 		CODE_ADD(c, 0xb5, 8);
 		CODE_ADD(c, 0x844, 12);
@@ -537,7 +537,7 @@ static int mpeg1_sequence_header(struct go7007 *go, unsigned char *buf, int ext)
 	int i, aspect_ratio, picture_rate;
 	CODE_GEN(c, buf + 6);
 
-	if (go->format == GO7007_FORMAT_MPEG1) {
+	if (go->format == V4L2_PIX_FMT_MPEG1) {
 		switch (go->aspect_ratio) {
 		case GO7007_RATIO_4_3:
 			aspect_ratio = go->standard == GO7007_STD_NTSC ? 3 : 2;
@@ -587,9 +587,9 @@ static int mpeg1_sequence_header(struct go7007 *go, unsigned char *buf, int ext)
 	CODE_ADD(c, go->height, 12);
 	CODE_ADD(c, aspect_ratio, 4);
 	CODE_ADD(c, picture_rate, 4);
-	CODE_ADD(c, go->format == GO7007_FORMAT_MPEG2 ? 20000 : 0x3ffff, 18);
+	CODE_ADD(c, go->format == V4L2_PIX_FMT_MPEG2 ? 20000 : 0x3ffff, 18);
 	CODE_ADD(c, 1, 1);
-	CODE_ADD(c, go->format == GO7007_FORMAT_MPEG2 ? 112 : 20, 10);
+	CODE_ADD(c, go->format == V4L2_PIX_FMT_MPEG2 ? 112 : 20, 10);
 	CODE_ADD(c, 0, 3);
 
 	/* Byte-align with zeros */
@@ -597,7 +597,7 @@ static int mpeg1_sequence_header(struct go7007 *go, unsigned char *buf, int ext)
 	if (i != 8)
 		CODE_ADD(c, 0, i);
 
-	if (go->format == GO7007_FORMAT_MPEG2) {
+	if (go->format == V4L2_PIX_FMT_MPEG2) {
 		CODE_ADD(c, 0x1, 24);
 		CODE_ADD(c, 0xb5, 8);
 		CODE_ADD(c, 0x148, 12);
@@ -930,10 +930,10 @@ static int brctrl_to_package(struct go7007 *go,
 					__le16 *code, int space, int *framelen)
 {
 	int converge_speed = 0;
-	int lambda = (go->format == GO7007_FORMAT_MJPEG || go->dvd_mode) ?
+	int lambda = (go->format == V4L2_PIX_FMT_MJPEG || go->dvd_mode) ?
 				100 : 0;
 	int peak_rate = 6 * go->bitrate / 5;
-	int vbv_buffer = go->format == GO7007_FORMAT_MJPEG ?
+	int vbv_buffer = go->format == V4L2_PIX_FMT_MJPEG ?
 				go->bitrate :
 				(go->dvd_mode ? 900000 : peak_rate);
 	int fps = go->sensor_framerate / go->fps_scale;
@@ -1096,10 +1096,10 @@ static int config_package(struct go7007 *go, __le16 *code, int space)
 		0xc003,		0x28b4,
 		0xc004,		0x3c5a,
 		0xdc05,		0x2a77,
-		0xc6c3,		go->format == GO7007_FORMAT_MPEG4 ? 0 :
-				(go->format == GO7007_FORMAT_H263 ? 0 : 1),
-		0xc680,		go->format == GO7007_FORMAT_MPEG4 ? 0xf1 :
-				(go->format == GO7007_FORMAT_H263 ? 0x61 :
+		0xc6c3,		go->format == V4L2_PIX_FMT_MPEG4 ? 0 :
+				(go->format == V4L2_PIX_FMT_H263 ? 0 : 1),
+		0xc680,		go->format == V4L2_PIX_FMT_MPEG4 ? 0xf1 :
+				(go->format == V4L2_PIX_FMT_H263 ? 0x61 :
 									0xd3),
 		0xc780,		0x0140,
 		0xe009,		0x0001,
@@ -1123,15 +1123,15 @@ static int config_package(struct go7007 *go, __le16 *code, int space)
 						(!go->interlace_coding) ?
 					0x0008 : 0x0009,
 		0xc404,		go->interlace_coding ? 0x44 :
-				(go->format == GO7007_FORMAT_MPEG4 ? 0x11 :
-				(go->format == GO7007_FORMAT_MPEG1 ? 0x02 :
-				(go->format == GO7007_FORMAT_MPEG2 ? 0x04 :
-				(go->format == GO7007_FORMAT_H263  ? 0x08 :
+				(go->format == V4L2_PIX_FMT_MPEG4 ? 0x11 :
+				(go->format == V4L2_PIX_FMT_MPEG1 ? 0x02 :
+				(go->format == V4L2_PIX_FMT_MPEG2 ? 0x04 :
+				(go->format == V4L2_PIX_FMT_H263  ? 0x08 :
 								     0x20)))),
-		0xbf0a,		(go->format == GO7007_FORMAT_MPEG4 ? 8 :
-				(go->format == GO7007_FORMAT_MPEG1 ? 1 :
-				(go->format == GO7007_FORMAT_MPEG2 ? 2 :
-				(go->format == GO7007_FORMAT_H263 ? 4 : 16)))) |
+		0xbf0a,		(go->format == V4L2_PIX_FMT_MPEG4 ? 8 :
+				(go->format == V4L2_PIX_FMT_MPEG1 ? 1 :
+				(go->format == V4L2_PIX_FMT_MPEG2 ? 2 :
+				(go->format == V4L2_PIX_FMT_H263 ? 4 : 16)))) |
 				((go->repeat_seqhead ? 1 : 0) << 6) |
 				((go->dvd_mode ? 1 : 0) << 9) |
 				((go->gop_header_enable ? 1 : 0) << 10),
@@ -1348,19 +1348,19 @@ static int final_package(struct go7007 *go, __le16 *code, int space)
 			0x41,
 		go->ipb ? 0xd4c : 0x36b,
 		(rows << 8) | (go->width >> 4),
-		go->format == GO7007_FORMAT_MPEG4 ? 0x0404 : 0,
+		go->format == V4L2_PIX_FMT_MPEG4 ? 0x0404 : 0,
 		(1 << 15) | ((go->interlace_coding ? 1 : 0) << 13) |
 			((go->closed_gop ? 1 : 0) << 12) |
-			((go->format == GO7007_FORMAT_MPEG4 ? 1 : 0) << 11) |
+			((go->format == V4L2_PIX_FMT_MPEG4 ? 1 : 0) << 11) |
 		/*	(1 << 9) |   */
 			((go->ipb ? 3 : 0) << 7) |
 			((go->modet_enable ? 1 : 0) << 2) |
 			((go->dvd_mode ? 1 : 0) << 1) | 1,
-		(go->format == GO7007_FORMAT_MPEG1 ? 0x89a0 :
-			(go->format == GO7007_FORMAT_MPEG2 ? 0x89a0 :
-			(go->format == GO7007_FORMAT_MJPEG ? 0x89a0 :
-			(go->format == GO7007_FORMAT_MPEG4 ? 0x8920 :
-			(go->format == GO7007_FORMAT_H263 ? 0x8920 : 0))))),
+		(go->format == V4L2_PIX_FMT_MPEG1 ? 0x89a0 :
+			(go->format == V4L2_PIX_FMT_MPEG2 ? 0x89a0 :
+			(go->format == V4L2_PIX_FMT_MJPEG ? 0x89a0 :
+			(go->format == V4L2_PIX_FMT_MPEG4 ? 0x8920 :
+			(go->format == V4L2_PIX_FMT_H263 ? 0x8920 : 0))))),
 		go->ipb ? 0x1f15 : 0x1f0b,
 		go->ipb ? 0x0015 : 0x000b,
 		go->ipb ? 0xa800 : 0x5800,
@@ -1503,13 +1503,13 @@ static int do_special(struct go7007 *go, u16 type, __le16 *code, int space,
 	switch (type) {
 	case SPECIAL_FRM_HEAD:
 		switch (go->format) {
-		case GO7007_FORMAT_MJPEG:
+		case V4L2_PIX_FMT_MJPEG:
 			return gen_mjpeghdr_to_package(go, code, space);
-		case GO7007_FORMAT_MPEG1:
-		case GO7007_FORMAT_MPEG2:
+		case V4L2_PIX_FMT_MPEG1:
+		case V4L2_PIX_FMT_MPEG2:
 			return gen_mpeg1hdr_to_package(go, code, space,
 								framelen);
-		case GO7007_FORMAT_MPEG4:
+		case V4L2_PIX_FMT_MPEG4:
 			return gen_mpeg4hdr_to_package(go, code, space,
 								framelen);
 		}
@@ -1519,11 +1519,11 @@ static int do_special(struct go7007 *go, u16 type, __le16 *code, int space,
 		return config_package(go, code, space);
 	case SPECIAL_SEQHEAD:
 		switch (go->format) {
-		case GO7007_FORMAT_MPEG1:
-		case GO7007_FORMAT_MPEG2:
+		case V4L2_PIX_FMT_MPEG1:
+		case V4L2_PIX_FMT_MPEG2:
 			return seqhead_to_package(go, code, space,
 					mpeg1_sequence_header);
-		case GO7007_FORMAT_MPEG4:
+		case V4L2_PIX_FMT_MPEG4:
 			return seqhead_to_package(go, code, space,
 					mpeg4_sequence_header);
 		default:
@@ -1553,16 +1553,16 @@ int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen)
 	int ret;
 
 	switch (go->format) {
-	case GO7007_FORMAT_MJPEG:
+	case V4L2_PIX_FMT_MJPEG:
 		mode_flag = FLAG_MODE_MJPEG;
 		break;
-	case GO7007_FORMAT_MPEG1:
+	case V4L2_PIX_FMT_MPEG1:
 		mode_flag = FLAG_MODE_MPEG1;
 		break;
-	case GO7007_FORMAT_MPEG2:
+	case V4L2_PIX_FMT_MPEG2:
 		mode_flag = FLAG_MODE_MPEG2;
 		break;
-	case GO7007_FORMAT_MPEG4:
+	case V4L2_PIX_FMT_MPEG4:
 		mode_flag = FLAG_MODE_MPEG4;
 		break;
 	default:
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index bf874dd..c2fafb2 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -151,12 +151,6 @@ struct go7007_file {
 	struct go7007_buffer *bufs;
 };
 
-#define	GO7007_FORMAT_MJPEG	0
-#define GO7007_FORMAT_MPEG4	1
-#define GO7007_FORMAT_MPEG1	2
-#define GO7007_FORMAT_MPEG2	3
-#define GO7007_FORMAT_H263	4
-
 #define GO7007_RATIO_1_1	0
 #define GO7007_RATIO_4_3	1
 #define GO7007_RATIO_16_9	2
@@ -186,6 +180,11 @@ struct go7007 {
 	unsigned boot_fw_len;
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *mpeg_video_encoding;
+	struct v4l2_ctrl *mpeg_video_gop_size;
+	struct v4l2_ctrl *mpeg_video_gop_closure;
+	struct v4l2_ctrl *mpeg_video_bitrate;
+	struct v4l2_ctrl *mpeg_video_aspect_ratio;
 	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
 	spinlock_t spinlock;
 	struct mutex hw_lock;
@@ -211,7 +210,7 @@ struct go7007 {
 	unsigned int encoder_subsample:1;
 
 	/* Encoder config */
-	int format;
+	u32 format;
 	int bitrate;
 	int fps_scale;
 	int pali;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 2fa5ffc..df5296f 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -39,11 +39,6 @@
 #include "go7007.h"
 #include "go7007-priv.h"
 
-/* Temporary defines until accepted in v4l-dvb */
-#ifndef V4L2_MPEG_STREAM_TYPE_MPEG_ELEM
-#define	V4L2_MPEG_STREAM_TYPE_MPEG_ELEM   6 /* MPEG elementary stream */
-#endif
-
 #define call_all(dev, o, f, args...) \
 	v4l2_device_call_until_err(dev, 0, o, f, ##args)
 
@@ -85,6 +80,10 @@ static int go7007_streamoff(struct go7007 *go)
 		go7007_reset_encoder(go);
 	}
 	mutex_unlock(&go->hw_lock);
+	v4l2_ctrl_grab(go->mpeg_video_gop_size, false);
+	v4l2_ctrl_grab(go->mpeg_video_gop_closure, false);
+	v4l2_ctrl_grab(go->mpeg_video_bitrate, false);
+	v4l2_ctrl_grab(go->mpeg_video_aspect_ratio, false);
 	return 0;
 }
 
@@ -125,14 +124,27 @@ static int go7007_release(struct file *file)
 	return 0;
 }
 
+static bool valid_pixelformat(u32 pixelformat)
+{
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_MJPEG:
+	case V4L2_PIX_FMT_MPEG1:
+	case V4L2_PIX_FMT_MPEG2:
+	case V4L2_PIX_FMT_MPEG4:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static u32 get_frame_type_flag(struct go7007_buffer *gobuf, int format)
 {
 	u8 *f = page_address(gobuf->pages[0]);
 
 	switch (format) {
-	case GO7007_FORMAT_MJPEG:
+	case V4L2_PIX_FMT_MJPEG:
 		return V4L2_BUF_FLAG_KEYFRAME;
-	case GO7007_FORMAT_MPEG4:
+	case V4L2_PIX_FMT_MPEG4:
 		switch ((f[gobuf->frame_offset + 4] >> 6) & 0x3) {
 		case 0:
 			return V4L2_BUF_FLAG_KEYFRAME;
@@ -143,8 +155,8 @@ static u32 get_frame_type_flag(struct go7007_buffer *gobuf, int format)
 		default:
 			return 0;
 		}
-	case GO7007_FORMAT_MPEG1:
-	case GO7007_FORMAT_MPEG2:
+	case V4L2_PIX_FMT_MPEG1:
+	case V4L2_PIX_FMT_MPEG2:
 		switch ((f[gobuf->frame_offset + 5] >> 3) & 0x7) {
 		case 1:
 			return V4L2_BUF_FLAG_KEYFRAME;
@@ -179,13 +191,87 @@ static void get_resolution(struct go7007 *go, int *width, int *height)
 	}
 }
 
+static void set_formatting(struct go7007 *go)
+{
+	if (go->format == V4L2_PIX_FMT_MJPEG) {
+		go->pali = 0;
+		go->aspect_ratio = GO7007_RATIO_1_1;
+		go->gop_size = 0;
+		go->ipb = 0;
+		go->closed_gop = 0;
+		go->repeat_seqhead = 0;
+		go->seq_header_enable = 0;
+		go->gop_header_enable = 0;
+		go->dvd_mode = 0;
+		return;
+	}
+
+	switch (go->format) {
+	case V4L2_PIX_FMT_MPEG1:
+		go->pali = 0;
+		break;
+	default:
+	case V4L2_PIX_FMT_MPEG2:
+		go->pali = 0x48;
+		break;
+	case V4L2_PIX_FMT_MPEG4:
+		/* For future reference: this is the list of MPEG4
+		 * profiles that are available, although they are
+		 * untested:
+		 *
+		 * Profile		pali
+		 * --------------	----
+		 * PROFILE_S_L0		0x08
+		 * PROFILE_S_L1		0x01
+		 * PROFILE_S_L2		0x02
+		 * PROFILE_S_L3		0x03
+		 * PROFILE_ARTS_L1	0x91
+		 * PROFILE_ARTS_L2	0x92
+		 * PROFILE_ARTS_L3	0x93
+		 * PROFILE_ARTS_L4	0x94
+		 * PROFILE_AS_L0	0xf0
+		 * PROFILE_AS_L1	0xf1
+		 * PROFILE_AS_L2	0xf2
+		 * PROFILE_AS_L3	0xf3
+		 * PROFILE_AS_L4	0xf4
+		 * PROFILE_AS_L5	0xf5
+		 */
+		go->pali = 0xf5;
+		break;
+	}
+	go->gop_size = v4l2_ctrl_g_ctrl(go->mpeg_video_gop_size);
+	go->closed_gop = v4l2_ctrl_g_ctrl(go->mpeg_video_gop_closure);
+	go->bitrate = v4l2_ctrl_g_ctrl(go->mpeg_video_bitrate);
+	go->gop_header_enable = 1;
+	go->dvd_mode = 0;
+	if (go->format == V4L2_PIX_FMT_MPEG2)
+		go->dvd_mode =
+			go->bitrate == 9800000 &&
+			go->gop_size == 15 &&
+			go->closed_gop;
+	go->repeat_seqhead = go->dvd_mode;
+	go->ipb = 0;
+
+	switch (v4l2_ctrl_g_ctrl(go->mpeg_video_aspect_ratio)) {
+	default:
+	case V4L2_MPEG_VIDEO_ASPECT_1x1:
+		go->aspect_ratio = GO7007_RATIO_1_1;
+		break;
+	case V4L2_MPEG_VIDEO_ASPECT_4x3:
+		go->aspect_ratio = GO7007_RATIO_4_3;
+		break;
+	case V4L2_MPEG_VIDEO_ASPECT_16x9:
+		go->aspect_ratio = GO7007_RATIO_16_9;
+		break;
+	}
+}
+
 static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 {
 	int sensor_height = 0, sensor_width = 0;
 	int width, height, i;
 
-	if (fmt != NULL && fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG &&
-			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MPEG)
+	if (fmt != NULL && !valid_pixelformat(fmt->fmt.pix.pixelformat))
 		return -EINVAL;
 
 	get_resolution(go, &sensor_width, &sensor_height);
@@ -241,6 +327,8 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 	if (try)
 		return 0;
 
+	if (fmt)
+		go->format = fmt->fmt.pix.pixelformat;
 	go->width = width;
 	go->height = height;
 	go->encoder_h_offset = go->board_info->sensor_h_offset;
@@ -275,55 +363,6 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 			go->encoder_subsample = 0;
 		}
 	}
-
-	if (fmt == NULL)
-		return 0;
-
-	switch (fmt->fmt.pix.pixelformat) {
-	case V4L2_PIX_FMT_MPEG:
-		if (go->format == GO7007_FORMAT_MPEG1 ||
-				go->format == GO7007_FORMAT_MPEG2 ||
-				go->format == GO7007_FORMAT_MPEG4)
-			break;
-		go->format = GO7007_FORMAT_MPEG1;
-		go->pali = 0;
-		go->aspect_ratio = GO7007_RATIO_1_1;
-		go->gop_size = go->sensor_framerate / 1000;
-		go->ipb = 0;
-		go->closed_gop = 1;
-		go->repeat_seqhead = 1;
-		go->seq_header_enable = 1;
-		go->gop_header_enable = 1;
-		go->dvd_mode = 0;
-		break;
-	/* Backwards compatibility only! */
-	case V4L2_PIX_FMT_MPEG4:
-		if (go->format == GO7007_FORMAT_MPEG4)
-			break;
-		go->format = GO7007_FORMAT_MPEG4;
-		go->pali = 0xf5;
-		go->aspect_ratio = GO7007_RATIO_1_1;
-		go->gop_size = go->sensor_framerate / 1000;
-		go->ipb = 0;
-		go->closed_gop = 1;
-		go->repeat_seqhead = 1;
-		go->seq_header_enable = 1;
-		go->gop_header_enable = 1;
-		go->dvd_mode = 0;
-		break;
-	case V4L2_PIX_FMT_MJPEG:
-		go->format = GO7007_FORMAT_MJPEG;
-		go->pali = 0;
-		go->aspect_ratio = GO7007_RATIO_1_1;
-		go->gop_size = 0;
-		go->ipb = 0;
-		go->closed_gop = 0;
-		go->repeat_seqhead = 0;
-		go->seq_header_enable = 0;
-		go->gop_header_enable = 0;
-		go->dvd_mode = 0;
-		break;
-	}
 	return 0;
 }
 
@@ -385,98 +424,6 @@ static int clip_to_modet_map(struct go7007 *go, int region,
 }
 #endif
 
-static int go7007_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct go7007 *go =
-		container_of(ctrl->handler, struct go7007, hdl);
-
-	/* pretty sure we can't change any of these while streaming */
-	if (go->streaming)
-		return -EBUSY;
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		switch (ctrl->val) {
-		case V4L2_MPEG_STREAM_TYPE_MPEG2_DVD:
-			go->format = GO7007_FORMAT_MPEG2;
-			go->bitrate = 9800000;
-			go->gop_size = 15;
-			go->pali = 0x48;
-			go->closed_gop = 1;
-			go->repeat_seqhead = 0;
-			go->seq_header_enable = 1;
-			go->gop_header_enable = 1;
-			go->dvd_mode = 1;
-			break;
-		default:
-			return -EINVAL;
-		}
-		break;
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		switch (ctrl->val) {
-		case V4L2_MPEG_VIDEO_ENCODING_MPEG_1:
-			go->format = GO7007_FORMAT_MPEG1;
-			go->pali = 0;
-			break;
-		case V4L2_MPEG_VIDEO_ENCODING_MPEG_2:
-			go->format = GO7007_FORMAT_MPEG2;
-			/*if (mpeg->pali >> 24 == 2)
-				go->pali = mpeg->pali & 0xff;
-			else*/
-				go->pali = 0x48;
-			break;
-		case V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC:
-			go->format = GO7007_FORMAT_MPEG4;
-			/*if (mpeg->pali >> 24 == 4)
-				go->pali = mpeg->pali & 0xff;
-			else*/
-				go->pali = 0xf5;
-			break;
-		default:
-			return -EINVAL;
-		}
-		go->gop_header_enable =
-			/*mpeg->flags & GO7007_MPEG_OMIT_GOP_HEADER
-			? 0 :*/ 1;
-		/*if (mpeg->flags & GO7007_MPEG_REPEAT_SEQHEADER)
-			go->repeat_seqhead = 1;
-		else*/
-			go->repeat_seqhead = 0;
-		go->dvd_mode = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		/* TODO: is this really the right thing to do for mjpeg? */
-		if (go->format == GO7007_FORMAT_MJPEG)
-			return -EINVAL;
-		switch (ctrl->val) {
-		case V4L2_MPEG_VIDEO_ASPECT_1x1:
-			go->aspect_ratio = GO7007_RATIO_1_1;
-			break;
-		case V4L2_MPEG_VIDEO_ASPECT_4x3:
-			go->aspect_ratio = GO7007_RATIO_4_3;
-			break;
-		case V4L2_MPEG_VIDEO_ASPECT_16x9:
-			go->aspect_ratio = GO7007_RATIO_16_9;
-			break;
-		default:
-			return -EINVAL;
-		}
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		go->gop_size = ctrl->val;
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
-		go->closed_gop = ctrl->val;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		go->bitrate = ctrl->val;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
@@ -504,11 +451,19 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	switch (fmt->index) {
 	case 0:
 		fmt->pixelformat = V4L2_PIX_FMT_MJPEG;
-		desc = "Motion-JPEG";
+		desc = "Motion JPEG";
 		break;
 	case 1:
-		fmt->pixelformat = V4L2_PIX_FMT_MPEG;
-		desc = "MPEG1/MPEG2/MPEG4";
+		fmt->pixelformat = V4L2_PIX_FMT_MPEG1;
+		desc = "MPEG-1 ES";
+		break;
+	case 2:
+		fmt->pixelformat = V4L2_PIX_FMT_MPEG2;
+		desc = "MPEG-2 ES";
+		break;
+	case 3:
+		fmt->pixelformat = V4L2_PIX_FMT_MPEG4;
+		desc = "MPEG-4 ES";
 		break;
 	default:
 		return -EINVAL;
@@ -529,8 +484,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fmt->fmt.pix.width = go->width;
 	fmt->fmt.pix.height = go->height;
-	fmt->fmt.pix.pixelformat = (go->format == GO7007_FORMAT_MJPEG) ?
-				   V4L2_PIX_FMT_MJPEG : V4L2_PIX_FMT_MPEG;
+	fmt->fmt.pix.pixelformat = go->format;
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = 0;
 	fmt->fmt.pix.sizeimage = GO7007_BUF_SIZE;
@@ -578,6 +532,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		if (gofh->bufs[i].mapped > 0)
 			goto unlock_and_return;
 
+	set_formatting(go);
 	mutex_lock(&go->hw_lock);
 	if (go->in_use > 0 && gofh->buf_count == 0) {
 		mutex_unlock(&go->hw_lock);
@@ -833,6 +788,10 @@ static int vidioc_streamon(struct file *file, void *priv,
 	mutex_unlock(&go->hw_lock);
 	mutex_unlock(&gofh->lock);
 	call_all(&go->v4l2_dev, video, s_stream, 1);
+	v4l2_ctrl_grab(go->mpeg_video_gop_size, true);
+	v4l2_ctrl_grab(go->mpeg_video_gop_closure, true);
+	v4l2_ctrl_grab(go->mpeg_video_bitrate, true);
+	v4l2_ctrl_grab(go->mpeg_video_aspect_ratio, true);
 
 	return retval;
 }
@@ -911,8 +870,7 @@ static int vidioc_enum_framesizes(struct file *filp, void *priv,
 	if (fsize->index > 2)
 		return -EINVAL;
 
-	if (fsize->pixel_format != V4L2_PIX_FMT_MJPEG &&
-	    fsize->pixel_format != V4L2_PIX_FMT_MPEG)
+	if (!valid_pixelformat(fsize->pixel_format))
 		return -EINVAL;
 
 	get_resolution(go, &width, &height);
@@ -932,8 +890,7 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 	if (fival->index > 4)
 		return -EINVAL;
 
-	if (fival->pixel_format != V4L2_PIX_FMT_MJPEG &&
-	    fival->pixel_format != V4L2_PIX_FMT_MPEG)
+	if (!valid_pixelformat(fival->pixel_format))
 		return -EINVAL;
 
 	if (!(go->board_info->sensor_flags & GO7007_SENSOR_SCALING)) {
@@ -1257,180 +1214,6 @@ static int vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *
  */
 
 #if 0
-	/* Temporary ioctls for controlling compression characteristics */
-	case GO7007IOC_S_BITRATE:
-	{
-		int *bitrate = arg;
-
-		if (go->streaming)
-			return -EINVAL;
-		/* Upper bound is kind of arbitrary here */
-		if (*bitrate < 64000 || *bitrate > 10000000)
-			return -EINVAL;
-		go->bitrate = *bitrate;
-		return 0;
-	}
-	case GO7007IOC_G_BITRATE:
-	{
-		int *bitrate = arg;
-
-		*bitrate = go->bitrate;
-		return 0;
-	}
-	case GO7007IOC_S_COMP_PARAMS:
-	{
-		struct go7007_comp_params *comp = arg;
-
-		if (go->format == GO7007_FORMAT_MJPEG)
-			return -EINVAL;
-		if (comp->gop_size > 0)
-			go->gop_size = comp->gop_size;
-		else
-			go->gop_size = go->sensor_framerate / 1000;
-		if (go->gop_size != 15)
-			go->dvd_mode = 0;
-		/*go->ipb = comp->max_b_frames > 0;*/ /* completely untested */
-		if (go->board_info->sensor_flags & GO7007_SENSOR_TV) {
-			switch (comp->aspect_ratio) {
-			case GO7007_ASPECT_RATIO_4_3_NTSC:
-			case GO7007_ASPECT_RATIO_4_3_PAL:
-				go->aspect_ratio = GO7007_RATIO_4_3;
-				break;
-			case GO7007_ASPECT_RATIO_16_9_NTSC:
-			case GO7007_ASPECT_RATIO_16_9_PAL:
-				go->aspect_ratio = GO7007_RATIO_16_9;
-				break;
-			default:
-				go->aspect_ratio = GO7007_RATIO_1_1;
-				break;
-			}
-		}
-		if (comp->flags & GO7007_COMP_OMIT_SEQ_HEADER) {
-			go->dvd_mode = 0;
-			go->seq_header_enable = 0;
-		} else {
-			go->seq_header_enable = 1;
-		}
-		/* fall-through */
-	}
-	case GO7007IOC_G_COMP_PARAMS:
-	{
-		struct go7007_comp_params *comp = arg;
-
-		if (go->format == GO7007_FORMAT_MJPEG)
-			return -EINVAL;
-		memset(comp, 0, sizeof(*comp));
-		comp->gop_size = go->gop_size;
-		comp->max_b_frames = go->ipb ? 2 : 0;
-		switch (go->aspect_ratio) {
-		case GO7007_RATIO_4_3:
-			if (go->standard == GO7007_STD_NTSC)
-				comp->aspect_ratio =
-					GO7007_ASPECT_RATIO_4_3_NTSC;
-			else
-				comp->aspect_ratio =
-					GO7007_ASPECT_RATIO_4_3_PAL;
-			break;
-		case GO7007_RATIO_16_9:
-			if (go->standard == GO7007_STD_NTSC)
-				comp->aspect_ratio =
-					GO7007_ASPECT_RATIO_16_9_NTSC;
-			else
-				comp->aspect_ratio =
-					GO7007_ASPECT_RATIO_16_9_PAL;
-			break;
-		default:
-			comp->aspect_ratio = GO7007_ASPECT_RATIO_1_1;
-			break;
-		}
-		if (go->closed_gop)
-			comp->flags |= GO7007_COMP_CLOSED_GOP;
-		if (!go->seq_header_enable)
-			comp->flags |= GO7007_COMP_OMIT_SEQ_HEADER;
-		return 0;
-	}
-	case GO7007IOC_S_MPEG_PARAMS:
-	{
-		struct go7007_mpeg_params *mpeg = arg;
-
-		if (go->format != GO7007_FORMAT_MPEG1 &&
-				go->format != GO7007_FORMAT_MPEG2 &&
-				go->format != GO7007_FORMAT_MPEG4)
-			return -EINVAL;
-
-		if (mpeg->flags & GO7007_MPEG_FORCE_DVD_MODE) {
-			go->format = GO7007_FORMAT_MPEG2;
-			go->bitrate = 9800000;
-			go->gop_size = 15;
-			go->pali = 0x48;
-			go->closed_gop = 1;
-			go->repeat_seqhead = 0;
-			go->seq_header_enable = 1;
-			go->gop_header_enable = 1;
-			go->dvd_mode = 1;
-		} else {
-			switch (mpeg->mpeg_video_standard) {
-			case GO7007_MPEG_VIDEO_MPEG1:
-				go->format = GO7007_FORMAT_MPEG1;
-				go->pali = 0;
-				break;
-			case GO7007_MPEG_VIDEO_MPEG2:
-				go->format = GO7007_FORMAT_MPEG2;
-				if (mpeg->pali >> 24 == 2)
-					go->pali = mpeg->pali & 0xff;
-				else
-					go->pali = 0x48;
-				break;
-			case GO7007_MPEG_VIDEO_MPEG4:
-				go->format = GO7007_FORMAT_MPEG4;
-				if (mpeg->pali >> 24 == 4)
-					go->pali = mpeg->pali & 0xff;
-				else
-					go->pali = 0xf5;
-				break;
-			default:
-				return -EINVAL;
-			}
-			go->gop_header_enable =
-				mpeg->flags & GO7007_MPEG_OMIT_GOP_HEADER
-				? 0 : 1;
-			if (mpeg->flags & GO7007_MPEG_REPEAT_SEQHEADER)
-				go->repeat_seqhead = 1;
-			else
-				go->repeat_seqhead = 0;
-			go->dvd_mode = 0;
-		}
-		/* fall-through */
-	}
-	case GO7007IOC_G_MPEG_PARAMS:
-	{
-		struct go7007_mpeg_params *mpeg = arg;
-
-		memset(mpeg, 0, sizeof(*mpeg));
-		switch (go->format) {
-		case GO7007_FORMAT_MPEG1:
-			mpeg->mpeg_video_standard = GO7007_MPEG_VIDEO_MPEG1;
-			mpeg->pali = 0;
-			break;
-		case GO7007_FORMAT_MPEG2:
-			mpeg->mpeg_video_standard = GO7007_MPEG_VIDEO_MPEG2;
-			mpeg->pali = GO7007_MPEG_PROFILE(2, go->pali);
-			break;
-		case GO7007_FORMAT_MPEG4:
-			mpeg->mpeg_video_standard = GO7007_MPEG_VIDEO_MPEG4;
-			mpeg->pali = GO7007_MPEG_PROFILE(4, go->pali);
-			break;
-		default:
-			return -EINVAL;
-		}
-		if (!go->gop_header_enable)
-			mpeg->flags |= GO7007_MPEG_OMIT_GOP_HEADER;
-		if (go->repeat_seqhead)
-			mpeg->flags |= GO7007_MPEG_REPEAT_SEQHEADER;
-		if (go->dvd_mode)
-			mpeg->flags |= GO7007_MPEG_FORCE_DVD_MODE;
-		return 0;
-	}
 	case GO7007IOC_S_MD_PARAMS:
 	{
 		struct go7007_md_params *mdp = arg;
@@ -1449,25 +1232,6 @@ static int vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *
 			go->modet[mdp->region].enable = 0;
 		/* fall-through */
 	}
-	case GO7007IOC_G_MD_PARAMS:
-	{
-		struct go7007_md_params *mdp = arg;
-		int region = mdp->region;
-
-		if (mdp->region > 3)
-			return -EINVAL;
-		memset(mdp, 0, sizeof(struct go7007_md_params));
-		mdp->region = region;
-		if (!go->modet[region].enable)
-			return 0;
-		mdp->pixel_threshold =
-			(go->modet[region].pixel_threshold << 1) + 1;
-		mdp->motion_threshold =
-			(go->modet[region].motion_threshold << 1) + 1;
-		mdp->trigger =
-			(go->modet[region].mb_threshold << 1) + 1;
-		return 0;
-	}
 	case GO7007IOC_S_MD_REGION:
 	{
 		struct go7007_md_region *region = arg;
@@ -1590,10 +1354,6 @@ static struct v4l2_file_operations go7007_fops = {
 	.poll		= go7007_poll,
 };
 
-static struct v4l2_ctrl_ops go7007_ctrl_ops = {
-	.s_ctrl = go7007_s_ctrl,
-};
-
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_querycap          = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid_cap,
@@ -1645,29 +1405,18 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
 	struct v4l2_ctrl *ctrl;
 
 	v4l2_ctrl_handler_init(hdl, 12);
-	v4l2_ctrl_new_std_menu(hdl, &go7007_ctrl_ops,
-			V4L2_CID_MPEG_STREAM_TYPE,
-			V4L2_MPEG_STREAM_TYPE_MPEG2_DVD,
-			0x7,
-			V4L2_MPEG_STREAM_TYPE_MPEG2_DVD);
-	v4l2_ctrl_new_std_menu(hdl, &go7007_ctrl_ops,
-			V4L2_CID_MPEG_VIDEO_ENCODING,
-			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC,
-			0,
-			V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
-	v4l2_ctrl_new_std_menu(hdl, &go7007_ctrl_ops,
-			V4L2_CID_MPEG_VIDEO_ASPECT,
-			V4L2_MPEG_VIDEO_ASPECT_16x9,
-			0,
-			V4L2_MPEG_VIDEO_ASPECT_1x1);
-	v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
+	go->mpeg_video_gop_size = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, 34, 1, 15);
-	v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
-			V4L2_CID_MPEG_VIDEO_GOP_CLOSURE, 0, 1, 1, 0);
-	v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
+	go->mpeg_video_gop_closure = v4l2_ctrl_new_std(hdl, NULL,
+			V4L2_CID_MPEG_VIDEO_GOP_CLOSURE, 0, 1, 1, 1);
+	go->mpeg_video_bitrate = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_MPEG_VIDEO_BITRATE,
-			64000, 10000000, 1, 1500000);
-	ctrl = v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
+			64000, 10000000, 1, 9800000);
+	go->mpeg_video_aspect_ratio = v4l2_ctrl_new_std_menu(hdl, NULL,
+			V4L2_CID_MPEG_VIDEO_ASPECT,
+			V4L2_MPEG_VIDEO_ASPECT_16x9, 0,
+			V4L2_MPEG_VIDEO_ASPECT_1x1);
+	ctrl = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_JPEG_ACTIVE_MARKER, 0,
 			V4L2_JPEG_ACTIVE_MARKER_DQT | V4L2_JPEG_ACTIVE_MARKER_DHT, 0,
 			V4L2_JPEG_ACTIVE_MARKER_DQT | V4L2_JPEG_ACTIVE_MARKER_DHT);
diff --git a/drivers/staging/media/go7007/go7007.h b/drivers/staging/media/go7007/go7007.h
index 7399c91..54b9897 100644
--- a/drivers/staging/media/go7007/go7007.h
+++ b/drivers/staging/media/go7007/go7007.h
@@ -17,72 +17,6 @@
  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  */
 
-/* DEPRECATED -- use V4L2_PIX_FMT_MPEG and then call GO7007IOC_S_MPEG_PARAMS
- * to select between MPEG1, MPEG2, and MPEG4 */
-#define V4L2_PIX_FMT_MPEG4     v4l2_fourcc('M', 'P', 'G', '4') /* MPEG4 */
-
-/* These will be replaced with a better interface
- * soon, so don't get too attached to them */
-#define	GO7007IOC_S_BITRATE	_IOW('V', BASE_VIDIOC_PRIVATE + 0, int)
-#define	GO7007IOC_G_BITRATE	_IOR('V', BASE_VIDIOC_PRIVATE + 1, int)
-
-enum go7007_aspect_ratio {
-	GO7007_ASPECT_RATIO_1_1 = 0,
-	GO7007_ASPECT_RATIO_4_3_NTSC = 1,
-	GO7007_ASPECT_RATIO_4_3_PAL = 2,
-	GO7007_ASPECT_RATIO_16_9_NTSC = 3,
-	GO7007_ASPECT_RATIO_16_9_PAL = 4,
-};
-
-/* Used to set generic compression parameters */
-struct go7007_comp_params {
-	__u32 gop_size;
-	__u32 max_b_frames;
-	enum go7007_aspect_ratio aspect_ratio;
-	__u32 flags;
-	__u32 reserved[8];
-};
-
-#define GO7007_COMP_CLOSED_GOP		0x00000001
-#define GO7007_COMP_OMIT_SEQ_HEADER	0x00000002
-
-enum go7007_mpeg_video_standard {
-	GO7007_MPEG_VIDEO_MPEG1 = 0,
-	GO7007_MPEG_VIDEO_MPEG2 = 1,
-	GO7007_MPEG_VIDEO_MPEG4 = 2,
-};
-
-/* Used to set parameters for V4L2_PIX_FMT_MPEG format */
-struct go7007_mpeg_params {
-	enum go7007_mpeg_video_standard mpeg_video_standard;
-	__u32 flags;
-	__u32 pali;
-	__u32 reserved[8];
-};
-
-#define GO7007_MPEG_FORCE_DVD_MODE	0x00000001
-#define GO7007_MPEG_OMIT_GOP_HEADER	0x00000002
-#define GO7007_MPEG_REPEAT_SEQHEADER	0x00000004
-
-#define GO7007_MPEG_PROFILE(format, pali)	(((format)<<24)|(pali))
-
-#define GO7007_MPEG2_PROFILE_MAIN_MAIN		GO7007_MPEG_PROFILE(2, 0x48)
-
-#define GO7007_MPEG4_PROFILE_S_L0		GO7007_MPEG_PROFILE(4, 0x08)
-#define GO7007_MPEG4_PROFILE_S_L1		GO7007_MPEG_PROFILE(4, 0x01)
-#define GO7007_MPEG4_PROFILE_S_L2		GO7007_MPEG_PROFILE(4, 0x02)
-#define GO7007_MPEG4_PROFILE_S_L3		GO7007_MPEG_PROFILE(4, 0x03)
-#define GO7007_MPEG4_PROFILE_ARTS_L1		GO7007_MPEG_PROFILE(4, 0x91)
-#define GO7007_MPEG4_PROFILE_ARTS_L2		GO7007_MPEG_PROFILE(4, 0x92)
-#define GO7007_MPEG4_PROFILE_ARTS_L3		GO7007_MPEG_PROFILE(4, 0x93)
-#define GO7007_MPEG4_PROFILE_ARTS_L4		GO7007_MPEG_PROFILE(4, 0x94)
-#define GO7007_MPEG4_PROFILE_AS_L0		GO7007_MPEG_PROFILE(4, 0xf0)
-#define GO7007_MPEG4_PROFILE_AS_L1		GO7007_MPEG_PROFILE(4, 0xf1)
-#define GO7007_MPEG4_PROFILE_AS_L2		GO7007_MPEG_PROFILE(4, 0xf2)
-#define GO7007_MPEG4_PROFILE_AS_L3		GO7007_MPEG_PROFILE(4, 0xf3)
-#define GO7007_MPEG4_PROFILE_AS_L4		GO7007_MPEG_PROFILE(4, 0xf4)
-#define GO7007_MPEG4_PROFILE_AS_L5		GO7007_MPEG_PROFILE(4, 0xf5)
-
 struct go7007_md_params {
 	__u16 region;
 	__u16 trigger;
@@ -98,14 +32,6 @@ struct go7007_md_region {
 	__u32 reserved[8];
 };
 
-#define	GO7007IOC_S_MPEG_PARAMS	_IOWR('V', BASE_VIDIOC_PRIVATE + 2, \
-					struct go7007_mpeg_params)
-#define	GO7007IOC_G_MPEG_PARAMS	_IOR('V', BASE_VIDIOC_PRIVATE + 3, \
-					struct go7007_mpeg_params)
-#define	GO7007IOC_S_COMP_PARAMS	_IOWR('V', BASE_VIDIOC_PRIVATE + 4, \
-					struct go7007_comp_params)
-#define	GO7007IOC_G_COMP_PARAMS	_IOR('V', BASE_VIDIOC_PRIVATE + 5, \
-					struct go7007_comp_params)
 #define	GO7007IOC_S_MD_PARAMS	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, \
 					struct go7007_md_params)
 #define	GO7007IOC_G_MD_PARAMS	_IOR('V', BASE_VIDIOC_PRIVATE + 7, \
-- 
1.7.10.4

