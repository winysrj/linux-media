Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbZEKXgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 19:36:54 -0400
Date: Mon, 11 May 2009 20:36:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?UTF-8?B?6rmA7ZiV7KSA?= <riverful.kim@samsung.com>
Subject: Re: About using VIDIOC_REQBUFS
Message-ID: <20090511203647.6c982275@pedra.chehab.org>
In-Reply-To: <5e9665e10904230315o46ef5f95o8c393a9148976880@mail.gmail.com>
References: <5e9665e10904230315o46ef5f95o8c393a9148976880@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 23 Apr 2009 19:15:14 +0900
"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com> escreveu:

> Hello Hans,
> 
> Is it an ordinary way to use twice reqbuf without closing and
> re-opening between them?
> 
> I mean like this,
> 
> 1. Open device
> 2. VIDIOC_REQBUFS
>      <snip>
> 3. VIDIOC_STREAMON
>      <snip>
> 4. VIDIOC_STREAMOFF
> 5. VIDIOC_REQBUFS
>      <snip>
> 6. VIDIOC_STREAMON
> 
> I suppose there should be a strict order for this. That order seems to
> be wrong but necessary when we do capturing a JPEG data which size
> (not resolution) is bigger than the preview data size. (Assuming that
> user is using mmap)
> Please let me know the right way for that kind of case. Just close and
> re-open with big enough size for JPEG? or mmap with big enough size in
> the first place?

That's a very good question. 

You shouldn't be needing to close/open the device for this to work, but between
(4) and (5), you'll need to call VIDIOC_S_FMT, to change the videobuf size,
and, to be safe, unmap the videobuf memory.

A code like the above may give different results depending on the way
videobuffer handling is implemented.

A good idea is to test it with vivi driver (that uses videobuf), with debugs
enabled, and compare with other drivers.

I did such test with vivi and it worked properly (although I didn't change the
data size).

If you want to test, I used the driver-test program, available at the
development tree, with the patch bellow. I didn't actually tested to resize the
stream, but from vivi logs, the mmapped buffers seem to be properly
allocated/deallocated.



Cheers,
Mauro

diff --git a/v4l2-apps/test/driver-test.c b/v4l2-apps/test/driver-test.c
--- a/v4l2-apps/test/driver-test.c
+++ b/v4l2-apps/test/driver-test.c
@@ -30,7 +30,7 @@ int main(void)
 {
 	struct v4l2_driver drv;
 	struct drv_list *cur;
-	unsigned int count = 10, i;
+	unsigned int count = 10, i, j;
 	double freq;
 
 	if (v4l2_open ("/dev/video0", 1,&drv)<0) {
@@ -97,45 +97,47 @@ int main(void)
 	fflush (stdout);
 	sleep(1);
 
-	v4l2_mmap_bufs(&drv, 2);
+	for (j = 0; j < 5; j++) {
+		v4l2_mmap_bufs(&drv, 2);
 
-	v4l2_start_streaming(&drv);
+		v4l2_start_streaming(&drv);
 
-	printf("Waiting for frames...\n");
+		printf("Waiting for frames...\n");
 
-	for (i=0;i<count;i++) {
-		fd_set fds;
-		struct timeval tv;
-		int r;
+		for (i=0;i<count;i++) {
+			fd_set fds;
+			struct timeval tv;
+			int r;
 
-		FD_ZERO (&fds);
-		FD_SET (drv.fd, &fds);
+			FD_ZERO (&fds);
+			FD_SET (drv.fd, &fds);
 
-		/* Timeout. */
-		tv.tv_sec = 2;
-		tv.tv_usec = 0;
+			/* Timeout. */
+			tv.tv_sec = 2;
+			tv.tv_usec = 0;
 
-		r = select (drv.fd + 1, &fds, NULL, NULL, &tv);
-		if (-1 == r) {
-			if (EINTR == errno)
-				continue;
+			r = select (drv.fd + 1, &fds, NULL, NULL, &tv);
+			if (-1 == r) {
+				if (EINTR == errno)
+					continue;
+	
+				perror ("select");
+				return errno;
+			}
 
-			perror ("select");
-			return errno;
+			if (0 == r) {
+				fprintf (stderr, "select timeout\n");
+				return errno;
+			}
+
+			if (v4l2_rcvbuf(&drv, recebe_buffer))
+				break;
 		}
 
-		if (0 == r) {
-			fprintf (stderr, "select timeout\n");
-			return errno;
-		}
-
-		if (v4l2_rcvbuf(&drv, recebe_buffer))
-			break;
+		printf("stopping streaming\n");
+		v4l2_stop_streaming(&drv);
 	}
 
-	printf("stopping streaming\n");
-	v4l2_stop_streaming(&drv);
-
 	if (v4l2_close (&drv)<0) {
 		perror("close");
 		return -1;

