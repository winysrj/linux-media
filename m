Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:12335 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3LJLk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 06:40:58 -0500
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 4/4] remove flooding debugs
Date: Tue, 10 Dec 2013 12:40:37 +0100
Message-id: <1386675637-18243-5-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
References: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those debugs are printed very often killing the efficiency, so they should
be removed from final code.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 uvc-gadget.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/uvc-gadget.c b/uvc-gadget.c
index 8f06a1f..4ff0d80 100644
--- a/uvc-gadget.c
+++ b/uvc-gadget.c
@@ -451,11 +451,8 @@ v4l2_process_data(struct v4l2_device *dev)
 	}
 
 	ret = ioctl(dev->v4l2_fd, VIDIOC_DQBUF, &vbuf);
-	if (ret < 0) {
-		printf("V4L2: Unable to dequeue buffer: %s (%d).\n",
-			strerror(errno), errno);
+	if (ret < 0)
 		return ret;
-	}
 
 	dev->dqbuf_count++;
 
@@ -953,11 +950,8 @@ uvc_video_process(struct uvc_device *dev)
 	if (dev->run_standalone) {
 		/* UVC stanalone setup. */
 		ret = ioctl(dev->uvc_fd, VIDIOC_DQBUF, &ubuf);
-		if (ret < 0) {
-			printf("UVC: Unable to dequeue buffer: %s (%d).\n",
-					strerror(errno), errno);
+		if (ret < 0)
 			return ret;
-		}
 
 		dev->dqbuf_count++;
 
@@ -999,11 +993,8 @@ uvc_video_process(struct uvc_device *dev)
 
 		/* Dequeue the spent buffer from UVC domain */
 		ret = ioctl(dev->uvc_fd, VIDIOC_DQBUF, &ubuf);
-		if (ret < 0) {
-			printf("UVC: Unable to dequeue buffer: %s (%d).\n",
-					strerror(errno), errno);
+		if (ret < 0)
 			return ret;
-		}
 
 		if (dev->io == IO_METHOD_USERPTR)
 			for (i = 0; i < dev->nbufs; ++i)
-- 
1.7.9.5

