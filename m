Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40142 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab1AGElE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 23:41:04 -0500
Received: by ywl5 with SMTP id 5so6674503ywl.19
        for <linux-media@vger.kernel.org>; Thu, 06 Jan 2011 20:41:02 -0800 (PST)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 1/2] [media] Fix mmap() example in the V4L2 API DocBook
Date: Thu,  6 Jan 2011 20:40:39 -0800
Message-Id: <1294375239-7009-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Correct ioctl return value handling and fix coding style issues.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 Documentation/DocBook/v4l/io.xml |   40 +++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/Documentation/DocBook/v4l/io.xml b/Documentation/DocBook/v4l/io.xml
index d424886..c3bc100 100644
--- a/Documentation/DocBook/v4l/io.xml
+++ b/Documentation/DocBook/v4l/io.xml
@@ -141,63 +141,63 @@ struct {
 } *buffers;
 unsigned int i;
 
-memset (&amp;reqbuf, 0, sizeof (reqbuf));
+memset(&amp;reqbuf, 0, sizeof(reqbuf));
 reqbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 reqbuf.memory = V4L2_MEMORY_MMAP;
 reqbuf.count = 20;
 
-if (-1 == ioctl (fd, &VIDIOC-REQBUFS;, &amp;reqbuf)) {
+if (ioctl(fd, &VIDIOC-REQBUFS;, &amp;reqbuf) &lt; 0) {
 	if (errno == EINVAL)
-		printf ("Video capturing or mmap-streaming is not supported\n");
+		printf("Video capturing or mmap-streaming is not supported\n");
 	else
-		perror ("VIDIOC_REQBUFS");
+		perror("VIDIOC_REQBUFS");
 
-	exit (EXIT_FAILURE);
+	exit(EXIT_FAILURE);
 }
 
 /* We want at least five buffers. */
 
 if (reqbuf.count &lt; 5) {
 	/* You may need to free the buffers here. */
-	printf ("Not enough buffer memory\n");
-	exit (EXIT_FAILURE);
+	printf("Not enough buffer memory\n");
+	exit(EXIT_FAILURE);
 }
 
-buffers = calloc (reqbuf.count, sizeof (*buffers));
-assert (buffers != NULL);
+buffers = calloc(reqbuf.count, sizeof(*buffers));
+assert(buffers != NULL);
 
 for (i = 0; i &lt; reqbuf.count; i++) {
 	&v4l2-buffer; buffer;
 
-	memset (&amp;buffer, 0, sizeof (buffer));
+	memset(&amp;buffer, 0, sizeof(buffer));
 	buffer.type = reqbuf.type;
 	buffer.memory = V4L2_MEMORY_MMAP;
 	buffer.index = i;
 
-	if (-1 == ioctl (fd, &VIDIOC-QUERYBUF;, &amp;buffer)) {
-		perror ("VIDIOC_QUERYBUF");
-		exit (EXIT_FAILURE);
+	if (ioctl(fd, &VIDIOC-QUERYBUF;, &amp;buffer) &lt; 0) {
+		perror("VIDIOC_QUERYBUF");
+		exit(EXIT_FAILURE);
 	}
 
 	buffers[i].length = buffer.length; /* remember for munmap() */
 
-	buffers[i].start = mmap (NULL, buffer.length,
-				 PROT_READ | PROT_WRITE, /* recommended */
-				 MAP_SHARED,             /* recommended */
-				 fd, buffer.m.offset);
+	buffers[i].start = mmap(NULL, buffer.length,
+				PROT_READ | PROT_WRITE, /* recommended */
+				MAP_SHARED,             /* recommended */
+				fd, buffer.m.offset);
 
 	if (MAP_FAILED == buffers[i].start) {
 		/* If you do not exit here you should unmap() and free()
 		   the buffers mapped so far. */
-		perror ("mmap");
-		exit (EXIT_FAILURE);
+		perror("mmap");
+		exit(EXIT_FAILURE);
 	}
 }
 
 /* Cleanup. */
 
 for (i = 0; i &lt; reqbuf.count; i++)
-	munmap (buffers[i].start, buffers[i].length);
+	munmap(buffers[i].start, buffers[i].length);
       </programlisting>
     </example>
 
-- 
1.7.3.4

