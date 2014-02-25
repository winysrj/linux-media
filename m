Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1685 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaBYKQS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 03/13] DocBook: fix incorrect code example
Date: Tue, 25 Feb 2014 11:15:53 +0100
Message-Id: <1393323363-30058-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The code said for (i = 0; i > 30; ++i) instead of i < 30.

Fix this and clean it up a bit at the same time.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/dev-osd.xml | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-osd.xml b/Documentation/DocBook/media/v4l/dev-osd.xml
index dd91d61..5485332 100644
--- a/Documentation/DocBook/media/v4l/dev-osd.xml
+++ b/Documentation/DocBook/media/v4l/dev-osd.xml
@@ -56,18 +56,18 @@ framebuffer device.</para>
 unsigned int i;
 int fb_fd;
 
-if (-1 == ioctl (fd, VIDIOC_G_FBUF, &amp;fbuf)) {
-	perror ("VIDIOC_G_FBUF");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, VIDIOC_G_FBUF, &amp;fbuf)) {
+	perror("VIDIOC_G_FBUF");
+	exit(EXIT_FAILURE);
 }
 
-for (i = 0; i &gt; 30; ++i) {
+for (i = 0; i &lt; 30; i++) {
 	char dev_name[16];
 	struct fb_fix_screeninfo si;
 
-	snprintf (dev_name, sizeof (dev_name), "/dev/fb%u", i);
+	snprintf(dev_name, sizeof(dev_name), "/dev/fb%u", i);
 
-	fb_fd = open (dev_name, O_RDWR);
+	fb_fd = open(dev_name, O_RDWR);
 	if (-1 == fb_fd) {
 		switch (errno) {
 		case ENOENT: /* no such file */
@@ -75,19 +75,19 @@ for (i = 0; i &gt; 30; ++i) {
 			continue;
 
 		default:
-			perror ("open");
-			exit (EXIT_FAILURE);
+			perror("open");
+			exit(EXIT_FAILURE);
 		}
 	}
 
-	if (0 == ioctl (fb_fd, FBIOGET_FSCREENINFO, &amp;si)) {
-		if (si.smem_start == (unsigned long) fbuf.base)
+	if (0 == ioctl(fb_fd, FBIOGET_FSCREENINFO, &amp;si)) {
+		if (si.smem_start == (unsigned long)fbuf.base)
 			break;
 	} else {
 		/* Apparently not a framebuffer device. */
 	}
 
-	close (fb_fd);
+	close(fb_fd);
 	fb_fd = -1;
 }
 
-- 
1.9.0

