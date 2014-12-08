Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:41669 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaLHInH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 03:43:07 -0500
Date: Mon, 8 Dec 2014 09:43:01 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felipe Balbi <balbi@ti.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] usb: hcd: get/put device and hcd for hcd_buffers()
Message-ID: <20141208084301.GA10390@linutronix.de>
References: <20141205200357.GA1586@linutronix.de>
 <Pine.LNX.4.44L0.1412051543510.1032-100000@iolanthe.rowland.org>
 <20141205232327.GB4854@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141205232327.GB4854@linutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Sebastian Andrzej Siewior | 2014-12-06 00:23:27 [+0100]:

>I had one patch doing that. Let me grab it out on Monday.

okay, this is it. Laurent, any idea why this could not fly? I haven't
seen anything odd so far.

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 7c8322d4fc63..d656c7de25ef 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1703,6 +1703,7 @@ static void uvc_unregister_video(struct uvc_device *dev)
 		stream->vdev = NULL;
 
 		uvc_debugfs_cleanup_stream(stream);
+		uvc_video_enable(stream, 0);
 	}
 
 	/* Decrement the stream count and call uvc_delete explicitly if there
@@ -1950,10 +1951,6 @@ static void uvc_disconnect(struct usb_interface *intf)
 	 */
 	usb_set_intfdata(intf, NULL);
 
-	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
-	    UVC_SC_VIDEOSTREAMING)
-		return;
-
 	dev->state |= UVC_DEV_DISCONNECTED;
 
 	uvc_unregister_video(dev);
-- 
2.1.3

