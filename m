Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7MKUYJD011928
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 16:30:35 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7MKUK1j021234
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 16:30:20 -0400
Message-ID: <48AF245E.3070108@hhs.nl>
Date: Fri, 22 Aug 2008 22:41:02 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------090301030603070708070708"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Patch: gspca-pac73xx-fixes-v2.patch
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
--------------090301030603070708070708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

I made a little mistake with the previous patch (forgot to hg add the new
pac_common.h, so it didn't make it into the patch) please use this version and
don't forget to hg add pac_common.h :)

##

I'm proud to present the results of spending way too much hours (days)
working on pac73xx results:

-add documentation (based on trial and error) for some registers
-some preparations for adding autogain_n_exposure functionality:
   -remove some old (broken, disabled in current version) autogain cruft
   -add working average lumination reading
-various pac7311 fixes so that a pac7311 cam will actually work
   (tested with a trust wb 3400-T: 093a:260e)
-disable brightness and colors controls for 7311, brightness was actually
   changing a gain register (I'll do a seperate patch adding gain and exposure
   controls, I already know which registers to poke for this).
-fix contrast control for 7311
-add hflip and vflip controls for 7311
-only send a very minimal jpeg header, tinyjpeg in libv4l can already handle
   jpeg's without a huffman header, and I've added the special Pixart
   quantization table to tinyjpeg, this saves some decoding time and more
   important makes us more flexibles with regards to the quantization table.
   I have strong indications that the magic marker in the bitstream after
   each DCT block actually codes which quantization table to use for that
   block. I believe this as with my 7302 testcam, some blocks get decoded
   looking actually blocky, just like what happens with the 7311 when you
   use the wrong quantization table, and exactly these blocks have a marker
   of 0x48 instead of 0x44. Now if only I knew which quantization table to use
   for those blocks :(
-add proper SOF detection instead of relying on the JPEG EOF marker. This
   code was taken from the pac207 subdriver which uses the some SOF marker,
   and is moved to a header file shared by both drivers. Also check the JPEG
   EOF from the previous frame for additional robustness.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------090301030603070708070708
Content-Type: text/plain;
 name="gspca-pac73xx-fixes-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-pac73xx-fixes-v2.patch"

I made a little mistake with the previous patch (forgot to hg add the new
pac_common.h, so it didn't make it into the patch) please use this version and
don't forget to hg add pac_common.h :)

##

I'm proud to present the results of spending way too much hours (days)
working on pac73xx results:

-add documentation (based on trial and error) for some registers
-some preparations for adding autogain_n_exposure functionality:
 -remove some old (broken, disabled in current version) autogain cruft
 -add working average lumination reading
-various pac7311 fixes so that a pac7311 cam will actually work
 (tested with a trust wb 3400-T: 093a:260e)
-disable brightness and colors controls for 7311, brightness was actually
 changing a gain register (I'll do a seperate patch adding gain and exposure
 controls, I already know which registers to poke for this).
-fix contrast control for 7311
-add hflip and vflip controls for 7311
-only send a very minimal jpeg header, tinyjpeg in libv4l can already handle
 jpeg's without a huffman header, and I've added the special Pixart
 quantization table to tinyjpeg, this saves some decoding time and more
 important makes us more flexibles with regards to the quantization table.
 I have strong indications that the magic marker in the bitstream after
 each DCT block actually codes which quantization table to use for that
 block. I believe this as with my 7302 testcam, some blocks get decoded
 looking actually blocky, just like what happens with the 7311 when you
 use the wrong quantization table, and exactly these blocks have a marker
 of 0x48 instead of 0x44. Now if only I knew which quantization table to use
 for those blocks :(
-add proper SOF detection instead of relying on the JPEG EOF marker. This
 code was taken from the pac207 subdriver which uses the some SOF marker,
 and is moved to a header file shared by both drivers. Also check the JPEG
 EOF from the previous frame for additional robustness.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

p.s.

I'll commit Pixart JPEG support to libv4l to my tree real soon now:
http://linuxtv.org/hg/~hgoede/v4l-dvb
diff -r 62a8eab36231 linux/drivers/media/video/gspca/pac207.c
--- a/linux/drivers/media/video/gspca/pac207.c	Fri Aug 22 09:13:34 2008 +0200
+++ b/linux/drivers/media/video/gspca/pac207.c	Fri Aug 22 20:38:56 2008 +0200
@@ -181,9 +181,6 @@
 			/* 48 reg_72 Rate Control end BalSize_4a =0x36 */
 static const __u8 PacReg72[] = { 0x00, 0x00, 0x36, 0x00 };
 
-static const unsigned char pac207_sof_marker[5] =
-		{ 0xff, 0xff, 0x00, 0xff, 0x96 };
-
 static int pac207_write_regs(struct gspca_dev *gspca_dev, u16 index,
 	const u8 *buffer, u16 length)
 {
@@ -367,31 +364,8 @@
 		sd->autogain_ignore_frames = PAC207_AUTOGAIN_IGNORE_FRAMES;
 }
 
-static unsigned char *pac207_find_sof(struct gspca_dev *gspca_dev,
-					unsigned char *m, int len)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	int i;
-
-	/* Search for the SOF marker (fixed part) in the header */
-	for (i = 0; i < len; i++) {
-		if (m[i] == pac207_sof_marker[sd->sof_read]) {
-			sd->sof_read++;
-			if (sd->sof_read == sizeof(pac207_sof_marker)) {
-				PDEBUG(D_STREAM,
-					"SOF found, bytes to analyze: %u."
-					" Frame starts at byte #%u",
-					len, i + 1);
-				sd->sof_read = 0;
-				return m + i + 1;
-			}
-		} else {
-			sd->sof_read = 0;
-		}
-	}
-
-	return NULL;
-}
+/* Include pac common sof detection functions */
+#include "pac_common.h"
 
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			struct gspca_frame *frame,
@@ -401,14 +375,14 @@
 	struct sd *sd = (struct sd *) gspca_dev;
 	unsigned char *sof;
 
-	sof = pac207_find_sof(gspca_dev, data, len);
+	sof = pac_find_sof(gspca_dev, data, len);
 	if (sof) {
 		int n;
 
 		/* finish decoding current frame */
 		n = sof - data;
-		if (n > sizeof pac207_sof_marker)
-			n -= sizeof pac207_sof_marker;
+		if (n > sizeof pac_sof_marker)
+			n -= sizeof pac_sof_marker;
 		else
 			n = 0;
 		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
diff -r 62a8eab36231 linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Fri Aug 22 09:13:34 2008 +0200
+++ b/linux/drivers/media/video/gspca/pac7311.c	Fri Aug 22 20:38:56 2008 +0200
@@ -19,10 +19,36 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+/* Some documentation about various registers as determined by trial and error.
+   When the register addresses differ between the 7202 and the 7311 the 2
+   different addresses are written as 7302addr/7311addr, when one of the 2
+   addresses is a - sign that register description is not valid for the
+   matching IC.
+    
+   Register page 1:
+   
+   Address	Description
+   -/0x08	Unknown compressor related, must always be 8 except when not
+   		in 640x480 resolution and page 4 reg 2 <= 3 then set it to 9 !
+   -/0x1b	Auto white balance related, bit 0 is AWB enable (inverted)
+   		bits 345 seem to toggle per color gains on/off (inverted)
+   0x78		Global control, bit 6 controls the LED (inverted)
+   -/0x80	JPEG compression ratio ? Best not touched
+
+   Register page 3/4:
+
+   Address	Description
+   0x02		Clock divider 2-63, fps =~ 60 / val. Must be a multiple of 3 on
+   		the 7302, so one of 3, 6, 9, ...
+   -/0x0f	Master gain 1-245, low value = high gain
+   0x10/-	Master gain 0-31
+   -/0x10	Another gain 0-15, limited influence (1-2x gain I guess)
+   0x21		Bitfield: 0-1 unused, 2-3 vflip/hflip, 4-5 unknown, 6-7 unused
+*/
+
 #define MODULE_NAME "pac7311"
 
 #include "gspca.h"
-#include "jpeg.h"
 
 MODULE_AUTHOR("Thomas Kaiser thomas@kaiser-linux.li");
 MODULE_DESCRIPTION("Pixart PAC7311");
@@ -32,25 +58,22 @@
 struct sd {
 	struct gspca_dev gspca_dev;		/* !! must be the first item */
 
-	int lum_sum;
-	atomic_t avg_lum;
-	atomic_t do_gain;
-
 	unsigned char brightness;
 	unsigned char contrast;
 	unsigned char colors;
 	unsigned char autogain;
 	__u8 hflip;
 	__u8 vflip;
-	__u8 qindex;
-
-	char tosof;	/* number of bytes before next start of frame */
-	signed char ag_cnt;
-#define AG_CNT_START 13
 
 	__u8 sensor;
 #define SENSOR_PAC7302 0
 #define SENSOR_PAC7311 1
+
+	u8 sof_read;
+	u8 header_read;
+	u8 autogain_ignore_frames;
+
+	atomic_t avg_lum;
 };
 
 /* V4L2 controls supported by the driver */
@@ -92,7 +115,7 @@
 #define CONTRAST_MAX 255
 		.maximum = CONTRAST_MAX,
 		.step    = 1,
-#define CONTRAST_DEF 60
+#define CONTRAST_DEF 127
 		.default_value = CONTRAST_DEF,
 	    },
 	    .set = sd_setcontrast,
@@ -243,7 +266,7 @@
 	0x2a, 5,	0xc8, 0x00, 0x18, 0x12, 0x22,
 	0x64, 8,	0x00, 0x00, 0xf0, 0x01, 0x14, 0x44, 0x44, 0x44,
 	0x6e, 1,	0x08,
-	0xff, 1,	0x03,		/* page 1 */
+	0xff, 1,	0x01,		/* page 1 */
 	0x78, 1,	0x00,
 	0, 0				/* end of sequence */
 };
@@ -274,9 +297,9 @@
 
 /* pac 7311 */
 static const __u8 probe_7311[] = {
-	0x78, 0x40,	/* Bit_0=start stream, Bit_7=LED */
-	0x78, 0x40,	/* Bit_0=start stream, Bit_7=LED */
-	0x78, 0x44,	/* Bit_0=start stream, Bit_7=LED */
+	0x78, 0x40,	/* Bit_0=start stream, Bit_6=LED */
+	0x78, 0x40,	/* Bit_0=start stream, Bit_6=LED */
+	0x78, 0x44,	/* Bit_0=start stream, Bit_6=LED */
 	0xff, 0x04,
 	0x27, 0x80,
 	0x28, 0xca,
@@ -340,6 +363,7 @@
 			500);
 }
 
+#if 0 /* not used */
 static __u8 reg_r(struct gspca_dev *gspca_dev,
 			     __u8 index)
 {
@@ -352,6 +376,7 @@
 			500);
 	return gspca_dev->usb_buf[0];
 }
+#endif
 
 static void reg_w(struct gspca_dev *gspca_dev,
 		  __u8 index,
@@ -413,7 +438,7 @@
 			reg_w_page(gspca_dev, page3_7302, sizeof page3_7302);
 			break;
 		default:
-			if (len > 32) {
+			if (len > 64) {
 				PDEBUG(D_ERR|D_STREAM,
 					"Incorrect variable sequence");
 				return;
@@ -453,7 +478,7 @@
 		cam->nmodes = 1;
 	} else {
 		PDEBUG(D_CONF, "Find Sensor PAC7311");
-		reg_w_seq(gspca_dev, probe_7302, sizeof probe_7302);
+		reg_w_seq(gspca_dev, probe_7311, sizeof probe_7311);
 
 		cam->cam_mode = vga_mode;
 		cam->nmodes = ARRAY_SIZE(vga_mode);
@@ -465,8 +490,6 @@
 	sd->autogain = AUTOGAIN_DEF;
 	sd->hflip = HFLIP_DEF;
 	sd->vflip = VFLIP_DEF;
-	sd->qindex = 3;
-	sd->ag_cnt = -1;
 	return 0;
 }
 
@@ -497,6 +520,7 @@
 	reg_w(gspca_dev, 0xdc, 0x01);
 }
 
+/* This function is used by pac7302 only */
 static void setbrightness(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -506,7 +530,10 @@
 		setbrightcont(gspca_dev);
 		return;
 	}
-/*jfm: inverted?*/
+/* HDG: this is not brightness but gain, I'll add gain and exposure controls
+   in a next patch */
+   	return;
+
 	brightness = BRIGHTNESS_MAX - sd->brightness;
 	reg_w(gspca_dev, 0xff, 0x04);
 	reg_w(gspca_dev, 0x0e, 0x00);
@@ -524,12 +551,13 @@
 		setbrightcont(gspca_dev);
 		return;
 	}
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x10, sd->contrast);
+	reg_w(gspca_dev, 0xff, 0x04);
+	reg_w(gspca_dev, 0x10, sd->contrast >> 4);
 	/* load registers to sensor (Bit 0, auto clear) */
 	reg_w(gspca_dev, 0x11, 0x01);
 }
 
+/* This function is used by pac7302 only */
 static void setcolors(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -551,36 +579,24 @@
 			reg_w(gspca_dev, 0x0f + 2 * i + 1, v);
 		}
 		reg_w(gspca_dev, 0xdc, 0x01);
-		return;
-	}
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x80, sd->colors);
-	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
-	PDEBUG(D_CONF|D_STREAM, "color: %i", sd->colors);
-}
-
-static void setautogain(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	if (sd->autogain) {
-		sd->lum_sum = 0;
-		sd->ag_cnt = AG_CNT_START;
-	} else {
-		sd->ag_cnt = -1;
+		PDEBUG(D_CONF|D_STREAM, "color: %i", sd->colors);
 	}
 }
 
-/* this function is used by pac7302 only */
 static void sethvflip(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	__u8 data;
 
-	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
-	data = (sd->hflip ? 0x00 : 0x08)
-		| (sd->vflip ? 0x04 : 0x00);
+	if (sd->sensor == SENSOR_PAC7302) {
+		reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+		data = (sd->hflip ? 0x00 : 0x08)
+			| (sd->vflip ? 0x04 : 0x00);
+	} else {
+		reg_w(gspca_dev, 0xff, 0x04);		/* page 3 */
+		data = (sd->hflip ? 0x04 : 0x00)
+			| (sd->vflip ? 0x08 : 0x00);
+	}
 	reg_w(gspca_dev, 0x21, data);
 	reg_w(gspca_dev, 0x11, 0x01);
 }
@@ -588,7 +604,6 @@
 /* this function is called at open time */
 static int sd_open(struct gspca_dev *gspca_dev)
 {
-	reg_w(gspca_dev, 0x78, 0x44);	/* Turn on LED */
 	return 0;
 }
 
@@ -596,7 +611,7 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	sd->tosof = 0;
+	sd->sof_read = 0;
 
 	if (sd->sensor == SENSOR_PAC7302)
 		reg_w_var(gspca_dev, start_7302);
@@ -606,7 +621,6 @@
 	setcontrast(gspca_dev);
 	setbrightness(gspca_dev);
 	setcolors(gspca_dev);
-	setautogain(gspca_dev);
 
 	/* set correct resolution */
 	switch (gspca_dev->cam.cam_mode[(int) gspca_dev->curr_mode].priv) {
@@ -621,7 +635,7 @@
 		break;
 	case 1:					/* 320x240 pac7311 */
 		reg_w(gspca_dev, 0xff, 0x04);
-		reg_w(gspca_dev, 0x02, 0x07);
+		reg_w(gspca_dev, 0x02, 0x03);
 		reg_w(gspca_dev, 0xff, 0x01);
 		reg_w(gspca_dev, 0x08, 0x09);
 		reg_w(gspca_dev, 0x17, 0x30);
@@ -650,6 +664,10 @@
 		reg_w(gspca_dev, 0x78, 0x44);
 		reg_w(gspca_dev, 0x78, 0x45);
 	}
+
+	sd->sof_read = 0;
+	sd->autogain_ignore_frames = 0;
+	atomic_set(&sd->avg_lum, -1);
 }
 
 static void sd_stopN(struct gspca_dev *gspca_dev)
@@ -657,6 +675,7 @@
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	if (sd->sensor == SENSOR_PAC7302) {
+		reg_w(gspca_dev, 0xff, 0x01);
 		reg_w(gspca_dev, 0x78, 0x00);
 		reg_w(gspca_dev, 0x78, 0x00);
 		return;
@@ -668,9 +687,9 @@
 	reg_w(gspca_dev, 0x2a, 0x0e);
 	reg_w(gspca_dev, 0xff, 0x01);
 	reg_w(gspca_dev, 0x3e, 0x20);
-	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_7=LED */
-	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_7=LED */
-	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_7=LED */
+	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
+	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
+	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
 }
 
 static void sd_stop0(struct gspca_dev *gspca_dev)
@@ -690,6 +709,7 @@
 
 static void do_autogain(struct gspca_dev *gspca_dev)
 {
+#if 0
 	struct sd *sd = (struct sd *) gspca_dev;
 	int luma;
 	int luma_mean = 128;
@@ -724,7 +744,22 @@
 			reg_w(gspca_dev, 0x11, 0x01);
 		}
 	}
+#endif
 }
+
+static const unsigned char pac7311_jpeg_header1[] = {
+  0xff, 0xd8, 0xff, 0xc0, 0x00, 0x11, 0x08
+};
+
+static const unsigned char pac7311_jpeg_header2[] = {
+  0x03, 0x01, 0x21, 0x00, 0x02, 0x11, 0x01, 0x03, 0x11, 0x01, 0xff, 0xda,
+  0x00, 0x0c, 0x03, 0x01, 0x00, 0x02, 0x11, 0x03, 0x11, 0x00, 0x3f, 0x00
+};
+
+/* Include pac common sof detection functions */
+#include "pac_common.h"
+
+#define HEADER_LENGTH 2
 
 /* this function is run at interrupt level */
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
@@ -733,98 +768,89 @@
 			int len)			/* iso packet length */
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int i;
+	unsigned char *sof;
 
-#define INTER_FRAME 0x53	/* eof + inter frame + sof */
-#define LUM_OFFSET 0x1e		/* reverse offset / start of frame */
+	sof = pac_find_sof(gspca_dev, data, len);
+	if (sof) {
+		unsigned char tmpbuf[4];
+		int n, lum_offset, footer_length;
 
-#if 0 /*fixme:test+*/
-/* dump the packet */
-	if (gspca_debug & 0x200) {
-		static char tmp[50];
+		if (sd->sensor == SENSOR_PAC7302) {
+		  lum_offset = 34 + sizeof pac_sof_marker;
+		  footer_length = 74;
+		} else {
+		  lum_offset = 24 + sizeof pac_sof_marker;
+		  footer_length = 26;
+		}
 
-		PDEBUG(0x200, "pkt_scan");
-		tmp[0] = 0;
-		for (i = 0; i < len; i++) {
-			if (i % 16 == 0 && i != 0) {
-				PDEBUG(0x200, "%s", tmp);
-				tmp[0] = 0;
-			}
-			sprintf(&tmp[(i % 16) * 3], "%02x ", data[i]);
+		/* Finish decoding current frame */
+		n = (sof - data) - (footer_length + sizeof pac_sof_marker);
+		if (n < 0) {
+			frame->data_end += n;
+			n = 0;
 		}
-		if (tmp[0] != 0)
-			PDEBUG(0x200, "%s", tmp);
-	}
-#endif /*fixme:test-*/
-	/*
-	 * inside a frame, there may be:
-	 *	escaped ff ('ff 00')
-	 *	sequences'ff ff ff xx' to remove
-	 *	end of frame ('ff d9')
-	 * at the end of frame, there are:
-	 *	ff d9			end of frame
-	 *	0x33 bytes
-	 *	one byte luminosity
-	 *	0x16 bytes
-	 *	ff ff 00 ff 96 62 44	start of frame
-	 */
+		frame = gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+					data, n);
+		if (gspca_dev->last_packet_type != DISCARD_PACKET &&
+				frame->data_end[-2] == 0xff &&
+				frame->data_end[-1] == 0xd9)
+			frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
+						NULL, 0);
 
-	if (sd->tosof != 0) {	/* if outside a frame */
+		n = sof - data;
+		len -= n;
+		data = sof;
 
-		/* get the luminosity and go to the start of frame */
-		data += sd->tosof;
-		len -= sd->tosof;
-		if (sd->tosof > LUM_OFFSET)
-			sd->lum_sum += data[-LUM_OFFSET];
-		sd->tosof = 0;
-		jpeg_put_header(gspca_dev, frame, sd->qindex, 0x21);
+		/* Get average lumination */
+		if (gspca_dev->last_packet_type == LAST_PACKET &&
+				n >= lum_offset) {
+			if (sd->sensor == SENSOR_PAC7302)
+				atomic_set(&sd->avg_lum,
+						(data[-lum_offset] << 8) |
+						data[-lum_offset + 1]);
+			else
+				atomic_set(&sd->avg_lum,
+						data[-lum_offset] +
+						data[-lum_offset + 1]);
+		}
+		else
+			atomic_set(&sd->avg_lum, -1);
+
+		/* Start the new frame with the jpeg header */
+		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
+			pac7311_jpeg_header1, sizeof(pac7311_jpeg_header1));
+		if (sd->sensor == SENSOR_PAC7302) {
+			/* The PAC7302 has the image rotated 90 degrees */
+			tmpbuf[0] = gspca_dev->width >> 8;
+			tmpbuf[1] = gspca_dev->width & 0xff;
+			tmpbuf[2] = gspca_dev->height >> 8;
+			tmpbuf[3] = gspca_dev->height & 0xff;
+		} else {
+			tmpbuf[0] = gspca_dev->height >> 8;
+			tmpbuf[1] = gspca_dev->height & 0xff;
+			tmpbuf[2] = gspca_dev->width >> 8;
+			tmpbuf[3] = gspca_dev->width & 0xff;
+		}
+		gspca_frame_add(gspca_dev, INTER_PACKET, frame, tmpbuf, 4);
+		gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+			pac7311_jpeg_header2, sizeof(pac7311_jpeg_header2));
+
+		sd->header_read = 0;
 	}
 
-	for (i = 0; i < len; i++) {
-		if (data[i] != 0xff)
-			continue;
-		switch (data[i + 1]) {
-		case 0xd9:		/* 'ff d9' end of frame */
-			frame = gspca_frame_add(gspca_dev,
-						LAST_PACKET,
-						frame, data, i + 2);
-			data += i + INTER_FRAME;
-			len -= i + INTER_FRAME;
-			i = 0;
-			if (len > -LUM_OFFSET)
-				sd->lum_sum += data[-LUM_OFFSET];
-			if (len < 0) {
-				sd->tosof = -len;
-				break;
-			}
-			jpeg_put_header(gspca_dev, frame, sd->qindex, 0x21);
-			break;
-#if 0 /*fixme:test+*/
-/* is there a start of frame ? */
-		case 0xff:		/* 'ff ff' */
-			if (data[i + 2] == 0x00) {
-				static __u8 ffd9[2] = {0xff, 0xd9};
+	if (sd->header_read < HEADER_LENGTH) {
+		/* skip the variable part of the sof header */
+ 		int needed = HEADER_LENGTH - sd->header_read;
+		if (len <= needed) {
+			sd->header_read += len;
+			return;
+		}
+		data += needed;
+		len -= needed;
+		sd->header_read = HEADER_LENGTH;
+	}
 
-				gspca_frame_add(gspca_dev,
-						INTER_PACKET,
-						frame, data,
-							i + 7 - INTER_FRAME);
-				frame = gspca_frame_add(gspca_dev,
-							LAST_PACKET,
-							frame, ffd9, 2);
-				data += i + 7;
-				len -= i + 7;
-				i = 0;
-				jpeg_put_header(gspca_dev, frame,
-						sd->qindex, 0x21);
-				break;
-			}
-			break;
-#endif /*fixme:test-*/
-		}
-	}
-	gspca_frame_add(gspca_dev, INTER_PACKET,
-			frame, data, i);
+	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }
 
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
@@ -886,8 +912,7 @@
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	sd->autogain = val;
-	if (gspca_dev->streaming)
-		setautogain(gspca_dev);
+
 	return 0;
 }
 
diff -r 254e4da67596 linux/drivers/media/video/gspca/pac_common.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/pac_common.h	Fri Aug 22 22:38:25 2008 +0200
@@ -0,0 +1,53 @@
+/*
+ * Pixart PAC207BCA / PAC73xx common functions
+ *
+ * Copyright (C) 2008 Hans de Goede <j.w.r.degoede@hhs.nl>
+ * Copyright (C) 2005 Thomas Kaiser thomas@kaiser-linux.li
+ * Copyleft (C) 2005 Michel Xhaard mxhaard@magic.fr
+ *
+ * V4L2 by Jean-Francois Moine <http://moinejf.free.fr>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+static const unsigned char pac_sof_marker[5] =
+		{ 0xff, 0xff, 0x00, 0xff, 0x96 };
+
+static unsigned char *pac_find_sof(struct gspca_dev *gspca_dev,
+					unsigned char *m, int len)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int i;
+
+	/* Search for the SOF marker (fixed part) in the header */
+	for (i = 0; i < len; i++) {
+		if (m[i] == pac_sof_marker[sd->sof_read]) {
+			sd->sof_read++;
+			if (sd->sof_read == sizeof(pac_sof_marker)) {
+				PDEBUG(D_STREAM,
+					"SOF found, bytes to analyze: %u."
+					" Frame starts at byte #%u",
+					len, i + 1);
+				sd->sof_read = 0;
+				return m + i + 1;
+			}
+		} else {
+			sd->sof_read = 0;
+		}
+	}
+
+	return NULL;
+}

--------------090301030603070708070708
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------090301030603070708070708--
