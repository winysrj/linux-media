Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n02G47AD028157
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 11:04:07 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n02G3fVp028256
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 11:03:42 -0500
Received: by wf-out-1314.google.com with SMTP id 25so6389330wfc.6
	for <video4linux-list@redhat.com>; Fri, 02 Jan 2009 08:03:39 -0800 (PST)
Message-ID: <e5df86c90901020803w75d5aab1g8b73b9da4c6b178@mail.gmail.com>
Date: Fri, 2 Jan 2009 10:03:39 -0600
From: "Mark Jenks" <mjenks1968@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: {PATCH] If using HVR-1250 and HVR-1800 in the same system it causes
	kernel oops.
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

Analog support for HVR-1250 is not completed, but exists for the HVR-1800.
This causes a NULL error to show up in video_open and mpeg_open.

-Mark


--- a/linux/drivers/media/video/cx23885/cx23885-417.c   2009-01-01
14:27:15.000000000 -0600
+++ b/linux/drivers/media/video/cx23885/cx23885-417.c   2009-01-01
14:27:39.000000000 -0600
@@ -1593,7 +1593,8 @@
        lock_kernel();
        list_for_each(list, &cx23885_devlist) {
                h = list_entry(list, struct cx23885_dev, devlist);
-               if (h->v4l_device->minor == minor) {
+               if (h->v4l_device &&
+                   h->v4l_device->minor == minor) {
                        dev = h;
                        break;
                }
--- a/linux/drivers/media/video/cx23885/cx23885-video.c Fri Dec 26 08:07:39
2008 -0200
+++ b/linux/drivers/media/video/cx23885/cx23885-video.c Sun Dec 28 16:34:04
2008 -0500
@@ -786,7 +786,8 @@ static int video_open(struct inode *inod
       lock_kernel();
       list_for_each(list, &cx23885_devlist) {
               h = list_entry(list, struct cx23885_dev, devlist);
-               if (h->video_dev->minor == minor) {
+               if (h->video_dev &&
+                   h->video_dev->minor == minor) {
                       dev  = h;
                       type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
               }
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
