Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABGr320029640
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 11:53:03 -0500
Received: from mailrelay009.isp.belgacom.be (mailrelay009.isp.belgacom.be
	[195.238.6.176])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABGqpoN032688
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 11:52:51 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 11 Nov 2008 17:53:03 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111753.03430.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFC] Add usb_endpoint_*,
	list_first_entry and uninitialized_var to compat.h
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

Hi everybody,

This patch adds support for the usb_endpoint_* functions as well as 
list_first_entry and uninitialized_var macros to compat.h. The uvcvideo 
driver requires it to compile on kernels older than 2.6.22.

As the usb_endpoint_* functions needs struct usb_endpoint_descriptor, they are 
only defined if linux/usb.h has been included before compat.h. This avoids 
including linux/usb.h unconditionally. I've tested the patch by compiling the 
v4l-dvb tree on 2.6.16 and 2.6.27 and didn't get any warning or error.

If nobody objects I'll include the changes in my tree with the related 
uvcvideo changes and send a pull request.

Cheers,

Laurent Pinchart

diff -r 54319724a6d1 v4l/compat.h
--- a/v4l/compat.h	Sat Nov 08 23:14:50 2008 +0100
+++ b/v4l/compat.h	Tue Nov 11 17:48:53 2008 +0100
@@ -258,4 +258,69 @@
 #define PCI_DEVICE_ID_MARVELL_88ALP01_CCIC     0x4102
 #endif
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
+#ifdef __LINUX_USB_H
+/*
+ * usb_endpoint_* functions
+ *
+ * Included in Linux 2.6.19
+ * Backported to 2.6.18 in Red Hat Enterprise Linux 5.2
+ */
+
+#ifdef RHEL_RELEASE_CODE
+#if RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(5, 2)
+#define RHEL_HAS_USB_ENDPOINT
 #endif
+#endif
+
+#ifndef RHEL_HAS_USB_ENDPOINT
+static inline int
+usb_endpoint_dir_in(const struct usb_endpoint_descriptor *epd)
+{
+	return (epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN;
+}
+
+static inline int
+usb_endpoint_xfer_int(const struct usb_endpoint_descriptor *epd)
+{
+	return (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
+		USB_ENDPOINT_XFER_INT;
+}
+
+static inline int
+usb_endpoint_xfer_isoc(const struct usb_endpoint_descriptor *epd)
+{
+	return (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
+		USB_ENDPOINT_XFER_ISOC;
+}
+
+static inline int
+usb_endpoint_xfer_bulk(const struct usb_endpoint_descriptor *epd)
+{
+	return (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
+		USB_ENDPOINT_XFER_BULK;
+}
+
+static inline int
+usb_endpoint_is_int_in(const struct usb_endpoint_descriptor *epd)
+{
+	return usb_endpoint_xfer_int(epd) && usb_endpoint_dir_in(epd);
+}
+#endif /* RHEL_HAS_USB_ENDPOINT */
+#endif /* __LINUX_USB_H */
+#endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22)
+/*
+ * Linked list API
+ */
+#define list_first_entry(ptr, type, member) \
+	list_entry((ptr)->next, type, member)
+
+/*
+ * uninitialized_var() macro
+ */
+#define uninitialized_var(x) x
+#endif
+
+#endif

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
