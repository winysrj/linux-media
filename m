Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m648p9jj008786
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 04:51:09 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m648orWR007648
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 04:50:54 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEh0H-0001eq-0V
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 10:50:53 +0200
Message-ID: <486DE449.7040603@hhs.nl>
Date: Fri, 04 Jul 2008 10:50:17 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------080306040402040108090006"
Cc: video4linux-list@redhat.com
Subject: Patch: gspca-remove-pac207-decode.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------080306040402040108090006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

HI,

This patch removes the in kernel decoding from the gspca-pac207 driver. pac207
decoding has been added to libv4l's mercurial:
http://linuxtv.org/hg/~tmerle/v4l2-library

And will be in the 0.3.2 tarbal release.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------080306040402040108090006
Content-Type: text/plain;
 name="gspca-remove-pac207-decode.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-remove-pac207-decode.patch"

This patch removes the in kernel decoding from the gspca-pac207 driver. pac207
decoding has been added to libv4l's mercurial:
http://linuxtv.org/hg/~tmerle/v4l2-library

And will be in the 0.3.2 tarbal release.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

--- a/linux/drivers/media/video/gspca/gspca.c	Fri Jul 04 09:36:32 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Fri Jul 04 10:43:23 2008 +0200
@@ -327,6 +327,7 @@
 	case V4L2_PIX_FMT_MJPEG:
 	case V4L2_PIX_FMT_JPEG:
 	case V4L2_PIX_FMT_SPCA561:
+	case V4L2_PIX_FMT_PAC207:
 		return 1;
 	}
 	return 0;
@@ -386,7 +387,8 @@
 	case V4L2_PIX_FMT_JPEG:
 	case V4L2_PIX_FMT_SBGGR8:	/* 'BA81' Bayer */
 	case V4L2_PIX_FMT_SN9C10X:	/* 'S910' SN9C10x compression */
-	case V4L2_PIX_FMT_SPCA561:	/* 'S561' compressed BGGR bayer */
+	case V4L2_PIX_FMT_SPCA561:	/* 'S561' compressed GBRG bayer */
+	case V4L2_PIX_FMT_PAC207:	/* 'P207' compressed BGGR bayer */
 		return 8;
 	}
 	PDEBUG(D_ERR|D_CONF, "Unknown pixel format %c%c%c%c",
--- a/linux/drivers/media/video/gspca/pac207.c	Fri Jul 04 09:36:32 2008 +0200
+++ b/linux/drivers/media/video/gspca/pac207.c	Fri Jul 04 10:43:23 2008 +0200
@@ -58,33 +58,9 @@
    before doing any other adjustments */
 #define PAC207_AUTOGAIN_IGNORE_FRAMES	3
 
-enum pac207_line_state {
-	LINE_HEADER1,
-	LINE_HEADER2,
-	LINE_UNCOMPRESSED,
-	LINE_COMPRESSED,
-};
-
-struct pac207_decoder_state {
-	/* generic state */
-	u16 line_read;
-	u16 line_marker;
-	u8 line_state;
-	u8 header_read;
-	/* compression state */
-	u16 processed_bytes;
-	u8 remaining_bits;
-	s8 no_remaining_bits;
-	u8 get_abs;
-	u8 discard_byte;
-	u8 line_decode_buf[352];
-};
-
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;		/* !! must be the first item */
-
-	struct pac207_decoder_state decoder_state;
 
 	u8 mode;
 
@@ -94,6 +70,7 @@
 	u8 gain;
 
 	u8 sof_read;
+	u8 header_read;
 	u8 autogain_ignore_frames;
 
 	atomic_t avg_lum;
@@ -173,8 +150,8 @@
 };
 
 static struct cam_mode sif_mode[] = {
-	{V4L2_PIX_FMT_SBGGR8, 176, 144, 1},
-	{V4L2_PIX_FMT_SBGGR8, 352, 288, 0},
+	{V4L2_PIX_FMT_PAC207, 176, 144, 1},
+	{V4L2_PIX_FMT_PAC207, 352, 288, 0},
 };
 
 static const __u8 pac207_sensor_init[][8] = {
@@ -361,68 +338,19 @@
 {
 }
 
-/* -- convert pixart frames to Bayer -- */
-/* Sonix decompressor struct B.S.(2004) */
-static struct {
-	u8 is_abs;
-	u8 len;
-	s8 val;
-} table[256];
+static int sd_get_buff_size_op(struct gspca_dev *gspca_dev, int mode)
+{
+	switch (gspca_dev->cam.cam_mode[mode].width)
+	{
+		case 176: /* 176x144 */
+			/* uncompressed, add 2 bytes / line for line header */
+			return (176 + 2) * 144;
+		case 352: /* 352x288 */
+			/* compressed */
+			return 352 * 288 / 2;
+	}
 
-void init_pixart_decoder(void)
-{
-	int i, is_abs, val, len;
-
-	for (i = 0; i < 256; i++) {
-		is_abs = 0;
-		val = 0;
-		len = 0;
-		if ((i & 0xC0) == 0) {
-			/* code 00 */
-			val = 0;
-			len = 2;
-		} else if ((i & 0xC0) == 0x40) {
-			/* code 01 */
-			val = -5;
-			len = 2;
-		} else if ((i & 0xC0) == 0x80) {
-			/* code 10 */
-			val = 5;
-			len = 2;
-		} else if ((i & 0xF0) == 0xC0) {
-			/* code 1100 */
-			val = -10;
-			len = 4;
-		} else if ((i & 0xF0) == 0xD0) {
-			/* code 1101 */
-			val = 10;
-			len = 4;
-		} else if ((i & 0xF8) == 0xE0) {
-			/* code 11100 */
-			val = -15;
-			len = 5;
-		} else if ((i & 0xF8) == 0xE8) {
-			/* code 11101 */
-			val = 15;
-			len = 5;
-		} else if ((i & 0xFC) == 0xF0) {
-			/* code 111100 */
-			val = -20;
-			len = 6;
-		} else if ((i & 0xFC) == 0xF4) {
-			/* code 111101 */
-			val = 20;
-			len = 6;
-		} else if ((i & 0xF8) == 0xF8) {
-			/* code 11111xxxxxx */
-			is_abs = 1;
-			val = 0;
-			len = 5;
-		}
-		table[i].is_abs = is_abs;
-		table[i].val = val;
-		table[i].len = len;
-	}
+	return -EIO; /* should never happen */
 }
 
 /* auto gain and exposure algorithm based on the knee algorithm described here:
@@ -517,245 +445,53 @@
 	return NULL;
 }
 
-static int pac207_decompress_row(struct gspca_dev *gspca_dev,
-				struct gspca_frame *f,
-				__u8 *cdata,
-				int len)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	struct pac207_decoder_state *decoder_state = &sd->decoder_state;
-	unsigned char *outp = decoder_state->line_decode_buf +
-				decoder_state->line_read;
-	int val, bitlen, bitpos = -decoder_state->no_remaining_bits;
-	u8 code;
-
-	/* first two pixels are stored as raw 8-bit */
-	while (decoder_state->line_read < 2) {
-		*outp++ = *cdata++;
-		decoder_state->line_read++;
-		len--;
-		if (len == 0)
-			return 0;
-	}
-
-	while (decoder_state->line_read < gspca_dev->width) {
-		if (bitpos < 0) {
-			code = decoder_state->remaining_bits << (8 + bitpos) |
-				cdata[0] >> -bitpos;
-		} else {
-			u8 *addr = cdata + bitpos / 8;
-			code = addr[0] << (bitpos & 7) |
-				addr[1] >> (8 - (bitpos & 7));
-		}
-
-		bitlen = decoder_state->get_abs ?
-				6 : table[code].len;
-
-		/* Stop decompressing if we're out of input data */
-		if ((bitpos + bitlen) > (len * 8))
-			break;
-
-		if (decoder_state->get_abs) {
-			*outp++ = code & 0xFC;
-			decoder_state->line_read++;
-			decoder_state->get_abs = 0;
-		} else {
-			if (table[code].is_abs) {
-				decoder_state->get_abs = 1;
-			} else {
-				/* relative to left pixel */
-				val = outp[-2] +
-					table[code].val;
-				if (val > 0xff)
-					val = 0xff;
-				else if (val < 0)
-					val = 0;
-				*outp++ = val;
-				decoder_state->line_read++;
-			}
-		}
-		bitpos += bitlen;
-	}
-
-	if (decoder_state->line_read == gspca_dev->width) {
-		int compressed_line_len;
-
-		gspca_frame_add(gspca_dev, INTER_PACKET, f,
-				decoder_state->line_decode_buf,
-				gspca_dev->width);
-
-		/* completely decompressed line, round pos to nearest word */
-		compressed_line_len = ((decoder_state->processed_bytes * 8 +
-			bitpos + 15) / 16) * 2;
-
-		len -= compressed_line_len - decoder_state->processed_bytes;
-		if (len < 0) {
-			decoder_state->discard_byte = 1;
-			len = 0;
-		}
-	} else {
-		decoder_state->processed_bytes += len;
-		decoder_state->remaining_bits = cdata[bitpos/8];
-		decoder_state->no_remaining_bits = (8 - bitpos) & 7;
-		len = 0;
-	}
-
-	return len;
-}
-
-static void pac207_decode_line_init(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	struct pac207_decoder_state *decoder_state = &sd->decoder_state;
-
-	decoder_state->line_read = 0;
-	decoder_state->line_state = LINE_HEADER1;
-	decoder_state->processed_bytes = 0;
-	decoder_state->no_remaining_bits = 0;
-	decoder_state->get_abs = 0;
-}
-
-static void pac207_decode_frame_init(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	struct pac207_decoder_state *decoder_state = &sd->decoder_state;
-
-	decoder_state->header_read = 0;
-	decoder_state->discard_byte = 0;
-
-	pac207_decode_line_init(gspca_dev);
-}
-
-static int pac207_decode_frame_data(struct gspca_dev *gspca_dev,
-	struct gspca_frame *f, unsigned char *data, int len)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	struct pac207_decoder_state *decoder_state = &sd->decoder_state;
-	int needed = 0;
-
-	/* first 11 bytes after sof marker: frame header */
-	if (decoder_state->header_read < 11) {
-		/* get average lumination from frame header (byte 5) */
-		if (decoder_state->header_read < 5) {
-			needed = 5 - decoder_state->header_read;
-			if (len >= needed)
-				atomic_set(&sd->avg_lum, data[needed-1]);
-		}
-		/* skip the rest of the header */
-		needed = 11 - decoder_state->header_read;
-		if (len <= needed) {
-			decoder_state->header_read += len;
-			return 0;
-		}
-		data += needed;
-		len -= needed;
-		decoder_state->header_read = 11;
-	}
-
-	while (len) {
-		if (decoder_state->discard_byte) {
-			data++;
-			len--;
-			decoder_state->discard_byte = 0;
-			continue;
-		}
-
-		switch (decoder_state->line_state) {
-		case LINE_HEADER1:
-			decoder_state->line_marker = data[0] << 8;
-			decoder_state->line_state = LINE_HEADER2;
-			needed = 1;
-			break;
-		case LINE_HEADER2:
-			decoder_state->line_marker |= data[0];
-			switch (decoder_state->line_marker) {
-			case 0x0ff0:
-				decoder_state->line_state = LINE_UNCOMPRESSED;
-				break;
-			case 0x1ee1:
-				decoder_state->line_state = LINE_COMPRESSED;
-				break;
-			default:
-				PDEBUG(D_STREAM,
-					"Error unknown line-header %04X",
-					(int) decoder_state->line_marker);
-				gspca_dev->last_packet_type = DISCARD_PACKET;
-				return 0;
-			}
-			needed = 1;
-			break;
-		case LINE_UNCOMPRESSED:
-			needed = gspca_dev->width - decoder_state->line_read;
-			if (needed > len)
-				needed = len;
-			gspca_frame_add(gspca_dev, INTER_PACKET, f, data,
-				needed);
-			decoder_state->line_read += needed;
-			break;
-		case LINE_COMPRESSED:
-			needed = len -
-				pac207_decompress_row(gspca_dev, f, data, len);
-			break;
-		}
-
-		data += needed;
-		len -= needed;
-
-		if (decoder_state->line_read == gspca_dev->width) {
-			if ((f->data_end - f->data) ==
-				(gspca_dev->width * gspca_dev->height)) {
-				/* eureka we've got a frame */
-				return 1;
-			}
-			pac207_decode_line_init(gspca_dev);
-		}
-	}
-
-	return 0;
-}
-
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			struct gspca_frame *frame,
 			unsigned char *data,
 			int len)
 {
+	struct sd *sd = (struct sd *) gspca_dev;
 	unsigned char *sof;
-	int n;
 
 	sof = pac207_find_sof(gspca_dev, data, len);
-
 	if (sof) {
 		/* finish decoding current frame */
-		if (gspca_dev->last_packet_type == INTER_PACKET) {
-			n = sof - data;
-			if (n > sizeof(pac207_sof_marker))
-				n -= sizeof(pac207_sof_marker);
-			else
-				n = 0;
-			n = pac207_decode_frame_data(gspca_dev, frame,
-							data, n);
-			if (n)
-				frame = gspca_frame_add(gspca_dev,
-						LAST_PACKET,
-						frame,
-						NULL,
-						0);
-			else
-				PDEBUG(D_STREAM, "Incomplete frame");
-		}
-		pac207_decode_frame_init(gspca_dev);
+		int n = sof - data;
+		if (n > sizeof(pac207_sof_marker))
+			n -= sizeof(pac207_sof_marker);
+		else
+			n = 0;
+		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
+					data, n);
+
+		sd->header_read = 0;
 		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
+
 		len -= sof - data;
 		data = sof;
 	}
 
-	if (gspca_dev->last_packet_type == DISCARD_PACKET)
-		return;
+	if (sd->header_read < 11) {
+		int needed;
 
-	n = pac207_decode_frame_data(gspca_dev, frame, data, len);
-	if (n)
-		frame = gspca_frame_add(gspca_dev, LAST_PACKET,
-					frame, NULL, 0);
+		/* get average lumination from frame header (byte 5) */
+		if (sd->header_read < 5) {
+			needed = 5 - sd->header_read;
+			if (len >= needed)
+				atomic_set(&sd->avg_lum, data[needed-1]);
+		}
+		/* skip the rest of the header */
+		needed = 11 - sd->header_read;
+		if (len <= needed) {
+			sd->header_read += len;
+			return;
+		}
+		data += needed;
+		len -= needed;
+		sd->header_read = 11;
+	}
+
+	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }
 
 static void setbrightness(struct gspca_dev *gspca_dev)
@@ -891,6 +627,7 @@
 	.close = sd_close,
 	.dq_callback = pac207_do_auto_gain,
 	.pkt_scan = sd_pkt_scan,
+	.get_buff_size = sd_get_buff_size_op,
 };
 
 /* -- module initialisation -- */
@@ -927,7 +664,6 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	init_pixart_decoder();
 	if (usb_register(&sd_driver) < 0)
 		return -1;
 	PDEBUG(D_PROBE, "v%s registered", version);
diff -r b8dc1b84f3c5 linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Fri Jul 04 09:36:32 2008 +0200
+++ b/linux/include/linux/videodev2.h	Fri Jul 04 10:43:23 2008 +0200
@@ -326,7 +326,8 @@
 #define V4L2_PIX_FMT_PWC2     v4l2_fourcc('P','W','C','2') /* pwc newer webcam */
 #define V4L2_PIX_FMT_ET61X251 v4l2_fourcc('E','6','2','5') /* ET61X251 compression */
 #define V4L2_PIX_FMT_SPCA501  v4l2_fourcc('S','5','0','1') /* YUYV per line */
-#define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S','5','6','1') /* compressed BGGR bayer */
+#define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S','5','6','1') /* compressed GBRG bayer */
+#define V4L2_PIX_FMT_PAC207   v4l2_fourcc('P','2','0','7') /* compressed BGGR bayer */
 
 /*
  *	F O R M A T   E N U M E R A T I O N

--------------080306040402040108090006
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080306040402040108090006--
