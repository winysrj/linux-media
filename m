Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m639ogDY004184
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 05:50:42 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m639oS2m005199
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 05:50:29 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KELSN-00014I-NG
	for video4linux-list@redhat.com; Thu, 03 Jul 2008 11:50:27 +0200
Message-ID: <486CA0C1.5020003@hhs.nl>
Date: Thu, 03 Jul 2008 11:49:53 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------000700020404020005040400"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-mercurial no const buffer for usb_ctrl_msg
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
--------------000700020404020005040400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

This patch fixes the usb_control_msg bug fixed in my sonixb patch for all
other drivers. The problem was that some drivers pass a constant buffer to
usb_control_msg, where it must get passed a variable buffer as the buffer is
an in/out parameter in my experience with the pac207 (had the same bug) and
sonixb drivers, passing a const buffer can lead to silence failure. I don't
know why the failure is silent but it is.

This patch touches allmost all gspca drivers as it makes all const array
definitions truely const, in some drivers they were variable, so there the
problem of passing a const buffer to usb_control_msg was not present, but
there usb_control_msg might have changed the contents of our meant to be const
register initialization tables, thus a subsequent use of those tables might
yield a different result.

This patch fixes a _real_ const buffer passed to usb_control_msg problems in
pac7311, and for the rest is more cosmetical / just to be sure. Note that this
also fixes the IMHO ugly use of local static variables for const arrays, why
make them static to safe stack space, instead of making them const as they
should be?

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------000700020404020005040400
Content-Type: text/plain; name="gspca-no-const-buf-for-usb-control-msg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="gspca-no-const-buf-for-usb-control-msg.patch"

This patch fixes the usb_control_msg bug fixed in my sonixb patch for all
other drivers. The problem was that some drivers pass a constant buffer to
usb_control_msg, where it must get passed a variable buffer as the buffer is
an in/out parameter in my experience with the pac207 (had the same bug) and
sonixb drivers, passing a const buffer can lead to silence failure. I don't
know why the failure is silent but it is.

This patch touches allmost all gspca drivers as it makes all const array
definitions truely const, in some drivers they were variable, so there the
problem of passing a const buffer to usb_control_msg was not present, but
there usb_control_msg might have changed the contents of our meant to be const
register initialization tables, thus a subsequent use of those tables might
yield a different result.

This patch fixes a _real_ const buffer passed to usb_control_msg problems in
pac7311, and for the rest is more cosmetical / just to be sure. Note that this
also fixes the IMHO ugly use of local static variables for const arrays, why
make them static to safe stack space, instead of making them const as they
should be?

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/conex.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/conex.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/conex.c~	2008-07-03 09:51:12.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/conex.c	2008-07-03 11:44:00.000000000 +0200
@@ -121,13 +121,15 @@ static void reg_w(struct usb_device *dev
 		  __u16 index,
 		  const __u8 *buffer, __u16 length)
 {
+	__u8 tmpbuf[8];
 	PDEBUG(D_USBO, "reg write i:%02x = %02x", index, *buffer);
+	memcpy(tmpbuf, buffer, length);
 	usb_control_msg(dev,
 			usb_sndctrlpipe(dev, 0),
 			0,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0,
-			index, (__u8 *) buffer, length,
+			index, tmpbuf, length,
 			500);
 }
 
@@ -221,7 +223,7 @@ static void cx11646_fw(struct gspca_dev*
 	reg_w(gspca_dev->dev, 0x006a, &val, 1);
 }
 
-static __u8 cxsensor[] = {
+static const __u8 cxsensor[] = {
 	0x88, 0x12, 0x70, 0x01,
 	0x88, 0x0d, 0x02, 0x01,
 	0x88, 0x0f, 0x00, 0x01,
@@ -236,16 +238,16 @@ static __u8 cxsensor[] = {
 	0x00
 };
 
-static __u8 reg20[] = { 0x10, 0x42, 0x81, 0x19, 0xd3, 0xff, 0xa7, 0xff };
-static __u8 reg28[] = { 0x87, 0x00, 0x87, 0x00, 0x8f, 0xff, 0xea, 0xff };
-static __u8 reg10[] = { 0xb1, 0xb1 };
-static __u8 reg71a[] = { 0x08, 0x18, 0x0a, 0x1e };	/* 640 */
-static __u8 reg71b[] = { 0x04, 0x0c, 0x05, 0x0f };
+static const __u8 reg20[] = { 0x10, 0x42, 0x81, 0x19, 0xd3, 0xff, 0xa7, 0xff };
+static const __u8 reg28[] = { 0x87, 0x00, 0x87, 0x00, 0x8f, 0xff, 0xea, 0xff };
+static const __u8 reg10[] = { 0xb1, 0xb1 };
+static const __u8 reg71a[] = { 0x08, 0x18, 0x0a, 0x1e };	/* 640 */
+static const __u8 reg71b[] = { 0x04, 0x0c, 0x05, 0x0f };
 	/* 352{0x04,0x0a,0x06,0x12}; //352{0x05,0x0e,0x06,0x11}; //352 */
-static __u8 reg71c[] = { 0x02, 0x07, 0x03, 0x09 };
+static const __u8 reg71c[] = { 0x02, 0x07, 0x03, 0x09 };
 					/* 320{0x04,0x0c,0x05,0x0f}; //320 */
-static __u8 reg71d[] = { 0x02, 0x07, 0x03, 0x09 };	/* 176 */
-static __u8 reg7b[] = { 0x00, 0xff, 0x00, 0xff, 0x00, 0xff };
+static const __u8 reg71d[] = { 0x02, 0x07, 0x03, 0x09 };	/* 176 */
+static const __u8 reg7b[] = { 0x00, 0xff, 0x00, 0xff, 0x00, 0xff };
 
 static void cx_sensor(struct gspca_dev*gspca_dev)
 {
@@ -253,7 +255,7 @@ static void cx_sensor(struct gspca_dev*g
 	int i = 0;
 	__u8 bufread[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
 	int length = 0;
-	__u8 *ptsensor = cxsensor;
+	const __u8 *ptsensor = cxsensor;
 
 	reg_w(gspca_dev->dev, 0x0020, reg20, 8);
 	reg_w(gspca_dev->dev, 0x0028, reg28, 8);
@@ -297,7 +299,7 @@ static void cx_sensor(struct gspca_dev*g
 	reg_r(gspca_dev->dev, 0x00e7, bufread, 8);
 }
 
-static __u8 cx_inits_176[] = {
+static const __u8 cx_inits_176[] = {
 	0x33, 0x81, 0xB0, 0x00, 0x90, 0x00, 0x0A, 0x03,	/* 176x144 */
 	0x00, 0x03, 0x03, 0x03, 0x1B, 0x05, 0x30, 0x03,
 	0x65, 0x15, 0x18, 0x25, 0x03, 0x25, 0x08, 0x30,
@@ -306,7 +308,7 @@ static __u8 cx_inits_176[] = {
 	0xF7, 0xFF, 0x88, 0xFF, 0x66, 0x02, 0x28, 0x02,
 	0x1E, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
 };
-static __u8 cx_inits_320[] = {
+static const __u8 cx_inits_320[] = {
 	0x7f, 0x7f, 0x40, 0x01, 0xf0, 0x00, 0x02, 0x01,
 	0x00, 0x01, 0x01, 0x01, 0x10, 0x00, 0x02, 0x01,
 	0x65, 0x45, 0xfa, 0x4c, 0x2c, 0xdf, 0xb9, 0x81,
@@ -315,7 +317,7 @@ static __u8 cx_inits_320[] = {
 	0xf5, 0xff, 0x6d, 0xff, 0xf6, 0x01, 0x43, 0x02,
 	0xd3, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
 };
-static __u8 cx_inits_352[] = {
+static const __u8 cx_inits_352[] = {
 	0x2e, 0x7c, 0x60, 0x01, 0x20, 0x01, 0x05, 0x03,
 	0x00, 0x06, 0x03, 0x06, 0x1b, 0x10, 0x05, 0x3b,
 	0x30, 0x25, 0x18, 0x25, 0x08, 0x30, 0x03, 0x25,
@@ -324,7 +326,7 @@ static __u8 cx_inits_352[] = {
 	0xf5, 0xff, 0x6b, 0xff, 0xee, 0x01, 0x43, 0x02,
 	0xe4, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
 };
-static __u8 cx_inits_640[] = {
+static const __u8 cx_inits_640[] = {
 	0x7e, 0x7e, 0x80, 0x02, 0xe0, 0x01, 0x01, 0x01,
 	0x00, 0x02, 0x01, 0x02, 0x10, 0x30, 0x01, 0x01,
 	0x65, 0x45, 0xf7, 0x52, 0x2c, 0xdf, 0xb9, 0x81,
@@ -336,7 +338,7 @@ static __u8 cx_inits_640[] = {
 
 static int cx11646_initsize(struct gspca_dev *gspca_dev)
 {
-	__u8 *cxinit;
+	const __u8 *cxinit;
 	__u8 val;
 	static const __u8 reg12[] = { 0x08, 0x05, 0x07, 0x04, 0x24 };
 	static const __u8 reg17[] =
@@ -388,7 +390,7 @@ static int cx11646_initsize(struct gspca
 	return val;
 }
 
-static __u8 cx_jpeg_init[][8] = {
+static const __u8 cx_jpeg_init[][8] = {
 	{0xff, 0xd8, 0xff, 0xdb, 0x00, 0x84, 0x00, 0x15},	/* 1 */
 	{0x0f, 0x10, 0x12, 0x10, 0x0d, 0x15, 0x12, 0x11},
 	{0x12, 0x18, 0x16, 0x15, 0x19, 0x20, 0x35, 0x22},
@@ -471,7 +473,7 @@ static __u8 cx_jpeg_init[][8] = {
 };
 
 
-static __u8 cxjpeg_640[][8] = {
+static const __u8 cxjpeg_640[][8] = {
 	{0xff, 0xd8, 0xff, 0xdb, 0x00, 0x84, 0x00, 0x10},	/* 1 */
 	{0x0b, 0x0c, 0x0e, 0x0c, 0x0a, 0x10, 0x0e, 0x0d},
 	{0x0e, 0x12, 0x11, 0x10, 0x13, 0x18, 0x28, 0x1a},
@@ -500,7 +502,7 @@ static __u8 cxjpeg_640[][8] = {
 	{0x00, 0x01, 0x11, 0x02, 0x11, 0x00, 0x3F, 0x00},
 	{0xFF, 0xD9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}	/* 27 */
 };
-static __u8 cxjpeg_352[][8] = {
+static const __u8 cxjpeg_352[][8] = {
 	{0xff, 0xd8, 0xff, 0xdb, 0x00, 0x84, 0x00, 0x0d},
 	{0x09, 0x09, 0x0b, 0x09, 0x08, 0x0D, 0x0b, 0x0a},
 	{0x0b, 0x0e, 0x0d, 0x0d, 0x0f, 0x13, 0x1f, 0x14},
@@ -529,7 +531,7 @@ static __u8 cxjpeg_352[][8] = {
 	{0x00, 0x01, 0x11, 0x02, 0x11, 0x00, 0x3F, 0x00},
 	{0xFF, 0xD9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
 };
-static __u8 cxjpeg_320[][8] = {
+static const __u8 cxjpeg_320[][8] = {
 	{0xff, 0xd8, 0xff, 0xdb, 0x00, 0x84, 0x00, 0x05},
 	{0x03, 0x04, 0x04, 0x04, 0x03, 0x05, 0x04, 0x04},
 	{0x04, 0x05, 0x05, 0x05, 0x06, 0x07, 0x0c, 0x08},
@@ -558,7 +560,7 @@ static __u8 cxjpeg_320[][8] = {
 	{0x00, 0x01, 0x11, 0x02, 0x11, 0x00, 0x3F, 0x00},
 	{0xFF, 0xD9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}	/* 27 */
 };
-static __u8 cxjpeg_176[][8] = {
+static const __u8 cxjpeg_176[][8] = {
 	{0xff, 0xd8, 0xff, 0xdb, 0x00, 0x84, 0x00, 0x0d},
 	{0x09, 0x09, 0x0B, 0x09, 0x08, 0x0D, 0x0B, 0x0A},
 	{0x0B, 0x0E, 0x0D, 0x0D, 0x0F, 0x13, 0x1F, 0x14},
@@ -587,7 +589,7 @@ static __u8 cxjpeg_176[][8] = {
 	{0x00, 0x01, 0x11, 0x02, 0x11, 0x00, 0x3F, 0x00},
 	{0xFF, 0xD9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
 };
-static __u8 cxjpeg_qtable[][8] = {	/* 640 take with the zcx30x part */
+static const __u8 cxjpeg_qtable[][8] = {	/* 640 take with the zcx30x part */
 	{0xff, 0xd8, 0xff, 0xdb, 0x00, 0x84, 0x00, 0x08},
 	{0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07, 0x07},
 	{0x07, 0x09, 0x09, 0x08, 0x0a, 0x0c, 0x14, 0x0a},
@@ -633,13 +635,13 @@ static void cx11646_jpegInit(struct gspc
 	reg_w(gspca_dev->dev, 0x0055, &val, 1);
 }
 
-static __u8 reg12[] = { 0x0a, 0x05, 0x07, 0x04, 0x19 };
-static __u8 regE5_8[] = { 0x88, 0x00, 0xd4, 0x01, 0x88, 0x01, 0x01, 0x01 };
-static __u8 regE5a[] = { 0x88, 0x0a, 0x0c, 0x01 };
-static __u8 regE5b[] = { 0x88, 0x0b, 0x12, 0x01 };
-static __u8 regE5c[] = { 0x88, 0x05, 0x01, 0x01 };
-static __u8 reg51[] = { 0x77, 0x03 };
-static __u8 reg70 = 0x03;
+static const __u8 reg12[] = { 0x0a, 0x05, 0x07, 0x04, 0x19 };
+static const __u8 regE5_8[] = { 0x88, 0x00, 0xd4, 0x01, 0x88, 0x01, 0x01, 0x01 };
+static const __u8 regE5a[] = { 0x88, 0x0a, 0x0c, 0x01 };
+static const __u8 regE5b[] = { 0x88, 0x0b, 0x12, 0x01 };
+static const __u8 regE5c[] = { 0x88, 0x05, 0x01, 0x01 };
+static const __u8 reg51[] = { 0x77, 0x03 };
+static const __u8 reg70 = 0x03;
 
 static void cx11646_jpeg(struct gspca_dev*gspca_dev)
 {
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/etoms.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/etoms.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/etoms.c~	2008-07-03 10:00:54.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/etoms.c	2008-07-03 10:00:54.000000000 +0200
@@ -205,13 +205,13 @@ static struct cam_mode sif_mode[] = {
 #define PAS106_REG0e 0x0e	/* global gain [4..0](default 0x0e) */
 #define PAS106_REG13 0x13	/* end i2c write */
 
-static __u8 GainRGBG[] = { 0x80, 0x80, 0x80, 0x80, 0x00, 0x00 };
+static const __u8 GainRGBG[] = { 0x80, 0x80, 0x80, 0x80, 0x00, 0x00 };
 
-static __u8 I2c2[] = { 0x08, 0x08, 0x08, 0x08, 0x0d };
+static const __u8 I2c2[] = { 0x08, 0x08, 0x08, 0x08, 0x0d };
 
-static __u8 I2c3[] = { 0x12, 0x05 };
+static const __u8 I2c3[] = { 0x12, 0x05 };
 
-static __u8 I2c4[] = { 0x41, 0x08 };
+static const __u8 I2c4[] = { 0x41, 0x08 };
 
 static void Et_RegRead(struct usb_device *dev,
 		       __u16 index, __u8 *buffer, int len)
@@ -233,7 +233,7 @@ static void Et_RegWrite(struct usb_devic
 			0, index, buffer, len, 500);
 }
 
-static int Et_i2cwrite(struct usb_device *dev, __u8 reg, __u8 *buffer,
+static int Et_i2cwrite(struct usb_device *dev, __u8 reg, const __u8 *buffer,
 		       __u16 length, __u8 mode)
 {
 /* buffer should be [D0..D7] */
@@ -250,7 +250,8 @@ static int Et_i2cwrite(struct usb_device
 	Et_RegWrite(dev, ET_I2C_REG, &reg, 1);
 	j = length - 1;
 	for (i = 0; i < length; i++) {
-		Et_RegWrite(dev, (ET_I2C_DATA0 + j), &buffer[j], 1);
+		__u8 value = buffer[j];
+		Et_RegWrite(dev, (ET_I2C_DATA0 + j), &value, 1);
 		j--;
 	}
 	return 0;
@@ -551,6 +552,7 @@ static void Et_init1(struct gspca_dev *g
 						/* try 1/120 0x6d 0xcd 0x40 */
 /*	__u8 I2c0 [] ={0x0a,0x12,0x05,0xfe,0xfe,0xc0,0x01,0x00};
 						 * 1/60000 hmm ?? */
+	__u8 tmpGainRGBG[6];
 
 	PDEBUG(D_STREAM, "Open Init1 ET");
 	value = 7;
@@ -679,7 +681,8 @@ static void Et_init1(struct gspca_dev *g
 	/* magnetude and sign bit for DAC */
 	Et_i2cwrite(dev, PAS106_REG7, I2c4, sizeof I2c4, 1);
 	/* now set by fifo the whole colors setting */
-	Et_RegWrite(dev, ET_G_RED, GainRGBG, 6);
+	memcpy(tmpGainRGBG, GainRGBG, 6);
+	Et_RegWrite(dev, ET_G_RED, tmpGainRGBG, 6);
 	getcolors(gspca_dev);
 	setcolors(gspca_dev);
 }
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/pac7311.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/pac7311.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/pac7311.c~	2008-07-03 10:29:59.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/pac7311.c	2008-07-03 11:42:08.000000000 +0200
@@ -124,7 +124,7 @@ static struct cam_mode vga_mode[] = {
 
 #define PAC7311_JPEG_HEADER_SIZE (sizeof pac7311_jpeg_header)	/* (594) */
 
-const unsigned char pac7311_jpeg_header[] = {
+static const unsigned char pac7311_jpeg_header[] = {
 	0xff, 0xd8,
 	0xff, 0xe0, 0x00, 0x03, 0x20,
 	0xff, 0xc0, 0x00, 0x11, 0x08,
@@ -198,13 +198,15 @@ static void reg_w(struct usb_device *dev
 			    __u16 req,
 			    __u16 value,
 			    __u16 index,
-			    __u8 *buffer, __u16 length)
+			    const __u8 *buffer, __u16 length)
 {
+	__u8 tmpbuf[8];
+	memcpy(tmpbuf, buffer, length);
 	usb_control_msg(dev,
 			usb_sndctrlpipe(dev, 0),
 			req,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, index, buffer, length,
+			value, index, tmpbuf, length,
 			500);
 }
 
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sonixj.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sonixj.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sonixj.c~	2008-07-03 10:40:07.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sonixj.c	2008-07-03 11:27:07.000000000 +0200
@@ -139,7 +139,7 @@ static struct cam_mode vga_mode[] = {
 };
 
 /*Data from sn9c102p+hv71331r */
-static __u8 sn_hv7131[] = {
+static const __u8 sn_hv7131[] = {
 	0x00, 0x03, 0x64, 0x00, 0x1A, 0x20, 0x20, 0x20, 0xA1, 0x11,
 /*	reg0  reg1  reg2  reg3  reg4  reg5  reg6  reg7  reg8  reg9 */
 	0x02, 0x09, 0x00, 0x00, 0x00, 0x10, 0x03, 0x00,		/* 00 */
@@ -150,7 +150,7 @@ static __u8 sn_hv7131[] = {
 /*	reg1c reg1d reg1e reg1f reg20 reg21 reg22 reg23 */
 };
 
-static __u8 sn_mi0360[] = {
+static const __u8 sn_mi0360[] = {
 	0x00, 0x61, 0x44, 0x00, 0x1a, 0x20, 0x20, 0x20, 0xb1, 0x5d,
 /*	reg0  reg1  reg2  reg3  reg4  reg5  reg6  reg7  reg8  reg9 */
 	0x07, 0x00, 0x00, 0x00, 0x00, 0x10, 0x03, 0x00,
@@ -161,7 +161,7 @@ static __u8 sn_mi0360[] = {
 /*	reg1c reg1d reg1e reg1f reg20 reg21 reg22 reg23 */
 };
 
-static __u8 sn_mo4000[] = {
+static const __u8 sn_mo4000[] = {
 	0x12,	0x23,	0x60,	0x00,	0x1A,	0x00,	0x20,	0x18,	0x81,
 /*	reg0	reg1	reg2	reg3	reg4	reg5	reg6	reg7	reg8 */
 	0x21,	0x00,	0x00,	0x00,	0x00,	0x00,	0x00,	0x03,	0x00,
@@ -174,13 +174,13 @@ static __u8 sn_mo4000[] = {
 	0xd3,	0xdf,	0xea,	0xf5
 };
 
-static __u8 sn_ov7648[] = {
+static const __u8 sn_ov7648[] = {
 	0x00, 0x21, 0x62, 0x00, 0x1a, 0x20, 0x20, 0x20, 0xA1, 0x6E, 0x18, 0x65,
 	0x00, 0x00, 0x00, 0x10, 0x03, 0x00, 0x00, 0x06, 0x06, 0x28, 0x1E, 0x82,
 	0x07, 0x00, 0x00, 0x00, 0x00, 0x00
 };
 
-static __u8 sn_ov7660[]	= {
+static const __u8 sn_ov7660[]	= {
 # if 1 /*jfm: from win trace */
 /*	reg0	reg1	reg2	reg3	reg4	reg5	reg6	reg7	reg8 */
 	0x00,	0x61,	0x40,	0x00,	0x1a,	0x00,	0x00,	0x00,	0x81,
@@ -203,7 +203,7 @@ static __u8 sn_ov7660[]	= {
 };
 
 /* sequence specific to the sensors - !! index = SENSOR_xxx */
-static __u8 *sn_tb[] = {
+static const __u8 *sn_tb[] = {
 	sn_hv7131,
 	sn_mi0360,
 	sn_mo4000,
@@ -211,28 +211,28 @@ static __u8 *sn_tb[] = {
 	sn_ov7660
 };
 
-static __u8 regsn20[] = {
+static const __u8 regsn20[] = {
 	0x00, 0x2d, 0x46, 0x5a, 0x6c, 0x7c, 0x8b, 0x99,
 	0xa6, 0xb2, 0xbf, 0xca, 0xd5, 0xe0, 0xeb, 0xf5, 0xff
 };
-static __u8 regsn20_sn9c325[] = {
+static const __u8 regsn20_sn9c325[] = {
 	0x0a, 0x3a, 0x56, 0x6c, 0x7e, 0x8d, 0x9a, 0xa4,
 	0xaf, 0xbb, 0xc5, 0xcd, 0xd5, 0xde, 0xe8, 0xed, 0xf5
 };
 
-static __u8 reg84[] = {
+static const __u8 reg84[] = {
 	0x14, 0x00, 0x27, 0x00, 0x07, 0x00, 0xe5, 0x0f,
 	0xe4, 0x0f, 0x38, 0x00, 0x3e, 0x00, 0xc3, 0x0f,
 /*	0x00, 0x00, 0x00, 0x00, 0x00 */
 	0xf7, 0x0f, 0x0a, 0x00, 0x00
 };
-static __u8 reg84_sn9c325[] = {
+static const __u8 reg84_sn9c325[] = {
 	0x14, 0x00, 0x27, 0x00, 0x07, 0x00, 0xe4, 0x0f,
 	0xd3, 0x0f, 0x4b, 0x00, 0x48, 0x00, 0xc0, 0x0f,
 	0xf8, 0x0f, 0x00, 0x00, 0x00
 };
 
-static __u8 hv7131r_sensor_init[][8] = {
+static const __u8 hv7131r_sensor_init[][8] = {
 	{0xC1, 0x11, 0x01, 0x08, 0x01, 0x00, 0x00, 0x10},
 	{0xB1, 0x11, 0x34, 0x17, 0x7F, 0x00, 0x00, 0x10},
 	{0xD1, 0x11, 0x40, 0xFF, 0x7F, 0x7F, 0x7F, 0x10},
@@ -263,7 +263,7 @@ static __u8 hv7131r_sensor_init[][8] = {
 	{0xA1, 0x11, 0x23, 0x10, 0x00, 0x00, 0x00, 0x10},
 	{0, 0, 0, 0, 0, 0, 0, 0}
 };
-static __u8 mi0360_sensor_init[][8] = {
+static const __u8 mi0360_sensor_init[][8] = {
 	{0xB1, 0x5D, 0x07, 0x00, 0x02, 0x00, 0x00, 0x10},
 	{0xB1, 0x5D, 0x0D, 0x00, 0x01, 0x00, 0x00, 0x10},
 	{0xB1, 0x5D, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x10},
@@ -317,7 +317,7 @@ static __u8 mi0360_sensor_init[][8] = {
 	{0xB1, 0x5D, 0x07, 0x00, 0x02, 0x00, 0x00, 0x10}, /* sensor on */
 	{0, 0, 0, 0, 0, 0, 0, 0}
 };
-static __u8 mo4000_sensor_init[][8] = {
+static const __u8 mo4000_sensor_init[][8] = {
 	{0xa1, 0x21, 0x01, 0x02, 0x00, 0x00, 0x00, 0x10},
 	{0xa1, 0x21, 0x02, 0x00, 0x00, 0x00, 0x00, 0x10},
 	{0xa1, 0x21, 0x03, 0x00, 0x00, 0x00, 0x00, 0x10},
@@ -340,7 +340,7 @@ static __u8 mo4000_sensor_init[][8] = {
 	{0xa1, 0x21, 0x11, 0x38, 0x00, 0x00, 0x00, 0x10},
 	{0, 0, 0, 0, 0, 0, 0, 0}
 };
-static __u8 ov7660_sensor_init[][8] = {
+static const __u8 ov7660_sensor_init[][8] = {
 	{0xa1, 0x21, 0x12, 0x80, 0x00, 0x00, 0x00, 0x10}, /* reset SCCB */
 	{0xa1, 0x21, 0x12, 0x05, 0x00, 0x00, 0x00, 0x10},
 						/* Outformat ?? rawRGB */
@@ -436,7 +436,7 @@ static __u8 ov7660_sensor_init[][8] = {
 /* reg0x04		reg0x07		reg 0x10 */
 /* expo  = (COM1 & 0x02) | (AECHH & 0x2f <<10) [ (AECh << 2) */
 
-static __u8 ov7648_sensor_init[][8] = {
+static const __u8 ov7648_sensor_init[][8] = {
 	{0xC1, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00},
 	{0xC1, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00},
 	{0xC1, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00},
@@ -492,7 +492,7 @@ static __u8 ov7648_sensor_init[][8] = {
 	{0, 0, 0, 0, 0, 0, 0, 0}
 };
 
-static __u8 qtable4[] = {
+static const __u8 qtable4[] = {
 	0x06, 0x04, 0x04, 0x06, 0x04, 0x04, 0x06, 0x06, 0x06, 0x06, 0x08, 0x06,
 	0x06, 0x08, 0x0A, 0x11,
 	0x0A, 0x0A, 0x08, 0x08, 0x0A, 0x15, 0x0F, 0x0F, 0x0C, 0x11, 0x19, 0x15,
@@ -526,21 +526,30 @@ static void reg_r(struct usb_device *dev
 
 static void reg_w(struct usb_device *dev,
 			  __u16 value,
-			  __u8 *buffer,
+			  const __u8 *buffer,
 			  int len)
 {
+	/* We do not use a stack buffer here as that needs to be 64 bytes
+	   big which might be a bit much on the stack */
+	__u8 *tmpbuf = (__u8 *) kmalloc(len, GFP_KERNEL);
+	if (!tmpbuf) {
+		PDEBUG(D_ERR, "RegWrite failed: out of memory");
+		return;
+	}
+	memcpy(tmpbuf, buffer, len);
 	usb_control_msg(dev,
 			usb_sndctrlpipe(dev, 0),
 			0x08,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			value, 0,
-			buffer, len,
+			tmpbuf, len,
 			500);
+	kfree(tmpbuf);
 }
 
 /* write 2 bytes */
 static void i2c_w2(struct gspca_dev *gspca_dev,
-		   __u8 *buffer)
+		   const __u8 *buffer)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
@@ -559,7 +568,7 @@ static void i2c_w2(struct gspca_dev *gsp
 }
 
 /* write 8 bytes */
-static void i2c_w8(struct usb_device *dev, __u8 *buffer)
+static void i2c_w8(struct usb_device *dev, const __u8 *buffer)
 {
 	reg_w(dev, 0x08, buffer, 8);
 	msleep(1);
@@ -593,7 +602,7 @@ static int probesensor(struct gspca_dev 
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
 	__u8 reg02;
-	static __u8 datasend[] = { 2, 0 };
+	const __u8 datasend[] = { 2, 0 };
 	/* reg val1 val2 val3 val4 */
 	__u8 datarecd[6];
 
@@ -620,7 +629,7 @@ static int probesensor(struct gspca_dev 
 }
 
 static int configure_gpio(struct gspca_dev *gspca_dev,
-			  __u8 *sn9c1xx)
+			  const __u8 *sn9c1xx)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
@@ -1171,7 +1180,7 @@ static void sd_start(struct gspca_dev *g
 	__u8 data;
 	__u8 reg1;
 	__u8 reg17;
-	__u8 *sn9c1xx;
+	const __u8 *sn9c1xx;
 	int mode;
 	static __u8 DC29[] = { 0x6a, 0x50, 0x00, 0x00, 0x50, 0x3c };
 	static __u8 C0[] = { 0x2d, 0x2d, 0x3a, 0x05, 0x04, 0x3f };
@@ -1329,7 +1338,7 @@ static void sd_stopN(struct gspca_dev *g
 		{ 0xb1, 0x5d, 0x07, 0x00, 0x00, 0x00, 0x00, 0x10 };
 	__u8 regF1;
 	__u8 data;
-	__u8 *sn9c1xx;
+	const __u8 *sn9c1xx;
 
 	data = 0x0b;
 	switch (sd->sensor) {
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca500.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca500.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca500.c~	2008-07-03 10:43:00.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca500.c	2008-07-03 11:20:53.000000000 +0200
@@ -139,7 +139,7 @@ static struct cam_mode sif_mode[] = {
 #define SPCA500_OFFSET_DATA      16
 
 #if 0
-static __u16 spca500_read_stats[][3] = {
+static const __u16 spca500_read_stats[][3] = {
 	{0x0c, 0x0000, 0x0000},
 	{0x30, 0x03fd, 0x0001},
 	/* possible values for following call: 0x01b3, 0x01e6, 0x01f7, 0x0218 */
@@ -156,7 +156,7 @@ static __u16 spca500_read_stats[][3] = {
 };
 #endif
 
-static __u16 spca500_visual_defaults[][3] = {
+static const __u16 spca500_visual_defaults[][3] = {
 	{0x00, 0x0003, 0x816b},	/* SSI not active sync with vsync,
 				 * hue (H byte) = 0,
 				 * saturation/hue enable,
@@ -181,7 +181,7 @@ static __u16 spca500_visual_defaults[][3
 
 	{0, 0, 0}
 };
-static __u16 Clicksmart510_defaults[][3] = {
+static const __u16 Clicksmart510_defaults[][3] = {
 	{0x00, 0x00, 0x8211},
 	{0x00, 0x01, 0x82c0},
 	{0x00, 0x10, 0x82cb},
@@ -310,7 +310,7 @@ static __u16 Clicksmart510_defaults[][3]
 	{}
 };
 
-static unsigned char qtable_creative_pccam[2][64] = {
+static const unsigned char qtable_creative_pccam[2][64] = {
 	{				/* Q-table Y-components */
 	 0x05, 0x03, 0x03, 0x05, 0x07, 0x0c, 0x0f, 0x12,
 	 0x04, 0x04, 0x04, 0x06, 0x08, 0x11, 0x12, 0x11,
@@ -331,7 +331,7 @@ static unsigned char qtable_creative_pcc
 	 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e}
 };
 
-static unsigned char qtable_kodak_ez200[2][64] = {
+static const unsigned char qtable_kodak_ez200[2][64] = {
 	{				/* Q-table Y-components */
 	 0x02, 0x01, 0x01, 0x02, 0x02, 0x04, 0x05, 0x06,
 	 0x01, 0x01, 0x01, 0x02, 0x03, 0x06, 0x06, 0x06,
@@ -352,7 +352,7 @@ static unsigned char qtable_kodak_ez200[
 	 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a}
 };
 
-static unsigned char qtable_pocketdv[2][64] = {
+static const unsigned char qtable_pocketdv[2][64] = {
 	{		/* Q-table Y-components start registers 0x8800 */
 	 0x06, 0x04, 0x04, 0x06, 0x0a, 0x10, 0x14, 0x18,
 	 0x05, 0x05, 0x06, 0x08, 0x0a, 0x17, 0x18, 0x16,
@@ -448,7 +448,7 @@ static int reg_readwait(struct usb_devic
 }
 
 static int write_vector(struct gspca_dev *gspca_dev,
-				__u16 data[][3])
+				const __u16 data[][3])
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int ret, i = 0;
@@ -466,7 +466,7 @@ static int spca50x_setup_qtable(struct g
 				unsigned int request,
 				unsigned int ybase,
 				unsigned int cbase,
-				unsigned char qtable[2][64])
+				const unsigned char qtable[][64])
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int i, err;
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca501.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca501.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca501.c~	2008-07-03 10:43:37.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca501.c	2008-07-03 11:17:57.000000000 +0200
@@ -151,7 +151,7 @@ static struct cam_mode vga_mode[] = {
 #define SPCA501_A33 0x10
 
 /* Data for video camera initialization before capturing */
-static __u16 spca501_open_data[][3] = {
+static const __u16 spca501_open_data[][3] = {
 	/* bmRequest,value,index */
 
 	{0x2, 0x50, 0x00},	/* C/S enable soft reset */
@@ -257,7 +257,7 @@ static __u16 spca501_open_data[][3] = {
  */
 
 /* Data for chip initialization (set default values) */
-static __u16 spca501_init_data[][3] = {
+static const __u16 spca501_init_data[][3] = {
 	/* Set all the values to powerup defaults */
 	/* bmRequest,value,index */
 	{0x0, 0xAA, 0x00},
@@ -544,7 +544,7 @@ static __u16 spca501_init_data[][3] = {
  * Capture and decoding by Colin Peart.
  * This is is for the 3com HomeConnect Lite which is spca501a based.
  */
-static __u16 spca501_3com_open_data[][3] = {
+static const __u16 spca501_3com_open_data[][3] = {
 	/* bmRequest,value,index */
 	{0x2, 0x0050, 0x0000},	/* C/S Enable TG soft reset, timing mode=010 */
 	{0x2, 0x0043, 0x0000},	/* C/S Disable TG soft reset, timing mode=010 */
@@ -639,7 +639,7 @@ static __u16 spca501_3com_open_data[][3]
  * 2) Understand why some values seem to appear more than once
  * 3) Write a small comment for each line of the following arrays.
  */
-static __u16 spca501c_arowana_open_data[][3] = {
+static const __u16 spca501c_arowana_open_data[][3] = {
 	/* bmRequest,value,index */
 	{0x02, 0x0007, 0x0005},
 	{0x02, 0xa048, 0x0000},
@@ -661,7 +661,7 @@ static __u16 spca501c_arowana_open_data[
 	{}
 };
 
-static __u16 spca501c_arowana_init_data[][3] = {
+static const __u16 spca501c_arowana_init_data[][3] = {
 	/* bmRequest,value,index */
 	{0x02, 0x0007, 0x0005},
 	{0x02, 0xa048, 0x0000},
@@ -1595,7 +1595,7 @@ static __u16 spca501c_arowana_init_data[
 
 /* Unknow camera from Ori Usbid 0x0000:0x0000 */
 /* Based on snoops from Ori Cohen */
-static __u16 spca501c_mysterious_open_data[][3] = {
+static const __u16 spca501c_mysterious_open_data[][3] = {
 	{0x02, 0x000f, 0x0005},
 	{0x02, 0xa048, 0x0000},
 	{0x05, 0x0022, 0x0004},
@@ -1646,7 +1646,7 @@ static __u16 spca501c_mysterious_open_da
 };
 
 /* Based on snoops from Ori Cohen */
-static __u16 spca501c_mysterious_init_data[][3] = {
+static const __u16 spca501c_mysterious_init_data[][3] = {
 /* Part 3 */
 /* TG registers */
 /*	{0x00, 0x0000, 0x0000}, */
@@ -1839,7 +1839,7 @@ static int reg_read(struct usb_device *d
 }
 
 static int write_vector(struct gspca_dev *gspca_dev,
-				__u16 data[][3])
+				const __u16 data[][3])
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int ret, i = 0;
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca505.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca505.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca505.c~	2008-07-03 10:44:08.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca505.c	2008-07-03 11:18:06.000000000 +0200
@@ -91,7 +91,7 @@ static struct cam_mode vga_mode[] = {
 /*
  * Data to initialize a SPCA505. Common to the CCD and external modes
  */
-static __u16 spca505_init_data[][3] = {
+static const __u16 spca505_init_data[][3] = {
 	/* line	   bmRequest,value,index */
 	/* 1819 */
 	{SPCA50X_REG_GLOBAL, SPCA50X_GMISC3_SAA7113RST, SPCA50X_GLOBAL_MISC3},
@@ -130,7 +130,7 @@ static __u16 spca505_init_data[][3] = {
 /*
  * Data to initialize the camera using the internal CCD
  */
-static __u16 spca505_open_data_ccd[][3] = {
+static const __u16 spca505_open_data_ccd[][3] = {
 	/* line	   bmRequest,value,index */
 	/* Internal CCD data set */
 	/* 1891 */ {0x3, 0x04, 0x01},
@@ -312,7 +312,7 @@ static __u16 spca505_open_data_ccd[][3] 
 /*
  * Data to initialize the camera in external video mode
  */
-static __u16 spca505_open_data_ext[][3] = {
+static const __u16 spca505_open_data_ext[][3] = {
 	/* line	   bmRequest,value,index */
 	/* External video input dataset */
 	/* 0808 */ {0x3, 0x04, 0x01},
@@ -350,7 +350,7 @@ static __u16 spca505_open_data_ext[][3] 
 /*
  * Additional data needed to initialze the camera in external mode
  */
-static __u16 spca505_open_data2[][3] = {
+static const __u16 spca505_open_data2[][3] = {
 	/* line	   bmRequest,value,index */
 	/* 1384 */ {0x3, 0x68, 0x03},
 	/* 1385 */ {0x3, 0x10, 0x01},
@@ -388,7 +388,7 @@ static __u16 spca505_open_data2[][3] = {
 /*
  * Data to initialize a SPCA505. Common to the CCD and external modes
  */
-static __u16 spca505b_init_data[][3] = {
+static const __u16 spca505b_init_data[][3] = {
 /* start */
 	{0x02, 0x00, 0x00},		/* init */
 	{0x02, 0x00, 0x01},
@@ -452,7 +452,7 @@ static __u16 spca505b_init_data[][3] = {
 /*
  * Data to initialize the camera using the internal CCD
  */
-static __u16 spca505b_open_data_ccd[][3] = {
+static const __u16 spca505b_open_data_ccd[][3] = {
 
 /* {0x02,0x00,0x00}, */
 	{0x03, 0x04, 0x01},		/* rst */
@@ -668,7 +668,7 @@ static int reg_read(struct usb_device *d
 }
 
 static int write_vector(struct gspca_dev *gspca_dev,
-				__u16 data[][3])
+				const __u16 data[][3])
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int ret, i = 0;
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca508.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca508.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca508.c~	2008-07-03 10:46:05.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca508.c	2008-07-03 11:18:17.000000000 +0200
@@ -92,7 +92,7 @@ static struct cam_mode sif_mode[] = {
  * Initialization data: this is the first set-up data written to the
  * device (before the open data).
  */
-static __u16 spca508_init_data[][3] =
+static const __u16 spca508_init_data[][3] =
 #define IGN(x)			/* nothing */
 {
 	/*  line   URB      value, index */
@@ -611,7 +611,7 @@ static __u16 spca508_init_data[][3] =
 /*
  * Data to initialize the camera using the internal CCD
  */
-static __u16 spca508_open_data[][3] = {
+static const __u16 spca508_open_data[][3] = {
 	/* line	bmRequest,value,index */
 	{0, 0}
 };
@@ -620,7 +620,7 @@ static __u16 spca508_open_data[][3] = {
 /*
  * Initialization data for Intel EasyPC Camera CS110
  */
-static __u16 spca508cs110_init_data[][3] = {
+static const __u16 spca508cs110_init_data[][3] = {
 	{0x0000, 0x870b}, /* Reset CTL3 */
 	{0x0003, 0x8111}, /* Soft Reset compression, memory, TG & CDSP */
 	{0x0000, 0x8111}, /* Normal operation on reset */
@@ -704,7 +704,7 @@ static __u16 spca508cs110_init_data[][3]
 	{}
 };
 
-static __u16 spca508_sightcam_init_data[][3] = {
+static const __u16 spca508_sightcam_init_data[][3] = {
 /* This line seems to setup the frame/canvas */
 	/*368  */ {0x000f, 0x8402},
 
@@ -788,7 +788,7 @@ static __u16 spca508_sightcam_init_data[
 	{0, 0}
 };
 
-static __u16 spca508_sightcam2_init_data[][3] = {
+static const __u16 spca508_sightcam2_init_data[][3] = {
 #if 1
 /* 35 */ {0x0020, 0x8112},
 
@@ -1137,7 +1137,7 @@ static __u16 spca508_sightcam2_init_data
 /*
  * Initialization data for Creative Webcam Vista
  */
-static __u16 spca508_vista_init_data[][3] = {
+static const __u16 spca508_vista_init_data[][3] = {
 	{0x0008, 0x8200},	/* Clear register */
 	{0x0000, 0x870b},	/* Reset CTL3 */
 	{0x0020, 0x8112},	/* Video Drop packet enable */
@@ -1479,7 +1479,7 @@ static int reg_read(struct usb_device *d
 }
 
 static int write_vector(struct gspca_dev *gspca_dev,
-				__u16 data[][3])
+				const __u16 data[][3])
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int ret, i = 0;
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca561.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca561.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca561.c~	2008-07-03 10:47:52.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca561.c	2008-07-03 11:19:16.000000000 +0200
@@ -148,7 +148,7 @@ static void reg_w_val(struct usb_device 
 		PDEBUG(D_ERR, "reg write: error %d", ret);
 }
 
-static void write_vector(struct gspca_dev *gspca_dev, __u16 data[][2])
+static void write_vector(struct gspca_dev *gspca_dev, const __u16 data[][2])
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int i;
@@ -227,7 +227,7 @@ static int i2c_read(struct gspca_dev *gs
 	return ((int) value << 8) | vallsb;
 }
 
-static __u16 spca561_init_data[][2] = {
+static const __u16 spca561_init_data[][2] = {
 	{0x0000, 0x8114},	/* Software GPIO output data */
 	{0x0001, 0x8114},	/* Software GPIO output data */
 	{0x0000, 0x8112},	/* Some kind of reset */
@@ -437,7 +437,7 @@ static void sensor_reset(struct gspca_de
 }
 
 /******************** QC Express etch2 stuff ********************/
-static __u16 Pb100_1map8300[][2] = {
+static const __u16 Pb100_1map8300[][2] = {
 	/* reg, value */
 	{0x8320, 0x3304},
 
@@ -452,14 +452,14 @@ static __u16 Pb100_1map8300[][2] = {
 	{0x8302, 0x000e},
 	{}
 };
-static __u16 Pb100_2map8300[][2] = {
+static const __u16 Pb100_2map8300[][2] = {
 	/* reg, value */
 	{0x8339, 0x0000},
 	{0x8307, 0x00aa},
 	{}
 };
 
-static __u16 spca561_161rev12A_data1[][2] = {
+static const __u16 spca561_161rev12A_data1[][2] = {
 	{0x21, 0x8118},
 	{0x01, 0x8114},
 	{0x00, 0x8112},
@@ -467,7 +467,7 @@ static __u16 spca561_161rev12A_data1[][2
 	{0x04, 0x8802},		/* windows uses 08 */
 	{}
 };
-static __u16 spca561_161rev12A_data2[][2] = {
+static const __u16 spca561_161rev12A_data2[][2] = {
 	{0x21, 0x8118},
 	{0x10, 0x8500},
 	{0x07, 0x8601},
@@ -513,7 +513,7 @@ static __u16 spca561_161rev12A_data2[][2
 };
 
 static void sensor_mapwrite(struct gspca_dev *gspca_dev,
-			    __u16 sensormap[][2])
+			    const __u16 sensormap[][2])
 {
 	int i = 0;
 	__u8 usbval[2];
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sunplus.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sunplus.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sunplus.c~	2008-07-03 10:51:39.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sunplus.c	2008-07-03 11:20:00.000000000 +0200
@@ -156,7 +156,7 @@ static struct cam_mode vga_mode2[] = {
 #define SPCA536_OFFSET_FRAMSEQ	 1
 
 /* Initialisation data for the Creative PC-CAM 600 */
-static __u16 spca504_pccam600_init_data[][3] = {
+static const __u16 spca504_pccam600_init_data[][3] = {
 /*	{0xa0, 0x0000, 0x0503},  * capture mode */
 	{0x00, 0x0000, 0x2000},
 	{0x00, 0x0013, 0x2301},
@@ -193,7 +193,7 @@ static __u16 spca504_pccam600_init_data[
 /* Creative PC-CAM 600 specific open data, sent before using the
  * generic initialisation data from spca504_open_data.
  */
-static __u16 spca504_pccam600_open_data[][3] = {
+static const __u16 spca504_pccam600_open_data[][3] = {
 	{0x00, 0x0001, 0x2501},
 	{0x20, 0x0500, 0x0001},	/* snapshot mode */
 	{0x00, 0x0003, 0x2880},
@@ -202,7 +202,7 @@ static __u16 spca504_pccam600_open_data[
 };
 
 /* Initialisation data for the logitech clicksmart 420 */
-static __u16 spca504A_clicksmart420_init_data[][3] = {
+static const __u16 spca504A_clicksmart420_init_data[][3] = {
 /*	{0xa0, 0x0000, 0x0503},  * capture mode */
 	{0x00, 0x0000, 0x2000},
 	{0x00, 0x0013, 0x2301},
@@ -257,7 +257,7 @@ static __u16 spca504A_clicksmart420_init
 };
 
 /* clicksmart 420 open data ? */
-static __u16 spca504A_clicksmart420_open_data[][3] = {
+static const __u16 spca504A_clicksmart420_open_data[][3] = {
 	{0x00, 0x0001, 0x2501},
 	{0x20, 0x0502, 0x0000},
 	{0x06, 0x0000, 0x0000},
@@ -404,7 +404,7 @@ static __u16 spca504A_clicksmart420_open
 	{}
 };
 
-static unsigned char qtable_creative_pccam[2][64] = {
+static const unsigned char qtable_creative_pccam[2][64] = {
 	{				/* Q-table Y-components */
 	 0x05, 0x03, 0x03, 0x05, 0x07, 0x0c, 0x0f, 0x12,
 	 0x04, 0x04, 0x04, 0x06, 0x08, 0x11, 0x12, 0x11,
@@ -429,7 +429,7 @@ static unsigned char qtable_creative_pcc
  *		except for one byte. Possibly a typo?
  *		NWG: 18/05/2003.
  */
-static unsigned char qtable_spca504_default[2][64] = {
+static const unsigned char qtable_spca504_default[2][64] = {
 	{				/* Q-table Y-components */
 	 0x05, 0x03, 0x03, 0x05, 0x07, 0x0c, 0x0f, 0x12,
 	 0x04, 0x04, 0x04, 0x06, 0x08, 0x11, 0x12, 0x11,
@@ -543,7 +543,7 @@ static int reg_read(struct usb_device *d
 }
 
 static int write_vector(struct gspca_dev *gspca_dev,
-				__u16 data[][3])
+				const __u16 data[][3])
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int ret, i = 0;
@@ -565,7 +565,7 @@ static int spca50x_setup_qtable(struct g
 				unsigned int request,
 				unsigned int ybase,
 				unsigned int cbase,
-				unsigned char qtable[2][64])
+				const unsigned char qtable[][64])
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int i, err;
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/t613.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/t613.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/t613.c~	2008-07-03 10:56:36.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/t613.c	2008-07-03 11:22:26.000000000 +0200
@@ -252,7 +252,7 @@ static struct cam_mode vga_mode_t16[] = 
 #define MAX_EFFECTS 7
 /* easily done by soft, this table could be removed,
  * i keep it here just in case */
-unsigned char effects_table[MAX_EFFECTS][6] = {
+static const unsigned char effects_table[MAX_EFFECTS][6] = {
 	{0xa8, 0xe8, 0xc6, 0xd2, 0xc0, 0x00},	/* Normal */
 	{0xa8, 0xc8, 0xc6, 0x52, 0xc0, 0x04},	/* Repujar */
 	{0xa8, 0xe8, 0xc6, 0xd2, 0xc0, 0x20},	/* Monochrome */
@@ -262,7 +262,7 @@ unsigned char effects_table[MAX_EFFECTS]
 	{0xa8, 0xc8, 0xc6, 0xd2, 0xc0, 0x40},	/* Negative */
 };
 
-unsigned char gamma_table[MAX_GAMMA][34] = {
+static const unsigned char gamma_table[MAX_GAMMA][34] = {
 	{0x90, 0x00, 0x91, 0x3e, 0x92, 0x69, 0x93, 0x85,
 	 0x94, 0x95, 0x95, 0xa1, 0x96, 0xae, 0x97, 0xb9,
 	 0x98, 0xc2, 0x99, 0xcb, 0x9a, 0xd4, 0x9b, 0xdb,
@@ -345,7 +345,7 @@ unsigned char gamma_table[MAX_GAMMA][34]
 	 0xA0, 0xFF}
 };
 
-static __u8 tas5130a_sensor_init[][8] = {
+static const __u8 tas5130a_sensor_init[][8] = {
 	{0x62, 0x08, 0x63, 0x70, 0x64, 0x1d, 0x60, 0x09},
 	{0x62, 0x20, 0x63, 0x01, 0x64, 0x02, 0x60, 0x09},
 	{0x62, 0x07, 0x63, 0x03, 0x64, 0x00, 0x60, 0x09},
@@ -366,13 +366,22 @@ static void t16RegRead(struct usb_device
 
 static void t16RegWrite(struct usb_device *dev,
 			__u16 value,
-			__u16 index, __u8 *buffer, __u16 length)
+			__u16 index, const __u8 *buffer, __u16 length)
 {
+	/* We do not use a stack buffer here as that needs to be 70 bytes
+	   big which might be a bit much on the stack */
+	__u8 *tmpbuf = (__u8 *) kmalloc(length, GFP_KERNEL);
+	if (!tmpbuf) {
+		PDEBUG(D_ERR, "RegWrite failed: out of memory");
+		return;
+	}
+	memcpy(tmpbuf, buffer, length);
 	usb_control_msg(dev,
 			usb_sndctrlpipe(dev, 0),
 			0,		/* request */
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, index, buffer, length, 500);
+			value, index, tmpbuf, length, 500);
+	kfree(tmpbuf);
 }
 
 /* this function is called at probe time */
@@ -425,18 +434,18 @@ static int init_default_parameters(struc
 	int i = 0;
 	__u8 test_byte;
 
-	static unsigned char read_indexs[] =
+	const unsigned char read_indexs[] =
 		{ 0x06, 0x07, 0x0a, 0x0b, 0x66, 0x80, 0x81, 0x8e, 0x8f, 0xa5,
 		  0xa6, 0xa8, 0xbb, 0xbc, 0xc6, 0x00, 0x00 };
-	static unsigned char n1[6] =
+	const unsigned char n1[6] =
 			{0x08, 0x03, 0x09, 0x03, 0x12, 0x04};
-	static unsigned char n2[2] =
+	const unsigned char n2[2] =
 			{0x08, 0x00};
-	static unsigned char nset[6] =
+	const unsigned char nset[6] =
 		{ 0x61, 0x68, 0x62, 0xff, 0x60, 0x07 };
-	static unsigned char n3[6] =
+	const unsigned char n3[6] =
 			{0x61, 0x68, 0x65, 0x0a, 0x60, 0x04};
-	static unsigned char n4[0x46] =
+	const unsigned char n4[0x46] =
 		{0x09, 0x01, 0x12, 0x04, 0x66, 0x8a, 0x80, 0x3c,
 		 0x81, 0x22, 0x84, 0x50, 0x8a, 0x78, 0x8b, 0x68,
 		 0x8c, 0x88, 0x8e, 0x33, 0x8f, 0x24, 0xaa, 0xb1,
@@ -447,7 +456,7 @@ static int init_default_parameters(struc
 		 0x87, 0x40, 0x89, 0x2b, 0x8d, 0xff, 0x83, 0x40,
 		 0xac, 0x84, 0xad, 0x86, 0xaf, 0x46};
 #if 0
-	static unsigned char nset1[50] = {
+	const unsigned char nset1[50] = {
 		0x80, 0x3c, 0x81, 0x68, 0x83, 0xa0, 0x84, 0x20, 0x8a, 0x5c,
 		0x8b, 0x4c, 0x8c, 0x88, 0x8e, 0xb4,
 		0x8f, 0x24, 0xa1, 0xb1, 0xa2, 0x30, 0xa5, 0x18, 0xa6, 0x4a,
@@ -457,40 +466,40 @@ static int init_default_parameters(struc
 		0xc6, 0xd2
 	};
 #endif
-	static unsigned char nset4[18] = {
+	const unsigned char nset4[18] = {
 		0xe0, 0x60, 0xe1, 0xa8, 0xe2, 0xe0, 0xe3, 0x60, 0xe4, 0xa8,
 		0xe5, 0xe0, 0xe6, 0x60, 0xe7, 0xa8,
 		0xe8, 0xe0
 	};
 	/* ojo puede ser 0xe6 en vez de 0xe9 */
-	static unsigned char nset2[20] = {
+	const unsigned char nset2[20] = {
 		0xd0, 0xbb, 0xd1, 0x28, 0xd2, 0x10, 0xd3, 0x10, 0xd4, 0xbb,
 		0xd5, 0x28, 0xd6, 0x1e, 0xd7, 0x27,
 		0xd8, 0xc8, 0xd9, 0xfc
 	};
-	static unsigned char missing[8] =
+	const unsigned char missing[8] =
 		{ 0x87, 0x20, 0x88, 0x20, 0x89, 0x20, 0x80, 0x38 };
-	static unsigned char nset3[18] = {
+	const unsigned char nset3[18] = {
 		0xc7, 0x60, 0xc8, 0xa8, 0xc9, 0xe0, 0xca, 0x60, 0xcb, 0xa8,
 		0xcc, 0xe0, 0xcd, 0x60, 0xce, 0xa8,
 		0xcf, 0xe0
 	};
-	static unsigned char nset5[4] =
+	const unsigned char nset5[4] =
 		{ 0x8f, 0x24, 0xc3, 0x00 };	/* bright */
-	static unsigned char nset6[34] = {
+	const unsigned char nset6[34] = {
 		0x90, 0x00, 0x91, 0x1c, 0x92, 0x30, 0x93, 0x43, 0x94, 0x54,
 		0x95, 0x65, 0x96, 0x75, 0x97, 0x84,
 		0x98, 0x93, 0x99, 0xa1, 0x9a, 0xb0, 0x9b, 0xbd, 0x9c, 0xca,
 		0x9d, 0xd8, 0x9e, 0xe5, 0x9f, 0xf2,
 		0xa0, 0xff
 	};			/* Gamma */
-	static unsigned char nset7[4] =
+	const unsigned char nset7[4] =
 			{ 0x66, 0xca, 0xa8, 0xf8 };	/* 50/60 Hz */
-	static unsigned char nset9[4] =
+	const unsigned char nset9[4] =
 			{ 0x0b, 0x04, 0x0a, 0x78 };
-	static unsigned char nset8[6] =
+	const unsigned char nset8[6] =
 			{ 0xa8, 0xf0, 0xc6, 0x88, 0xc0, 0x00 };
-	static unsigned char nset10[6] =
+	const unsigned char nset10[6] =
 			{ 0x0c, 0x03, 0xab, 0x10, 0x81, 0x20 };
 
 	t16RegWrite(dev, 0x01, 0x0000, n1, 0x06);
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/vc032x.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/vc032x.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/vc032x.c~	2008-07-03 10:59:51.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/vc032x.c	2008-07-03 11:28:12.000000000 +0200
@@ -98,15 +98,15 @@ static struct cam_mode vc0323_mode[] = {
 };
 
 #if 0
-static __u8 mi1310soc_gamma[17] = {
+static const __u8 mi1310soc_gamma[17] = {
 	0x00, 0x13, 0x38, 0x59, 0x79, 0x92, 0xa7, 0xb9, 0xc8,
 	0xd4, 0xdf, 0xe7, 0xee, 0xf4, 0xf9, 0xfc, 0xff
 };
-static __u8 mi1310soc_matrix[9] = {
+static const __u8 mi1310soc_matrix[9] = {
 	0x56, 0xf0, 0xf6, 0xf3, 0x57, 0xf6, 0xf3, 0xef, 0x58
 };
 #endif
-static __u8 mi1310_socinitVGA_JPG[][4] = {
+static const __u8 mi1310_socinitVGA_JPG[][4] = {
 	{0xb0, 0x03, 0x19, 0xcc},
 	{0xb0, 0x04, 0x02, 0xcc},
 	{0xb3, 0x00, 0x64, 0xcc},
@@ -258,7 +258,7 @@ static __u8 mi1310_socinitVGA_JPG[][4] =
 	{0x03, 0x03, 0xc0, 0xbb},
 	{},
 };
-static __u8 mi1310_socinitQVGA_JPG[][4] = {
+static const __u8 mi1310_socinitQVGA_JPG[][4] = {
 	{0xb0, 0x03, 0x19, 0xcc},	{0xb0, 0x04, 0x02, 0xcc},
 	{0xb3, 0x00, 0x64, 0xcc},	{0xb3, 0x00, 0x65, 0xcc},
 	{0xb3, 0x05, 0x00, 0xcc},	{0xb3, 0x06, 0x00, 0xcc},
@@ -332,14 +332,14 @@ static __u8 mi1310_socinitQVGA_JPG[][4] 
 	{},
 };
 
-static __u8 mi1320_gamma[17] = {
+static const __u8 mi1320_gamma[17] = {
 	0x00, 0x13, 0x38, 0x59, 0x79, 0x92, 0xa7, 0xb9, 0xc8,
 	0xd4, 0xdf, 0xe7, 0xee, 0xf4, 0xf9, 0xfc, 0xff
 };
-static __u8 mi1320_matrix[9] = {
+static const __u8 mi1320_matrix[9] = {
 	0x54, 0xda, 0x06, 0xf1, 0x50, 0xf4, 0xf7, 0xea, 0x52
 };
-static __u8 mi1320_initVGA_data[][4] = {
+static const __u8 mi1320_initVGA_data[][4] = {
 	{0xb3, 0x01, 0x01, 0xcc},	{0x00, 0x00, 0x33, 0xdd},
 	{0xb0, 0x03, 0x19, 0xcc},	{0x00, 0x00, 0x33, 0xdd},
 	{0xb0, 0x04, 0x02, 0xcc},	{0x00, 0x00, 0x33, 0xdd},
@@ -418,7 +418,7 @@ static __u8 mi1320_initVGA_data[][4] = {
 	{0xb3, 0x5c, 0x01, 0xcc},	{0xb3, 0x01, 0x41, 0xcc},
 	{}
 };
-static __u8 mi1320_initQVGA_data[][4] = {
+static const __u8 mi1320_initQVGA_data[][4] = {
 	{0xb3, 0x01, 0x01, 0xcc},	{0x00, 0x00, 0x33, 0xdd},
 	{0xb0, 0x03, 0x19, 0xcc},	{0x00, 0x00, 0x33, 0xdd},
 	{0xb0, 0x04, 0x02, 0xcc},	{0x00, 0x00, 0x33, 0xdd},
@@ -487,15 +487,15 @@ static __u8 mi1320_initQVGA_data[][4] = 
 	{}
 };
 
-static __u8 po3130_gamma[17] = {
+static const __u8 po3130_gamma[17] = {
 	0x00, 0x13, 0x38, 0x59, 0x79, 0x92, 0xa7, 0xb9, 0xc8,
 	0xd4, 0xdf, 0xe7, 0xee, 0xf4, 0xf9, 0xfc, 0xff
 };
-static __u8 po3130_matrix[9] = {
+static const __u8 po3130_matrix[9] = {
 	0x5f, 0xec, 0xf5, 0xf1, 0x5a, 0xf5, 0xf1, 0xec, 0x63
 };
 
-static __u8 po3130_initVGA_data[][4] = {
+static const __u8 po3130_initVGA_data[][4] = {
 	{0xb0, 0x4d, 0x00, 0xcc},	{0xb3, 0x01, 0x01, 0xcc},
 	{0x00, 0x00, 0x50, 0xdd},	{0xb0, 0x03, 0x01, 0xcc},
 	{0xb3, 0x00, 0x04, 0xcc},	{0xb3, 0x00, 0x24, 0xcc},
@@ -578,7 +578,7 @@ static __u8 po3130_initVGA_data[][4] = {
 	{0xb3, 0x5c, 0x00, 0xcc},	{0xb3, 0x01, 0x41, 0xcc},
 	{}
 };
-static __u8 po3130_rundata[][4] = {
+static const __u8 po3130_rundata[][4] = {
 	{0x00, 0x47, 0x45, 0xaa},	{0x00, 0x48, 0x9b, 0xaa},
 	{0x00, 0x49, 0x3a, 0xaa},	{0x00, 0x4a, 0x01, 0xaa},
 	{0x00, 0x44, 0x40, 0xaa},
@@ -593,7 +593,7 @@ static __u8 po3130_rundata[][4] = {
 	{}
 };
 
-static __u8 po3130_initQVGA_data[][4] = {
+static const __u8 po3130_initQVGA_data[][4] = {
 	{0xb0, 0x4d, 0x00, 0xcc},	{0xb3, 0x01, 0x01, 0xcc},
 	{0x00, 0x00, 0x50, 0xdd},	{0xb0, 0x03, 0x09, 0xcc},
 	{0xb3, 0x00, 0x04, 0xcc},	{0xb3, 0x00, 0x24, 0xcc},
@@ -679,16 +679,16 @@ static __u8 po3130_initQVGA_data[][4] = 
 	{}
 };
 
-static __u8 hv7131r_gamma[17] = {
+static const __u8 hv7131r_gamma[17] = {
 /*	0x00, 0x13, 0x38, 0x59, 0x79, 0x92, 0xa7, 0xb9, 0xc8,
  *	0xd4, 0xdf, 0xe7, 0xee, 0xf4, 0xf9, 0xfc, 0xff */
 	0x04, 0x1a, 0x36, 0x55, 0x6f, 0x87, 0x9d, 0xb0, 0xc1,
 	0xcf, 0xda, 0xe4, 0xec, 0xf3, 0xf8, 0xfd, 0xff
 };
-static __u8 hv7131r_matrix[9] = {
+static const __u8 hv7131r_matrix[9] = {
 	0x5f, 0xec, 0xf5, 0xf1, 0x5a, 0xf5, 0xf1, 0xec, 0x63
 };
-static __u8 hv7131r_initVGA_data[][4] = {
+static const __u8 hv7131r_initVGA_data[][4] = {
 	{0xb0, 0x4d, 0x00, 0xcc},	{0xb3, 0x01, 0x01, 0xcc},
 	{0x00, 0x00, 0x50, 0xdd},	{0xb0, 0x03, 0x01, 0xcc},
 	{0xb3, 0x00, 0x24, 0xcc},
@@ -731,7 +731,7 @@ static __u8 hv7131r_initVGA_data[][4] = 
 	{}
 };
 
-static __u8 hv7131r_initQVGA_data[][4] = {
+static const __u8 hv7131r_initQVGA_data[][4] = {
 	{0xb0, 0x4d, 0x00, 0xcc},	{0xb3, 0x01, 0x01, 0xcc},
 	{0x00, 0x00, 0x50, 0xdd},	{0xb0, 0x03, 0x01, 0xcc},
 	{0xb3, 0x00, 0x24, 0xcc},
@@ -786,14 +786,14 @@ static __u8 hv7131r_initQVGA_data[][4] =
 	{}
 };
 
-static __u8 ov7660_gamma[17] = {
+static const __u8 ov7660_gamma[17] = {
 	0x00, 0x13, 0x38, 0x59, 0x79, 0x92, 0xa7, 0xb9, 0xc8,
 	0xd4, 0xdf, 0xe7, 0xee, 0xf4, 0xf9, 0xfc, 0xff
 };
-static __u8 ov7660_matrix[9] = {
+static const __u8 ov7660_matrix[9] = {
 	0x5a, 0xf0, 0xf6, 0xf3, 0x57, 0xf6, 0xf3, 0xef, 0x62
 };
-static __u8 ov7660_initVGA_data[][4] = {
+static const __u8 ov7660_initVGA_data[][4] = {
 	{0xb0, 0x4d, 0x00, 0xcc},	{0xb3, 0x01, 0x01, 0xcc},
 	{0x00, 0x00, 0x50, 0xdd},
 	{0xb0, 0x03, 0x01, 0xcc},
@@ -851,7 +851,7 @@ static __u8 ov7660_initVGA_data[][4] = {
 	{0x00, 0x29, 0x3c, 0xaa},	{0xb3, 0x01, 0x45, 0xcc},
 	{}
 };
-static __u8 ov7660_initQVGA_data[][4] = {
+static const __u8 ov7660_initQVGA_data[][4] = {
 	{0xb0, 0x4d, 0x00, 0xcc},	{0xb3, 0x01, 0x01, 0xcc},
 	{0x00, 0x00, 0x50, 0xdd},	{0xb0, 0x03, 0x01, 0xcc},
 	{0xb3, 0x00, 0x21, 0xcc},	{0xb3, 0x00, 0x26, 0xcc},
@@ -920,26 +920,26 @@ static __u8 ov7660_initQVGA_data[][4] = 
 	{0x00, 0x00, 0x00, 0x00}
 };
 
-static __u8 ov7660_50HZ[][4] = {
+static const __u8 ov7660_50HZ[][4] = {
 	{0x00, 0x3b, 0x08, 0xaa},
 	{0x00, 0x9d, 0x40, 0xaa},
 	{0x00, 0x13, 0xa7, 0xaa},
 	{0x00, 0x00, 0x00, 0x00}
 };
 
-static __u8 ov7660_60HZ[][4] = {
+static const __u8 ov7660_60HZ[][4] = {
 	{0x00, 0x3b, 0x00, 0xaa},
 	{0x00, 0x9e, 0x40, 0xaa},
 	{0x00, 0x13, 0xa7, 0xaa},
 	{}
 };
 
-static __u8 ov7660_NoFliker[][4] = {
+static const __u8 ov7660_NoFliker[][4] = {
 	{0x00, 0x13, 0x87, 0xaa},
 	{}
 };
 
-static __u8 ov7670_initVGA_JPG[][4] = {
+static const __u8 ov7670_initVGA_JPG[][4] = {
 	{0xb3, 0x01, 0x05, 0xcc},
 	{0x00, 0x00, 0x30, 0xdd},	{0xb0, 0x03, 0x19, 0xcc},
 	{0x00, 0x00, 0x10, 0xdd},
@@ -1067,7 +1067,7 @@ static __u8 ov7670_initVGA_JPG[][4] = {
 	{},
 };
 
-static __u8 ov7670_initQVGA_JPG[][4] = {
+static const __u8 ov7670_initQVGA_JPG[][4] = {
 	{0xb3, 0x01, 0x05, 0xcc},	{0x00, 0x00, 0x30, 0xdd},
 	{0xb0, 0x03, 0x19, 0xcc},	{0x00, 0x00, 0x10, 0xdd},
 	{0xb0, 0x04, 0x02, 0xcc},	{0x00, 0x00, 0x10, 0xdd},
@@ -1199,7 +1199,7 @@ static __u8 ov7670_initQVGA_JPG[][4] = {
 	{},
 };
 #if 0
-static __u8 ov7670_initQVGA_JPG[][4] = {
+static const __u8 ov7670_initQVGA_JPG[][4] = {
 	{0xb3, 0x00, 0x00, 0xcc},
 	{0xb0, 0x16, 0x0d, 0xcc},
 	{0x00, 0x00, 0x50, 0xdd},	{0xb0, 0x16, 0x00, 0xcc},
@@ -1380,7 +1380,7 @@ struct sensor_info {
 	__u8 op;
 	};
 
-static struct sensor_info sensor_info_data[] = {
+static const struct sensor_info sensor_info_data[] = {
 /*      sensorId,         I2cAdd,	IdAdd,  VpId,  m1,    m2,  op */
 	{SENSOR_HV7131R,    0x80 | 0x11, 0x00, 0x0209, 0x24, 0x25, 0x01},
 	{SENSOR_OV7660,     0x80 | 0x21, 0x0a, 0x7660, 0x26, 0x26, 0x05},
@@ -1462,7 +1462,7 @@ static int vc032x_probe_sensor(struct gs
 	int i;
 	__u8 data;
 	__u16 value;
-	struct sensor_info *ptsensor_info;
+	const struct sensor_info *ptsensor_info;
 
 	reg_r(dev, 0xa1, 0xbfcf, &data, 1);
 	PDEBUG(D_PROBE, "check sensor header %d", data);
@@ -1489,7 +1489,7 @@ static int vc032x_probe_sensor(struct gs
 }
 
 static __u8 i2c_write(struct usb_device *dev,
-				__u8 reg, __u8 *val, __u8 size)
+				__u8 reg, const __u8 *val, __u8 size)
 {
 	__u8 retbyte;
 
@@ -1521,7 +1521,7 @@ static __u8 i2c_write(struct usb_device 
 }
 
 static void put_tab_to_reg(struct gspca_dev *gspca_dev,
-			__u8 *tab, __u8 tabsize, __u16 addr)
+			const __u8 *tab, __u8 tabsize, __u16 addr)
 {
 	int j;
 	__u16 ad = addr;
@@ -1531,7 +1531,7 @@ static void put_tab_to_reg(struct gspca_
 }
 
 static void usb_exchange(struct gspca_dev *gspca_dev,
-				__u8 data[][4])
+				const __u8 data[][4])
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int i = 0;
@@ -1708,7 +1708,7 @@ static void setautogain(struct gspca_dev
 static void setlightfreq(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	static __u8 (*ov7660_freq_tb[3])[4] =
+	static const __u8 (*ov7660_freq_tb[3])[4] =
 		{ov7660_NoFliker, ov7660_50HZ, ov7660_60HZ};
 
 	if (sd->sensor != SENSOR_OV7660)
@@ -1720,8 +1720,8 @@ static void sd_start(struct gspca_dev *g
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 /*	__u8 tmp2; */
-	__u8 *GammaT = NULL;
-	__u8 *MatrixT = NULL;
+	const __u8 *GammaT = NULL;
+	const __u8 *MatrixT = NULL;
 	int mode;
 
 	/* Assume start use the good resolution from gspca_dev->mode */
diff -up gspca-2bbb47f61a95/linux/drivers/media/video/gspca/zc3xx.c~ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/zc3xx.c
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/zc3xx.c~	2008-07-03 11:05:01.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/zc3xx.c	2008-07-03 11:25:28.000000000 +0200
@@ -190,7 +190,7 @@ struct usb_action {
 	__u16	idx;
 };
 
-static struct usb_action cs2102_Initial[] = {
+static const struct usb_action cs2102_Initial[] = {
 	{0xa1, 0x01, 0x0008},
 	{0xa1, 0x01, 0x0008},
 	{0xa0, 0x01, 0x0000},
@@ -320,7 +320,7 @@ static struct usb_action cs2102_Initial[
 	{}
 };
 
-static struct usb_action cs2102_InitialScale[] = {
+static const struct usb_action cs2102_InitialScale[] = {
 	{0xa1, 0x01, 0x0008},
 	{0xa1, 0x01, 0x0008},
 	{0xa0, 0x01, 0x0000},
@@ -449,7 +449,7 @@ static struct usb_action cs2102_InitialS
 	{0xa0, 0x40, 0x0118},
 	{}
 };
-static struct usb_action cs2102_50HZ[] = {
+static const struct usb_action cs2102_50HZ[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0f, 0x008c}, /* 00,0f,8c,aa */
 	{0xaa, 0x03, 0x0005}, /* 00,03,05,aa */
@@ -474,7 +474,7 @@ static struct usb_action cs2102_50HZ[] =
 	{0xa0, 0xd0, 0x001f}, /* 00,1f,d0,cc */
 	{}
 };
-static struct usb_action cs2102_50HZScale[] = {
+static const struct usb_action cs2102_50HZScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0f, 0x0093}, /* 00,0f,93,aa */
 	{0xaa, 0x03, 0x0005}, /* 00,03,05,aa */
@@ -499,7 +499,7 @@ static struct usb_action cs2102_50HZScal
 	{0xa0, 0xd0, 0x001f}, /* 00,1f,d0,cc */
 	{}
 };
-static struct usb_action cs2102_60HZ[] = {
+static const struct usb_action cs2102_60HZ[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0f, 0x005d}, /* 00,0f,5d,aa */
 	{0xaa, 0x03, 0x0005}, /* 00,03,05,aa */
@@ -524,7 +524,7 @@ static struct usb_action cs2102_60HZ[] =
 	{0xa0, 0xd0, 0x00c8}, /* 00,c8,d0,cc */
 	{}
 };
-static struct usb_action cs2102_60HZScale[] = {
+static const struct usb_action cs2102_60HZScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0f, 0x00b7}, /* 00,0f,b7,aa */
 	{0xaa, 0x03, 0x0005}, /* 00,03,05,aa */
@@ -549,7 +549,7 @@ static struct usb_action cs2102_60HZScal
 	{0xa0, 0xe8, 0x001f}, /* 00,1f,e8,cc */
 	{}
 };
-static struct usb_action cs2102_NoFliker[] = {
+static const struct usb_action cs2102_NoFliker[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0f, 0x0059}, /* 00,0f,59,aa */
 	{0xaa, 0x03, 0x0005}, /* 00,03,05,aa */
@@ -574,7 +574,7 @@ static struct usb_action cs2102_NoFliker
 	{0xa0, 0xc8, 0x001f}, /* 00,1f,c8,cc */
 	{}
 };
-static struct usb_action cs2102_NoFlikerScale[] = {
+static const struct usb_action cs2102_NoFlikerScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0f, 0x0059}, /* 00,0f,59,aa */
 	{0xaa, 0x03, 0x0005}, /* 00,03,05,aa */
@@ -601,7 +601,7 @@ static struct usb_action cs2102_NoFliker
 };
 
 /* CS2102_KOCOM */
-static struct usb_action cs2102K_Initial[] = {
+static const struct usb_action cs2102K_Initial[] = {
 	{0xa0, 0x11, 0x0002},
 	{0xa0, 0x03, 0x0008},
 	{0xa0, 0x08, 0x0010},
@@ -860,7 +860,7 @@ static struct usb_action cs2102K_Initial
 	{}
 };
 
-static struct usb_action cs2102K_InitialScale[] = {
+static const struct usb_action cs2102K_InitialScale[] = {
 	{0xa0, 0x11, 0x0002},
 	{0xa0, 0x00, 0x0002},
 	{0xa0, 0x03, 0x0008},
@@ -1437,7 +1437,7 @@ static struct usb_action cs2102K_Initial
 	{}
 };
 
-static struct usb_action gc0305_Initial[] = {		/* 640x480 */
+static const struct usb_action gc0305_Initial[] = {		/* 640x480 */
 	{0xa0, 0x01, 0x0000},	/* 00,00,01,cc */
 	{0xa0, 0x03, 0x0008},	/* 00,08,03,cc */
 	{0xa0, 0x01, 0x0010},	/* 00,10,01,cc */
@@ -1501,7 +1501,7 @@ static struct usb_action gc0305_Initial[
 	{0xa0, 0x03, 0x0113},	/* 01,13,03,cc */
 	{}
 };
-static struct usb_action gc0305_InitialScale[] = {	/* 320x240 */
+static const struct usb_action gc0305_InitialScale[] = {	/* 320x240 */
 	{0xa0, 0x01, 0x0000},	/* 00,00,01,cc */
 	{0xa0, 0x03, 0x0008},	/* 00,08,03,cc */
 	{0xa0, 0x01, 0x0010},	/* 00,10,01,cc */
@@ -1564,7 +1564,7 @@ static struct usb_action gc0305_InitialS
 	{0xa0, 0x03, 0x0113},	/* 01,13,03,cc */
 	{}
 };
-static struct usb_action gc0305_50HZ[] = {
+static const struct usb_action gc0305_50HZ[] = {
 	{0xaa, 0x82, 0x0000},	/* 00,82,00,aa */
 	{0xaa, 0x83, 0x0002},	/* 00,83,02,aa */
 	{0xaa, 0x84, 0x0038},	/* 00,84,38,aa */	/* win: 00,84,ec */
@@ -1587,7 +1587,7 @@ static struct usb_action gc0305_50HZ[] =
 /*	{0xa0, 0x85, 0x018d},	 * 01,8d,85,cc *	 * if 640x480 */
 	{}
 };
-static struct usb_action gc0305_60HZ[] = {
+static const struct usb_action gc0305_60HZ[] = {
 	{0xaa, 0x82, 0x0000},	/* 00,82,00,aa */
 	{0xaa, 0x83, 0x0000},	/* 00,83,00,aa */
 	{0xaa, 0x84, 0x00ec},	/* 00,84,ec,aa */
@@ -1611,7 +1611,7 @@ static struct usb_action gc0305_60HZ[] =
 	{}
 };
 
-static struct usb_action gc0305_NoFliker[] = {
+static const struct usb_action gc0305_NoFliker[] = {
 	{0xa0, 0x0c, 0x0100},	/* 01,00,0c,cc */
 	{0xaa, 0x82, 0x0000},	/* 00,82,00,aa */
 	{0xaa, 0x83, 0x0000},	/* 00,83,00,aa */
@@ -1635,7 +1635,7 @@ static struct usb_action gc0305_NoFliker
 };
 
 /* play poker with registers at your own risk !! */
-static struct usb_action hdcs2020xx_Initial[] = {
+static const struct usb_action hdcs2020xx_Initial[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x03, 0x0008},
 	{0xa0, 0x0e, 0x0010},
@@ -1780,7 +1780,7 @@ static struct usb_action hdcs2020xx_Init
 	{}
 };
 
-static struct usb_action hdcs2020xx_InitialScale[] = {
+static const struct usb_action hdcs2020xx_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x03, 0x0008},
 	{0xa0, 0x0e, 0x0010},
@@ -1922,7 +1922,7 @@ static struct usb_action hdcs2020xx_Init
 /*	{0xa0, 0x18, 0x00fe}, */
 	{}
 };
-static struct usb_action hdcs2020xb_Initial[] = {
+static const struct usb_action hdcs2020xb_Initial[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x11, 0x0002},
 	{0xa0, 0x03, 0x0008},	/* qtable 0x05 */
@@ -2054,7 +2054,7 @@ static struct usb_action hdcs2020xb_Init
 	{0xa0, 0x40, 0x0118},
 	{}
 };
-static struct usb_action hdcs2020xb_InitialScale[] = {
+static const struct usb_action hdcs2020xb_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x00, 0x0002},
 	{0xa0, 0x03, 0x0008},
@@ -2182,7 +2182,7 @@ static struct usb_action hdcs2020xb_Init
 	{0xa0, 0x40, 0x0118},
 	{}
 };
-static struct usb_action hdcs2020b_50HZ[] = {
+static const struct usb_action hdcs2020b_50HZ[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x13, 0x0018}, /* 00,13,18,aa */
 	{0xaa, 0x14, 0x0001}, /* 00,14,01,aa */
@@ -2203,7 +2203,7 @@ static struct usb_action hdcs2020b_50HZ[
 	{0xa0, 0x2f, 0x001f}, /* 00,1f,2f,cc */
 	{}
 };
-static struct usb_action hdcs2020b_60HZ[] = {
+static const struct usb_action hdcs2020b_60HZ[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x13, 0x0031}, /* 00,13,31,aa */
 	{0xaa, 0x14, 0x0001}, /* 00,14,01,aa */
@@ -2224,7 +2224,7 @@ static struct usb_action hdcs2020b_60HZ[
 	{0xa0, 0x2c, 0x001f}, /* 00,1f,2c,cc */
 	{}
 };
-static struct usb_action hdcs2020b_NoFliker[] = {
+static const struct usb_action hdcs2020b_NoFliker[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x13, 0x0010}, /* 00,13,10,aa */
 	{0xaa, 0x14, 0x0001}, /* 00,14,01,aa */
@@ -2246,7 +2246,7 @@ static struct usb_action hdcs2020b_NoFli
 	{}
 };
 
-static struct usb_action hv7131bxx_Initial[] = {
+static const struct usb_action hv7131bxx_Initial[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x10, 0x0002},
 	{0xa0, 0x00, 0x0010},
@@ -2354,7 +2354,7 @@ static struct usb_action hv7131bxx_Initi
 	{}
 };
 
-static struct usb_action hv7131bxx_InitialScale[] = {
+static const struct usb_action hv7131bxx_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x00, 0x0002},
 	{0xa0, 0x00, 0x0010},
@@ -2460,7 +2460,7 @@ static struct usb_action hv7131bxx_Initi
 	{}
 };
 
-static struct usb_action hv7131cxx_Initial[] = {
+static const struct usb_action hv7131cxx_Initial[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x10, 0x0002},
 	{0xa0, 0x01, 0x0010},
@@ -2554,7 +2554,7 @@ static struct usb_action hv7131cxx_Initi
 	{}
 };
 
-static struct usb_action hv7131cxx_InitialScale[] = {
+static const struct usb_action hv7131cxx_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},
 
 	{0xa0, 0x00, 0x0002},	/* diff */
@@ -2655,7 +2655,7 @@ static struct usb_action hv7131cxx_Initi
 	{}
 };
 
-static struct usb_action icm105axx_Initial[] = {
+static const struct usb_action icm105axx_Initial[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x10, 0x0002},
 	{0xa0, 0x03, 0x0008},
@@ -2832,7 +2832,7 @@ static struct usb_action icm105axx_Initi
 	{}
 };
 
-static struct usb_action icm105axx_InitialScale[] = {
+static const struct usb_action icm105axx_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x00, 0x0002},
 	{0xa0, 0x03, 0x0008},
@@ -3011,7 +3011,7 @@ static struct usb_action icm105axx_Initi
 	{0xa0, 0x40, 0x0118},
 	{}
 };
-static struct usb_action icm105a_50HZ[] = {
+static const struct usb_action icm105a_50HZ[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0d, 0x0003}, /* 00,0d,03,aa */
 	{0xaa, 0x0c, 0x0020}, /* 00,0c,20,aa */
@@ -3042,7 +3042,7 @@ static struct usb_action icm105a_50HZ[] 
 	{0xa0, 0xff, 0x0020}, /* 00,20,ff,cc */
 	{}
 };
-static struct usb_action icm105a_50HZScale[] = {
+static const struct usb_action icm105a_50HZScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0d, 0x0003}, /* 00,0d,03,aa */
 	{0xaa, 0x0c, 0x008c}, /* 00,0c,8c,aa */
@@ -3075,7 +3075,7 @@ static struct usb_action icm105a_50HZSca
 	{0xa0, 0xc0, 0x01a8}, /* 01,a8,c0,cc */
 	{}
 };
-static struct usb_action icm105a_60HZ[] = {
+static const struct usb_action icm105a_60HZ[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0d, 0x0003}, /* 00,0d,03,aa */
 	{0xaa, 0x0c, 0x0004}, /* 00,0c,04,aa */
@@ -3106,7 +3106,7 @@ static struct usb_action icm105a_60HZ[] 
 	{0xa0, 0xff, 0x0020}, /* 00,20,ff,cc */
 	{}
 };
-static struct usb_action icm105a_60HZScale[] = {
+static const struct usb_action icm105a_60HZScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0d, 0x0003}, /* 00,0d,03,aa */
 	{0xaa, 0x0c, 0x0008}, /* 00,0c,08,aa */
@@ -3139,7 +3139,7 @@ static struct usb_action icm105a_60HZSca
 	{0xa0, 0xc0, 0x01a8}, /* 01,a8,c0,cc */
 	{}
 };
-static struct usb_action icm105a_NoFliker[] = {
+static const struct usb_action icm105a_NoFliker[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0d, 0x0003}, /* 00,0d,03,aa */
 	{0xaa, 0x0c, 0x0004}, /* 00,0c,04,aa */
@@ -3170,7 +3170,7 @@ static struct usb_action icm105a_NoFlike
 	{0xa0, 0xff, 0x0020}, /* 00,20,ff,cc */
 	{}
 };
-static struct usb_action icm105a_NoFlikerScale[] = {
+static const struct usb_action icm105a_NoFlikerScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0x0d, 0x0003}, /* 00,0d,03,aa */
 	{0xaa, 0x0c, 0x0004}, /* 00,0c,04,aa */
@@ -3204,7 +3204,7 @@ static struct usb_action icm105a_NoFlike
 	{}
 };
 
-static struct usb_action MC501CB_InitialScale[] = {
+static const struct usb_action MC501CB_InitialScale[] = {
 	{0xa0, 0x01, 0x0000}, /* 00,00,01,cc */
 	{0xa0, 0x00, 0x0002}, /* 00,02,00,cc */
 	{0xa0, 0x01, 0x0010}, /* 00,10,01,cc */
@@ -3324,7 +3324,7 @@ static struct usb_action MC501CB_Initial
 	{}
 };
 
-static struct usb_action MC501CB_Initial[] = {	 /* 320x240 */
+static const struct usb_action MC501CB_Initial[] = {	 /* 320x240 */
 	{0xa0, 0x01, 0x0000}, /* 00,00,01,cc */
 	{0xa0, 0x10, 0x0002}, /* 00,02,10,cc */
 	{0xa0, 0x01, 0x0010}, /* 00,10,01,cc */
@@ -3443,7 +3443,7 @@ static struct usb_action MC501CB_Initial
 	{}
 };
 
-static struct usb_action MC501CB_50HZ[] = {
+static const struct usb_action MC501CB_50HZ[] = {
 	{0xaa, 0x03, 0x0003}, /* 00,03,03,aa */
 	{0xaa, 0x10, 0x00fc}, /* 00,10,fc,aa */
 	{0xaa, 0x36, 0x001d}, /* 00,36,1D,aa */
@@ -3460,7 +3460,7 @@ static struct usb_action MC501CB_50HZ[] 
 	{}
 };
 
-static struct usb_action MC501CB_50HZScale[] = {
+static const struct usb_action MC501CB_50HZScale[] = {
 	{0xaa, 0x03, 0x0003}, /* 00,03,03,aa */
 	{0xaa, 0x10, 0x00fc}, /* 00,10,fc,aa */
 	{0xaa, 0x36, 0x003a}, /* 00,36,3A,aa */
@@ -3477,7 +3477,7 @@ static struct usb_action MC501CB_50HZSca
 	{}
 };
 
-static struct usb_action MC501CB_60HZ[] = {
+static const struct usb_action MC501CB_60HZ[] = {
 	{0xaa, 0x03, 0x0003}, /* 00,03,03,aa */
 	{0xaa, 0x10, 0x00fc}, /* 00,10,fc,aa */
 	{0xaa, 0x36, 0x0018}, /* 00,36,18,aa */
@@ -3494,7 +3494,7 @@ static struct usb_action MC501CB_60HZ[] 
 	{}
 };
 
-static struct usb_action MC501CB_60HZScale[] = {
+static const struct usb_action MC501CB_60HZScale[] = {
 	{0xaa, 0x03, 0x0003}, /* 00,03,03,aa */
 	{0xaa, 0x10, 0x00fc}, /* 00,10,fc,aa */
 	{0xaa, 0x36, 0x0030}, /* 00,36,30,aa */
@@ -3511,7 +3511,7 @@ static struct usb_action MC501CB_60HZSca
 	{}
 };
 
-static struct usb_action MC501CB_NoFliker[] = {
+static const struct usb_action MC501CB_NoFliker[] = {
 	{0xaa, 0x03, 0x0003}, /* 00,03,03,aa */
 	{0xaa, 0x10, 0x00fc}, /* 00,10,fc,aa */
 	{0xaa, 0x36, 0x0018}, /* 00,36,18,aa */
@@ -3528,7 +3528,7 @@ static struct usb_action MC501CB_NoFlike
 	{}
 };
 
-static struct usb_action MC501CB_NoFlikerScale[] = {
+static const struct usb_action MC501CB_NoFlikerScale[] = {
 	{0xaa, 0x03, 0x0003}, /* 00,03,03,aa */
 	{0xaa, 0x10, 0x00fc}, /* 00,10,fc,aa */
 	{0xaa, 0x36, 0x0030}, /* 00,36,30,aa */
@@ -3541,7 +3541,7 @@ static struct usb_action MC501CB_NoFlike
 };
 
 /* from zs211.inf - HKR,%OV7620%,Initial - 640x480 */
-static struct usb_action OV7620_mode0[] = {
+static const struct usb_action OV7620_mode0[] = {
 	{0xa0, 0x01, 0x0000}, /* 00,00,01,cc */
 	{0xa0, 0x40, 0x0002}, /* 00,02,40,cc */
 #if 1 /*jfm*/
@@ -3616,7 +3616,7 @@ static struct usb_action OV7620_mode0[] 
 };
 
 /* from zs211.inf - HKR,%OV7620%,InitialScale - 320x240 */
-static struct usb_action OV7620_mode1[] = {
+static const struct usb_action OV7620_mode1[] = {
 	{0xa0, 0x01, 0x0000}, /* 00,00,01,cc */
 	{0xa0, 0x50, 0x0002}, /* 00,02,50,cc */
 	{0xa0, 0x03, 0x0008}, /* 00,08,00,cc */		/* mx change? */
@@ -3687,7 +3687,7 @@ static struct usb_action OV7620_mode1[] 
 };
 
 /* from zs211.inf - HKR,%OV7620%\AE,50HZ */
-static struct usb_action OV7620_50HZ[] = {
+static const struct usb_action OV7620_50HZ[] = {
 	{0xaa, 0x13, 0x00a3},	/* 00,13,a3,aa */
 	{0xdd, 0x00, 0x0100},	/* 00,01,00,dd */
 	{0xaa, 0x2b, 0x0096},	/* 00,2b,96,aa */
@@ -3706,7 +3706,7 @@ static struct usb_action OV7620_50HZ[] =
 };
 
 /* from zs211.inf - HKR,%OV7620%\AE,60HZ */
-static struct usb_action OV7620_60HZ[] = {
+static const struct usb_action OV7620_60HZ[] = {
 	{0xaa, 0x13, 0x00a3}, /* 00,13,a3,aa */	/* (bug in zs211.inf) */
 	{0xdd, 0x00, 0x0100},	/* 00,01,00,dd */
 	{0xaa, 0x2b, 0x0000}, /* 00,2b,00,aa */
@@ -3728,7 +3728,7 @@ static struct usb_action OV7620_60HZ[] =
 };
 
 /* from zs211.inf - HKR,%OV7620%\AE,NoFliker */
-static struct usb_action OV7620_NoFliker[] = {
+static const struct usb_action OV7620_NoFliker[] = {
 	{0xaa, 0x13, 0x00a3}, /* 00,13,a3,aa */	/* (bug in zs211.inf) */
 	{0xdd, 0x00, 0x0100},	/* 00,01,00,dd */
 	{0xaa, 0x2b, 0x0000}, /* 00,2b,00,aa */
@@ -3747,7 +3747,7 @@ static struct usb_action OV7620_NoFliker
 	{}
 };
 
-static struct usb_action ov7630c_Initial[] = {
+static const struct usb_action ov7630c_Initial[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x10, 0x0002},
 	{0xa0, 0x01, 0x0000},
@@ -3904,7 +3904,7 @@ static struct usb_action ov7630c_Initial
 	{}
 };
 
-static struct usb_action ov7630c_InitialScale[] = {
+static const struct usb_action ov7630c_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x00, 0x0002},
 	{0xa0, 0x03, 0x0008},
@@ -4061,7 +4061,7 @@ static struct usb_action ov7630c_Initial
 	{}
 };
 
-static struct usb_action pas106b_Initial_com[] = {
+static const struct usb_action pas106b_Initial_com[] = {
 /* Sream and Sensor specific */
 	{0xa1, 0x01, 0x0010},	/* CMOSSensorSelect */
 /* System */
@@ -4075,7 +4075,7 @@ static struct usb_action pas106b_Initial
 	{}
 };
 
-static struct usb_action pas106b_Initial[] = {	/* 176x144 */
+static const struct usb_action pas106b_Initial[] = {	/* 176x144 */
 /* JPEG control */
 	{0xa0, 0x03, 0x0008},	/* ClockSetting */
 /* Sream and Sensor specific */
@@ -4193,7 +4193,7 @@ static struct usb_action pas106b_Initial
 	{}
 };
 
-static struct usb_action pas106b_InitialScale[] = {	/* 352x288 */
+static const struct usb_action pas106b_InitialScale[] = {	/* 352x288 */
 /* JPEG control */
 	{0xa0, 0x03, 0x0008},	/* ClockSetting */
 /* Sream and Sensor specific */
@@ -4316,7 +4316,7 @@ static struct usb_action pas106b_Initial
 	{0xa0, 0xff, 0x0018},	/* Frame adjust */
 	{}
 };
-static struct usb_action pas106b_50HZ[] = {
+static const struct usb_action pas106b_50HZ[] = {
 	{0xa0, 0x00, 0x0190}, /* 01,90,00,cc */
 	{0xa0, 0x06, 0x0191}, /* 01,91,06,cc */
 	{0xa0, 0x54, 0x0192}, /* 01,92,54,cc */
@@ -4332,7 +4332,7 @@ static struct usb_action pas106b_50HZ[] 
 	{0xa0, 0x04, 0x01a9}, /* 01,a9,04,cc */
 	{}
 };
-static struct usb_action pas106b_60HZ[] = {
+static const struct usb_action pas106b_60HZ[] = {
 	{0xa0, 0x00, 0x0190}, /* 01,90,00,cc */
 	{0xa0, 0x06, 0x0191}, /* 01,91,06,cc */
 	{0xa0, 0x2e, 0x0192}, /* 01,92,2e,cc */
@@ -4348,7 +4348,7 @@ static struct usb_action pas106b_60HZ[] 
 	{0xa0, 0x04, 0x01a9}, /* 01,a9,04,cc */
 	{}
 };
-static struct usb_action pas106b_NoFliker[] = {
+static const struct usb_action pas106b_NoFliker[] = {
 	{0xa0, 0x00, 0x0190}, /* 01,90,00,cc */
 	{0xa0, 0x06, 0x0191}, /* 01,91,06,cc */
 	{0xa0, 0x50, 0x0192}, /* 01,92,50,cc */
@@ -4365,7 +4365,7 @@ static struct usb_action pas106b_NoFlike
 	{}
 };
 
-static struct usb_action pb03303x_Initial[] = {
+static const struct usb_action pb03303x_Initial[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x03, 0x0008},
 	{0xa0, 0x0a, 0x0010},
@@ -4511,7 +4511,7 @@ static struct usb_action pb03303x_Initia
 	{}
 };
 
-static struct usb_action pb03303x_InitialScale[] = {
+static const struct usb_action pb03303x_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x03, 0x0008},
 	{0xa0, 0x0a, 0x0010},
@@ -4659,7 +4659,7 @@ static struct usb_action pb03303x_Initia
 	{0xa0, 0x42, 0x0180},
 	{}
 };
-static struct usb_action pb0330xx_Initial[] = {
+static const struct usb_action pb0330xx_Initial[] = {
 	{0xa1, 0x01, 0x0008},
 	{0xa1, 0x01, 0x0008},
 	{0xa0, 0x01, 0x0000},
@@ -4774,7 +4774,7 @@ static struct usb_action pb0330xx_Initia
 	{}
 };
 
-static struct usb_action pb0330xx_InitialScale[] = {
+static const struct usb_action pb0330xx_InitialScale[] = {
 	{0xa1, 0x01, 0x0008},
 	{0xa1, 0x01, 0x0008},
 	{0xa0, 0x01, 0x0000},
@@ -4887,7 +4887,7 @@ static struct usb_action pb0330xx_Initia
 /*	{0xa0, 0x00, 0x0007}, */
 	{}
 };
-static struct usb_action pb0330_50HZ[] = {
+static const struct usb_action pb0330_50HZ[] = {
 	{0xa0, 0x00, 0x0190}, /* 01,90,00,cc */
 	{0xa0, 0x07, 0x0191}, /* 01,91,07,cc */
 	{0xa0, 0xee, 0x0192}, /* 01,92,ee,cc */
@@ -4903,7 +4903,7 @@ static struct usb_action pb0330_50HZ[] =
 	{0xa0, 0xc8, 0x001f}, /* 00,1f,c8,cc */
 	{}
 };
-static struct usb_action pb0330_50HZScale[] = {
+static const struct usb_action pb0330_50HZScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xa0, 0x00, 0x0190}, /* 01,90,00,cc */
 	{0xa0, 0x07, 0x0191}, /* 01,91,07,cc */
@@ -4920,7 +4920,7 @@ static struct usb_action pb0330_50HZScal
 	{0xa0, 0xf8, 0x001f}, /* 00,1f,f8,cc */
 	{}
 };
-static struct usb_action pb0330_60HZ[] = {
+static const struct usb_action pb0330_60HZ[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xa0, 0x00, 0x0190}, /* 01,90,00,cc */
 	{0xa0, 0x07, 0x0191}, /* 01,91,07,cc */
@@ -4937,7 +4937,7 @@ static struct usb_action pb0330_60HZ[] =
 	{0xa0, 0x90, 0x001f}, /* 00,1f,90,cc */
 	{}
 };
-static struct usb_action pb0330_60HZScale[] = {
+static const struct usb_action pb0330_60HZScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xa0, 0x00, 0x0190}, /* 01,90,00,cc */
 	{0xa0, 0x07, 0x0191}, /* 01,91,07,cc */
@@ -4954,7 +4954,7 @@ static struct usb_action pb0330_60HZScal
 	{0xa0, 0x90, 0x001f}, /* 00,1f,90,cc */
 	{}
 };
-static struct usb_action pb0330_NoFliker[] = {
+static const struct usb_action pb0330_NoFliker[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xa0, 0x00, 0x0190}, /* 01,90,00,cc */
 	{0xa0, 0x07, 0x0191}, /* 01,91,07,cc */
@@ -4971,7 +4971,7 @@ static struct usb_action pb0330_NoFliker
 	{0xa0, 0x90, 0x001f}, /* 00,1f,90,cc */
 	{}
 };
-static struct usb_action pb0330_NoFlikerScale[] = {
+static const struct usb_action pb0330_NoFlikerScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xa0, 0x00, 0x0190}, /* 01,90,00,cc */
 	{0xa0, 0x07, 0x0191}, /* 01,91,07,cc */
@@ -4990,7 +4990,7 @@ static struct usb_action pb0330_NoFliker
 };
 
 /* from oem9.inf - HKR,%PO2030%,Initial - 640x480 - (close to CS2102) */
-static struct usb_action PO2030_mode0[] = {
+static const struct usb_action PO2030_mode0[] = {
 	{0xa0, 0x01, 0x0000}, /* 00,00,01,cc */
 	{0xa0, 0x04, 0x0002}, /* 00,02,04,cc */
 	{0xa0, 0x01, 0x0010}, /* 00,10,01,cc */
@@ -5067,7 +5067,7 @@ static struct usb_action PO2030_mode0[] 
 };
 
 /* from oem9.inf - HKR,%PO2030%,InitialScale - 320x240 */
-static struct usb_action PO2030_mode1[] = {
+static const struct usb_action PO2030_mode1[] = {
 	{0xa0, 0x01, 0x0000}, /* 00,00,01,cc */
 	{0xa0, 0x10, 0x0002}, /* 00,02,10,cc */
 	{0xa0, 0x01, 0x0010}, /* 00,10,01,cc */
@@ -5143,7 +5143,7 @@ static struct usb_action PO2030_mode1[] 
 	{}
 };
 
-static struct usb_action PO2030_50HZ[] = {
+static const struct usb_action PO2030_50HZ[] = {
 	{0xaa, 0x8d, 0x0008}, /* 00,8d,08,aa */
 	{0xaa, 0x1a, 0x0001}, /* 00,1a,01,aa */
 	{0xaa, 0x1b, 0x000a}, /* 00,1b,0a,aa */
@@ -5165,7 +5165,7 @@ static struct usb_action PO2030_50HZ[] =
 	{}
 };
 
-static struct usb_action PO2030_60HZ[] = {
+static const struct usb_action PO2030_60HZ[] = {
 	{0xaa, 0x8d, 0x0008}, /* 00,8d,08,aa */
 	{0xaa, 0x1a, 0x0000}, /* 00,1a,00,aa */
 	{0xaa, 0x1b, 0x00de}, /* 00,1b,de,aa */
@@ -5187,7 +5187,7 @@ static struct usb_action PO2030_60HZ[] =
 	{}
 };
 
-static struct usb_action PO2030_NoFliker[] = {
+static const struct usb_action PO2030_NoFliker[] = {
 	{0xa0, 0x02, 0x0180}, /* 01,80,02,cc */
 	{0xaa, 0x8d, 0x000d}, /* 00,8d,0d,aa */
 	{0xaa, 0x1a, 0x0000}, /* 00,1a,00,aa */
@@ -5199,7 +5199,7 @@ static struct usb_action PO2030_NoFliker
 };
 
 /* TEST */
-static struct usb_action tas5130CK_Initial[] = {
+static const struct usb_action tas5130CK_Initial[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x01, 0x003b},
 	{0xa0, 0x0e, 0x003a},
@@ -5402,7 +5402,7 @@ static struct usb_action tas5130CK_Initi
 	{}
 };
 
-static struct usb_action tas5130CK_InitialScale[] = {
+static const struct usb_action tas5130CK_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x01, 0x003b},
 	{0xa0, 0x0e, 0x003a},
@@ -5610,7 +5610,7 @@ static struct usb_action tas5130CK_Initi
 	{}
 };
 
-static struct usb_action tas5130cxx_Initial[] = {
+static const struct usb_action tas5130cxx_Initial[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x50, 0x0002},
 	{0xa0, 0x03, 0x0008},
@@ -5699,7 +5699,7 @@ static struct usb_action tas5130cxx_Init
 	{0xa0, 0x42, 0x0180},
 	{}
 };
-static struct usb_action tas5130cxx_InitialScale[] = {
+static const struct usb_action tas5130cxx_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x01, 0x0000},
 	{0xa0, 0x40, 0x0002},
@@ -5789,7 +5789,7 @@ static struct usb_action tas5130cxx_Init
 	{0xa0, 0x42, 0x0180},
 	{}
 };
-static struct usb_action tas5130cxx_50HZ[] = {
+static const struct usb_action tas5130cxx_50HZ[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0xa3, 0x0001}, /* 00,a3,01,aa */
 	{0xaa, 0xa4, 0x0063}, /* 00,a4,63,aa */
@@ -5812,7 +5812,7 @@ static struct usb_action tas5130cxx_50HZ
 	{0xa0, 0x03, 0x009f}, /* 00,9f,03,cc */
 	{}
 };
-static struct usb_action tas5130cxx_50HZScale[] = {
+static const struct usb_action tas5130cxx_50HZScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0xa3, 0x0001}, /* 00,a3,01,aa */
 	{0xaa, 0xa4, 0x0077}, /* 00,a4,77,aa */
@@ -5835,7 +5835,7 @@ static struct usb_action tas5130cxx_50HZ
 	{0xa0, 0x03, 0x009f}, /* 00,9f,03,cc */
 	{}
 };
-static struct usb_action tas5130cxx_60HZ[] = {
+static const struct usb_action tas5130cxx_60HZ[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0xa3, 0x0001}, /* 00,a3,01,aa */
 	{0xaa, 0xa4, 0x0036}, /* 00,a4,36,aa */
@@ -5858,7 +5858,7 @@ static struct usb_action tas5130cxx_60HZ
 	{0xa0, 0x03, 0x009f}, /* 00,9f,03,cc */
 	{}
 };
-static struct usb_action tas5130cxx_60HZScale[] = {
+static const struct usb_action tas5130cxx_60HZScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0xa3, 0x0001}, /* 00,a3,01,aa */
 	{0xaa, 0xa4, 0x0077}, /* 00,a4,77,aa */
@@ -5881,7 +5881,7 @@ static struct usb_action tas5130cxx_60HZ
 	{0xa0, 0x03, 0x009f}, /* 00,9f,03,cc */
 	{}
 };
-static struct usb_action tas5130cxx_NoFliker[] = {
+static const struct usb_action tas5130cxx_NoFliker[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0xa3, 0x0001}, /* 00,a3,01,aa */
 	{0xaa, 0xa4, 0x0040}, /* 00,a4,40,aa */
@@ -5905,7 +5905,7 @@ static struct usb_action tas5130cxx_NoFl
 	{}
 };
 
-static struct usb_action tas5130cxx_NoFlikerScale[] = {
+static const struct usb_action tas5130cxx_NoFlikerScale[] = {
 	{0xa0, 0x00, 0x0019}, /* 00,19,00,cc */
 	{0xaa, 0xa3, 0x0001}, /* 00,a3,01,aa */
 	{0xaa, 0xa4, 0x0090}, /* 00,a4,90,aa */
@@ -5929,7 +5929,7 @@ static struct usb_action tas5130cxx_NoFl
 	{}
 };
 
-static struct usb_action tas5130c_vf0250_Initial[] = {
+static const struct usb_action tas5130c_vf0250_Initial[] = {
 	{0xa0, 0x01, 0x0000},		/* 00,00,01,cc, */
 	{0xa0, 0x02, 0x0008},		/* 00,08,02,cc, */
 	{0xa0, 0x01, 0x0010},		/* 00,10,01,cc, */
@@ -5993,7 +5993,7 @@ static struct usb_action tas5130c_vf0250
 	{}
 };
 
-static struct usb_action tas5130c_vf0250_InitialScale[] = {
+static const struct usb_action tas5130c_vf0250_InitialScale[] = {
 	{0xa0, 0x01, 0x0000},		/* 00,00,01,cc, */
 	{0xa0, 0x02, 0x0008},		/* 00,08,02,cc, */
 	{0xa0, 0x01, 0x0010},		/* 00,10,01,cc, */
@@ -6057,7 +6057,7 @@ static struct usb_action tas5130c_vf0250
 	{}
 };
 /* "50HZ" light frequency banding filter */
-static struct usb_action tas5130c_vf0250_50HZ[] = {
+static const struct usb_action tas5130c_vf0250_50HZ[] = {
 	{0xaa, 0x82, 0x0000},		/* 00,82,00,aa */
 	{0xaa, 0x83, 0x0001},		/* 00,83,01,aa */
 	{0xaa, 0x84, 0x00aa},		/* 00,84,aa,aa */
@@ -6082,7 +6082,7 @@ static struct usb_action tas5130c_vf0250
 };
 
 /* "50HZScale" light frequency banding filter */
-static struct usb_action tas5130c_vf0250_50HZScale[] = {
+static const struct usb_action tas5130c_vf0250_50HZScale[] = {
 	{0xaa, 0x82, 0x0000},		/* 00,82,00,aa */
 	{0xaa, 0x83, 0x0003},		/* 00,83,03,aa */
 	{0xaa, 0x84, 0x0054},		/* 00,84,54,aa */
@@ -6107,7 +6107,7 @@ static struct usb_action tas5130c_vf0250
 };
 
 /* "60HZ" light frequency banding filter */
-static struct usb_action tas5130c_vf0250_60HZ[] = {
+static const struct usb_action tas5130c_vf0250_60HZ[] = {
 	{0xaa, 0x82, 0x0000},		/* 00,82,00,aa */
 	{0xaa, 0x83, 0x0001},		/* 00,83,01,aa */
 	{0xaa, 0x84, 0x0062},		/* 00,84,62,aa */
@@ -6132,7 +6132,7 @@ static struct usb_action tas5130c_vf0250
 };
 
 /* "60HZScale" light frequency banding ilter */
-static struct usb_action tas5130c_vf0250_60HZScale[] = {
+static const struct usb_action tas5130c_vf0250_60HZScale[] = {
 	{0xaa, 0x82, 0x0000},		/* 00,82,00,aa */
 	{0xaa, 0x83, 0x0002},		/* 00,83,02,aa */
 	{0xaa, 0x84, 0x00c4},		/* 00,84,c4,aa */
@@ -6157,7 +6157,7 @@ static struct usb_action tas5130c_vf0250
 };
 
 /* "NoFliker" light frequency banding flter */
-static struct usb_action tas5130c_vf0250_NoFliker[] = {
+static const struct usb_action tas5130c_vf0250_NoFliker[] = {
 	{0xa0, 0x0c, 0x0100},		/* 01,00,0c,cc, */
 	{0xaa, 0x82, 0x0000},		/* 00,82,00,aa */
 	{0xaa, 0x83, 0x0000},		/* 00,83,00,aa */
@@ -6180,7 +6180,7 @@ static struct usb_action tas5130c_vf0250
 };
 
 /* "NoFlikerScale" light frequency banding filter */
-static struct usb_action tas5130c_vf0250_NoFlikerScale[] = {
+static const struct usb_action tas5130c_vf0250_NoFlikerScale[] = {
 	{0xa0, 0x0c, 0x0100},		/* 01,00,0c,cc, */
 	{0xaa, 0x82, 0x0000},		/* 00,82,00,aa */
 	{0xaa, 0x83, 0x0000},		/* 00,83,00,aa */
@@ -6276,7 +6276,7 @@ static __u8 i2c_write(struct usb_device 
 }
 
 static void usb_exchange(struct usb_device *dev,
-			struct usb_action *action)
+			const struct usb_action *action)
 {
 	__u8 buffread;
 
@@ -6308,12 +6308,12 @@ static void setmatrix(struct gspca_dev *
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i;
-	__u8 *matrix;
-	static __u8 gc0305_matrix[9] =
+	const __u8 *matrix;
+	const __u8 gc0305_matrix[9] =
 		{0x50, 0xf8, 0xf8, 0xf8, 0x50, 0xf8, 0xf8, 0xf8, 0x50};
-	static __u8 ov7620_matrix[9] =
+	const __u8 ov7620_matrix[9] =
 		{0x58, 0xf4, 0xf4, 0xf4, 0x58, 0xf4, 0xf4, 0xf4, 0x58};
-	static __u8 po2030_matrix[9] =
+	const __u8 po2030_matrix[9] =
 		{0x60, 0xf0, 0xf0, 0xf0, 0x60, 0xf0, 0xf0, 0xf0, 0x60};
 
 	switch (sd->sensor) {
@@ -6365,7 +6365,7 @@ static void setsharpness(struct gspca_de
 	struct usb_device *dev = gspca_dev->dev;
 	int sharpness;
 	__u8 retbyte;
-	static __u8 sharpness_tb[][2] = {
+	const __u8 sharpness_tb[][2] = {
 		{0x02, 0x03},
 		{0x04, 0x07},
 		{0x08, 0x0f},
@@ -6384,55 +6384,55 @@ static void setcontrast(struct gspca_dev
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
-	__u8 *Tgamma, *Tgradient;
+	const __u8 *Tgamma, *Tgradient;
 	int g, i, k;
-	static __u8 kgamma_tb[16] =		/* delta for contrast */
+	const __u8 kgamma_tb[16] =		/* delta for contrast */
 		{0x15, 0x0d, 0x0a, 0x09, 0x08, 0x08, 0x08, 0x08,
 		 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08};
-	static __u8 kgrad_tb[16] =
+	const __u8 kgrad_tb[16] =
 		{0x1b, 0x06, 0x03, 0x02, 0x00, 0x00, 0x00, 0x00,
 		 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x06, 0x04};
-	static __u8 Tgamma_1[16] =
+	const __u8 Tgamma_1[16] =
 		{0x00, 0x00, 0x03, 0x0d, 0x1b, 0x2e, 0x45, 0x5f,
 		 0x79, 0x93, 0xab, 0xc1, 0xd4, 0xe5, 0xf3, 0xff};
-	static __u8 Tgradient_1[16] =
+	const __u8 Tgradient_1[16] =
 		{0x00, 0x01, 0x05, 0x0b, 0x10, 0x15, 0x18, 0x1a,
 		 0x1a, 0x18, 0x16, 0x14, 0x12, 0x0f, 0x0d, 0x06};
-	static __u8 Tgamma_2[16] =
+	const __u8 Tgamma_2[16] =
 		{0x01, 0x0c, 0x1f, 0x3a, 0x53, 0x6d, 0x85, 0x9c,
 		 0xb0, 0xc2, 0xd1, 0xde, 0xe9, 0xf2, 0xf9, 0xff};
-	static __u8 Tgradient_2[16] =
+	const __u8 Tgradient_2[16] =
 		{0x05, 0x0f, 0x16, 0x1a, 0x19, 0x19, 0x17, 0x15,
 		 0x12, 0x10, 0x0e, 0x0b, 0x09, 0x08, 0x06, 0x03};
-	static __u8 Tgamma_3[16] =
+	const __u8 Tgamma_3[16] =
 		{0x04, 0x16, 0x30, 0x4e, 0x68, 0x81, 0x98, 0xac,
 		 0xbe, 0xcd, 0xda, 0xe4, 0xed, 0xf5, 0xfb, 0xff};
-	static __u8 Tgradient_3[16] =
+	const __u8 Tgradient_3[16] =
 		{0x0c, 0x16, 0x1b, 0x1c, 0x19, 0x18, 0x15, 0x12,
 		 0x10, 0x0d, 0x0b, 0x09, 0x08, 0x06, 0x05, 0x03};
-	static __u8 Tgamma_4[16] =
+	const __u8 Tgamma_4[16] =
 		{0x13, 0x38, 0x59, 0x79, 0x92, 0xa7, 0xb9, 0xc8,
 		 0xd4, 0xdf, 0xe7, 0xee, 0xf4, 0xf9, 0xfc, 0xff};
-	static __u8 Tgradient_4[16] =
+	const __u8 Tgradient_4[16] =
 		{0x26, 0x22, 0x20, 0x1c, 0x16, 0x13, 0x10, 0x0d,
 		 0x0b, 0x09, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02};
-	static __u8 Tgamma_5[16] =
+	const __u8 Tgamma_5[16] =
 		{0x20, 0x4b, 0x6e, 0x8d, 0xa3, 0xb5, 0xc5, 0xd2,
 		 0xdc, 0xe5, 0xec, 0xf2, 0xf6, 0xfa, 0xfd, 0xff};
-	static __u8 Tgradient_5[16] =
+	const __u8 Tgradient_5[16] =
 		{0x37, 0x26, 0x20, 0x1a, 0x14, 0x10, 0x0e, 0x0b,
 		 0x09, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x02};
-	static __u8 Tgamma_6[16] =		/* ?? was gamma 5 */
+	const __u8 Tgamma_6[16] =		/* ?? was gamma 5 */
 		{0x24, 0x44, 0x64, 0x84, 0x9d, 0xb2, 0xc4, 0xd3,
 		 0xe0, 0xeb, 0xf4, 0xff, 0xff, 0xff, 0xff, 0xff};
-	static __u8 Tgradient_6[16] =
+	const __u8 Tgradient_6[16] =
 		{0x18, 0x20, 0x20, 0x1c, 0x16, 0x13, 0x10, 0x0e,
 		 0x0b, 0x09, 0x07, 0x00, 0x00, 0x00, 0x00, 0x01};
-	static __u8 *gamma_tb[] = {
+	const __u8 *gamma_tb[] = {
 		0, Tgamma_1, Tgamma_2,
 		Tgamma_3, Tgamma_4, Tgamma_5, Tgamma_6
 	};
-	static __u8 *gradient_tb[] = {
+	const __u8 *gradient_tb[] = {
 		0, Tgradient_1, Tgradient_2,
 		Tgradient_3, Tgradient_4, Tgradient_5, Tgradient_6
 	};
@@ -6533,8 +6533,8 @@ static int setlightfreq(struct gspca_dev
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i, mode;
-	struct usb_action *zc3_freq;
-	static struct usb_action *freq_tb[SENSOR_MAX][6] = {
+	const struct usb_action *zc3_freq;
+	static const struct usb_action *freq_tb[SENSOR_MAX][6] = {
 /* SENSOR_CS2102 0 */
 		{cs2102_NoFliker, cs2102_NoFlikerScale,
 		 cs2102_50HZ, cs2102_50HZScale,
@@ -6956,7 +6956,7 @@ static int sd_config(struct gspca_dev *g
 	int sensor;
 	__u8 bsensor;
 	int vga = 1;		/* 1: vga, 0: sif */
-	static __u8 gamma[SENSOR_MAX] = {
+	const __u8 gamma[SENSOR_MAX] = {
 		5,	/* SENSOR_CS2102 0 */
 		5,	/* SENSOR_CS2102K 1 */
 		4,	/* SENSOR_GC0305 2 */
@@ -7149,10 +7149,10 @@ static void sd_start(struct gspca_dev *g
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
-	struct usb_action *zc3_init;
+	const struct usb_action *zc3_init;
 	int mode;
 	__u8 retbyte;
-	static struct usb_action *init_tb[SENSOR_MAX][2] = {
+	static const struct usb_action *init_tb[SENSOR_MAX][2] = {
 		{cs2102_InitialScale, cs2102_Initial},		/* 0 */
 		{cs2102K_InitialScale, cs2102K_Initial},	/* 1 */
 		{gc0305_Initial, gc0305_InitialScale},		/* 2 */

--------------000700020404020005040400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------000700020404020005040400--
