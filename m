Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67N5Dae016631
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 19:05:13 -0400
Received: from mailrelay010.isp.belgacom.be (mailrelay010.isp.belgacom.be
	[195.238.6.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67N4UCZ016249
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 19:04:31 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 8 Jul 2008 01:04:29 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807080104.30092.laurent.pinchart@skynet.be>
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: Make input device support optional
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

UVC devices can report button events. The uvcvideo driver depends on
CONFIG_INPUT to report events to the input layer. This patch removes the hard
dependency by introducing a new CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV option.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/Kconfig          |    8 +-------
 drivers/media/video/uvc/Kconfig      |   17 +++++++++++++++++
 drivers/media/video/uvc/uvc_status.c |   17 +++++++++++++++--
 3 files changed, 33 insertions(+), 9 deletions(-)
 create mode 100644 drivers/media/video/uvc/Kconfig

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 5ccb0ae..e00717d 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -793,13 +793,7 @@ menuconfig V4L_USB_DRIVERS
 
 if V4L_USB_DRIVERS && USB
 
-config USB_VIDEO_CLASS
-	tristate "USB Video Class (UVC)"
-	---help---
-	  Support for the USB Video Class (UVC).  Currently only video
-	  input devices, such as webcams, are supported.
-
-	  For more information see: <http://linux-uvc.berlios.de/>
+source "drivers/media/video/uvc/Kconfig"
 
 source "drivers/media/video/pvrusb2/Kconfig"
 
diff --git a/drivers/media/video/uvc/Kconfig b/drivers/media/video/uvc/Kconfig
new file mode 100644
index 0000000..c2d9760
--- /dev/null
+++ b/drivers/media/video/uvc/Kconfig
@@ -0,0 +1,17 @@
+config USB_VIDEO_CLASS
+	tristate "USB Video Class (UVC)"
+	---help---
+	  Support for the USB Video Class (UVC).  Currently only video
+	  input devices, such as webcams, are supported.
+
+	  For more information see: <http://linux-uvc.berlios.de/>
+
+config USB_VIDEO_CLASS_INPUT_EVDEV
+	bool "UVC input events device support"
+	default y
+	depends on USB_VIDEO_CLASS && INPUT
+	---help---
+	  This option makes USB Video Class devices register an input device
+	  to report button events.
+
+	  If you are in doubt, say Y.
diff --git a/drivers/media/video/uvc/uvc_status.c b/drivers/media/video/uvc/uvc_status.c
index 06b4798..eb2f970 100644
--- a/drivers/media/video/uvc/uvc_status.c
+++ b/drivers/media/video/uvc/uvc_status.c
@@ -22,6 +22,7 @@
 /* --------------------------------------------------------------------------
  * Input device
  */
+#ifdef CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV
 static int uvc_input_init(struct uvc_device *dev)
 {
 	struct usb_device *udev = dev->udev;
@@ -67,6 +68,19 @@ static void uvc_input_cleanup(struct uvc_device *dev)
 		input_unregister_device(dev->input);
 }
 
+static void uvc_input_report_key(struct uvc_device *dev, unsigned int code,
+	int value)
+{
+	if (dev->input)
+		input_report_key(dev->input, code, value);
+}
+
+#else
+#define uvc_input_init(dev)
+#define uvc_input_cleanup(dev)
+#define uvc_input_report_key(dev, code, value)
+#endif /* CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV */
+
 /* --------------------------------------------------------------------------
  * Status interrupt endpoint
  */
@@ -83,8 +97,7 @@ static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
 			return;
 		uvc_trace(UVC_TRACE_STATUS, "Button (intf %u) %s len %d\n",
 			data[1], data[3] ? "pressed" : "released", len);
-		if (dev->input)
-			input_report_key(dev->input, BTN_0, data[3]);
+		uvc_input_report_key(dev, BTN_0, data[3]);
 	} else {
 		uvc_trace(UVC_TRACE_STATUS, "Stream %u error event %02x %02x "
 			"len %d.\n", data[1], data[2], data[3], len);
-- 
1.5.4.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
