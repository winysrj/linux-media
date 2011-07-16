Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49823 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1GPDvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 23:51:22 -0400
Date: Sat, 16 Jul 2011 11:51:00 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Ming Lei <ming.lei@canonical.com>, <linux-usb@vger.kernel.org>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] uvcvideo: add SetInterface(0) in .reset_resume handler
Message-ID: <20110716115100.10f6f764@tom-ThinkPad-T410>
In-Reply-To: <Pine.LNX.4.44L0.1107151122490.1866-100000@iolanthe.rowland.org>
References: <CACVXFVPHfskUCxhznpATknNxokmL5hft-b+KoxWiMzprVmuJ4w@mail.gmail.com>
	<Pine.LNX.4.44L0.1107151122490.1866-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


As commented in uvc_video_init,

	/* Alternate setting 0 should be the default, yet the XBox Live Vision
	 * Cam (and possibly other devices) crash or otherwise misbehave if
	 * they don't receive a SET_INTERFACE request before any other video
	 * control request.
	 */

so it does make sense to add the SetInterface(0) in .reset_resume
handler so that this kind of devices can work well if they are reseted
during resume from system or runtime suspend.

We have found, without the patch, Microdia camera(0c45:6437) can't send
stream data any longer after it is reseted during resume from
system suspend.

Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/video/uvc/uvc_driver.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index b6eae48..41c6d1a 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1959,8 +1959,20 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 	}
 
 	list_for_each_entry(stream, &dev->streams, list) {
-		if (stream->intf == intf)
+		if (stream->intf == intf) {
+			/*
+			 * After usb bus reset, some devices may
+			 * misbehave if SetInterface(0) is not done, for
+			 * example, Microdia camera(0c45:6437) will stop
+			 * sending streaming data. I think XBox Live
+			 * Vision Cam needs it too, as commented in
+			 * uvc_video_init.
+			 */
+			if (reset)
+				usb_set_interface(stream->dev->udev,
+					stream->intfnum, 0);
 			return uvc_video_resume(stream);
+		}
 	}
 
 	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
-- 
1.7.4.1




-- 
Ming Lei
