Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LKVfUJ026931
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 16:31:41 -0400
Received: from sk.insite.com.br (sk.insite.com.br [66.135.32.93])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LKVRQs022299
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 16:31:27 -0400
Received: from [201.82.105.195] (helo=[192.168.1.101])
	by sk.insite.com.br with esmtps (TLSv1:AES256-SHA:256) (Exim 4.69)
	(envelope-from <diniz@wimobilis.com.br>) id 1KsNs9-00072G-OU
	for video4linux-list@redhat.com; Tue, 21 Oct 2008 18:30:34 -0200
From: Rafael Diniz <diniz@wimobilis.com.br>
To: video4linux-list@redhat.com
Date: Tue, 21 Oct 2008 18:36:56 -0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_o1j/I8N+4TM+N3j"
Message-Id: <200810211836.56798.diniz@wimobilis.com.br>
Subject: closed caption support for cx88 cards
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

--Boundary-00=_o1j/I8N+4TM+N3j
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello people, 
I managed to get NTSC closed caption working for a cx88 based card (PixelView 
PlayTV 8000GT).
The attached patch is a quick and dirty hack to make it work, but I'll try to 
make a definitive patch (probably I'll need some help).
I'm testing closed caption reception using
zvbi-ntsc-cc -c -d /dev/vbi0

ps: I traked the ioctl() error, and found that the -EINVAL return comes from 
the cx88-video.c

bye,
rafael diniz


--Boundary-00=_o1j/I8N+4TM+N3j
Content-Type: text/x-diff;
  charset="us-ascii";
  name="cx88-vbi.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cx88-vbi.diff"

diff -r 963a30f13bbf linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Wed Sep 03 09:49:20 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Tue Oct 21 18:33:41 2008 -0200
@@ -1452,9 +1452,9 @@
 {
 	struct cx8800_fh  *fh   = priv;
 	struct cx8800_dev *dev  = fh->dev;
-
-	if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
-		return -EINVAL;
+	
+	// if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) && unlikely(fh->type != V4L2_BUF_TYPE_SLICED_VBI_CAPTURE) )
+	//      return -EINVAL;
 	if (unlikely(i != fh->type))
 		return -EINVAL;
 
@@ -1469,8 +1469,8 @@
 	struct cx8800_dev *dev  = fh->dev;
 	int               err, res;
 
-	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
+	// if ((fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) && (fh->type != V4L2_BUF_TYPE_SLICED_VBI_CAPTURE))
+	//	return -EINVAL;
 	if (i != fh->type)
 		return -EINVAL;
 

--Boundary-00=_o1j/I8N+4TM+N3j
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_o1j/I8N+4TM+N3j--
