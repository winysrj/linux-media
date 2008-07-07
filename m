Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67KNVZF013311
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 16:23:31 -0400
Received: from vsmtp1.tin.it (vsmtp1.tin.it [212.216.176.141])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67KN1k3024966
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 16:23:01 -0400
Received: from [192.168.3.11] (77.103.126.124) by vsmtp1.tin.it (8.0.016.5)
	(authenticated as aodetti@tin.it)
	id 48494F15019B38B1 for video4linux-list@redhat.com;
	Mon, 7 Jul 2008 22:22:55 +0200
Message-ID: <48727ABD.40608@tiscali.it>
Date: Mon, 07 Jul 2008 21:21:17 +0100
From: Andrea <audetto@tiscali.it>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <25500277.1215264222465.JavaMail.root@ps10>
In-Reply-To: <25500277.1215264222465.JavaMail.root@ps10>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] pwc: do not block in VIDIOC_DQBUF
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

audetto@tiscali.it wrote:
> I think the ioctl VIDIOC_DQBUF in pwc does not follow the API spec.
> It should not block if there are no buffers and the device has been 
> opened with O_NONBLOCK.
> 
> I am not sure the patch is 100% correct, since I do not understand it 
> completely.
> 
> Andrea

Anybody to review this patch?

The documentation of VIDIOC_DQBUF is at

http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/r8849.htm

diff -r 87aa6048e718 linux/drivers/media/video/pwc/pwc-v4l.c
--- a/linux/drivers/media/video/pwc/pwc-v4l.c   Wed Jul 02 08:59:38 2008 -0300
+++ b/linux/drivers/media/video/pwc/pwc-v4l.c   Mon Jul 07 21:17:49 2008 +0100
@@ -1134,6 +1136,13 @@
                                      frameq is safe now.
                          */
                         add_wait_queue(&pdev->frameq, &wait);
+
+                       if ((pdev->full_frames == NULL) && (file->f_flags & O_NONBLOCK)) {
+                               remove_wait_queue(&pdev->frameq, &wait);
+                               set_current_state(TASK_RUNNING);
+                               return -EAGAIN;
+                       }
+
                         while (pdev->full_frames == NULL) {
                                 if (pdev->error_status) {
                                         remove_wait_queue(&pdev->frameq, &wait);


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
