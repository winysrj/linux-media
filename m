Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1146 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaITJLx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 05:11:53 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8K9Bn1n020933
	for <linux-media@vger.kernel.org>; Sat, 20 Sep 2014 11:11:51 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 208AD2A002F
	for <linux-media@vger.kernel.org>; Sat, 20 Sep 2014 11:11:45 +0200 (CEST)
Message-ID: <541D44D0.5050806@xs4all.nl>
Date: Sat, 20 Sep 2014 11:11:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] vivid: add teletext support to VBI capture
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is useful to test teletext capture applications like alevt and mtt.

It also fixes a previously undetected bug where the PAL VBI start line
of the second field was off by one. Using the new field start defines
helps a lot fixing such bugs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/vivid.txt          | 10 ++--
 drivers/media/platform/vivid/vivid-vbi-cap.c | 43 +++++++++++-----
 drivers/media/platform/vivid/vivid-vbi-gen.c | 76 +++++++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-vbi-gen.h |  2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c |  7 +--
 drivers/media/platform/vivid/vivid-vid-cap.c |  2 +-
 drivers/media/platform/vivid/vivid-vid-out.c |  2 +-
 7 files changed, 117 insertions(+), 25 deletions(-)

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index 4f1d442..eeb11a2 100644
--- a/Documentation/video4linux/vivid.txt
+++ b/Documentation/video4linux/vivid.txt
@@ -422,7 +422,7 @@ generate Closed Caption and XDS data. The closed caption stream will
 alternate between "Hello world!" and "Closed captions test" every second.
 The XDS stream will give the current time once a minute. For 50 Hz standards
 it will generate the Wide Screen Signal which is based on the actual Video
-Aspect Ratio control setting.
+Aspect Ratio control setting and teletext pages 100-159, one page per frame.
 
 The VBI device will only work for the S-Video and TV inputs, it will give
 back an error if the current input is a webcam or HDMI.
@@ -435,8 +435,8 @@ There are three types of VBI output devices: those that only support raw
 (undecoded) VBI, those that only support sliced (decoded) VBI and those that
 support both. This is determined by the node_types module option.
 
-The sliced VBI output supports the Wide Screen Signal for 50 Hz standards
-and Closed Captioning + XDS for 60 Hz standards.
+The sliced VBI output supports the Wide Screen Signal and the teletext signal
+for 50 Hz standards and Closed Captioning + XDS for 60 Hz standards.
 
 The VBI device will only work for the S-Video output, it will give
 back an error if the current output is HDMI.
@@ -910,7 +910,8 @@ capture device.
 
 For VBI looping to work all of the above must be valid and in addition the vbi
 output must be configured for sliced VBI. The VBI capture side can be configured
-for either raw or sliced VBI.
+for either raw or sliced VBI. Note that at the moment only CC/XDS (60 Hz formats)
+and WSS (50 Hz formats) VBI data is looped. Teletext VBI data is not looped.
 
 
 Section 10.2: Radio & RDS Looping
@@ -1090,6 +1091,7 @@ Just as a reminder and in no particular order:
 - Add virtual sub-devices and media controller support
 - Some support for testing compressed video
 - Add support to loop raw VBI output to raw VBI input
+- Add support to loop teletext sliced VBI output to VBI input
 - Fix sequence/field numbering when looping of video with alternate fields
 - Add support for V4L2_CID_BG_COLOR for video outputs
 - Add ARGB888 overlay support: better testing of the alpha channel
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index e239cfd..2166d0b 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -37,25 +37,25 @@ static void vivid_sliced_vbi_cap_fill(struct vivid_dev *dev, unsigned seqnr)
 	if (!is_60hz) {
 		if (dev->loop_video) {
 			if (dev->vbi_out_have_wss) {
-				vbi_gen->data[0].data[0] = dev->vbi_out_wss[0];
-				vbi_gen->data[0].data[1] = dev->vbi_out_wss[1];
+				vbi_gen->data[12].data[0] = dev->vbi_out_wss[0];
+				vbi_gen->data[12].data[1] = dev->vbi_out_wss[1];
 			} else {
-				vbi_gen->data[0].id = 0;
+				vbi_gen->data[12].id = 0;
 			}
 		} else {
 			switch (tpg_g_video_aspect(&dev->tpg)) {
 			case TPG_VIDEO_ASPECT_14X9_CENTRE:
-				vbi_gen->data[0].data[0] = 0x01;
+				vbi_gen->data[12].data[0] = 0x01;
 				break;
 			case TPG_VIDEO_ASPECT_16X9_CENTRE:
-				vbi_gen->data[0].data[0] = 0x0b;
+				vbi_gen->data[12].data[0] = 0x0b;
 				break;
 			case TPG_VIDEO_ASPECT_16X9_ANAMORPHIC:
-				vbi_gen->data[0].data[0] = 0x07;
+				vbi_gen->data[12].data[0] = 0x07;
 				break;
 			case TPG_VIDEO_ASPECT_4X3:
 			default:
-				vbi_gen->data[0].data[0] = 0x08;
+				vbi_gen->data[12].data[0] = 0x08;
 				break;
 			}
 		}
@@ -83,8 +83,8 @@ static void vivid_g_fmt_vbi_cap(struct vivid_dev *dev, struct v4l2_vbi_format *v
 	vbi->offset = 24;
 	vbi->samples_per_line = 1440;
 	vbi->sample_format = V4L2_PIX_FMT_GREY;
-	vbi->start[0] = is_60hz ? 10 : 6;
-	vbi->start[1] = is_60hz ? 273 : 318;
+	vbi->start[0] = is_60hz ? V4L2_VBI_ITU_525_F1_START + 9 : V4L2_VBI_ITU_625_F1_START + 5;
+	vbi->start[1] = is_60hz ? V4L2_VBI_ITU_525_F2_START + 9 : V4L2_VBI_ITU_625_F2_START + 5;
 	vbi->count[0] = vbi->count[1] = is_60hz ? 12 : 18;
 	vbi->flags = dev->vbi_cap_interlaced ? V4L2_VBI_INTERLACED : 0;
 	vbi->reserved[0] = 0;
@@ -125,8 +125,10 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *bu
 
 	memset(vbuf, 0, vb2_plane_size(&buf->vb, 0));
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode)) {
-		vbuf[0] = dev->vbi_gen.data[0];
-		vbuf[1] = dev->vbi_gen.data[1];
+		unsigned i;
+
+		for (i = 0; i < 25; i++)
+			vbuf[i] = dev->vbi_gen.data[i];
 	}
 
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
@@ -280,8 +282,14 @@ void vivid_fill_service_lines(struct v4l2_sliced_vbi_format *vbi, u32 service_se
 		vbi->service_lines[0][21] = V4L2_SLICED_CAPTION_525;
 		vbi->service_lines[1][21] = V4L2_SLICED_CAPTION_525;
 	}
-	if (vbi->service_set & V4L2_SLICED_WSS_625)
+	if (vbi->service_set & V4L2_SLICED_WSS_625) {
+		unsigned i;
+
+		for (i = 7; i <= 18; i++)
+			vbi->service_lines[0][i] =
+			vbi->service_lines[1][i] = V4L2_SLICED_TELETEXT_B;
 		vbi->service_lines[0][23] = V4L2_SLICED_WSS_625;
+	}
 }
 
 int vidioc_g_fmt_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_format *fmt)
@@ -306,7 +314,8 @@ int vidioc_try_fmt_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_forma
 	if (!vivid_is_sdtv_cap(dev) || !dev->has_sliced_vbi_cap)
 		return -EINVAL;
 
-	service_set &= is_60hz ? V4L2_SLICED_CAPTION_525 : V4L2_SLICED_WSS_625;
+	service_set &= is_60hz ? V4L2_SLICED_CAPTION_525 :
+				 V4L2_SLICED_WSS_625 | V4L2_SLICED_TELETEXT_B;
 	vivid_fill_service_lines(vbi, service_set);
 	return 0;
 }
@@ -345,11 +354,17 @@ int vidioc_g_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_sliced_vbi_
 			return -EINVAL;
 	}
 
-	cap->service_set = is_60hz ? V4L2_SLICED_CAPTION_525 : V4L2_SLICED_WSS_625;
+	cap->service_set = is_60hz ? V4L2_SLICED_CAPTION_525 :
+				     V4L2_SLICED_WSS_625 | V4L2_SLICED_TELETEXT_B;
 	if (is_60hz) {
 		cap->service_lines[0][21] = V4L2_SLICED_CAPTION_525;
 		cap->service_lines[1][21] = V4L2_SLICED_CAPTION_525;
 	} else {
+		unsigned i;
+
+		for (i = 7; i <= 18; i++)
+			cap->service_lines[0][i] =
+			cap->service_lines[1][i] = V4L2_SLICED_TELETEXT_B;
 		cap->service_lines[0][23] = V4L2_SLICED_WSS_625;
 	}
 	return 0;
diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.c b/drivers/media/platform/vivid/vivid-vbi-gen.c
index 450ec3c..a2159de 100644
--- a/drivers/media/platform/vivid/vivid-vbi-gen.c
+++ b/drivers/media/platform/vivid/vivid-vbi-gen.c
@@ -57,6 +57,27 @@ static void vivid_vbi_gen_wss_raw(const struct v4l2_sliced_vbi_data *data,
 	}
 }
 
+static void vivid_vbi_gen_teletext_raw(const struct v4l2_sliced_vbi_data *data,
+		u8 *buf, unsigned sampling_rate)
+{
+	const unsigned rate = 6937500 / 10;	/* Teletext has a 6.9375 MHz transmission rate */
+	u8 teletext[45] = { 0x55, 0x55, 0x27 };
+	unsigned bit = 0;
+	int i;
+
+	memcpy(teletext + 3, data->data, sizeof(teletext) - 3);
+	/* prevents 32 bit overflow */
+	sampling_rate /= 10;
+
+	for (i = 0, bit = 0; bit < sizeof(teletext) * 8; bit++) {
+		unsigned n = ((bit + 1) * sampling_rate) / rate;
+		u8 val = (teletext[bit / 8] & (1 << (bit & 7))) ? 0xc0 : 0x10;
+
+		while (i < n)
+			buf[i++] = val;
+	}
+}
+
 static void cc_insert(u8 *cc, u8 ch)
 {
 	unsigned tot = 0;
@@ -102,7 +123,7 @@ void vivid_vbi_gen_raw(const struct vivid_vbi_gen_data *vbi,
 {
 	unsigned idx;
 
-	for (idx = 0; idx < 2; idx++) {
+	for (idx = 0; idx < 25; idx++) {
 		const struct v4l2_sliced_vbi_data *data = vbi->data + idx;
 		unsigned start_2nd_field;
 		unsigned line = data->line;
@@ -123,6 +144,8 @@ void vivid_vbi_gen_raw(const struct vivid_vbi_gen_data *vbi,
 			vivid_vbi_gen_cc_raw(data, linebuf, vbi_fmt->sampling_rate);
 		else if (data->id == V4L2_SLICED_WSS_625)
 			vivid_vbi_gen_wss_raw(data, linebuf, vbi_fmt->sampling_rate);
+		else if (data->id == V4L2_SLICED_TELETEXT_B)
+			vivid_vbi_gen_teletext_raw(data, linebuf, vbi_fmt->sampling_rate);
 	}
 }
 
@@ -197,6 +220,41 @@ static void vivid_vbi_gen_set_time_of_day(u8 *packet)
 	packet[15] = calc_parity(0x100 - checksum);
 }
 
+static const u8 hamming[16] = {
+	0x15, 0x02, 0x49, 0x5e, 0x64, 0x73, 0x38, 0x2f,
+	0xd0, 0xc7, 0x8c, 0x9b, 0xa1, 0xb6, 0xfd, 0xea
+};
+
+static void vivid_vbi_gen_teletext(u8 *packet, unsigned line, unsigned frame)
+{
+	unsigned offset = 2;
+	unsigned i;
+
+	packet[0] = hamming[1 + ((line & 1) << 3)];
+	packet[1] = hamming[line >> 1];
+	memset(packet + 2, 0x20, 40);
+	if (line == 0) {
+		/* subcode */
+		packet[2] = hamming[frame % 10];
+		packet[3] = hamming[frame / 10];
+		packet[4] = hamming[0];
+		packet[5] = hamming[0];
+		packet[6] = hamming[0];
+		packet[7] = hamming[0];
+		packet[8] = hamming[0];
+		packet[9] = hamming[1];
+		offset = 10;
+	}
+	packet += offset;
+	memcpy(packet, "Page: 100 Row: 10", 17);
+	packet[7] = '0' + frame / 10;
+	packet[8] = '0' + frame % 10;
+	packet[15] = '0' + line / 10;
+	packet[16] = '0' + line % 10;
+	for (i = 0; i < 42 - offset; i++)
+		packet[i] = calc_parity(packet[i]);
+}
+
 void vivid_vbi_gen_sliced(struct vivid_vbi_gen_data *vbi,
 		bool is_60hz, unsigned seqnr)
 {
@@ -207,10 +265,26 @@ void vivid_vbi_gen_sliced(struct vivid_vbi_gen_data *vbi,
 	memset(vbi->data, 0, sizeof(vbi->data));
 
 	if (!is_60hz) {
+		unsigned i;
+
+		for (i = 0; i <= 11; i++) {
+			data0->id = V4L2_SLICED_TELETEXT_B;
+			data0->line = 7 + i;
+			vivid_vbi_gen_teletext(data0->data, i, frame);
+			data0++;
+		}
 		data0->id = V4L2_SLICED_WSS_625;
 		data0->line = 23;
 		/* 4x3 video aspect ratio */
 		data0->data[0] = 0x08;
+		data0++;
+		for (i = 0; i <= 11; i++) {
+			data0->id = V4L2_SLICED_TELETEXT_B;
+			data0->field = 1;
+			data0->line = 7 + i;
+			vivid_vbi_gen_teletext(data0->data, 12 + i, frame);
+			data0++;
+		}
 		return;
 	}
 
diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.h b/drivers/media/platform/vivid/vivid-vbi-gen.h
index 401dd47..8444abe 100644
--- a/drivers/media/platform/vivid/vivid-vbi-gen.h
+++ b/drivers/media/platform/vivid/vivid-vbi-gen.h
@@ -21,7 +21,7 @@
 #define _VIVID_VBI_GEN_H_
 
 struct vivid_vbi_gen_data {
-	struct v4l2_sliced_vbi_data data[2];
+	struct v4l2_sliced_vbi_data data[25];
 	u8 time_of_day_packet[16];
 };
 
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 039316d..9d00a07 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -149,8 +149,8 @@ int vidioc_g_fmt_vbi_out(struct file *file, void *priv,
 	vbi->offset = 24;
 	vbi->samples_per_line = 1440;
 	vbi->sample_format = V4L2_PIX_FMT_GREY;
-	vbi->start[0] = is_60hz ? 10 : 6;
-	vbi->start[1] = is_60hz ? 273 : 318;
+	vbi->start[0] = is_60hz ? V4L2_VBI_ITU_525_F1_START + 9 : V4L2_VBI_ITU_625_F1_START + 5;
+	vbi->start[1] = is_60hz ? V4L2_VBI_ITU_525_F2_START + 9 : V4L2_VBI_ITU_625_F2_START + 5;
 	vbi->count[0] = vbi->count[1] = is_60hz ? 12 : 18;
 	vbi->flags = dev->vbi_cap_interlaced ? V4L2_VBI_INTERLACED : 0;
 	vbi->reserved[0] = 0;
@@ -195,7 +195,8 @@ int vidioc_try_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_forma
 	if (!vivid_is_svid_out(dev) || !dev->has_sliced_vbi_out)
 		return -EINVAL;
 
-	service_set &= is_60hz ? V4L2_SLICED_CAPTION_525 : V4L2_SLICED_WSS_625;
+	service_set &= is_60hz ? V4L2_SLICED_CAPTION_525 :
+				 V4L2_SLICED_WSS_625 | V4L2_SLICED_TELETEXT_B;
 	vivid_fill_service_lines(vbi, service_set);
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index b016aed..331c544 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -419,7 +419,7 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 		} else {
 			dev->src_rect.height = 576;
 			dev->timeperframe_vid_cap = (struct v4l2_fract) { 1000, 25000 };
-			dev->service_set_cap = V4L2_SLICED_WSS_625;
+			dev->service_set_cap = V4L2_SLICED_WSS_625 | V4L2_SLICED_TELETEXT_B;
 		}
 		tpg_s_rgb_range(&dev->tpg, V4L2_DV_RGB_RANGE_AUTO);
 		break;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index d0e0e95..69c2dbd 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -234,7 +234,7 @@ void vivid_update_format_out(struct vivid_dev *dev)
 		} else {
 			dev->sink_rect.height = 576;
 			dev->timeperframe_vid_out = (struct v4l2_fract) { 1000, 25000 };
-			dev->service_set_out = V4L2_SLICED_WSS_625;
+			dev->service_set_out = V4L2_SLICED_WSS_625 | V4L2_SLICED_TELETEXT_B;
 		}
 		dev->colorspace_out = V4L2_COLORSPACE_SMPTE170M;
 		break;
-- 
2.1.0

