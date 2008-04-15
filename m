Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3FIGAu9006658
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 14:16:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3FIFaYZ005538
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 14:15:40 -0400
Date: Tue, 15 Apr 2008 15:15:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Message-ID: <20080415151525.23e54de2@gaivota>
In-Reply-To: <200804151958.39524.toralf.foerster@gmx.de>
References: <200804061448.42888.toralf.foerster@gmx.de>
	<20080415135933.1a85fd2e@gaivota>
	<200804151958.39524.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: build issue #469 for v2.6.25-rc8-166-g6fdf5e6 in pms.c :
 undefined reference to `video_usercopy'
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

On Tue, 15 Apr 2008 19:58:39 +0200
Toralf Förster <toralf.foerster@gmx.de> wrote:

> At Tuesday 15 April 2008 18:59:33 Mauro Carvalho Chehab wrote :
> > Hi Toralf,
> > Please try the enclosed patch. It should fix the issue.
> ...
> > ---
> > Fix build when CONFIG_VIDEO_PMS=y and VIDEO_V4L2_COMMON=m
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> > 
> > 
> > Cheers,
> > Mauro
> 
> The patch works, thx :)

Thanks for testing.
> 
> However I had to change the files manually b/c the patch utility didn't
> accepted your input, therefore here's the diff output from my side:

Ah, sorry. The patch were generated with -p2 format (in fact, it is against our
development tree).

If this patch works, the more complete one I've just sent should also work. It
just fixes the symbol checks inside a few drivers.

Ok, this time with -p1 format, against "devel" branch of V4L/DVB (should
equally apply well at linux-next and at mainstream).

Cheers,
Mauro

---

Fix build that occurs when CONFIG_VIDEO_PMS=y and VIDEO_V4L2_COMMON=m

This patch removes zoran checks for VIDEO_V4L2, since this API is always
present, when V4L is selected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
---

diff -upNr oldtree/drivers/media/Kconfig linux/drivers/media/Kconfig
--- oldtree/drivers/media/Kconfig	2008-04-15 15:14:04.000000000 -0300
+++ linux/drivers/media/Kconfig	2008-04-15 15:14:01.000000000 -0300
@@ -30,7 +30,7 @@ config VIDEO_V4L2_COMMON
 	depends on (I2C || I2C=n) && VIDEO_DEV
 	default (I2C || I2C=n) && VIDEO_DEV
 
-config VIDEO_V4L1
+config VIDEO_ALLOW_V4L1
 	bool "Enable Video For Linux API 1 (DEPRECATED)"
 	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	default VIDEO_DEV && VIDEO_V4L2_COMMON
@@ -59,10 +59,15 @@ config VIDEO_V4L1_COMPAT
 	  If you are unsure as to whether this is required, answer Y.
 
 config VIDEO_V4L2
-	bool
+	tristate
 	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	default VIDEO_DEV && VIDEO_V4L2_COMMON
 
+config VIDEO_V4L1
+	tristate
+	depends on VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
+	default VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
+
 source "drivers/media/video/Kconfig"
 
 source "drivers/media/radio/Kconfig"
diff -upNr oldtree/drivers/media/video/msp3400-driver.c linux/drivers/media/video/msp3400-driver.c
--- oldtree/drivers/media/video/msp3400-driver.c	2008-04-15 15:14:06.000000000 -0300
+++ linux/drivers/media/video/msp3400-driver.c	2008-04-15 15:14:02.000000000 -0300
@@ -366,7 +366,7 @@ int msp_sleep(struct msp_state *state, i
 }
 
 /* ------------------------------------------------------------------------ */
-#ifdef CONFIG_VIDEO_V4L1
+#ifdef CONFIG_VIDEO_ALLOW_V4L1
 static int msp_mode_v4l2_to_v4l1(int rxsubchans, int audmode)
 {
 	if (rxsubchans == V4L2_TUNER_SUB_MONO)
@@ -514,7 +514,7 @@ static int msp_command(struct i2c_client
 	/* --- v4l ioctls --- */
 	/* take care: bttv does userspace copying, we'll get a
 	   kernel pointer here... */
-#ifdef CONFIG_VIDEO_V4L1
+#ifdef CONFIG_VIDEO_ALLOW_V4L1
 	case VIDIOCGAUDIO:
 	{
 		struct video_audio *va = arg;
diff -upNr oldtree/drivers/media/video/tuner-core.c linux/drivers/media/video/tuner-core.c
--- oldtree/drivers/media/video/tuner-core.c	2008-04-15 15:14:06.000000000 -0300
+++ linux/drivers/media/video/tuner-core.c	2008-04-15 15:14:03.000000000 -0300
@@ -758,7 +758,7 @@ static int tuner_command(struct i2c_clie
 		if (analog_ops->standby)
 			analog_ops->standby(&t->fe);
 		break;
-#ifdef CONFIG_VIDEO_V4L1
+#ifdef CONFIG_VIDEO_ALLOW_V4L1
 	case VIDIOCSAUDIO:
 		if (check_mode(t, "VIDIOCSAUDIO") == EINVAL)
 			return 0;
diff -upNr oldtree/drivers/media/video/zoran_driver.c linux/drivers/media/video/zoran_driver.c
--- oldtree/drivers/media/video/zoran_driver.c	2008-04-15 15:14:05.000000000 -0300
+++ linux/drivers/media/video/zoran_driver.c	2008-04-15 15:14:02.000000000 -0300
@@ -85,7 +85,6 @@
 #include "zoran_device.h"
 #include "zoran_card.h"
 
-#ifdef CONFIG_VIDEO_V4L2
 	/* we declare some card type definitions here, they mean
 	 * the same as the v4l1 ZORAN_VID_TYPE above, except it's v4l2 */
 #define ZORAN_V4L2_VID_FLAGS ( \
@@ -94,19 +93,15 @@
 				V4L2_CAP_VIDEO_OUTPUT |\
 				V4L2_CAP_VIDEO_OVERLAY \
 			      )
-#endif
 
 #include <asm/byteorder.h>
 
-#if defined(CONFIG_VIDEO_V4L2) && defined(CONFIG_VIDEO_V4L1_COMPAT)
+#if defined(CONFIG_VIDEO_V4L1_COMPAT)
 #define ZFMT(pal, fcc, cs) \
 	.palette = (pal), .fourcc = (fcc), .colorspace = (cs)
-#elif defined(CONFIG_VIDEO_V4L2)
-#define ZFMT(pal, fcc, cs) \
-	.fourcc = (fcc), .colorspace = (cs)
 #else
 #define ZFMT(pal, fcc, cs) \
-	.palette = (pal)
+	.fourcc = (fcc), .colorspace = (cs)
 #endif
 
 const struct zoran_format zoran_formats[] = {
@@ -209,7 +204,6 @@ static int lock_norm;	/* 0 = default 1 =
 module_param(lock_norm, int, 0644);
 MODULE_PARM_DESC(lock_norm, "Prevent norm changes (1 = ignore, >1 = fail)");
 
-#ifdef CONFIG_VIDEO_V4L2
 	/* small helper function for calculating buffersizes for v4l2
 	 * we calculate the nearest higher power-of-two, which
 	 * will be the recommended buffersize */
@@ -232,7 +226,6 @@ zoran_v4l2_calc_bufsize (struct zoran_jp
 		return 8192;
 	return result;
 }
-#endif
 
 /* forward references */
 static void v4l_fbuffer_free(struct file *file);
@@ -1709,7 +1702,6 @@ setup_overlay (struct file *file,
 	return wait_grab_pending(zr);
 }
 
-#ifdef CONFIG_VIDEO_V4L2
 	/* get the status of a buffer in the clients buffer queue */
 static int
 zoran_v4l2_buffer_status (struct file        *file,
@@ -1815,7 +1807,6 @@ zoran_v4l2_buffer_status (struct file   
 
 	return 0;
 }
-#endif
 
 static int
 zoran_set_norm (struct zoran *zr,
@@ -2624,8 +2615,6 @@ zoran_do_ioctl (struct inode *inode,
 	}
 		break;
 
-#ifdef CONFIG_VIDEO_V4L2
-
 		/* The new video4linux2 capture interface - much nicer than video4linux1, since
 		 * it allows for integrating the JPEG capturing calls inside standard v4l2
 		 */
@@ -4197,7 +4186,6 @@ zoran_do_ioctl (struct inode *inode,
 		return 0;
 	}
 		break;
-#endif
 
 	default:
 		dprintk(1, KERN_DEBUG "%s: UNKNOWN ioctl cmd: 0x%x\n",
@@ -4657,9 +4645,7 @@ static const struct file_operations zora
 struct video_device zoran_template __devinitdata = {
 	.name = ZORAN_NAME,
 	.type = ZORAN_VID_TYPE,
-#ifdef CONFIG_VIDEO_V4L2
 	.type2 = ZORAN_V4L2_VID_FLAGS,
-#endif
 	.fops = &zoran_fops,
 	.release = &zoran_vdev_release,
 	.minor = -1
diff -upNr oldtree/drivers/media/video/zoran.h linux/drivers/media/video/zoran.h
--- oldtree/drivers/media/video/zoran.h	2008-04-15 15:14:06.000000000 -0300
+++ linux/drivers/media/video/zoran.h	2008-04-15 15:14:02.000000000 -0300
@@ -243,10 +243,8 @@ struct zoran_format {
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 	int palette;
 #endif
-#ifdef CONFIG_VIDEO_V4L2
 	__u32 fourcc;
 	int colorspace;
-#endif
 	int depth;
 	__u32 flags;
 	__u32 vfespfr;
@@ -271,8 +269,6 @@ struct zoran_v4l_settings {
 	const struct zoran_format *format;	/* capture format */
 };
 
-/* whoops, this one is undeclared if !v4l2 */
-#ifndef CONFIG_VIDEO_V4L2
 struct v4l2_jpegcompression {
 	int quality;
 	int APPn;
@@ -283,7 +279,6 @@ struct v4l2_jpegcompression {
 	__u32 jpeg_markers;
 	__u8 reserved[116];
 };
-#endif
 
 /* jpg-capture/-playback settings */
 struct zoran_jpg_settings {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
