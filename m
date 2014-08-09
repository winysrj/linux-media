Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55018 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaHIJgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 05:36:23 -0400
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/2] em28xx-v4l: give back all active video buffers to the vb2 core properly on streaming stop
Date: Sat,  9 Aug 2014 11:37:20 +0200
Message-Id: <1407577041-3301-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a new video frame is started, the driver takes the next video buffer from
the list of active buffers and moves it to dev->usb_ctl.vid_buf / dev->usb_ctl.vbi_buf
for further processing.

On streaming stop we currently only give back the pending buffers from the list
but not the ones which are currently processed.

This causes the following warning from the vb2 core since kernel 3.15:

...
 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 2284 at drivers/media/v4l2-core/videobuf2-core.c:2115 __vb2_queue_cancel+0xed/0x150 [videobuf2_core]()
 [...]
 Call Trace:
  [<c0769c46>] dump_stack+0x48/0x69
  [<c0245b69>] warn_slowpath_common+0x79/0x90
  [<f925e4ad>] ? __vb2_queue_cancel+0xed/0x150 [videobuf2_core]
  [<f925e4ad>] ? __vb2_queue_cancel+0xed/0x150 [videobuf2_core]
  [<c0245bfd>] warn_slowpath_null+0x1d/0x20
  [<f925e4ad>] __vb2_queue_cancel+0xed/0x150 [videobuf2_core]
  [<f925fa35>] vb2_internal_streamoff+0x35/0x90 [videobuf2_core]
  [<f925fac5>] vb2_streamoff+0x35/0x60 [videobuf2_core]
  [<f925fb27>] vb2_ioctl_streamoff+0x37/0x40 [videobuf2_core]
  [<f8e45895>] v4l_streamoff+0x15/0x20 [videodev]
  [<f8e4925d>] __video_do_ioctl+0x23d/0x2d0 [videodev]
  [<f8e49020>] ? video_ioctl2+0x20/0x20 [videodev]
  [<f8e48c63>] video_usercopy+0x203/0x5a0 [videodev]
  [<f8e49020>] ? video_ioctl2+0x20/0x20 [videodev]
  [<c039d0e7>] ? fsnotify+0x1e7/0x2b0
  [<f8e49012>] video_ioctl2+0x12/0x20 [videodev]
  [<f8e49020>] ? video_ioctl2+0x20/0x20 [videodev]
  [<f8e4461e>] v4l2_ioctl+0xee/0x130 [videodev]
  [<f8e44530>] ? v4l2_open+0xf0/0xf0 [videodev]
  [<c0378de2>] do_vfs_ioctl+0x2e2/0x4d0
  [<c0368eec>] ? vfs_write+0x13c/0x1c0
  [<c0369a8f>] ? vfs_writev+0x2f/0x50
  [<c0379028>] SyS_ioctl+0x58/0x80
  [<c076fff3>] sysenter_do_call+0x12/0x12
 ---[ end trace 5545f934409f13f4 ]---
...

Many thanks to Hans Verkuil, whose recently added check in the vb2 core unveiled
this long standing issue and who has investigated it further.

Cc: <stable@vger.kernel.org>
Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 90dec29..9db219d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -994,13 +994,16 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 	}
 
 	spin_lock_irqsave(&dev->slock, flags);
+	if (dev->usb_ctl.vid_buf != NULL) {
+		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb, VB2_BUF_STATE_ERROR);
+		dev->usb_ctl.vid_buf = NULL;
+	}
 	while (!list_empty(&vidq->active)) {
 		struct em28xx_buffer *buf;
 		buf = list_entry(vidq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
-	dev->usb_ctl.vid_buf = NULL;
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
@@ -1021,13 +1024,16 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 	}
 
 	spin_lock_irqsave(&dev->slock, flags);
+	if (dev->usb_ctl.vbi_buf != NULL) {
+		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb, VB2_BUF_STATE_ERROR);
+		dev->usb_ctl.vbi_buf = NULL;
+	}
 	while (!list_empty(&vbiq->active)) {
 		struct em28xx_buffer *buf;
 		buf = list_entry(vbiq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
-	dev->usb_ctl.vbi_buf = NULL;
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-- 
1.8.4.5

