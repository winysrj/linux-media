Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7MKPZRP008811
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 16:25:36 -0400
Received: from mailrelay008.isp.belgacom.be (mailrelay008.isp.belgacom.be
	[195.238.6.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7MKPGv0018450
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 16:25:16 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 22 Aug 2008 22:25:10 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808222225.11056.laurent.pinchart@skynet.be>
Cc: USB list <linux-usb@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: Implement the USB power management reset_resume
	method.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

When a suspended device has been reset instead of being resumed, USB core
calls the reset_resume method if available instead of unbinding and rebinding
the device.

This patch implements reset_resume by reusing the current resume
implementation and simplifies the resume method by skipping the controls
restore stage. Resuming from autosuspend should be faster.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_driver.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 7e10203..4a2d099 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1663,7 +1663,7 @@ static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
 	return uvc_video_suspend(&dev->video);
 }
 
-static int uvc_resume(struct usb_interface *intf)
+static int __uvc_resume(struct usb_interface *intf, int reset)
 {
 	struct uvc_device *dev = usb_get_intfdata(intf);
 	int ret;
@@ -1672,7 +1672,7 @@ static int uvc_resume(struct usb_interface *intf)
 		intf->cur_altsetting->desc.bInterfaceNumber);
 
 	if (intf->cur_altsetting->desc.bInterfaceSubClass == SC_VIDEOCONTROL) {
-		if ((ret = uvc_ctrl_resume_device(dev)) < 0)
+		if (reset && (ret = uvc_ctrl_resume_device(dev)) < 0)
 			return ret;
 
 		return uvc_status_resume(dev);
@@ -1687,6 +1687,16 @@ static int uvc_resume(struct usb_interface *intf)
 	return uvc_video_resume(&dev->video);
 }
 
+static int uvc_resume(struct usb_interface *intf)
+{
+	return __uvc_resume(intf, 0);
+}
+
+static int uvc_reset_resume(struct usb_interface *intf)
+{
+	return __uvc_resume(intf, 1);
+}
+
 /* ------------------------------------------------------------------------
  * Driver initialization and cleanup
  */
@@ -1952,6 +1962,7 @@ struct uvc_driver uvc_driver = {
 		.disconnect	= uvc_disconnect,
 		.suspend	= uvc_suspend,
 		.resume		= uvc_resume,
+		.reset_resume	= uvc_reset_resume,
 		.id_table	= uvc_ids,
 		.supports_autosuspend = 1,
 	},
-- 
1.5.6.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
