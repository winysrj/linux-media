Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8FMOXam007742
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 18:24:34 -0400
Received: from mailrelay010.isp.belgacom.be (mailrelay010.isp.belgacom.be
	[195.238.6.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8FMOMxH007157
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 18:24:23 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 16 Sep 2008 00:24:29 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809160024.29950.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: uvcvideo: Fix incomplete frame drop when switching to a variable
	size format.
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

When streaming in a fixed size format the driver sets a flag in the uvc_queue
structure to drop incomplete incoming frames. The flag wasn't cleared when
switching to a variable size format, which resulted in a broken
'MJPEG after YUV'.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_v4l2.c  |    4 ----
 drivers/media/video/uvc/uvc_video.c |    5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index d7bd71b..71530a0 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -845,10 +845,6 @@ static int uvc_v4l2_do_ioctl(struct inode *inode, struct file *file,
 		if (ret < 0)
 			return ret;
 
-		if (!(video->streaming->cur_format->flags &
-		    UVC_FMT_FLAG_COMPRESSED))
-			video->queue.flags |= UVC_QUEUE_DROP_INCOMPLETE;
-
 		rb->count = ret;
 		ret = 0;
 		break;
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 0b7fc5d..08c453e 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -971,6 +971,11 @@ int uvc_video_enable(struct uvc_video_device *video, int enable)
 		return 0;
 	}
 
+	if (video->streaming->cur_format->flags & UVC_FMT_FLAG_COMPRESSED)
+		video->queue.flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
+	else
+		video->queue.flags |= UVC_QUEUE_DROP_INCOMPLETE;
+
 	if ((ret = uvc_queue_enable(&video->queue, 1)) < 0)
 		return ret;
 
-- 
1.5.6.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
