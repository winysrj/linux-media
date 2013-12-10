Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38471 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3LJLk4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 06:40:56 -0500
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 3/4] fix v4l2 stream handling
Date: Tue, 10 Dec 2013 12:40:36 +0100
Message-id: <1386675637-18243-4-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
References: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes v4l2 stream handling. It improves few things:

- Fix dqbuf_count check in v4l2_process_data() function.

- Removes freeing v4l2 device buffers in STREAMOFF event. It's because
  this buffers are requested once at the beginning, and it's not needed
  to free them on STREAMOFF and request again on STREAMON every time.

- Removes v4l2_qbuf() function from main(). It should be rather called from
  uvc_handle_streamon_event().

- Clears first_buffer_queued field of uvc device in STREAMOFF event handler.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 uvc-gadget.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/uvc-gadget.c b/uvc-gadget.c
index c964f37..8f06a1f 100644
--- a/uvc-gadget.c
+++ b/uvc-gadget.c
@@ -432,7 +432,7 @@ v4l2_process_data(struct v4l2_device *dev)
 		return 0;
 
 	if (dev->udev->first_buffer_queued)
-		if ((dev->dqbuf_count + 1) >= dev->qbuf_count)
+		if (dev->dqbuf_count >= dev->qbuf_count)
 			return 0;
 
 	/* Dequeue spent buffer rom V4L2 domain. */
@@ -1351,11 +1351,11 @@ uvc_handle_streamon_event(struct uvc_device *dev)
 			ret = v4l2_reqbufs(dev->vdev, dev->vdev->nbufs);
 			if (ret < 0)
 				goto err;
-
-			ret = v4l2_qbuf(dev->vdev);
-			if (ret < 0)
-				goto err;
 		}
+		ret = v4l2_qbuf(dev->vdev);
+		if (ret < 0)
+			goto err;
+		
 
 		/* Start V4L2 capturing now. */
 		ret = v4l2_start_capturing(dev->vdev);
@@ -2011,8 +2011,6 @@ uvc_events_process(struct uvc_device *dev)
 		if (!dev->run_standalone && dev->vdev->is_streaming) {
 			/* UVC - V4L2 integrated path. */
 			v4l2_stop_capturing(dev->vdev);
-			v4l2_uninit_device(dev->vdev);
-			v4l2_reqbufs(dev->vdev, 0);
 			dev->vdev->is_streaming = 0;
 		}
 
@@ -2022,6 +2020,7 @@ uvc_events_process(struct uvc_device *dev)
 			uvc_uninit_device(dev);
 			uvc_video_reqbufs(dev, 0);
 			dev->is_streaming = 0;
+			dev->first_buffer_queued = 0;
 		}
 
 		return;
@@ -2365,7 +2364,6 @@ main(int argc, char *argv[])
 		 * buffers queued.
 		 */
 		v4l2_reqbufs(vdev, vdev->nbufs);
-		v4l2_qbuf(vdev);
 	}
 
 	if (mjpeg_image)
-- 
1.7.9.5

