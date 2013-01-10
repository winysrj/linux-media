Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:44675 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3AJKFA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 05:05:00 -0500
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	tom.leiming@gmail.com, linux-media@vger.kernel.org
Cc: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH] uvc: fix race of open and suspend in error case
Date: Thu, 10 Jan 2013 11:04:55 +0100
Message-Id: <1357812295-21174-1-git-send-email-oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ming Lei reported:
IMO, there is a minor fault in the error handling path of
uvc_status_start() inside uvc_v4l2_open(), and the 'users' count
should have been decreased before usb_autopm_put_interface().
In theory, the warning can be triggered when the device is
opened just between usb_autopm_put_interface() and
atomic_dec(&stream->dev->users).
The fix is trivial.

Signed-off-by:Oliver Neukum <oneukum@suse.de>
---
 drivers/media/usb/uvc/uvc_v4l2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index f2ee8c6..74937b7 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -501,8 +501,8 @@ static int uvc_v4l2_open(struct file *file)
 	if (atomic_inc_return(&stream->dev->users) == 1) {
 		ret = uvc_status_start(stream->dev);
 		if (ret < 0) {
-			usb_autopm_put_interface(stream->dev->intf);
 			atomic_dec(&stream->dev->users);
+			usb_autopm_put_interface(stream->dev->intf);
 			kfree(handle);
 			return ret;
 		}
-- 
1.7.10.4

