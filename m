Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4385 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaHDKaN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 06:30:13 -0400
Message-ID: <53DF60A7.4080208@xs4all.nl>
Date: Mon, 04 Aug 2014 12:29:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] pwc: fix WARN_ON
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If start_streaming fails, then the buffers must be given back to vb2 with state
QUEUED, not ERROR. Otherwise a WARN_ON will be generated.

In the disconnect it is pointless to call pwc_cleanup_queued_bufs() as stop_streaming()
will be called anyway.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 15b754d..702267e 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -508,7 +508,8 @@ static void pwc_isoc_cleanup(struct pwc_device *pdev)
 }
 
 /* Must be called with vb_queue_lock hold */
-static void pwc_cleanup_queued_bufs(struct pwc_device *pdev)
+static void pwc_cleanup_queued_bufs(struct pwc_device *pdev,
+				    enum vb2_buffer_state state)
 {
 	unsigned long flags = 0;
 
@@ -519,7 +520,7 @@ static void pwc_cleanup_queued_bufs(struct pwc_device *pdev)
 		buf = list_entry(pdev->queued_bufs.next, struct pwc_frame_buf,
 				 list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb, state);
 	}
 	spin_unlock_irqrestore(&pdev->queued_bufs_lock, flags);
 }
@@ -674,7 +675,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 		pwc_set_leds(pdev, 0, 0);
 		pwc_camera_power(pdev, 0);
 		/* And cleanup any queued bufs!! */
-		pwc_cleanup_queued_bufs(pdev);
+		pwc_cleanup_queued_bufs(pdev, VB2_BUF_STATE_QUEUED);
 	}
 	mutex_unlock(&pdev->v4l2_lock);
 
@@ -692,7 +693,9 @@ static void stop_streaming(struct vb2_queue *vq)
 		pwc_isoc_cleanup(pdev);
 	}
 
-	pwc_cleanup_queued_bufs(pdev);
+	pwc_cleanup_queued_bufs(pdev, VB2_BUF_STATE_ERROR);
+	if (pdev->fill_buf)
+		vb2_buffer_done(&pdev->fill_buf->vb, VB2_BUF_STATE_ERROR);
 	mutex_unlock(&pdev->v4l2_lock);
 }
 
@@ -1125,7 +1128,6 @@ static void usb_pwc_disconnect(struct usb_interface *intf)
 	if (pdev->vb_queue.streaming)
 		pwc_isoc_cleanup(pdev);
 	pdev->udev = NULL;
-	pwc_cleanup_queued_bufs(pdev);
 
 	v4l2_device_disconnect(&pdev->v4l2_dev);
 	video_unregister_device(&pdev->vdev);

