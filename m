Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m62LJcG7006411
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 17:19:38 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m62LJPHZ011274
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 17:19:26 -0400
Message-ID: <486BF25D.5090005@hhs.nl>
Date: Wed, 02 Jul 2008 23:25:49 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------080808040306000002020306"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-mercurial: fix debugging output
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
--------------080808040306000002020306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

This patch makes CONFIG_VIDEO_ADV_DEBUG actually work for gspca

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------080808040306000002020306
Content-Type: text/x-patch;
 name="gspca-fix-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-fix-debug.patch"

Make CONFIG_VIDEO_ADV_DEBUG actually work for gspca

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/gspca.c.dbg	2008-07-02 11:14:56.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/gspca.c	2008-07-02 20:02:12.000000000 +0200
@@ -50,7 +50,7 @@ static int video_nr = -1;
 
 static int comp_fac = 30;	/* Buffer size ratio when compressed in % */
 
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 int gspca_debug = D_ERR | D_PROBE;
 EXPORT_SYMBOL(gspca_debug);
 
@@ -823,7 +823,7 @@ static int try_fmt_vid_cap(struct gspca_
 	/* (luvcview problem) */
 	if (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_MJPEG)
 		fmt->fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG;
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 	if (gspca_debug & D_CONF)
 		PDEBUG_MODE("try fmt cap", fmt->fmt.pix.pixelformat, w, h);
 #endif
@@ -843,7 +843,7 @@ static int try_fmt_vid_cap(struct gspca_
 			/* no chance, return this mode */
 			fmt->fmt.pix.pixelformat =
 					gspca_dev->cam.cam_mode[mode].pixfmt;
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 			if (gspca_debug & D_CONF) {
 				PDEBUG_MODE("new format",
 					fmt->fmt.pix.pixelformat,
@@ -958,7 +958,7 @@ static int dev_open(struct inode *inode,
 	}
 	gspca_dev->users++;
 	file->private_data = gspca_dev;
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 	/* activate the v4l2 debug */
 	if (gspca_debug & D_V4L2)
 		gspca_dev->vdev.debug |= 3;
@@ -1231,7 +1231,7 @@ static int vidioc_streamon(struct file *
 		if (ret < 0)
 			goto out;
 	}
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 	if (gspca_debug & D_STREAM) {
 		PDEBUG_MODE("stream on OK",
 			gspca_dev->pixfmt,
@@ -1986,7 +1986,7 @@ static void __exit gspca_exit(void)
 module_init(gspca_init);
 module_exit(gspca_exit);
 
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 module_param_named(debug, gspca_debug, int, 0644);
 MODULE_PARM_DESC(debug,
 		"Debug (bit) 0x01:error 0x02:probe 0x04:config"
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/gspca.h.dbg	2008-07-02 11:14:56.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/gspca.h	2008-07-02 20:10:16.000000000 +0200
@@ -28,7 +28,7 @@
 #define V4L2_CID_SHARPNESS  (V4L2_CID_BASE+27)
 #endif
 
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 /* GSPCA our debug messages */
 extern int gspca_debug;
 #define PDEBUG(level, fmt, args...) \
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/zc3xx.c.dbg	2008-07-02 11:14:56.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/zc3xx.c	2008-07-02 20:02:13.000000000 +0200
@@ -6436,7 +6436,7 @@ static void setcontrast(struct gspca_dev
 		0, Tgradient_1, Tgradient_2,
 		Tgradient_3, Tgradient_4, Tgradient_5, Tgradient_6
 	};
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 	__u8 v[16];
 #endif
 
@@ -6454,7 +6454,7 @@ static void setcontrast(struct gspca_dev
 		else if (g <= 0)
 			g = 1;
 		reg_w(dev, g, 0x0120 + i);	/* gamma */
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 		if (gspca_debug & D_CONF)
 			v[i] = g;
 #endif
@@ -6474,7 +6474,7 @@ static void setcontrast(struct gspca_dev
 				g = 1;
 		}
 		reg_w(dev, g, 0x0130 + i);	/* gradient */
-#ifdef VIDEO_ADV_DEBUG
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 		if (gspca_debug & D_CONF)
 			v[i] = g;
 #endif

--------------080808040306000002020306
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080808040306000002020306--
