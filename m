Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54804 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/16] msi3101: fix stream re-start halt
Date: Wed,  7 Aug 2013 21:51:37 +0300
Message-Id: <1375901507-26661-7-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Restarting stream fails quite often. Small delay is between urb killing
and stream stop command - likely to give harware some time to process
killed urbs.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index c73f1d9..2180bf8 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -959,7 +959,7 @@ static int msi3101_ctrl_msg(struct msi3101_state *s, u8 cmd, u32 data)
 	msi3101_dbg_usb_control_msg(s->udev,
 			request, requesttype, value, index, NULL, 0);
 
-	ret = usb_control_msg(s->udev, usb_rcvctrlpipe(s->udev, 0),
+	ret = usb_control_msg(s->udev, usb_sndctrlpipe(s->udev, 0),
 			request, requesttype, value, index, NULL, 0, 2000);
 
 	if (ret)
@@ -1300,12 +1300,15 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
 	if (mutex_lock_interruptible(&s->v4l2_lock))
 		return -ERESTARTSYS;
 
-	msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0);
-
 	if (s->udev)
 		msi3101_isoc_cleanup(s);
 
 	msi3101_cleanup_queued_bufs(s);
+
+	/* according to tests, at least 700us delay is required  */
+	msleep(20);
+	msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0);
+
 	mutex_unlock(&s->v4l2_lock);
 
 	return 0;
-- 
1.7.11.7

