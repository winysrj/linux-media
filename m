Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40357 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaBJT3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 14:29:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 1/5] msi3101: convert to SDR API
Date: Mon, 10 Feb 2014 21:28:59 +0200
Message-Id: <1392060543-3972-2-git-send-email-crope@iki.fi>
In-Reply-To: <1392060543-3972-1-git-send-email-crope@iki.fi>
References: <1392060543-3972-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Massive rewrite. Use SDR API. Fix bugs.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 1352 ++++++++++++---------------
 1 file changed, 574 insertions(+), 778 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 4c3bf77..d076d10 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -21,20 +21,6 @@
  *  (C) 1999-2004 Nemosoft Unv.
  *  (C) 2004-2006 Luc Saillard (luc@saillard.org)
  *  (C) 2011 Hans de Goede <hdegoede@redhat.com>
- *
- * Development tree of that driver will be on:
- * http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/mirics
- *
- * GNU Radio plugin "gr-kernel" for device usage will be on:
- * http://git.linuxtv.org/anttip/gr-kernel.git
- *
- * TODO:
- * Help is very highly welcome for these + all the others you could imagine:
- * - split USB ADC interface and RF tuner to own drivers (msi2500 and msi001)
- * - move controls to V4L2 API
- * - use libv4l2 for stream format conversions
- * - gr-kernel: switch to v4l2_mmap (current read eats a lot of cpu)
- * - SDRSharp support
  */
 
 #include <linux/module.h>
@@ -48,317 +34,6 @@
 #include <linux/usb.h>
 #include <media/videobuf2-vmalloc.h>
 
-struct msi3101_gain {
-	u8 tot:7;
-	u8 baseband:6;
-	bool lna:1;
-	bool mixer:1;
-};
-
-/* 60 – 120 MHz band, lna 24dB, mixer 19dB */
-static const struct msi3101_gain msi3101_gain_lut_120[] = {
-	{  0,  0,  0,  0},
-	{  1,  1,  0,  0},
-	{  2,  2,  0,  0},
-	{  3,  3,  0,  0},
-	{  4,  4,  0,  0},
-	{  5,  5,  0,  0},
-	{  6,  6,  0,  0},
-	{  7,  7,  0,  0},
-	{  8,  8,  0,  0},
-	{  9,  9,  0,  0},
-	{ 10, 10,  0,  0},
-	{ 11, 11,  0,  0},
-	{ 12, 12,  0,  0},
-	{ 13, 13,  0,  0},
-	{ 14, 14,  0,  0},
-	{ 15, 15,  0,  0},
-	{ 16, 16,  0,  0},
-	{ 17, 17,  0,  0},
-	{ 18, 18,  0,  0},
-	{ 19, 19,  0,  0},
-	{ 20, 20,  0,  0},
-	{ 21, 21,  0,  0},
-	{ 22, 22,  0,  0},
-	{ 23, 23,  0,  0},
-	{ 24, 24,  0,  0},
-	{ 25, 25,  0,  0},
-	{ 26, 26,  0,  0},
-	{ 27, 27,  0,  0},
-	{ 28, 28,  0,  0},
-	{ 29,  5,  1,  0},
-	{ 30,  6,  1,  0},
-	{ 31,  7,  1,  0},
-	{ 32,  8,  1,  0},
-	{ 33,  9,  1,  0},
-	{ 34, 10,  1,  0},
-	{ 35, 11,  1,  0},
-	{ 36, 12,  1,  0},
-	{ 37, 13,  1,  0},
-	{ 38, 14,  1,  0},
-	{ 39, 15,  1,  0},
-	{ 40, 16,  1,  0},
-	{ 41, 17,  1,  0},
-	{ 42, 18,  1,  0},
-	{ 43, 19,  1,  0},
-	{ 44, 20,  1,  0},
-	{ 45, 21,  1,  0},
-	{ 46, 22,  1,  0},
-	{ 47, 23,  1,  0},
-	{ 48, 24,  1,  0},
-	{ 49, 25,  1,  0},
-	{ 50, 26,  1,  0},
-	{ 51, 27,  1,  0},
-	{ 52, 28,  1,  0},
-	{ 53, 29,  1,  0},
-	{ 54, 30,  1,  0},
-	{ 55, 31,  1,  0},
-	{ 56, 32,  1,  0},
-	{ 57, 33,  1,  0},
-	{ 58, 34,  1,  0},
-	{ 59, 35,  1,  0},
-	{ 60, 36,  1,  0},
-	{ 61, 37,  1,  0},
-	{ 62, 38,  1,  0},
-	{ 63, 39,  1,  0},
-	{ 64, 40,  1,  0},
-	{ 65, 41,  1,  0},
-	{ 66, 42,  1,  0},
-	{ 67, 43,  1,  0},
-	{ 68, 44,  1,  0},
-	{ 69, 45,  1,  0},
-	{ 70, 46,  1,  0},
-	{ 71, 47,  1,  0},
-	{ 72, 48,  1,  0},
-	{ 73, 49,  1,  0},
-	{ 74, 50,  1,  0},
-	{ 75, 51,  1,  0},
-	{ 76, 52,  1,  0},
-	{ 77, 53,  1,  0},
-	{ 78, 54,  1,  0},
-	{ 79, 55,  1,  0},
-	{ 80, 56,  1,  0},
-	{ 81, 57,  1,  0},
-	{ 82, 58,  1,  0},
-	{ 83, 40,  1,  1},
-	{ 84, 41,  1,  1},
-	{ 85, 42,  1,  1},
-	{ 86, 43,  1,  1},
-	{ 87, 44,  1,  1},
-	{ 88, 45,  1,  1},
-	{ 89, 46,  1,  1},
-	{ 90, 47,  1,  1},
-	{ 91, 48,  1,  1},
-	{ 92, 49,  1,  1},
-	{ 93, 50,  1,  1},
-	{ 94, 51,  1,  1},
-	{ 95, 52,  1,  1},
-	{ 96, 53,  1,  1},
-	{ 97, 54,  1,  1},
-	{ 98, 55,  1,  1},
-	{ 99, 56,  1,  1},
-	{100, 57,  1,  1},
-	{101, 58,  1,  1},
-	{102, 59,  1,  1},
-};
-
-/* 120 – 245 MHz band, lna 24dB, mixer 19dB */
-static const struct msi3101_gain msi3101_gain_lut_245[] = {
-	{  0,  0,  0,  0},
-	{  1,  1,  0,  0},
-	{  2,  2,  0,  0},
-	{  3,  3,  0,  0},
-	{  4,  4,  0,  0},
-	{  5,  5,  0,  0},
-	{  6,  6,  0,  0},
-	{  7,  7,  0,  0},
-	{  8,  8,  0,  0},
-	{  9,  9,  0,  0},
-	{ 10, 10,  0,  0},
-	{ 11, 11,  0,  0},
-	{ 12, 12,  0,  0},
-	{ 13, 13,  0,  0},
-	{ 14, 14,  0,  0},
-	{ 15, 15,  0,  0},
-	{ 16, 16,  0,  0},
-	{ 17, 17,  0,  0},
-	{ 18, 18,  0,  0},
-	{ 19, 19,  0,  0},
-	{ 20, 20,  0,  0},
-	{ 21, 21,  0,  0},
-	{ 22, 22,  0,  0},
-	{ 23, 23,  0,  0},
-	{ 24, 24,  0,  0},
-	{ 25, 25,  0,  0},
-	{ 26, 26,  0,  0},
-	{ 27, 27,  0,  0},
-	{ 28, 28,  0,  0},
-	{ 29,  5,  1,  0},
-	{ 30,  6,  1,  0},
-	{ 31,  7,  1,  0},
-	{ 32,  8,  1,  0},
-	{ 33,  9,  1,  0},
-	{ 34, 10,  1,  0},
-	{ 35, 11,  1,  0},
-	{ 36, 12,  1,  0},
-	{ 37, 13,  1,  0},
-	{ 38, 14,  1,  0},
-	{ 39, 15,  1,  0},
-	{ 40, 16,  1,  0},
-	{ 41, 17,  1,  0},
-	{ 42, 18,  1,  0},
-	{ 43, 19,  1,  0},
-	{ 44, 20,  1,  0},
-	{ 45, 21,  1,  0},
-	{ 46, 22,  1,  0},
-	{ 47, 23,  1,  0},
-	{ 48, 24,  1,  0},
-	{ 49, 25,  1,  0},
-	{ 50, 26,  1,  0},
-	{ 51, 27,  1,  0},
-	{ 52, 28,  1,  0},
-	{ 53, 29,  1,  0},
-	{ 54, 30,  1,  0},
-	{ 55, 31,  1,  0},
-	{ 56, 32,  1,  0},
-	{ 57, 33,  1,  0},
-	{ 58, 34,  1,  0},
-	{ 59, 35,  1,  0},
-	{ 60, 36,  1,  0},
-	{ 61, 37,  1,  0},
-	{ 62, 38,  1,  0},
-	{ 63, 39,  1,  0},
-	{ 64, 40,  1,  0},
-	{ 65, 41,  1,  0},
-	{ 66, 42,  1,  0},
-	{ 67, 43,  1,  0},
-	{ 68, 44,  1,  0},
-	{ 69, 45,  1,  0},
-	{ 70, 46,  1,  0},
-	{ 71, 47,  1,  0},
-	{ 72, 48,  1,  0},
-	{ 73, 49,  1,  0},
-	{ 74, 50,  1,  0},
-	{ 75, 51,  1,  0},
-	{ 76, 52,  1,  0},
-	{ 77, 53,  1,  0},
-	{ 78, 54,  1,  0},
-	{ 79, 55,  1,  0},
-	{ 80, 56,  1,  0},
-	{ 81, 57,  1,  0},
-	{ 82, 58,  1,  0},
-	{ 83, 40,  1,  1},
-	{ 84, 41,  1,  1},
-	{ 85, 42,  1,  1},
-	{ 86, 43,  1,  1},
-	{ 87, 44,  1,  1},
-	{ 88, 45,  1,  1},
-	{ 89, 46,  1,  1},
-	{ 90, 47,  1,  1},
-	{ 91, 48,  1,  1},
-	{ 92, 49,  1,  1},
-	{ 93, 50,  1,  1},
-	{ 94, 51,  1,  1},
-	{ 95, 52,  1,  1},
-	{ 96, 53,  1,  1},
-	{ 97, 54,  1,  1},
-	{ 98, 55,  1,  1},
-	{ 99, 56,  1,  1},
-	{100, 57,  1,  1},
-	{101, 58,  1,  1},
-	{102, 59,  1,  1},
-};
-
-/* 420 – 1000 MHz band, lna 7dB, mixer 19dB */
-static const struct msi3101_gain msi3101_gain_lut_1000[] = {
-	{  0,  0, 0,  0},
-	{  1,  1, 0,  0},
-	{  2,  2, 0,  0},
-	{  3,  3, 0,  0},
-	{  4,  4, 0,  0},
-	{  5,  5, 0,  0},
-	{  6,  6, 0,  0},
-	{  7,  7, 0,  0},
-	{  8,  8, 0,  0},
-	{  9,  9, 0,  0},
-	{ 10, 10, 0,  0},
-	{ 11, 11, 0,  0},
-	{ 12,  5, 1,  0},
-	{ 13,  6, 1,  0},
-	{ 14,  7, 1,  0},
-	{ 15,  8, 1,  0},
-	{ 16,  9, 1,  0},
-	{ 17, 10, 1,  0},
-	{ 18, 11, 1,  0},
-	{ 19, 12, 1,  0},
-	{ 20, 13, 1,  0},
-	{ 21, 14, 1,  0},
-	{ 22, 15, 1,  0},
-	{ 23, 16, 1,  0},
-	{ 24, 17, 1,  0},
-	{ 25, 18, 1,  0},
-	{ 26, 19, 1,  0},
-	{ 27, 20, 1,  0},
-	{ 28, 21, 1,  0},
-	{ 29, 22, 1,  0},
-	{ 30, 23, 1,  0},
-	{ 31, 24, 1,  0},
-	{ 32, 25, 1,  0},
-	{ 33, 26, 1,  0},
-	{ 34, 27, 1,  0},
-	{ 35, 28, 1,  0},
-	{ 36, 29, 1,  0},
-	{ 37, 30, 1,  0},
-	{ 38, 31, 1,  0},
-	{ 39, 32, 1,  0},
-	{ 40, 33, 1,  0},
-	{ 41, 34, 1,  0},
-	{ 42, 35, 1,  0},
-	{ 43, 36, 1,  0},
-	{ 44, 37, 1,  0},
-	{ 45, 38, 1,  0},
-	{ 46, 39, 1,  0},
-	{ 47, 40, 1,  0},
-	{ 48, 41, 1,  0},
-	{ 49, 42, 1,  0},
-	{ 50, 43, 1,  0},
-	{ 51, 44, 1,  0},
-	{ 52, 45, 1,  0},
-	{ 53, 46, 1,  0},
-	{ 54, 47, 1,  0},
-	{ 55, 48, 1,  0},
-	{ 56, 49, 1,  0},
-	{ 57, 50, 1,  0},
-	{ 58, 51, 1,  0},
-	{ 59, 52, 1,  0},
-	{ 60, 53, 1,  0},
-	{ 61, 54, 1,  0},
-	{ 62, 55, 1,  0},
-	{ 63, 56, 1,  0},
-	{ 64, 57, 1,  0},
-	{ 65, 58, 1,  0},
-	{ 66, 40, 1,  1},
-	{ 67, 41, 1,  1},
-	{ 68, 42, 1,  1},
-	{ 69, 43, 1,  1},
-	{ 70, 44, 1,  1},
-	{ 71, 45, 1,  1},
-	{ 72, 46, 1,  1},
-	{ 73, 47, 1,  1},
-	{ 74, 48, 1,  1},
-	{ 75, 49, 1,  1},
-	{ 76, 50, 1,  1},
-	{ 77, 51, 1,  1},
-	{ 78, 52, 1,  1},
-	{ 79, 53, 1,  1},
-	{ 80, 54, 1,  1},
-	{ 81, 55, 1,  1},
-	{ 82, 56, 1,  1},
-	{ 83, 57, 1,  1},
-	{ 84, 58, 1,  1},
-	{ 85, 59, 1,  1},
-};
-
 /*
  *   iConfiguration          0
  *     bInterfaceNumber        0
@@ -377,13 +52,72 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 #define MAX_ISOC_ERRORS         20
 
 /* TODO: These should be moved to V4L2 API */
-#define MSI3101_CID_SAMPLING_MODE         ((V4L2_CID_USER_BASE | 0xf000) + 0)
-#define MSI3101_CID_SAMPLING_RATE         ((V4L2_CID_USER_BASE | 0xf000) + 1)
-#define MSI3101_CID_SAMPLING_RESOLUTION   ((V4L2_CID_USER_BASE | 0xf000) + 2)
-#define MSI3101_CID_TUNER_RF              ((V4L2_CID_USER_BASE | 0xf000) + 10)
-#define MSI3101_CID_TUNER_BW              ((V4L2_CID_USER_BASE | 0xf000) + 11)
-#define MSI3101_CID_TUNER_IF              ((V4L2_CID_USER_BASE | 0xf000) + 12)
-#define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
+#define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
+#define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
+#define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
+#define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
+
+static const struct v4l2_frequency_band bands_adc[] = {
+	{
+		.tuner = 0,
+		.type = V4L2_TUNER_ADC,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  1200000,
+		.rangehigh  = 15000000,
+	},
+};
+
+static const struct v4l2_frequency_band bands_rf[] = {
+	{
+		.tuner = 1,
+		.type = V4L2_TUNER_RF,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =   49000000,
+		.rangehigh  =  263000000,
+	}, {
+		.tuner = 1,
+		.type = V4L2_TUNER_RF,
+		.index = 1,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  390000000,
+		.rangehigh  =  960000000,
+	},
+};
+
+/* stream formats */
+struct msi3101_format {
+	char	*name;
+	u32	pixelformat;
+};
+
+/* format descriptions for capture and preview */
+static struct msi3101_format formats[] = {
+	{
+		.name		= "IQ U8",
+		.pixelformat	= V4L2_SDR_FMT_CU8,
+	}, {
+		.name		= "IQ U16LE",
+		.pixelformat	=  V4L2_SDR_FMT_CU16LE,
+#if 0
+	}, {
+		.name		= "8-bit signed",
+		.pixelformat	= V4L2_PIX_FMT_SDR_S8,
+	}, {
+		.name		= "10+2-bit signed",
+		.pixelformat	= V4L2_PIX_FMT_SDR_MSI2500_384,
+	}, {
+		.name		= "12-bit signed",
+		.pixelformat	= V4L2_PIX_FMT_SDR_S12,
+	}, {
+		.name		= "14-bit signed",
+		.pixelformat	= V4L2_PIX_FMT_SDR_S14,
+#endif
+	},
+};
+
+static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct msi3101_frame_buf {
@@ -407,24 +141,30 @@ struct msi3101_state {
 	/* Pointer to our usb_device, will be NULL after unplug */
 	struct usb_device *udev; /* Both mutexes most be hold when setting! */
 
+	unsigned int f_adc, f_tuner;
+	u32 pixelformat;
+
 	unsigned int isoc_errors; /* number of contiguous ISOC errors */
 	unsigned int vb_full; /* vb is full and packets dropped */
 
 	struct urb *urbs[MAX_ISO_BUFS];
-	int (*convert_stream) (struct msi3101_state *s, u32 *dst, u8 *src,
+	int (*convert_stream) (struct msi3101_state *s, u8 *dst, u8 *src,
 			unsigned int src_len);
 
 	/* Controls */
-	struct v4l2_ctrl_handler ctrl_handler;
-	struct v4l2_ctrl *ctrl_sampling_rate;
-	struct v4l2_ctrl *ctrl_tuner_rf;
-	struct v4l2_ctrl *ctrl_tuner_bw;
-	struct v4l2_ctrl *ctrl_tuner_if;
-	struct v4l2_ctrl *ctrl_tuner_gain;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *bandwidth_auto;
+	struct v4l2_ctrl *bandwidth;
+	struct v4l2_ctrl *lna_gain_auto;
+	struct v4l2_ctrl *lna_gain;
+	struct v4l2_ctrl *mixer_gain_auto;
+	struct v4l2_ctrl *mixer_gain;
+	struct v4l2_ctrl *if_gain_auto;
+	struct v4l2_ctrl *if_gain;
 
 	u32 next_sample; /* for track lost packets */
 	u32 sample; /* for sample rate calc */
-	unsigned long jiffies;
+	unsigned long jiffies_next;
 	unsigned int sample_ctrl_bit[4];
 };
 
@@ -448,98 +188,79 @@ leave:
 
 /*
  * +===========================================================================
- * |   00-1023 | USB packet type '384'
+ * |   00-1023 | USB packet type '504'
  * +===========================================================================
  * |   00-  03 | sequence number of first sample in that USB packet
  * +---------------------------------------------------------------------------
  * |   04-  15 | garbage
  * +---------------------------------------------------------------------------
- * |   16- 175 | samples
- * +---------------------------------------------------------------------------
- * |  176- 179 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  180- 339 | samples
- * +---------------------------------------------------------------------------
- * |  340- 343 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  344- 503 | samples
- * +---------------------------------------------------------------------------
- * |  504- 507 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  508- 667 | samples
- * +---------------------------------------------------------------------------
- * |  668- 671 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  672- 831 | samples
- * +---------------------------------------------------------------------------
- * |  832- 835 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  836- 995 | samples
- * +---------------------------------------------------------------------------
- * |  996- 999 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * | 1000-1023 | garbage
+ * |   16-1023 | samples
  * +---------------------------------------------------------------------------
- *
- * Bytes 4 - 7 could have some meaning?
- *
- * Control bits for previous samples is 32-bit field, containing 16 x 2-bit
- * numbers. This results one 2-bit number for 8 samples. It is likely used for
- * for bit shifting sample by given bits, increasing actual sampling resolution.
- * Number 2 (0b10) was never seen.
- *
- * 6 * 16 * 2 * 4 = 768 samples. 768 * 4 = 3072 bytes
+ * signed 8-bit sample
+ * 504 * 2 = 1008 samples
  */
+static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
+		u8 *src, unsigned int src_len)
+{
+	int i, i_max, dst_len = 0;
+	u32 sample_num[3];
 
-/*
- * Integer to 32-bit IEEE floating point representation routine is taken
- * from Radeon R600 driver (drivers/gpu/drm/radeon/r600_blit_kms.c).
- *
- * TODO: Currently we do conversion here in Kernel, but in future that will
- * be moved to the libv4l2 library as video format conversions are.
- */
-#define I2F_FRAC_BITS  23
-#define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
+	/* There could be 1-3 1024 bytes URB frames */
+	i_max = src_len / 1024;
 
-/*
- * Converts signed 8-bit integer into 32-bit IEEE floating point
- * representation.
- */
-static u32 msi3101_convert_sample_504(struct msi3101_state *s, u16 x)
-{
-	u32 msb, exponent, fraction, sign;
+	for (i = 0; i < i_max; i++) {
+		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
+		if (i == 0 && s->next_sample != sample_num[0]) {
+			dev_dbg_ratelimited(&s->udev->dev,
+					"%d samples lost, %d %08x:%08x\n",
+					sample_num[0] - s->next_sample,
+					src_len, s->next_sample, sample_num[0]);
+		}
 
-	/* Zero is special */
-	if (!x)
-		return 0;
+		/*
+		 * Dump all unknown 'garbage' data - maybe we will discover
+		 * someday if there is something rational...
+		 */
+		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
 
-	/* Negative / positive value */
-	if (x & (1 << 7)) {
-		x = -x;
-		x &= 0x7f; /* result is 7 bit ... + sign */
-		sign = 1 << 31;
-	} else {
-		sign = 0 << 31;
+		/* 504 x I+Q samples */
+		src += 16;
+		memcpy(dst, src, 1008);
+		src += 1008;
+		dst += 1008;
+		dst_len += 1008;
 	}
 
-	/* Get location of the most significant bit */
-	msb = __fls(x);
+	/* calculate samping rate and output it in 10 seconds intervals */
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+		unsigned long jiffies_now = jiffies;
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
+		unsigned int samples = sample_num[i_max - 1] - s->sample;
+		s->jiffies_next = jiffies_now;
+		s->sample = sample_num[i_max - 1];
+		dev_dbg(&s->udev->dev,
+				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
+				src_len, samples, msecs,
+				samples * 1000UL / msecs);
+	}
 
-	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
-	exponent = (127 + msb) << I2F_FRAC_BITS;
+	/* next sample (sample = sample + i * 504) */
+	s->next_sample = sample_num[i_max - 1] + 504;
 
-	return (fraction + exponent) | sign;
+	return dst_len;
 }
 
-static int msi3101_convert_stream_504(struct msi3101_state *s, u32 *dst,
+static int msi3101_convert_stream_504_u8(struct msi3101_state *s, u8 *dst,
 		u8 *src, unsigned int src_len)
 {
 	int i, j, i_max, dst_len = 0;
-	u16 sample[2];
 	u32 sample_num[3];
+	s8 *s8src;
+	u8 *u8dst;
 
 	/* There could be 1-3 1024 bytes URB frames */
 	i_max = src_len / 1024;
+	u8dst = (u8 *) dst;
 
 	for (i = 0; i < i_max; i++) {
 		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
@@ -556,30 +277,28 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u32 *dst,
 		 */
 		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
 
+		/* 504 x I+Q samples */
 		src += 16;
-		for (j = 0; j < 1008; j += 2) {
-			sample[0] = src[j + 0];
-			sample[1] = src[j + 1];
 
-			*dst++ = msi3101_convert_sample_504(s, sample[0]);
-			*dst++ = msi3101_convert_sample_504(s, sample[1]);
-		}
-		/* 504 x I+Q 32bit float samples */
-		dst_len += 504 * 2 * 4;
+		s8src = (s8 *) src;
+		for (j = 0; j < 1008; j++)
+			*u8dst++ = *s8src++ + 128;
+
 		src += 1008;
+		dst += 1008;
+		dst_len += 1008;
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
-		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
+#define MSECS 10000UL
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-		s->jiffies = jiffies_now;
+		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
 				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
-				src_len, samples, msecs,
-				samples * 1000UL / msecs);
+				src_len, samples, MSECS,
+				samples * 1000UL / MSECS);
 	}
 
 	/* next sample (sample = sample + i * 504) */
@@ -589,48 +308,53 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u32 *dst,
 }
 
 /*
- * Converts signed ~10+2-bit integer into 32-bit IEEE floating point
- * representation.
+ * +===========================================================================
+ * |   00-1023 | USB packet type '384'
+ * +===========================================================================
+ * |   00-  03 | sequence number of first sample in that USB packet
+ * +---------------------------------------------------------------------------
+ * |   04-  15 | garbage
+ * +---------------------------------------------------------------------------
+ * |   16- 175 | samples
+ * +---------------------------------------------------------------------------
+ * |  176- 179 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  180- 339 | samples
+ * +---------------------------------------------------------------------------
+ * |  340- 343 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  344- 503 | samples
+ * +---------------------------------------------------------------------------
+ * |  504- 507 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  508- 667 | samples
+ * +---------------------------------------------------------------------------
+ * |  668- 671 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  672- 831 | samples
+ * +---------------------------------------------------------------------------
+ * |  832- 835 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  836- 995 | samples
+ * +---------------------------------------------------------------------------
+ * |  996- 999 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * | 1000-1023 | garbage
+ * +---------------------------------------------------------------------------
+ *
+ * Bytes 4 - 7 could have some meaning?
+ *
+ * Control bits for previous samples is 32-bit field, containing 16 x 2-bit
+ * numbers. This results one 2-bit number for 8 samples. It is likely used for
+ * for bit shifting sample by given bits, increasing actual sampling resolution.
+ * Number 2 (0b10) was never seen.
+ *
+ * 6 * 16 * 2 * 4 = 768 samples. 768 * 4 = 3072 bytes
  */
-static u32 msi3101_convert_sample_384(struct msi3101_state *s, u16 x, int shift)
-{
-	u32 msb, exponent, fraction, sign;
-	s->sample_ctrl_bit[shift]++;
-
-	/* Zero is special */
-	if (!x)
-		return 0;
-
-	if (shift == 3)
-		shift =	2;
-
-	/* Convert 10-bit two's complement to 12-bit */
-	if (x & (1 << 9)) {
-		x |= ~0U << 10; /* set all the rest bits to one */
-		x <<= shift;
-		x = -x;
-		x &= 0x7ff; /* result is 11 bit ... + sign */
-		sign = 1 << 31;
-	} else {
-		x <<= shift;
-		sign = 0 << 31;
-	}
-
-	/* Get location of the most significant bit */
-	msb = __fls(x);
-
-	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
-	exponent = (127 + msb) << I2F_FRAC_BITS;
-
-	return (fraction + exponent) | sign;
-}
-
-static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
+static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
 		u8 *src, unsigned int src_len)
 {
-	int i, j, k, l, i_max, dst_len = 0;
-	u16 sample[4];
-	u32 bits;
+	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
 
 	/* There could be 1-3 1024 bytes URB frames */
@@ -651,38 +375,20 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
 		dev_dbg_ratelimited(&s->udev->dev,
 				"%*ph  %*ph\n", 12, &src[4], 24, &src[1000]);
 
+		/* 384 x I+Q samples */
 		src += 16;
-		for (j = 0; j < 6; j++) {
-			bits = src[160 + 3] << 24 | src[160 + 2] << 16 | src[160 + 1] << 8 | src[160 + 0] << 0;
-			for (k = 0; k < 16; k++) {
-				for (l = 0; l < 10; l += 5) {
-					sample[0] = (src[l + 0] & 0xff) >> 0 | (src[l + 1] & 0x03) << 8;
-					sample[1] = (src[l + 1] & 0xfc) >> 2 | (src[l + 2] & 0x0f) << 6;
-					sample[2] = (src[l + 2] & 0xf0) >> 4 | (src[l + 3] & 0x3f) << 4;
-					sample[3] = (src[l + 3] & 0xc0) >> 6 | (src[l + 4] & 0xff) << 2;
-
-					*dst++ = msi3101_convert_sample_384(s, sample[0], (bits >> (2 * k)) & 0x3);
-					*dst++ = msi3101_convert_sample_384(s, sample[1], (bits >> (2 * k)) & 0x3);
-					*dst++ = msi3101_convert_sample_384(s, sample[2], (bits >> (2 * k)) & 0x3);
-					*dst++ = msi3101_convert_sample_384(s, sample[3], (bits >> (2 * k)) & 0x3);
-				}
-				src += 10;
-			}
-			dev_dbg_ratelimited(&s->udev->dev,
-					"sample control bits %08x\n", bits);
-			src += 4;
-		}
-		/* 384 x I+Q 32bit float samples */
-		dst_len += 384 * 2 * 4;
-		src += 24;
+		memcpy(dst, src, 984);
+		src += 984 + 24;
+		dst += 984;
+		dst_len += 984;
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-		s->jiffies = jiffies_now;
+		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
 				"slen=%d samples=%u msecs=%lu sampling rate=%lu bits=%d.%d.%d.%d\n",
@@ -699,40 +405,21 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
 }
 
 /*
- * Converts signed 12-bit integer into 32-bit IEEE floating point
- * representation.
+ * +===========================================================================
+ * |   00-1023 | USB packet type '336'
+ * +===========================================================================
+ * |   00-  03 | sequence number of first sample in that USB packet
+ * +---------------------------------------------------------------------------
+ * |   04-  15 | garbage
+ * +---------------------------------------------------------------------------
+ * |   16-1023 | samples
+ * +---------------------------------------------------------------------------
+ * signed 12-bit sample
  */
-static u32 msi3101_convert_sample_336(struct msi3101_state *s, u16 x)
-{
-	u32 msb, exponent, fraction, sign;
-
-	/* Zero is special */
-	if (!x)
-		return 0;
-
-	/* Negative / positive value */
-	if (x & (1 << 11)) {
-		x = -x;
-		x &= 0x7ff; /* result is 11 bit ... + sign */
-		sign = 1 << 31;
-	} else {
-		sign = 0 << 31;
-	}
-
-	/* Get location of the most significant bit */
-	msb = __fls(x);
-
-	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
-	exponent = (127 + msb) << I2F_FRAC_BITS;
-
-	return (fraction + exponent) | sign;
-}
-
-static int msi3101_convert_stream_336(struct msi3101_state *s, u32 *dst,
+static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
 		u8 *src, unsigned int src_len)
 {
-	int i, j, i_max, dst_len = 0;
-	u16 sample[2];
+	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
 
 	/* There could be 1-3 1024 bytes URB frames */
@@ -753,25 +440,20 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u32 *dst,
 		 */
 		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
 
+		/* 336 x I+Q samples */
 		src += 16;
-		for (j = 0; j < 1008; j += 3) {
-			sample[0] = (src[j + 0] & 0xff) >> 0 | (src[j + 1] & 0x0f) << 8;
-			sample[1] = (src[j + 1] & 0xf0) >> 4 | (src[j + 2] & 0xff) << 4;
-
-			*dst++ = msi3101_convert_sample_336(s, sample[0]);
-			*dst++ = msi3101_convert_sample_336(s, sample[1]);
-		}
-		/* 336 x I+Q 32bit float samples */
-		dst_len += 336 * 2 * 4;
+		memcpy(dst, src, 1008);
 		src += 1008;
+		dst += 1008;
+		dst_len += 1008;
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-		s->jiffies = jiffies_now;
+		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
 				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
@@ -786,41 +468,75 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u32 *dst,
 }
 
 /*
- * Converts signed 14-bit integer into 32-bit IEEE floating point
- * representation.
+ * +===========================================================================
+ * |   00-1023 | USB packet type '252'
+ * +===========================================================================
+ * |   00-  03 | sequence number of first sample in that USB packet
+ * +---------------------------------------------------------------------------
+ * |   04-  15 | garbage
+ * +---------------------------------------------------------------------------
+ * |   16-1023 | samples
+ * +---------------------------------------------------------------------------
+ * signed 14-bit sample
  */
-static u32 msi3101_convert_sample_252(struct msi3101_state *s, u16 x)
+static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
+		u8 *src, unsigned int src_len)
 {
-	u32 msb, exponent, fraction, sign;
+	int i, i_max, dst_len = 0;
+	u32 sample_num[3];
 
-	/* Zero is special */
-	if (!x)
-		return 0;
+	/* There could be 1-3 1024 bytes URB frames */
+	i_max = src_len / 1024;
 
-	/* Negative / positive value */
-	if (x & (1 << 13)) {
-		x = -x;
-		x &= 0x1fff; /* result is 13 bit ... + sign */
-		sign = 1 << 31;
-	} else {
-		sign = 0 << 31;
+	for (i = 0; i < i_max; i++) {
+		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
+		if (i == 0 && s->next_sample != sample_num[0]) {
+			dev_dbg_ratelimited(&s->udev->dev,
+					"%d samples lost, %d %08x:%08x\n",
+					sample_num[0] - s->next_sample,
+					src_len, s->next_sample, sample_num[0]);
+		}
+
+		/*
+		 * Dump all unknown 'garbage' data - maybe we will discover
+		 * someday if there is something rational...
+		 */
+		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
+
+		/* 252 x I+Q samples */
+		src += 16;
+		memcpy(dst, src, 1008);
+		src += 1008;
+		dst += 1008;
+		dst_len += 1008;
 	}
 
-	/* Get location of the most significant bit */
-	msb = __fls(x);
+	/* calculate samping rate and output it in 10 seconds intervals */
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+		unsigned long jiffies_now = jiffies;
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
+		unsigned int samples = sample_num[i_max - 1] - s->sample;
+		s->jiffies_next = jiffies_now;
+		s->sample = sample_num[i_max - 1];
+		dev_dbg(&s->udev->dev,
+				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
+				src_len, samples, msecs,
+				samples * 1000UL / msecs);
+	}
 
-	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
-	exponent = (127 + msb) << I2F_FRAC_BITS;
+	/* next sample (sample = sample + i * 252) */
+	s->next_sample = sample_num[i_max - 1] + 252;
 
-	return (fraction + exponent) | sign;
+	return dst_len;
 }
 
-static int msi3101_convert_stream_252(struct msi3101_state *s, u32 *dst,
+static int msi3101_convert_stream_252_u16(struct msi3101_state *s, u8 *dst,
 		u8 *src, unsigned int src_len)
 {
 	int i, j, i_max, dst_len = 0;
-	u16 sample[2];
 	u32 sample_num[3];
+	u16 *u16dst = (u16 *) dst;
+	struct {signed int x:14;} se;
 
 	/* There could be 1-3 1024 bytes URB frames */
 	i_max = src_len / 1024;
@@ -840,30 +556,44 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u32 *dst,
 		 */
 		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
 
+		/* 252 x I+Q samples */
 		src += 16;
+
 		for (j = 0; j < 1008; j += 4) {
-			sample[0] = src[j + 0] >> 0 | src[j + 1] << 8;
-			sample[1] = src[j + 2] >> 0 | src[j + 3] << 8;
+			unsigned int usample[2];
+			int ssample[2];
 
-			*dst++ = msi3101_convert_sample_252(s, sample[0]);
-			*dst++ = msi3101_convert_sample_252(s, sample[1]);
+			usample[0] = src[j + 0] >> 0 | src[j + 1] << 8;
+			usample[1] = src[j + 2] >> 0 | src[j + 3] << 8;
+
+			/* sign extension from 14-bit to signed int */
+			ssample[0] = se.x = usample[0];
+			ssample[1] = se.x = usample[1];
+
+			/* from signed to unsigned */
+			usample[0] = ssample[0] + 8192;
+			usample[1] = ssample[1] + 8192;
+
+			/* from 14-bit to 16-bit */
+			*u16dst++ = (usample[0] << 2) | (usample[0] >> 12);
+			*u16dst++ = (usample[1] << 2) | (usample[1] >> 12);
 		}
-		/* 252 x I+Q 32bit float samples */
-		dst_len += 252 * 2 * 4;
+
 		src += 1008;
+		dst += 1008;
+		dst_len += 1008;
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
-		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
+#define MSECS 10000UL
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-		s->jiffies = jiffies_now;
+		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
 				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
-				src_len, samples, msecs,
-				samples * 1000UL / msecs);
+				src_len, samples, MSECS,
+				samples * 1000UL / MSECS);
 	}
 
 	/* next sample (sample = sample + i * 252) */
@@ -883,14 +613,14 @@ static void msi3101_isoc_handler(struct urb *urb)
 	unsigned char *iso_buf = NULL;
 	struct msi3101_frame_buf *fbuf;
 
-	if (urb->status == -ENOENT || urb->status == -ECONNRESET ||
-			urb->status == -ESHUTDOWN) {
+	if (unlikely(urb->status == -ENOENT || urb->status == -ECONNRESET ||
+			urb->status == -ESHUTDOWN)) {
 		dev_dbg(&s->udev->dev, "URB (%p) unlinked %ssynchronuously\n",
 				urb, urb->status == -ENOENT ? "" : "a");
 		return;
 	}
 
-	if (urb->status != 0) {
+	if (unlikely(urb->status != 0)) {
 		dev_dbg(&s->udev->dev,
 				"msi3101_isoc_handler() called with status %d\n",
 				urb->status);
@@ -910,28 +640,28 @@ static void msi3101_isoc_handler(struct urb *urb)
 
 		/* Check frame error */
 		fstatus = urb->iso_frame_desc[i].status;
-		if (fstatus) {
+		if (unlikely(fstatus)) {
 			dev_dbg_ratelimited(&s->udev->dev,
 					"frame=%d/%d has error %d skipping\n",
 					i, urb->number_of_packets, fstatus);
-			goto skip;
+			continue;
 		}
 
 		/* Check if that frame contains data */
 		flen = urb->iso_frame_desc[i].actual_length;
-		if (flen == 0)
-			goto skip;
+		if (unlikely(flen == 0))
+			continue;
 
 		iso_buf = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 
 		/* Get free framebuffer */
 		fbuf = msi3101_get_next_fill_buf(s);
-		if (fbuf == NULL) {
+		if (unlikely(fbuf == NULL)) {
 			s->vb_full++;
 			dev_dbg_ratelimited(&s->udev->dev,
 					"videobuf is full, %d packets dropped\n",
 					s->vb_full);
-			goto skip;
+			continue;
 		}
 
 		/* fill framebuffer */
@@ -939,13 +669,11 @@ static void msi3101_isoc_handler(struct urb *urb)
 		flen = s->convert_stream(s, ptr, iso_buf, flen);
 		vb2_set_plane_payload(&fbuf->vb, 0, flen);
 		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
-skip:
-		;
 	}
 
 handler_end:
 	i = usb_submit_urb(urb, GFP_ATOMIC);
-	if (i != 0)
+	if (unlikely(i != 0))
 		dev_dbg(&s->udev->dev,
 				"Error (%d) re-submitting urb in msi3101_isoc_handler\n",
 				i);
@@ -1008,7 +736,7 @@ static int msi3101_isoc_init(struct msi3101_state *s)
 	udev = s->udev;
 
 	ret = usb_set_interface(s->udev, 0, 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	/* Allocate and init Isochronuous urbs */
@@ -1112,14 +840,12 @@ static int msi3101_querycap(struct file *file, void *fh,
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
 	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
 	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-			V4L2_CAP_READWRITE;
-	cap->device_caps = V4L2_CAP_TUNER;
+	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
+			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-
 /* Videobuf2 operations */
 static int msi3101_queue_setup(struct vb2_queue *vq,
 		const struct v4l2_format *fmt, unsigned int *nbuffers,
@@ -1135,25 +861,14 @@ static int msi3101_queue_setup(struct vb2_queue *vq,
 	 *   3, wMaxPacketSize 3x 1024 bytes
 	 * 504, max IQ sample pairs per 1024 frame
 	 *   2, two samples, I and Q
-	 *   4, 32-bit float
+	 *   2, 16-bit is enough for single sample
 	 */
-	sizes[0] = PAGE_ALIGN(3 * 504 * 2 * 4); /* = 12096 */
+	sizes[0] = PAGE_ALIGN(3 * 504 * 2 * 2);
 	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
 			__func__, *nbuffers, sizes[0]);
 	return 0;
 }
 
-static int msi3101_buf_prepare(struct vb2_buffer *vb)
-{
-	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
-
-	/* Don't allow queing new buffers after device disconnection */
-	if (!s->udev)
-		return -ENODEV;
-
-	return 0;
-}
-
 static void msi3101_buf_queue(struct vb2_buffer *vb)
 {
 	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
@@ -1162,7 +877,7 @@ static void msi3101_buf_queue(struct vb2_buffer *vb)
 	unsigned long flags = 0;
 
 	/* Check the device has not disconnected between prep and queuing */
-	if (!s->udev) {
+	if (unlikely(!s->udev)) {
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
@@ -1221,29 +936,46 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	int ret, div_n, div_m, div_r_out, f_sr, f_vco, fract;
 	u32 reg3, reg4, reg7;
 
-	f_sr = s->ctrl_sampling_rate->val64;
+	f_sr = s->f_adc;
 
 	/* select stream format */
-	if (f_sr < 6000000) {
-		s->convert_stream = msi3101_convert_stream_252;
+	switch (s->pixelformat) {
+	case V4L2_SDR_FMT_CU8:
+		s->convert_stream = msi3101_convert_stream_504_u8;
+		reg7 = 0x000c9407;
+		break;
+	case  V4L2_SDR_FMT_CU16LE:
+		s->convert_stream = msi3101_convert_stream_252_u16;
 		reg7 = 0x00009407;
-	} else if (f_sr < 8000000) {
-		s->convert_stream = msi3101_convert_stream_336;
-		reg7 = 0x00008507;
-	} else if (f_sr < 9000000) {
+		break;
+	case V4L2_PIX_FMT_SDR_S8:
+		s->convert_stream = msi3101_convert_stream_504;
+		reg7 = 0x000c9407;
+		break;
+	case V4L2_PIX_FMT_SDR_MSI2500_384:
 		s->convert_stream = msi3101_convert_stream_384;
 		reg7 = 0x0000a507;
-	} else {
-		s->convert_stream = msi3101_convert_stream_504;
+		break;
+	case V4L2_PIX_FMT_SDR_S12:
+		s->convert_stream = msi3101_convert_stream_336;
+		reg7 = 0x00008507;
+		break;
+	case V4L2_PIX_FMT_SDR_S14:
+		s->convert_stream = msi3101_convert_stream_252;
+		reg7 = 0x00009407;
+		break;
+	default:
+		s->convert_stream = msi3101_convert_stream_504_u8;
 		reg7 = 0x000c9407;
+		break;
 	}
 
 	/*
 	 * Synthesizer config is just a educated guess...
 	 *
 	 * [7:0]   0x03, register address
-	 * [8]     1, always
-	 * [9]     ?
+	 * [8]     1, power control
+	 * [9]     ?, power control
 	 * [12:10] output divider
 	 * [13]    0 ?
 	 * [14]    0 ?
@@ -1334,14 +1066,37 @@ err:
 	return ret;
 };
 
+static int msi3101_set_gain(struct msi3101_state *s)
+{
+	int ret;
+	u32 reg;
+	dev_dbg(&s->udev->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,
+			s->lna_gain->val, s->mixer_gain->val, s->if_gain->val);
+
+	reg = 1 << 0;
+	reg |= (59 - s->if_gain->val) << 4;
+	reg |= 0 << 10;
+	reg |= (1 - s->mixer_gain->val) << 12;
+	reg |= (1 - s->lna_gain->val) << 13;
+	reg |= 4 << 14;
+	reg |= 0 << 17;
+	ret = msi3101_tuner_write(s, reg);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&s->udev->dev, "%s: failed %d\n", __func__, ret);
+	return ret;
+};
+
 static int msi3101_set_tuner(struct msi3101_state *s)
 {
-	int ret, i, len;
+	int ret, i;
 	unsigned int n, m, thresh, frac, vco_step, tmp, f_if1;
 	u32 reg;
 	u64 f_vco, tmp64;
 	u8 mode, filter_mode, lo_div;
-	const struct msi3101_gain *gain_lut;
 	static const struct {
 		u32 rf;
 		u8 mode;
@@ -1376,30 +1131,23 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 		{8000000, 0x07}, /* 8 MHz */
 	};
 
-	unsigned int f_rf = s->ctrl_tuner_rf->val64;
+	unsigned int f_rf = s->f_tuner;
 
 	/*
 	 * bandwidth (Hz)
 	 * 200000, 300000, 600000, 1536000, 5000000, 6000000, 7000000, 8000000
 	 */
-	unsigned int bandwidth = s->ctrl_tuner_bw->val;
+	unsigned int bandwidth;
 
 	/*
 	 * intermediate frequency (Hz)
 	 * 0, 450000, 1620000, 2048000
 	 */
-	unsigned int f_if = s->ctrl_tuner_if->val;
-
-	/*
-	 * gain reduction (dB)
-	 * 0 - 102 below 420 MHz
-	 * 0 - 85 above 420 MHz
-	 */
-	int gain = s->ctrl_tuner_gain->val;
+	unsigned int f_if = 0;
 
 	dev_dbg(&s->udev->dev,
-			"%s: f_rf=%d bandwidth=%d f_if=%d gain=%d\n",
-			__func__, f_rf, bandwidth, f_if, gain);
+			"%s: f_rf=%d f_if=%d\n",
+			__func__, f_rf, f_if);
 
 	ret = -EINVAL;
 
@@ -1430,8 +1178,16 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (i == ARRAY_SIZE(if_freq_lut))
 		goto err;
 
+	/* filters */
+	if (s->bandwidth_auto->val)
+		bandwidth = s->f_adc;
+	else
+		bandwidth = s->bandwidth->val;
+
+	bandwidth = clamp(bandwidth, 200000U, 8000000U);
+
 	for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
-		if (bandwidth == bandwidth_lut[i].freq) {
+		if (bandwidth <= bandwidth_lut[i].freq) {
 			bandwidth = bandwidth_lut[i].val;
 			break;
 		}
@@ -1440,6 +1196,11 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (i == ARRAY_SIZE(bandwidth_lut))
 		goto err;
 
+	s->bandwidth->val = bandwidth_lut[i].freq;
+
+	dev_dbg(&s->udev->dev, "%s: bandwidth selected=%d\n",
+			__func__, bandwidth_lut[i].freq);
+
 #define F_OUT_STEP 1
 #define R_REF 4
 	f_vco = (f_rf + f_if + f_if1) * lo_div;
@@ -1504,38 +1265,7 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (ret)
 		goto err;
 
-	if (f_rf < 120000000) {
-		gain_lut = msi3101_gain_lut_120;
-		len = ARRAY_SIZE(msi3101_gain_lut_120);
-	} else if (f_rf < 245000000) {
-		gain_lut = msi3101_gain_lut_245;
-		len = ARRAY_SIZE(msi3101_gain_lut_120);
-	} else {
-		gain_lut = msi3101_gain_lut_1000;
-		len = ARRAY_SIZE(msi3101_gain_lut_1000);
-	}
-
-	for (i = 0; i < len; i++) {
-		if (gain_lut[i].tot >= gain)
-			break;
-	}
-
-	if (i == len)
-		goto err;
-
-	dev_dbg(&s->udev->dev,
-			"%s: gain tot=%d baseband=%d lna=%d mixer=%d\n",
-			__func__, gain_lut[i].tot, gain_lut[i].baseband,
-			gain_lut[i].lna, gain_lut[i].mixer);
-
-	reg = 1 << 0;
-	reg |= gain_lut[i].baseband << 4;
-	reg |= 0 << 10;
-	reg |= gain_lut[i].mixer << 12;
-	reg |= gain_lut[i].lna << 13;
-	reg |= 4 << 14;
-	reg |= 0 << 17;
-	ret = msi3101_tuner_write(s, reg);
+	ret = msi3101_set_gain(s);
 	if (ret)
 		goto err;
 
@@ -1594,6 +1324,12 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
 	msleep(20);
 	msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0);
 
+	/* sleep USB IF / ADC */
+	msi3101_ctrl_msg(s, CMD_WREG, 0x01000003);
+
+	/* sleep tuner */
+	msi3101_tuner_write(s, 0x000000);
+
 	mutex_unlock(&s->v4l2_lock);
 
 	return 0;
@@ -1601,7 +1337,6 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
 
 static struct vb2_ops msi3101_vb2_ops = {
 	.queue_setup            = msi3101_queue_setup,
-	.buf_prepare            = msi3101_buf_prepare,
 	.buf_queue              = msi3101_buf_queue,
 	.start_streaming        = msi3101_start_streaming,
 	.stop_streaming         = msi3101_stop_streaming,
@@ -1609,30 +1344,77 @@ static struct vb2_ops msi3101_vb2_ops = {
 	.wait_finish            = vb2_ops_wait_finish,
 };
 
-static int msi3101_enum_input(struct file *file, void *fh, struct v4l2_input *i)
+static int msi3101_enum_fmt_sdr_cap(struct file *file, void *priv,
+		struct v4l2_fmtdesc *f)
 {
-	if (i->index != 0)
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, f->index);
+
+	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
 
-	strlcpy(i->name, "SDR data", sizeof(i->name));
-	i->type = V4L2_INPUT_TYPE_CAMERA;
+	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
+	f->pixelformat = formats[f->index].pixelformat;
+
+	return 0;
+}
+
+static int msi3101_g_fmt_sdr_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+			(char *)&s->pixelformat);
+
+	f->fmt.sdr.pixelformat = s->pixelformat;
 
 	return 0;
 }
 
-static int msi3101_g_input(struct file *file, void *fh, unsigned int *i)
+static int msi3101_s_fmt_sdr_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
 {
-	*i = 0;
+	struct msi3101_state *s = video_drvdata(file);
+	struct vb2_queue *q = &s->vb_queue;
+	int i;
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+			(char *)&f->fmt.sdr.pixelformat);
+
+	if (vb2_is_busy(q))
+		return -EBUSY;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
+			s->pixelformat = f->fmt.sdr.pixelformat;
+			return 0;
+		}
+	}
+
+	f->fmt.sdr.pixelformat = formats[0].pixelformat;
+	s->pixelformat = formats[0].pixelformat;
 
 	return 0;
 }
 
-static int msi3101_s_input(struct file *file, void *fh, unsigned int i)
+static int msi3101_try_fmt_sdr_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
 {
-	return i ? -EINVAL : 0;
+	struct msi3101_state *s = video_drvdata(file);
+	int i;
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+			(char *)&f->fmt.sdr.pixelformat);
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
+			return 0;
+	}
+
+	f->fmt.sdr.pixelformat = formats[0].pixelformat;
+
+	return 0;
 }
 
-static int vidioc_s_tuner(struct file *file, void *priv,
+static int msi3101_s_tuner(struct file *file, void *priv,
 		const struct v4l2_tuner *v)
 {
 	struct msi3101_state *s = video_drvdata(file);
@@ -1641,34 +1423,113 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
+static int msi3101_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 {
 	struct msi3101_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
-	strcpy(v->name, "SDR RX");
-	v->capability = V4L2_TUNER_CAP_LOW;
+	if (v->index == 0) {
+		strlcpy(v->name, "ADC: Mirics MSi2500", sizeof(v->name));
+		v->type = V4L2_TUNER_ADC;
+		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		v->rangelow =   1200000;
+		v->rangehigh = 15000000;
+	} else if (v->index == 1) {
+		strlcpy(v->name, "RF: Mirics MSi001", sizeof(v->name));
+		v->type = V4L2_TUNER_RF;
+		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		v->rangelow =    49000000;
+		v->rangehigh =  960000000;
+	} else {
+		return -EINVAL;
+	}
 
 	return 0;
 }
 
-static int vidioc_s_frequency(struct file *file, void *priv,
+static int msi3101_g_frequency(struct file *file, void *priv,
+		struct v4l2_frequency *f)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	int ret  = 0;
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
+			__func__, f->tuner, f->type);
+
+	if (f->tuner == 0)
+		f->frequency = s->f_adc;
+	else if (f->tuner == 1)
+		f->frequency = s->f_tuner;
+	else
+		return -EINVAL;
+
+	return ret;
+}
+
+static int msi3101_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s: frequency=%lu Hz (%u)\n",
-			__func__, f->frequency * 625UL / 10UL, f->frequency);
+	int ret, band;
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
+			__func__, f->tuner, f->type, f->frequency);
+
+	if (f->tuner == 0) {
+		s->f_adc = clamp_t(unsigned int, f->frequency,
+				bands_adc[0].rangelow,
+				bands_adc[0].rangehigh);
+		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
+				__func__, s->f_adc);
+		ret = msi3101_set_usb_adc(s);
+	} else if (f->tuner == 1) {
+		#define BAND_RF_0 ((bands_rf[0].rangehigh + bands_rf[1].rangelow) / 2)
+		if (f->frequency < BAND_RF_0)
+			band = 0;
+		else
+			band = 1;
+		s->f_tuner = clamp_t(unsigned int, f->frequency,
+				bands_rf[band].rangelow,
+				bands_rf[band].rangehigh);
+		dev_dbg(&s->udev->dev, "%s: RF frequency=%u Hz\n",
+				__func__, f->frequency);
+		ret = msi3101_set_tuner(s);
+	} else {
+		return -EINVAL;
+	}
 
-	return v4l2_ctrl_s_ctrl_int64(s->ctrl_tuner_rf,
-			f->frequency * 625UL / 10UL);
+	return ret;
+}
+
+static int msi3101_enum_freq_bands(struct file *file, void *priv,
+		struct v4l2_frequency_band *band)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
+			__func__, band->tuner, band->type, band->index);
+
+	if (band->tuner == 0) {
+		if (band->index >= ARRAY_SIZE(bands_adc))
+			return -EINVAL;
+
+		*band = bands_adc[band->index];
+	} else if (band->tuner == 1) {
+		if (band->index >= ARRAY_SIZE(bands_rf))
+			return -EINVAL;
+
+		*band = bands_rf[band->index];
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
 	.vidioc_querycap          = msi3101_querycap,
 
-	.vidioc_enum_input        = msi3101_enum_input,
-	.vidioc_g_input           = msi3101_g_input,
-	.vidioc_s_input           = msi3101_s_input,
+	.vidioc_enum_fmt_sdr_cap  = msi3101_enum_fmt_sdr_cap,
+	.vidioc_g_fmt_sdr_cap     = msi3101_g_fmt_sdr_cap,
+	.vidioc_s_fmt_sdr_cap     = msi3101_s_fmt_sdr_cap,
+	.vidioc_try_fmt_sdr_cap   = msi3101_try_fmt_sdr_cap,
 
 	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
@@ -1680,9 +1541,12 @@ static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
 	.vidioc_streamon          = vb2_ioctl_streamon,
 	.vidioc_streamoff         = vb2_ioctl_streamoff,
 
-	.vidioc_g_tuner           = vidioc_g_tuner,
-	.vidioc_s_tuner           = vidioc_s_tuner,
-	.vidioc_s_frequency       = vidioc_s_frequency,
+	.vidioc_g_tuner           = msi3101_g_tuner,
+	.vidioc_s_tuner           = msi3101_s_tuner,
+
+	.vidioc_g_frequency       = msi3101_g_frequency,
+	.vidioc_s_frequency       = msi3101_s_frequency,
+	.vidioc_enum_freq_bands   = msi3101_enum_freq_bands,
 
 	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
@@ -1704,13 +1568,14 @@ static struct video_device msi3101_template = {
 	.release                  = video_device_release_empty,
 	.fops                     = &msi3101_fops,
 	.ioctl_ops                = &msi3101_ioctl_ops,
+	.debug                    = 0,
 };
 
 static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct msi3101_state *s =
 			container_of(ctrl->handler, struct msi3101_state,
-					ctrl_handler);
+					hdl);
 	int ret;
 	dev_dbg(&s->udev->dev,
 			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
@@ -1718,18 +1583,17 @@ static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
 	switch (ctrl->id) {
-	case MSI3101_CID_SAMPLING_MODE:
-	case MSI3101_CID_SAMPLING_RATE:
-	case MSI3101_CID_SAMPLING_RESOLUTION:
-		ret = 0;
-		break;
-	case MSI3101_CID_TUNER_RF:
-	case MSI3101_CID_TUNER_BW:
-	case MSI3101_CID_TUNER_IF:
-	case MSI3101_CID_TUNER_GAIN:
+	case V4L2_CID_BANDWIDTH_AUTO:
+	case V4L2_CID_BANDWIDTH:
 		ret = msi3101_set_tuner(s);
 		break;
+	case  V4L2_CID_LNA_GAIN:
+	case  V4L2_CID_MIXER_GAIN:
+	case  V4L2_CID_IF_GAIN:
+		ret = msi3101_set_gain(s);
+		break;
 	default:
+		dev_dbg(&s->udev->dev, "%s: EINVAL\n", __func__);
 		ret = -EINVAL;
 	}
 
@@ -1745,7 +1609,7 @@ static void msi3101_video_release(struct v4l2_device *v)
 	struct msi3101_state *s =
 			container_of(v, struct msi3101_state, v4l2_dev);
 
-	v4l2_ctrl_handler_free(&s->ctrl_handler);
+	v4l2_ctrl_handler_free(&s->hdl);
 	v4l2_device_unregister(&s->v4l2_dev);
 	kfree(s);
 }
@@ -1755,81 +1619,8 @@ static int msi3101_probe(struct usb_interface *intf,
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct msi3101_state *s = NULL;
+	const struct v4l2_ctrl_ops *ops = &msi3101_ctrl_ops;
 	int ret;
-	static const char * const ctrl_sampling_mode_qmenu_strings[] = {
-		"Quadrature Sampling",
-		NULL,
-	};
-	static const struct v4l2_ctrl_config ctrl_sampling_mode = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_SAMPLING_MODE,
-		.type   = V4L2_CTRL_TYPE_MENU,
-		.flags  = V4L2_CTRL_FLAG_INACTIVE,
-		.name	= "Sampling Mode",
-		.qmenu  = ctrl_sampling_mode_qmenu_strings,
-	};
-	static const struct v4l2_ctrl_config ctrl_sampling_rate = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_SAMPLING_RATE,
-		.type	= V4L2_CTRL_TYPE_INTEGER64,
-		.name	= "Sampling Rate",
-		.min	= 500000,
-		.max	= 12000000,
-		.def    = 2048000,
-		.step	= 1,
-	};
-	static const struct v4l2_ctrl_config ctrl_sampling_resolution = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_SAMPLING_RESOLUTION,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.flags  = V4L2_CTRL_FLAG_INACTIVE,
-		.name	= "Sampling Resolution",
-		.min	= 10,
-		.max	= 10,
-		.def    = 10,
-		.step	= 1,
-	};
-	static const struct v4l2_ctrl_config ctrl_tuner_rf = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_TUNER_RF,
-		.type   = V4L2_CTRL_TYPE_INTEGER64,
-		.name	= "Tuner RF",
-		.min	= 40000000,
-		.max	= 2000000000,
-		.def    = 100000000,
-		.step	= 1,
-	};
-	static const struct v4l2_ctrl_config ctrl_tuner_bw = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_TUNER_BW,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.name	= "Tuner BW",
-		.min	= 200000,
-		.max	= 8000000,
-		.def    = 600000,
-		.step	= 1,
-	};
-	static const struct v4l2_ctrl_config ctrl_tuner_if = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_TUNER_IF,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.flags  = V4L2_CTRL_FLAG_INACTIVE,
-		.name	= "Tuner IF",
-		.min	= 0,
-		.max	= 2048000,
-		.def    = 0,
-		.step	= 1,
-	};
-	static const struct v4l2_ctrl_config ctrl_tuner_gain = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_TUNER_GAIN,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.name	= "Tuner Gain",
-		.min	= 0,
-		.max	= 102,
-		.def    = 0,
-		.step	= 1,
-	};
 
 	s = kzalloc(sizeof(struct msi3101_state), GFP_KERNEL);
 	if (s == NULL) {
@@ -1841,11 +1632,12 @@ static int msi3101_probe(struct usb_interface *intf,
 	mutex_init(&s->vb_queue_lock);
 	spin_lock_init(&s->queued_bufs_lock);
 	INIT_LIST_HEAD(&s->queued_bufs);
-
 	s->udev = udev;
+	s->f_adc = bands_adc[0].rangelow;
+	s->pixelformat = V4L2_SDR_FMT_CU8;
 
 	/* Init videobuf2 queue structure */
-	s->vb_queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
 	s->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 	s->vb_queue.drv_priv = s;
 	s->vb_queue.buf_struct_size = sizeof(struct msi3101_frame_buf);
@@ -1853,7 +1645,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	s->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	s->vb_queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	ret = vb2_queue_init(&s->vb_queue);
-	if (ret < 0) {
+	if (ret) {
 		dev_err(&s->udev->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
 	}
@@ -1866,16 +1658,20 @@ static int msi3101_probe(struct usb_interface *intf,
 	video_set_drvdata(&s->vdev, s);
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&s->ctrl_handler, 7);
-	v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_mode, NULL);
-	s->ctrl_sampling_rate = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_rate, NULL);
-	v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_resolution, NULL);
-	s->ctrl_tuner_rf = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_rf, NULL);
-	s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_bw, NULL);
-	s->ctrl_tuner_if = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_if, NULL);
-	s->ctrl_tuner_gain = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_gain, NULL);
-	if (s->ctrl_handler.error) {
-		ret = s->ctrl_handler.error;
+	v4l2_ctrl_handler_init(&s->hdl, 5);
+	s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
+	s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_BANDWIDTH, 0, 8000000, 1, 0);
+	v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
+	s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_LNA_GAIN, 0, 1, 1, 1);
+	s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_MIXER_GAIN, 0, 1, 1, 1);
+	s->if_gain = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_IF_GAIN, 0, 59, 1, 0);
+	if (s->hdl.error) {
+		ret = s->hdl.error;
 		dev_err(&s->udev->dev, "Could not initialize controls\n");
 		goto err_free_controls;
 	}
@@ -1889,12 +1685,12 @@ static int msi3101_probe(struct usb_interface *intf,
 		goto err_free_controls;
 	}
 
-	s->v4l2_dev.ctrl_handler = &s->ctrl_handler;
+	s->v4l2_dev.ctrl_handler = &s->hdl;
 	s->vdev.v4l2_dev = &s->v4l2_dev;
 	s->vdev.lock = &s->v4l2_lock;
 
-	ret = video_register_device(&s->vdev, VFL_TYPE_GRABBER, -1);
-	if (ret < 0) {
+	ret = video_register_device(&s->vdev, VFL_TYPE_SDR, -1);
+	if (ret) {
 		dev_err(&s->udev->dev,
 				"Failed to register as video device (%d)\n",
 				ret);
@@ -1908,7 +1704,7 @@ static int msi3101_probe(struct usb_interface *intf,
 err_unregister_v4l2_dev:
 	v4l2_device_unregister(&s->v4l2_dev);
 err_free_controls:
-	v4l2_ctrl_handler_free(&s->ctrl_handler);
+	v4l2_ctrl_handler_free(&s->hdl);
 err_free_mem:
 	kfree(s);
 	return ret;
-- 
1.8.5.3

