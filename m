Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m47Kqxax017404
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 16:52:59 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m47KqOMI023778
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 16:52:26 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 7 May 2008 22:52:16 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805072252.16704.tobias.lorenz@gmx.net>
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 1/2] v4l2: hardware frequency seek ioctl interface
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
Hi Keith,

based on the radio hardware frequency seek patch from Keith, I propose the following patch.
Mainly it introduces a new ioctl VIDIOC_S_HW_FREQ_SEEK.
The following options can be set: seek_upward, wrap_around.
I removed the start_freq from the original proposal, as I see no use case for it.
Usually you want to start searching at the current frequency and if not VIDIOC_S_FREQUENCY can be used.

The first part of the patch contains the driver independent part of VIDIOC_S_HW_FREQ_SEEK.
The second part of the patch contains a modification to the radio-si470x driver to support the new ioctl.

Testing of the new interface was done by a modified version of fmseek from the fmtools package, that I can provide on request.
Hardware specific options to change the seek behaviour are implemented using private video controls.
For this it was necessary to introduce a new header file for the radio-si470x private video control definitions, but I also moved all hardware register definitions to it.

The current patch is against linux-2.6.25.
I can provide one against the current mercurial version on request.

Bye,
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
+++ linux-2.6.25-si470x/drivers/media/video/videodev.c	2008-05-07 17:44:17.000000000 +0200
@@ -331,6 +331,7 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_DBG_G_REGISTER)]   = "VIDIOC_DBG_G_REGISTER",
 
 	[_IOC_NR(VIDIOC_G_CHIP_IDENT)]     = "VIDIOC_G_CHIP_IDENT",
+	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
 #endif
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
@@ -1853,6 +1854,16 @@ static int __video_do_ioctl(struct inode
 			dbgarg (cmd, "chip_ident=%u, revision=0x%x\n", p->ident, p->revision);
 		break;
 	}
+	case VIDIOC_S_HW_FREQ_SEEK:
+	{
+		struct v4l2_hw_freq_seek *p=arg;
+		if (!vfd->vidioc_s_hw_freq_seek)
+			break;
+		dbgarg (cmd, "tuner=%d, type=%d, seek_upward=%d, wrap_around=%d\n",
+				p->tuner,p->type,p->seek_upward,p->wrap_around);
+		ret=vfd->vidioc_s_hw_freq_seek(file, fh, p);
+		break;
+	}
 	} /* switch */
 
 	if (vfd->debug & V4L2_DEBUG_IOCTL_ARG) {
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h --exclude='radio-si470x.[ch]' -uprN linux-2.6.25/include/linux/videodev2.h linux-2.6.25-si470x/include/linux/videodev2.h
--- linux-2.6.25/include/linux/videodev2.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-si470x/include/linux/videodev2.h	2008-05-07 16:56:33.000000000 +0200
@@ -246,6 +246,7 @@ struct v4l2_capability
 #define V4L2_CAP_SLICED_VBI_OUTPUT	0x00000080  /* Is a sliced VBI output device */
 #define V4L2_CAP_RDS_CAPTURE		0x00000100  /* RDS data capture */
 #define V4L2_CAP_VIDEO_OUTPUT_OVERLAY	0x00000200  /* Can do video output overlay */
+#define V4L2_CAP_HW_FREQ_SEEK		0x00000400  /* Can do hardware frequency seek  */
 
 #define V4L2_CAP_TUNER			0x00010000  /* has a tuner */
 #define V4L2_CAP_AUDIO			0x00020000  /* has audio support */
@@ -1111,6 +1112,15 @@ struct v4l2_frequency
 	__u32		      reserved[8];
 };
 
+struct v4l2_hw_freq_seek
+{
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
@@ -1396,6 +1406,7 @@ struct v4l2_chip_ident {
 
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
