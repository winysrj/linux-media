Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TBqc5K025473
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 07:52:38 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TBqQEg017242
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 07:52:26 -0400
Date: Tue, 29 Jul 2008 13:52:24 +0200
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20080729115224.GD21280@vidsoft.de>
References: <488721F2.5000509@hhs.nl> <20080728214927.GA21280@vidsoft.de>
	<488E4090.5020600@gmail.com>
	<20080728221628.GB21280@vidsoft.de> <488E46BC.10104@gmail.com>
	<488EEA42.2020907@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488EEA42.2020907@hhs.nl>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Subject: Re: [V4l2-library] Messed up syscall return value
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

On Tue, Jul 29, 2008 at 12:00:34PM +0200, Hans de Goede wrote:
> Indeed, so iow I'm happy to conclude that thie is not a libv4l bug :)

Will you add a work around like the above in libv4l?

Thanks,
Gregor

Index: libv4l2/libv4l2.c
===================================================================
RCS file: /var/cvs/vidsoft/extern/libv4l/libv4l2/libv4l2.c,v
retrieving revision 1.5
diff -u -r1.5 libv4l2.c
--- libv4l2/libv4l2.c	14 Jul 2008 14:00:28 -0000	1.5
+++ libv4l2/libv4l2.c	29 Jul 2008 11:51:20 -0000
@@ -97,7 +97,7 @@
   req.count = devices[index].nreadbuffers;
   req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
   req.memory = V4L2_MEMORY_MMAP;
-  if ((result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_REQBUFS, &req))){
+  if ((result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_REQBUFS, &req)) < 0){
     int saved_err = errno;
     V4L2_LOG_ERR("requesting buffers: %s\n", strerror(errno));
     errno = saved_err;
@@ -121,7 +121,7 @@
   req.count = 0;
   req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
   req.memory = V4L2_MEMORY_MMAP;
-  if ((result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_REQBUFS, &req))) {
+  if ((result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_REQBUFS, &req)) < 0) {
     int saved_err = errno;
     V4L2_LOG_ERR("unrequesting buffers: %s\n", strerror(errno));
     errno = saved_err;
@@ -723,8 +723,9 @@
 	v4l2_unmap_buffers(index);
 
 	result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_REQBUFS, req);
-	if (result)
+	if (result < 0)
 	  break;
+	result = 0; // some drivers return the number of buffers on success
 
 	/* If we got more frames then we can handle lie to the app */
 	if (req->count > V4L2_MAX_NO_FRAMES)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
