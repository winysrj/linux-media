Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:54580 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759324Ab2FAJjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jun 2012 05:39:20 -0400
From: Bhupesh Sharma <bhupesh.sharma@st.com>
To: <laurent.pinchart@ideasonboard.com>, <linux-usb@vger.kernel.org>
Cc: <balbi@ti.com>, <linux-media@vger.kernel.org>,
	<gregkh@linuxfoundation.org>,
	Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH 2/5] usb: gadget/uvc: Use macro for interrupt endpoint status size instead of using a MAGIC number
Date: Fri, 1 Jun 2012 15:08:55 +0530
Message-ID: <6d0fcc5336f6a9cd10188ee5132be682f346f8f9.1338543124.git.bhupesh.sharma@st.com>
In-Reply-To: <cover.1338543124.git.bhupesh.sharma@st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a MACRO for the UVC video control status (interrupt) endpoint and
removes the magic number which was being used earlier.

Some UDCs have issues supporting an interrupt IN endpoint having a max packet
size less than a particular value (say 32). It is easier in that case to simply
change the MACRO value instead of changing the max packet size value at a
number of locations.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
---
 drivers/usb/gadget/f_uvc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
index 054c35a..dd7d7a9 100644
--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -59,6 +59,8 @@ static struct usb_gadget_strings *uvc_function_strings[] = {
 #define UVC_INTF_VIDEO_CONTROL			0
 #define UVC_INTF_VIDEO_STREAMING		1
 
+#define STATUS_BYTECOUNT			16	/* 16 bytes status */
+
 static struct usb_interface_assoc_descriptor uvc_iad __initdata = {
 	.bLength		= sizeof(uvc_iad),
 	.bDescriptorType	= USB_DT_INTERFACE_ASSOCIATION,
@@ -87,7 +89,7 @@ static struct usb_endpoint_descriptor uvc_control_ep __initdata = {
 	.bDescriptorType	= USB_DT_ENDPOINT,
 	.bEndpointAddress	= USB_DIR_IN,
 	.bmAttributes		= USB_ENDPOINT_XFER_INT,
-	.wMaxPacketSize		= cpu_to_le16(16),
+	.wMaxPacketSize		= cpu_to_le16(STATUS_BYTECOUNT),
 	.bInterval		= 8,
 };
 
@@ -95,7 +97,7 @@ static struct uvc_control_endpoint_descriptor uvc_control_cs_ep __initdata = {
 	.bLength		= UVC_DT_CONTROL_ENDPOINT_SIZE,
 	.bDescriptorType	= USB_DT_CS_ENDPOINT,
 	.bDescriptorSubType	= UVC_EP_INTERRUPT,
-	.wMaxTransferSize	= cpu_to_le16(16),
+	.wMaxTransferSize	= cpu_to_le16(STATUS_BYTECOUNT),
 };
 
 static struct usb_interface_descriptor uvc_streaming_intf_alt0 __initdata = {
-- 
1.7.2.2

