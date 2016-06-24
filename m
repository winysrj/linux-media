Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 03/19] cx18: use macros instead of static const vars
Date: Fri, 24 Jun 2016 12:31:44 -0300
Message-Id: <318de7911feddb452a92c43fe67cc01dc3878daf.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gcc 6.1 now complains about unused vars:

drivers/media/pci/cx18/cx18-driver.h:497:18: warning: 'vbi_hblank_samples_50Hz' defined but not used [-Wunused-const-variable=]
 static const u32 vbi_hblank_samples_50Hz = 284; /* 4 byte EAV + 280 anc/fill */
                  ^~~~~~~~~~~~~~~~~~~~~~~
drivers/media/pci/cx18/cx18-driver.h:496:18: warning: 'vbi_hblank_samples_60Hz' defined but not used [-Wunused-const-variable=]
 static const u32 vbi_hblank_samples_60Hz = 272; /* 4 byte EAV + 268 anc/fill */
                  ^~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/media/pci/cx18/cx18-cards.c:25:0:
drivers/media/pci/cx18/cx18-driver.h:497:18: warning: 'vbi_hblank_samples_50Hz' defined but not used [-Wunused-const-variable=]
 static const u32 vbi_hblank_samples_50Hz = 284; /* 4 byte EAV + 280 anc/fill */
                  ^~~~~~~~~~~~~~~~~~~~~~~
drivers/media/pci/cx18/cx18-driver.h:496:18: warning: 'vbi_hblank_samples_60Hz' defined but not used [-Wunused-const-variable=]
 static const u32 vbi_hblank_samples_60Hz = 272; /* 4 byte EAV + 268 anc/fill */
                  ^~~~~~~~~~~~~~~~~~~~~~~
drivers/media/pci/cx18/cx18-driver.h:495:18: warning: 'vbi_active_samples' defined but not used [-Wunused-const-variable=]
 static const u32 vbi_active_samples = 1444; /* 4 byte SAV + 720 Y + 720 U/V */
                  ^~~~~~~~~~~~~~~~~~

In this specific case, this is somewhat intentional, as those
values are actually used in parts of the driver. The code assumes
that gcc optimizer it and not actually create any var, but convert
it to immediate access at the routines.

Yet, as we want to shut up gcc warnings, let's use #define, with
is the standard way to store values that will use assembler's
immediate access code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx18/cx18-driver.c  |  2 +-
 drivers/media/pci/cx18/cx18-driver.h  |  6 +++---
 drivers/media/pci/cx18/cx18-ioctl.c   |  2 +-
 drivers/media/pci/cx18/cx18-streams.c | 12 ++++++------
 drivers/media/pci/cx18/cx18-vbi.c     |  6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 260e462d91b4..2f23b26b16c0 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -560,7 +560,7 @@ static void cx18_process_options(struct cx18 *cx)
 	cx->stream_buf_size[CX18_ENC_STREAM_TYPE_MPG] = enc_mpg_bufsize;
 	cx->stream_buf_size[CX18_ENC_STREAM_TYPE_IDX] = enc_idx_bufsize;
 	cx->stream_buf_size[CX18_ENC_STREAM_TYPE_YUV] = enc_yuv_bufsize;
-	cx->stream_buf_size[CX18_ENC_STREAM_TYPE_VBI] = vbi_active_samples * 36;
+	cx->stream_buf_size[CX18_ENC_STREAM_TYPE_VBI] = VBI_ACTIVE_SAMPLES * 36;
 	cx->stream_buf_size[CX18_ENC_STREAM_TYPE_PCM] = enc_pcm_bufsize;
 	cx->stream_buf_size[CX18_ENC_STREAM_TYPE_RAD] = 0; /* control no data */
 
diff --git a/drivers/media/pci/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
index 47ce80fa73b9..ef308a10e870 100644
--- a/drivers/media/pci/cx18/cx18-driver.h
+++ b/drivers/media/pci/cx18/cx18-driver.h
@@ -492,9 +492,9 @@ struct cx18_card;
  *  (1/15.625 kHz) * 2 * 13.5 MHz = 1728 samples/line =
  *  4 bytes SAV + 280 bytes anc data + 4 bytes SAV + 1440 active samples
  */
-static const u32 vbi_active_samples = 1444; /* 4 byte SAV + 720 Y + 720 U/V */
-static const u32 vbi_hblank_samples_60Hz = 272; /* 4 byte EAV + 268 anc/fill */
-static const u32 vbi_hblank_samples_50Hz = 284; /* 4 byte EAV + 280 anc/fill */
+#define VBI_ACTIVE_SAMPLES	1444 /* 4 byte SAV + 720 Y + 720 U/V */
+#define VBI_HBLANK_SAMPLES_60HZ	272 /* 4 byte EAV + 268 anc/fill */
+#define VBI_HBLANK_SAMPLES_50HZ	284 /* 4 byte EAV + 280 anc/fill */
 
 #define CX18_VBI_FRAMES 32
 
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index eeb741c7db1b..fecca2a63891 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -177,7 +177,7 @@ static int cx18_g_fmt_vbi_cap(struct file *file, void *fh,
 
 	vbifmt->sampling_rate = 27000000;
 	vbifmt->offset = 248; /* FIXME - slightly wrong for both 50 & 60 Hz */
-	vbifmt->samples_per_line = vbi_active_samples - 4;
+	vbifmt->samples_per_line = VBI_ACTIVE_SAMPLES - 4;
 	vbifmt->sample_format = V4L2_PIX_FMT_GREY;
 	vbifmt->start[0] = cx->vbi.start[0];
 	vbifmt->start[1] = cx->vbi.start[1];
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index c9860845264f..f3802ec1b383 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -605,9 +605,9 @@ static void cx18_vbi_setup(struct cx18_stream *s)
 	/* Lines per field */
 	data[1] = (lines / 2) | ((lines / 2) << 16);
 	/* bytes per line */
-	data[2] = (raw ? vbi_active_samples
-		       : (cx->is_60hz ? vbi_hblank_samples_60Hz
-				      : vbi_hblank_samples_50Hz));
+	data[2] = (raw ? VBI_ACTIVE_SAMPLES
+		       : (cx->is_60hz ? VBI_HBLANK_SAMPLES_60HZ
+				      : VBI_HBLANK_SAMPLES_50HZ));
 	/* Every X number of frames a VBI interrupt arrives
 	   (frames as in 25 or 30 fps) */
 	data[3] = 1;
@@ -761,7 +761,7 @@ static void cx18_stream_configure_mdls(struct cx18_stream *s)
 		s->bufs_per_mdl = 1;
 		if  (cx18_raw_vbi(s->cx)) {
 			s->mdl_size = (s->cx->is_60hz ? 12 : 18)
-						       * 2 * vbi_active_samples;
+						       * 2 * VBI_ACTIVE_SAMPLES;
 		} else {
 			/*
 			 * See comment in cx18_vbi_setup() below about the
@@ -769,8 +769,8 @@ static void cx18_stream_configure_mdls(struct cx18_stream *s)
 			 * the lines on which EAV RP codes toggle.
 			*/
 			s->mdl_size = s->cx->is_60hz
-				   ? (21 - 4 + 1) * 2 * vbi_hblank_samples_60Hz
-				   : (23 - 2 + 1) * 2 * vbi_hblank_samples_50Hz;
+				   ? (21 - 4 + 1) * 2 * VBI_HBLANK_SAMPLES_60HZ
+				   : (23 - 2 + 1) * 2 * VBI_HBLANK_SAMPLES_50HZ;
 		}
 		break;
 	default:
diff --git a/drivers/media/pci/cx18/cx18-vbi.c b/drivers/media/pci/cx18/cx18-vbi.c
index add99642f1e2..43360cbcf24b 100644
--- a/drivers/media/pci/cx18/cx18-vbi.c
+++ b/drivers/media/pci/cx18/cx18-vbi.c
@@ -108,7 +108,7 @@ static void copy_vbi_data(struct cx18 *cx, int lines, u32 pts_stamp)
 /* FIXME - this function ignores the input size. */
 static u32 compress_raw_buf(struct cx18 *cx, u8 *buf, u32 size, u32 hdr_size)
 {
-	u32 line_size = vbi_active_samples;
+	u32 line_size = VBI_ACTIVE_SAMPLES;
 	u32 lines = cx->vbi.count * 2;
 	u8 *q = buf;
 	u8 *p;
@@ -145,8 +145,8 @@ static u32 compress_sliced_buf(struct cx18 *cx, u8 *buf, u32 size,
 	struct v4l2_decode_vbi_line vbi;
 	int i;
 	u32 line = 0;
-	u32 line_size = cx->is_60hz ? vbi_hblank_samples_60Hz
-				    : vbi_hblank_samples_50Hz;
+	u32 line_size = cx->is_60hz ? VBI_HBLANK_SAMPLES_60HZ
+				    : VBI_HBLANK_SAMPLES_50HZ;
 
 	/* find the first valid line */
 	for (i = hdr_size, buf += hdr_size; i < size; i++, buf++) {
-- 
2.7.4


