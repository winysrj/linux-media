Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LLQLic022457
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 17:26:21 -0400
Received: from eldar.vidconference.de (dns.vs-node5.de [87.106.133.120])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LLQ8lt016149
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 17:26:09 -0400
Date: Tue, 21 Oct 2008 23:26:07 +0200
To: Linux and Kernel Video <video4linux-list@redhat.com>
Message-ID: <20081021212606.GG28699@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
From: Gregor Jasny <jasny@vidsoft.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Add some missing compat32 ioctls
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

Hi,

This patch adds the missing compat ioctls that are needed to
operate Skype in combination with libv4l and a MJPEG only camera.

If you think it's trivial enough please submit it to -stable, too.

Thanks,
Gregor

Signed-off-by: Gregor Jasny <gjasny@web.de>

diff --git a/drivers/media/video/compat_ioctl32.c b/drivers/media/video/compat_ioctl32.c
index bd5d9de..1e6e701 100644
--- a/drivers/media/video/compat_ioctl32.c
+++ b/drivers/media/video/compat_ioctl32.c
@@ -867,6 +867,7 @@ long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_STREAMON32:
 	case VIDIOC_STREAMOFF32:
 	case VIDIOC_G_PARM:
+	case VIDIOC_S_PARM:
 	case VIDIOC_G_STD:
 	case VIDIOC_S_STD:
 	case VIDIOC_G_TUNER:
@@ -885,6 +886,8 @@ long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_S_INPUT32:
 	case VIDIOC_TRY_FMT32:
 	case VIDIOC_S_HW_FREQ_SEEK:
+	case VIDIOC_ENUM_FRAMESIZES:
+	case VIDIOC_ENUM_FRAMEINTERVALS:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
