Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77GI1Mh022188
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 12:18:01 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m77GHe0B016632
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 12:17:42 -0400
Message-ID: <489B2253.6090400@hhs.nl>
Date: Thu, 07 Aug 2008 18:26:59 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------080808070408050101000206"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Subject: PATCH: gspca-spc200nc-upside-down.patch
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
--------------080808070408050101000206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

This patch adds a V4L2_FMT_FLAG_UPSIDEDOWN flag to the fmt_desc struct flags,
and sets this flag for the Philips SPC200NC cam (which has its sensor installed
upside down). The same flag is likely needed for the Philips SPC300NC.

Together with a patch to libv4l which adds flipping the image in software this
fixes the upside down display with the SPC200NC cam.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------080808070408050101000206
Content-Type: text/x-patch;
 name="gspca-spc200nc-upside-down.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-spc200nc-upside-down.patch"

This patch adds a V4L2_FMT_FLAG_UPSIDEDOWN flag to the fmt_desc struct flags,
and sets this flag for the Philips SPC200NC cam (which has its sensor installed
upside down). The same flag is likely needed for the Philips SPC300NC.

Together with a patch to libv4l which adds flipping the image in software this
fixes the upside down display with the SPC200NC cam.

Signed-of-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 0cb3bf647ecd linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Thu Aug 07 15:23:49 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Thu Aug 07 18:10:10 2008 +0200
@@ -651,6 +651,8 @@
 	fmtdesc->pixelformat = fmt_tb[index];
 	if (gspca_is_compressed(fmt_tb[index]))
 		fmtdesc->flags = V4L2_FMT_FLAG_COMPRESSED;
+	if (gspca_dev->flags & GSPCA_SENSOR_UPSIDE_DOWN_FLAG)
+		fmtdesc->flags |= V4L2_FMT_FLAG_UPSIDEDOWN;
 	fmtdesc->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fmtdesc->description[0] = fmtdesc->pixelformat & 0xff;
 	fmtdesc->description[1] = (fmtdesc->pixelformat >> 8) & 0xff;
diff -r 0cb3bf647ecd linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Thu Aug 07 15:23:49 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.h	Thu Aug 07 18:10:10 2008 +0200
@@ -119,6 +119,9 @@
 	struct v4l2_buffer v4l2_buf;
 };
 
+/* defines for the flags member */
+#define GSPCA_SENSOR_UPSIDE_DOWN_FLAG 0x01
+
 struct gspca_dev {
 	struct video_device vdev;	/* !! must be the first item */
 	struct file_operations fops;
@@ -161,6 +164,7 @@
 	char nurbs;			/* number of allocated URBs */
 	char memory;			/* memory type (V4L2_MEMORY_xxx) */
 	__u8 nbalt;			/* number of USB alternate settings */
+	__u8 flags;                     /* see GSPCA_XXX_FLAG defines */
 };
 
 int gspca_dev_probe(struct usb_interface *intf,
diff -r 0cb3bf647ecd linux/drivers/media/video/gspca/zc3xx.c
--- a/linux/drivers/media/video/gspca/zc3xx.c	Thu Aug 07 15:23:49 2008 +0200
+++ b/linux/drivers/media/video/gspca/zc3xx.c	Thu Aug 07 18:10:10 2008 +0200
@@ -69,6 +69,10 @@
 #define SENSOR_MAX 17
 	unsigned short chip_revision;
 };
+
+#define DRIVER_INFO(sensor, flags) .driver_info = ((sensor) << 8) | (flags)
+#define DRIVER_INFO_GET_SENSOR(driver_info) ((driver_info) >> 8)
+#define DRIVER_INFO_GET_FLAGS(driver_info)  ((driver_info) & 0xff)
 
 /* V4L2 controls supported by the driver */
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
@@ -7022,7 +7026,8 @@
 
 	/* define some sensors from the vendor/product */
 	sd->sharpness = 2;
-	sd->sensor = id->driver_info;
+	sd->sensor = DRIVER_INFO_GET_SENSOR(id->driver_info);
+	gspca_dev->flags = DRIVER_INFO_GET_FLAGS(id->driver_info);
 	sensor = zcxx_probeSensor(gspca_dev);
 	if (sensor >= 0)
 		PDEBUG(D_PROBE, "probe sensor -> %02x", sensor);
@@ -7530,8 +7535,8 @@
 	{USB_DEVICE(0x041e, 0x4036)},
 	{USB_DEVICE(0x041e, 0x403a)},
 #endif
-	{USB_DEVICE(0x041e, 0x4051), .driver_info = SENSOR_TAS5130C_VF0250},
-	{USB_DEVICE(0x041e, 0x4053), .driver_info = SENSOR_TAS5130C_VF0250},
+	{USB_DEVICE(0x041e, 0x4051), DRIVER_INFO(SENSOR_TAS5130C_VF0250, 0)},
+	{USB_DEVICE(0x041e, 0x4053), DRIVER_INFO(SENSOR_TAS5130C_VF0250, 0)},
 #ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x0458, 0x7007)},
 	{USB_DEVICE(0x0458, 0x700c)},
@@ -7557,8 +7562,9 @@
 	{USB_DEVICE(0x046d, 0x08d9)},
 	{USB_DEVICE(0x046d, 0x08d8)},
 	{USB_DEVICE(0x046d, 0x08da)},
-	{USB_DEVICE(0x046d, 0x08dd), .driver_info = SENSOR_MC501CB},
-	{USB_DEVICE(0x0471, 0x0325)},
+	{USB_DEVICE(0x046d, 0x08dd), DRIVER_INFO(SENSOR_MC501CB, 0)},
+	{USB_DEVICE(0x0471, 0x0325),
+		DRIVER_INFO(0, GSPCA_SENSOR_UPSIDE_DOWN_FLAG)},
 	{USB_DEVICE(0x0471, 0x0326)},
 	{USB_DEVICE(0x0471, 0x032d)},
 	{USB_DEVICE(0x0471, 0x032e)},
@@ -7573,7 +7579,7 @@
 	{USB_DEVICE(0x0ac8, 0x301b)},
 	{USB_DEVICE(0x0ac8, 0x303b)},
 #endif
-	{USB_DEVICE(0x0ac8, 0x305b), .driver_info = SENSOR_TAS5130C_VF0250},
+	{USB_DEVICE(0x0ac8, 0x305b), DRIVER_INFO(SENSOR_TAS5130C_VF0250, 0)},
 #ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x0ac8, 0x307b)},
 	{USB_DEVICE(0x10fd, 0x0128)},
diff -r 0cb3bf647ecd linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Thu Aug 07 15:23:49 2008 +0200
+++ b/linux/include/linux/videodev2.h	Thu Aug 07 18:10:10 2008 +0200
@@ -348,6 +348,10 @@
 };
 
 #define V4L2_FMT_FLAG_COMPRESSED 0x0001
+/* This flags gets set if the image is upside down in this format and this can
+   *not* be fixed using v4l2 flipx/y controls. Note that absence of this flag
+   is not a guarantee for the image not being upsidedown. */
+#define V4L2_FMT_FLAG_UPSIDEDOWN 0x0002
 
 #if 1 /*KEEP*/
 	/* Experimental Frame Size and frame rate enumeration */

--------------080808070408050101000206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080808070408050101000206--
