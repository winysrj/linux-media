Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9MHYga9026958
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 13:34:42 -0400
Received: from sk.insite.com.br (sk.insite.com.br [66.135.32.93])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9MHYPJG027325
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 13:34:26 -0400
Received: from [201.82.105.195] (helo=[192.168.1.101])
	by sk.insite.com.br with esmtps (TLSv1:AES256-SHA:256) (Exim 4.69)
	(envelope-from <diniz@wimobilis.com.br>) id 1KshaO-0001eH-8H
	for video4linux-list@redhat.com; Wed, 22 Oct 2008 15:33:33 -0200
From: Rafael Diniz <diniz@wimobilis.com.br>
To: video4linux-list@redhat.com
Date: Wed, 22 Oct 2008 15:39:42 -0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_eV2/I//GcOoU4TU"
Message-Id: <200810221539.42999.diniz@wimobilis.com.br>
Subject: [PATCH] VBI fix for cx88 cards
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

--Boundary-00=_eV2/I//GcOoU4TU
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The attached patch fix VBI support cx88 card.
I'm running a capture for hours, getting the closed caption from it[1], and 
it's working perfect - the output is the same of a bttv card.
Please apply this patch as soon as possible.

[1] - using zvbi-ntsc-cc of zvbi project.


Thanks,
Rafael Diniz


--Boundary-00=_eV2/I//GcOoU4TU
Content-Type: text/x-diff; charset="us-ascii";
	name="cx88-video-vbi-support.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cx88-video-vbi-support.diff"

diff -r 931fa560184d linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Tue Oct 21 20:20:26 2008 -0200
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Wed Oct 22 15:28:44 2008 -0200
@@ -1453,8 +1453,12 @@ static int vidioc_streamon(struct file *
 	struct cx8800_fh  *fh   = priv;
 	struct cx8800_dev *dev  = fh->dev;
 
-	if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
+	/* We should remember that this driver also supports teletext,  */
+	/* so we have to test if the v4l2_buf_type is VBI capture data. */
+	if (unlikely((fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) && 
+		     (fh->type != V4L2_BUF_TYPE_VBI_CAPTURE)))
 		return -EINVAL;
+
 	if (unlikely(i != fh->type))
 		return -EINVAL;
 
@@ -1469,8 +1473,10 @@ static int vidioc_streamoff(struct file 
 	struct cx8800_dev *dev  = fh->dev;
 	int               err, res;
 
-	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if ((fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
+	    (fh->type != V4L2_BUF_TYPE_VBI_CAPTURE))
 		return -EINVAL;
+
 	if (i != fh->type)
 		return -EINVAL;
 

--Boundary-00=_eV2/I//GcOoU4TU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_eV2/I//GcOoU4TU--
