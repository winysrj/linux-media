Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab0IPSA1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 14:00:27 -0400
From: Matthew Garrett <mjg@redhat.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] uvc: Enable USB autosuspend by default on uvcvideo
Date: Thu, 16 Sep 2010 14:00:04 -0400
Message-Id: <1284660004-28158-1-git-send-email-mjg@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We've been doing this for a while in Fedora without any complaints.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/media/video/uvc/uvc_driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 8bdd940..28ed5b4 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1814,6 +1814,7 @@ static int uvc_probe(struct usb_interface *intf,
 	}
 
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
+	usb_enable_autosuspend(udev);
 	return 0;
 
 error:
-- 
1.7.2.3

