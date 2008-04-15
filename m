Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3FI93a7032448
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 14:09:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3FI8qZX032105
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 14:08:52 -0400
Date: Tue, 15 Apr 2008 15:08:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080415150841.2041984e@gaivota>
In-Reply-To: <20080415135933.1a85fd2e@gaivota>
References: <200804061448.42888.toralf.foerster@gmx.de>
	<20080415135933.1a85fd2e@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Rafael Wysocki <rjw@sisk.pl>,
	Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>,
	video4linux-list@redhat.com
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

On Tue, 15 Apr 2008 13:59:33 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hi Toralf,
> 
> On Sun, 6 Apr 2008 14:48:40 +0200
> Toralf Förster <toralf.foerster@gmx.de> wrote:
> 
> > drivers/built-in.o: In function `pms_ioctl':
> > pms.c:(.text+0x44947): undefined reference to `video_usercopy'
> > drivers/built-in.o: In function `pms_do_ioctl':
> > pms.c:(.text+0x44974): undefined reference to `video_devdata'
> > drivers/built-in.o: In function `pms_read':
> > pms.c:(.text+0x45025): undefined reference to `video_devdata'
> > drivers/built-in.o: In function `cleanup_pms_module':
> > pms.c:(.exit.text+0x5fe): undefined reference to `video_unregister_device'
> > drivers/built-in.o: In function `init_pms_cards':
> > pms.c:(.init.text+0x610d): undefined reference to `video_register_device'
> > drivers/built-in.o:(.rodata+0x2ec8): undefined reference to `v4l_compat_ioctl32'
> > drivers/built-in.o:(.rodata+0x2ed0): undefined reference to `video_exclusive_open'
> > drivers/built-in.o:(.rodata+0x2ed8): undefined reference to `video_exclusive_release'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> Please try the enclosed patch. It should fix the issue.

Sorry, the previous patch were incomplete, since there a few drivers that test
for those boolean symbols.

Cheers,
Mauro.

---

Fix build that occurs when CONFIG_VIDEO_PMS=y and VIDEO_V4L2_COMMON=m

This patch removes zoran checks for VIDEO_V4L2, since this API is always present, when
V4L is selected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r 34e5c8ed9fcb linux/drivers/media/Kconfig
--- a/linux/drivers/media/Kconfig	Tue Apr 15 12:12:36 2008 -0300
+++ b/linux/drivers/media/Kconfig	Tue Apr 15 14:38:08 2008 -0300
@@ -30,7 +30,7 @@ config VIDEO_V4L2_COMMON
 	depends on (I2C || I2C=n) && VIDEO_DEV
 	default (I2C || I2C=n) && VIDEO_DEV
 
-config VIDEO_V4L1
+config VIDEO_ALLOW_V4L1
 	bool "Enable Video For Linux API 1 (DEPRECATED)"
 	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	default VIDEO_DEV && VIDEO_V4L2_COMMON
@@ -59,9 +59,14 @@ config VIDEO_V4L1_COMPAT
 	  If you are unsure as to whether this is required, answer Y.
 
 config VIDEO_V4L2
-	bool
+	tristate
 	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	default VIDEO_DEV && VIDEO_V4L2_COMMON
+
+config VIDEO_V4L1
+	tristate
+	depends on VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
+	default VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
 
 source "drivers/media/video/Kconfig"
 
diff -r 34e5c8ed9fcb linux/drivers/media/video/msp3400-driver.c
--- a/linux/drivers/media/video/msp3400-driver.c	Tue Apr 15 12:12:36 2008 -0300
+++ b/linux/drivers/media/video/msp3400-driver.c	Tue Apr 15 14:38:08 2008 -0300
@@ -410,7 +410,7 @@ int msp_sleep(struct msp_state *state, i
 }
 
 /* ------------------------------------------------------------------------ */
-#ifdef CONFIG_VIDEO_V4L1
+#ifdef CONFIG_VIDEO_ALLOW_V4L1
 static int msp_mode_v4l2_to_v4l1(int rxsubchans, int audmode)
 {
 	if (rxsubchans == V4L2_TUNER_SUB_MONO)
@@ -558,7 +558,7 @@ static int msp_command(struct i2c_client
 	/* --- v4l ioctls --- */
 	/* take care: bttv does userspace copying, we'll get a
 	   kernel pointer here... */
-#ifdef CONFIG_VIDEO_V4L1
+#ifdef CONFIG_VIDEO_ALLOW_V4L1
 	case VIDIOCGAUDIO:
 	{
 		struct video_audio *va = arg;
diff -r 34e5c8ed9fcb linux/drivers/media/video/tuner-core.c
--- a/linux/drivers/media/video/tuner-core.c	Tue Apr 15 12:12:36 2008 -0300
+++ b/linux/drivers/media/video/tuner-core.c	Tue Apr 15 14:38:08 2008 -0300
@@ -802,7 +802,7 @@ static int tuner_command(struct i2c_clie
 		if (analog_ops->standby)
 			analog_ops->standby(&t->fe);
 		break;
-#ifdef CONFIG_VIDEO_V4L1
+#ifdef CONFIG_VIDEO_ALLOW_V4L1
 	case VIDIOCSAUDIO:
 		if (check_mode(t, "VIDIOCSAUDIO") == EINVAL)
 			return 0;
diff -r 34e5c8ed9fcb linux/drivers/media/video/zoran.h
--- a/linux/drivers/media/video/zoran.h	Tue Apr 15 12:12:36 2008 -0300
+++ b/linux/drivers/media/video/zoran.h	Tue Apr 15 14:38:08 2008 -0300
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
diff -r 34e5c8ed9fcb linux/drivers/media/video/zoran_driver.c
--- a/linux/drivers/media/video/zoran_driver.c	Tue Apr 15 12:12:36 2008 -0300
+++ b/linux/drivers/media/video/zoran_driver.c	Tue Apr 15 14:38:08 2008 -0300
@@ -88,7 +88,6 @@
 #include "zoran_device.h"
 #include "zoran_card.h"
 
-#ifdef CONFIG_VIDEO_V4L2
 	/* we declare some card type definitions here, they mean
 	 * the same as the v4l1 ZORAN_VID_TYPE above, except it's v4l2 */
 #define ZORAN_V4L2_VID_FLAGS ( \
@@ -97,19 +96,15 @@
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
+#else
 #define ZFMT(pal, fcc, cs) \
 	.fourcc = (fcc), .colorspace = (cs)
-#else
-#define ZFMT(pal, fcc, cs) \
-	.palette = (pal)
 #endif
 
 const struct zoran_format zoran_formats[] = {
@@ -219,7 +214,6 @@ module_param(lock_norm, int, 0644);
 module_param(lock_norm, int, 0644);
 MODULE_PARM_DESC(lock_norm, "Prevent norm changes (1 = ignore, >1 = fail)");
 
-#ifdef CONFIG_VIDEO_V4L2
 	/* small helper function for calculating buffersizes for v4l2
 	 * we calculate the nearest higher power-of-two, which
 	 * will be the recommended buffersize */
@@ -242,7 +236,6 @@ zoran_v4l2_calc_bufsize (struct zoran_jp
 		return 8192;
 	return result;
 }
-#endif
 
 /* forward references */
 static void v4l_fbuffer_free(struct file *file);
@@ -1776,7 +1769,6 @@ setup_overlay (struct file *file,
 	return wait_grab_pending(zr);
 }
 
-#ifdef CONFIG_VIDEO_V4L2
 	/* get the status of a buffer in the clients buffer queue */
 static int
 zoran_v4l2_buffer_status (struct file        *file,
@@ -1882,7 +1874,6 @@ zoran_v4l2_buffer_status (struct file   
 
 	return 0;
 }
-#endif
 
 static int
 zoran_set_norm (struct zoran *zr,
@@ -2691,8 +2682,6 @@ zoran_do_ioctl (struct inode *inode,
 	}
 		break;
 
-#ifdef CONFIG_VIDEO_V4L2
-
 		/* The new video4linux2 capture interface - much nicer than video4linux1, since
 		 * it allows for integrating the JPEG capturing calls inside standard v4l2
 		 */
@@ -4264,7 +4253,6 @@ zoran_do_ioctl (struct inode *inode,
 		return 0;
 	}
 		break;
-#endif
 
 	default:
 		dprintk(1, KERN_DEBUG "%s: UNKNOWN ioctl cmd: 0x%x\n",
@@ -4724,9 +4712,7 @@ struct video_device zoran_template __dev
 struct video_device zoran_template __devinitdata = {
 	.name = ZORAN_NAME,
 	.type = ZORAN_VID_TYPE,
-#ifdef CONFIG_VIDEO_V4L2
 	.type2 = ZORAN_V4L2_VID_FLAGS,
-#endif
 	.fops = &zoran_fops,
 	.release = &zoran_vdev_release,
 	.minor = -1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
