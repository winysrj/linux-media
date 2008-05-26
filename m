Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QIf6Iw002269
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 14:41:06 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4QIetfl002580
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 14:40:55 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 26 May 2008 20:40:46 +0200
References: <200805072252.16704.tobias.lorenz@gmx.net>
	<20080526104130.355b6f41@gaivota>
In-Reply-To: <20080526104130.355b6f41@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805262040.47204.tobias.lorenz@gmx.net>
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 1/2] v4l2: hardware frequency seek ioctl interface
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

Hi Mauro,

> The patch itself looks good. However, there are several codingstyle errors. Please run checkpatch.pl against it and send me again, having the pointed issues fixed.

Yes, I know. The errors are a result from trying to follow the coding style of these files.

This is the file list with comments on coding style and patch:
drivers/media/video/videodev.c: has unusual coding style, but hwseek patch is now corrected
drivers/media/video/compat_ioctl32.c: had already nice coding style, hwseek patch too
include/linux/videodev2.h: has unusual coding style, but hwseek patch is now corrected except from one long line...
include/media/v4l2-dev.h: has unusual coding style, but hwseek patch is now corrected
Maybe I should send a coding style cleanup patch for these files too :-)

The corrected patch is still against linux-2.6.25. I hope it applies cleanly to the mercurial v4l repository.

Best regards,

Toby


Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h --exclude='radio-si470x.[ch]' -uprN linux-2.6.25/drivers/media/video/compat_ioctl32.c linux-2.6.25-si470x/drivers/media/video/compat_ioctl32.c
--- linux-2.6.25/drivers/media/video/compat_ioctl32.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-si470x/drivers/media/video/compat_ioctl32.c	2008-04-30 08:39:14.000000000 +0200
@@ -884,6 +884,7 @@ long v4l_compat_ioctl32(struct file *fil
 	case VIDIOC_G_INPUT32:
 	case VIDIOC_S_INPUT32:
 	case VIDIOC_TRY_FMT32:
+	case VIDIOC_S_HW_FREQ_SEEK:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h --exclude='radio-si470x.[ch]' -uprN linux-2.6.25/drivers/media/video/videodev.c linux-2.6.25-si470x/drivers/media/video/videodev.c
--- linux-2.6.25/drivers/media/video/videodev.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-si470x/drivers/media/video/videodev.c	2008-05-26 20:28:17.000000000 +0200
@@ -331,6 +331,7 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_DBG_G_REGISTER)]   = "VIDIOC_DBG_G_REGISTER",
 
 	[_IOC_NR(VIDIOC_G_CHIP_IDENT)]     = "VIDIOC_G_CHIP_IDENT",
+	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
 #endif
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
@@ -1853,6 +1854,17 @@ static int __video_do_ioctl(struct inode
 			dbgarg (cmd, "chip_ident=%u, revision=0x%x\n", p->ident, p->revision);
 		break;
 	}
+	case VIDIOC_S_HW_FREQ_SEEK:
+	{
+		struct v4l2_hw_freq_seek *p = arg;
+		if (!vfd->vidioc_s_hw_freq_seek)
+			break;
+		dbgarg(cmd,
+			"tuner=%d, type=%d, seek_upward=%d, wrap_around=%d\n",
+			p->tuner, p->type, p->seek_upward, p->wrap_around);
+		ret = vfd->vidioc_s_hw_freq_seek(file, fh, p);
+		break;
+	}
 	} /* switch */
 
 	if (vfd->debug & V4L2_DEBUG_IOCTL_ARG) {
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h --exclude='radio-si470x.[ch]' -uprN linux-2.6.25/include/linux/videodev2.h linux-2.6.25-si470x/include/linux/videodev2.h
--- linux-2.6.25/include/linux/videodev2.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-si470x/include/linux/videodev2.h	2008-05-26 20:28:55.000000000 +0200
@@ -246,6 +246,7 @@ struct v4l2_capability
 #define V4L2_CAP_SLICED_VBI_OUTPUT	0x00000080  /* Is a sliced VBI output device */
 #define V4L2_CAP_RDS_CAPTURE		0x00000100  /* RDS data capture */
 #define V4L2_CAP_VIDEO_OUTPUT_OVERLAY	0x00000200  /* Can do video output overlay */
+#define V4L2_CAP_HW_FREQ_SEEK		0x00000400  /* Can do hardware frequency seek  */
 
 #define V4L2_CAP_TUNER			0x00010000  /* has a tuner */
 #define V4L2_CAP_AUDIO			0x00020000  /* has audio support */
@@ -1111,6 +1112,14 @@ struct v4l2_frequency
 	__u32		      reserved[8];
 };
 
+struct v4l2_hw_freq_seek {
+	__u32		      tuner;
+	enum v4l2_tuner_type  type;
+	__u32		      seek_upward;
+	__u32		      wrap_around;
+	__u32		      reserved[8];
+};
+
 /*
  *	A U D I O
  */
@@ -1396,6 +1405,7 @@ struct v4l2_chip_ident {
 
 #define VIDIOC_G_CHIP_IDENT     _IOWR ('V', 81, struct v4l2_chip_ident)
 #endif
+#define VIDIOC_S_HW_FREQ_SEEK	_IOW  ('V', 82, struct v4l2_hw_freq_seek)
 
 #ifdef __OLD_VIDIOC_
 /* for compatibility, will go away some day */
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h --exclude='radio-si470x.[ch]' -uprN linux-2.6.25/include/media/v4l2-dev.h linux-2.6.25-si470x/include/media/v4l2-dev.h
--- linux-2.6.25/include/media/v4l2-dev.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-si470x/include/media/v4l2-dev.h	2008-04-24 23:21:48.000000000 +0200
@@ -318,6 +318,8 @@ struct video_device
 	int (*vidioc_g_chip_ident)     (struct file *file, void *fh,
 					struct v4l2_chip_ident *chip);
 
+	int (*vidioc_s_hw_freq_seek)   (struct file *file, void *fh,
+					struct v4l2_hw_freq_seek *a);
 
 #ifdef OBSOLETE_OWNER /* to be removed soon */
 /* obsolete -- fops->owner is used instead */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
