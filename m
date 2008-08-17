Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HI0Irn024884
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 14:00:18 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HI05tn018423
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 14:00:06 -0400
Message-ID: <48A8698E.3090004@hhs.nl>
Date: Sun, 17 Aug 2008 20:10:22 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------070905010304030700090102"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: PATCH: gspca-spc200nc-upside-down-v2
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
--------------070905010304030700090102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch adds a V4L2_CAP_SENSOR_UPSIDE_DOWN flag to the capabilities flags,
and sets this flag for the Philips SPC200NC cam (which has its sensor installed
upside down). The same flag is also needed and added for the Philips SPC300NC.

Together with a patch to libv4l which adds flipping the image in software this
fixes the upside down display with the SPC200NC cam.

Signed-of-by: Hans de Goede <j.w.r.degoede@hhs.nl>


This is version 2 of the patch which now makes the flag a capability flag 
rather then a format flag as suggested by Hans Verkuil.

Regards,

Hans

p.s.

Of you do not plan to apply this patch please let me know that and why, then we 
can discuss this further, I really believe that in cases where the upside down 
ness is 100% known at the kernel level we should report this in some way to 
userspace so that libv4l can flip the image in software. I know that for 
certain cases the upside down ness needs to be determined elsewhere, but not 
for all cases.

I believe all hardware info for a certain piece of hardware should be kept at 
one place, and in this case that is the driver. With upside down mounted 
generic laptop cam modules, the upside down ness is not module specific but 
laptop specific and thus this info should be stored in hal, which takes care of 
laptop model specific things which can differ from laptop to laptop even though 
they use the same lowlevel IC's. In this case however this is not system/latop 
specific but cam specific so this info should be stored together with the other 
cam specific knowledge (such as which sensor it uses) in the driver.

--------------070905010304030700090102
Content-Type: text/plain;
 name="gspca-spc200nc-upside-down-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-spc200nc-upside-down-v2.patch"

This patch adds a V4L2_CAP_SENSOR_UPSIDE_DOWN flag to the capabilities flags,
and sets this flag for the Philips SPC200NC cam (which has its sensor installed
upside down). The same flag is also needed and added for the Philips SPC300NC.

Together with a patch to libv4l which adds flipping the image in software this
fixes the upside down display with the SPC200NC cam.

Signed-of-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 1da7166882de linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Sun Aug 17 09:09:20 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Sun Aug 17 20:01:51 2008 +0200
@@ -857,6 +857,8 @@
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
 			  | V4L2_CAP_STREAMING
 			  | V4L2_CAP_READWRITE;
+	if (gspca_dev->flags & GSPCA_SENSOR_UPSIDE_DOWN_FLAG)
+		cap->capabilities |= V4L2_CAP_SENSOR_UPSIDE_DOWN;
 	return 0;
 }
 
diff -r 1da7166882de linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Sun Aug 17 09:09:20 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.h	Sun Aug 17 20:01:51 2008 +0200
@@ -118,6 +118,9 @@
 	struct v4l2_buffer v4l2_buf;
 };
 
+/* defines for the flags member */
+#define GSPCA_SENSOR_UPSIDE_DOWN_FLAG 0x01
+
 struct gspca_dev {
 	struct video_device vdev;	/* !! must be the first item */
 	struct file_operations fops;
@@ -160,6 +163,7 @@
 	char nurbs;			/* number of allocated URBs */
 	char memory;			/* memory type (V4L2_MEMORY_xxx) */
 	__u8 nbalt;			/* number of USB alternate settings */
+	__u8 flags;                     /* see GSPCA_XXX_FLAG defines */
 };
 
 int gspca_dev_probe(struct usb_interface *intf,
diff -r 1da7166882de linux/drivers/media/video/gspca/zc3xx.c
--- a/linux/drivers/media/video/gspca/zc3xx.c	Sun Aug 17 09:09:20 2008 +0200
+++ b/linux/drivers/media/video/gspca/zc3xx.c	Sun Aug 17 20:01:51 2008 +0200
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
@@ -7020,7 +7024,8 @@
 
 	/* define some sensors from the vendor/product */
 	sd->sharpness = 2;
-	sd->sensor = id->driver_info;
+	sd->sensor = DRIVER_INFO_GET_SENSOR(id->driver_info);
+	gspca_dev->flags = DRIVER_INFO_GET_FLAGS(id->driver_info);
 	sensor = zcxx_probeSensor(gspca_dev);
 	if (sensor >= 0)
 		PDEBUG(D_PROBE, "probe sensor -> %02x", sensor);
@@ -7517,19 +7522,19 @@
 	{USB_DEVICE(0x041e, 0x041e)},
 #ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x041e, 0x4017)},
-	{USB_DEVICE(0x041e, 0x401c), .driver_info = SENSOR_PAS106},
+	{USB_DEVICE(0x041e, 0x401c), DRIVER_INFO(SENSOR_PAS106, 0)},
 	{USB_DEVICE(0x041e, 0x401e)},
 	{USB_DEVICE(0x041e, 0x401f)},
 #endif
 	{USB_DEVICE(0x041e, 0x4029)},
 #ifndef CONFIG_USB_ZC0301
-	{USB_DEVICE(0x041e, 0x4034), .driver_info = SENSOR_PAS106},
-	{USB_DEVICE(0x041e, 0x4035), .driver_info = SENSOR_PAS106},
+	{USB_DEVICE(0x041e, 0x4034), DRIVER_INFO(SENSOR_PAS106, 0)},
+	{USB_DEVICE(0x041e, 0x4035), DRIVER_INFO(SENSOR_PAS106, 0)},
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
@@ -7555,11 +7560,13 @@
 	{USB_DEVICE(0x046d, 0x08d9)},
 	{USB_DEVICE(0x046d, 0x08d8)},
 	{USB_DEVICE(0x046d, 0x08da)},
-	{USB_DEVICE(0x046d, 0x08dd), .driver_info = SENSOR_MC501CB},
-	{USB_DEVICE(0x0471, 0x0325), .driver_info = SENSOR_PAS106},
-	{USB_DEVICE(0x0471, 0x0326), .driver_info = SENSOR_PAS106},
-	{USB_DEVICE(0x0471, 0x032d), .driver_info = SENSOR_PAS106},
-	{USB_DEVICE(0x0471, 0x032e), .driver_info = SENSOR_PAS106},
+	{USB_DEVICE(0x046d, 0x08dd), DRIVER_INFO(SENSOR_MC501CB, 0)},
+	{USB_DEVICE(0x0471, 0x0325), DRIVER_INFO(SENSOR_PAS106,
+		GSPCA_SENSOR_UPSIDE_DOWN_FLAG)},
+	{USB_DEVICE(0x0471, 0x0326), DRIVER_INFO(SENSOR_PAS106,
+		GSPCA_SENSOR_UPSIDE_DOWN_FLAG)},
+	{USB_DEVICE(0x0471, 0x032d), DRIVER_INFO(SENSOR_PAS106, 0)},
+	{USB_DEVICE(0x0471, 0x032e), DRIVER_INFO(SENSOR_PAS106, 0)},
 	{USB_DEVICE(0x055f, 0xc005)},
 #ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x055f, 0xd003)},
@@ -7571,7 +7578,7 @@
 	{USB_DEVICE(0x0ac8, 0x301b)},
 	{USB_DEVICE(0x0ac8, 0x303b)},
 #endif
-	{USB_DEVICE(0x0ac8, 0x305b), .driver_info = SENSOR_TAS5130C_VF0250},
+	{USB_DEVICE(0x0ac8, 0x305b), DRIVER_INFO(SENSOR_TAS5130C_VF0250, 0)},
 #ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x0ac8, 0x307b)},
 	{USB_DEVICE(0x10fd, 0x0128)},
diff -r 1da7166882de linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Sun Aug 17 09:09:20 2008 +0200
+++ b/linux/include/linux/videodev2.h	Sun Aug 17 20:01:51 2008 +0200
@@ -260,6 +260,11 @@
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
+
+/* This flags gets set if the "sensor" is known to be upside down and this can
+   *not* be fixed using v4l2 flipx/y controls. Note that absence of this flag
+   is not a guarantee for the image not being upside down. */
+#define V4L2_CAP_SENSOR_UPSIDE_DOWN     0x10000000
 
 /*
  *	V I D E O   I M A G E   F O R M A T

--------------070905010304030700090102
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------070905010304030700090102--
