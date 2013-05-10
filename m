Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44193 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3EJVzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 17:55:33 -0400
Received: by mail-ee0-f41.google.com with SMTP id d4so1438680eek.0
        for <linux-media@vger.kernel.org>; Fri, 10 May 2013 14:55:32 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: fix uvcvideo compilation for kernels 2.6.33 and 2.6.34
Date: Fri, 10 May 2013 23:55:00 +0200
Message-Id: <1368222900-8591-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch v2.6.32_usb_ss_ep_comp.patch is needed also by kernels 2.6.33 and 2.6.34.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/backports.txt                |  2 +-
 backports/v2.6.32_usb_ss_ep_comp.patch | 11 -----------
 backports/v2.6.34_usb_ss_ep_comp.patch | 11 +++++++++++
 3 files changed, 12 insertions(+), 12 deletions(-)
 delete mode 100644 backports/v2.6.32_usb_ss_ep_comp.patch
 create mode 100644 backports/v2.6.34_usb_ss_ep_comp.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index f21cd53..4aaa4d4 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -56,6 +56,7 @@ add v2.6.35_kfifo.patch
 [2.6.34]
 add v2.6.34_dvb_net.patch
 add v2.6.34_fix_define_warnings.patch
+add v2.6.34_usb_ss_ep_comp.patch
 
 [2.6.33]
 add v2.6.33_input_handlers_are_int.patch
@@ -65,7 +66,6 @@ add v2.6.33_no_gpio_request_one.patch
 [2.6.32]
 add v2.6.32_kfifo.patch
 add v2.6.32_request_firmware_nowait.patch
-add v2.6.32_usb_ss_ep_comp.patch
 
 [2.6.31]
 add v2.6.31_nodename.patch
diff --git a/backports/v2.6.32_usb_ss_ep_comp.patch b/backports/v2.6.32_usb_ss_ep_comp.patch
deleted file mode 100644
index d3624f3..0000000
--- a/backports/v2.6.32_usb_ss_ep_comp.patch
+++ /dev/null
@@ -1,11 +0,0 @@
---- linux.orig/drivers/media/usb/uvc/uvc_video.c	2012-11-14 14:33:51.995088200 -0500
-+++ linux/drivers/media/usb/uvc/uvc_video.c	2012-11-14 14:36:23.510088227 -0500
-@@ -1447,7 +1447,7 @@
- 
- 	switch (dev->speed) {
- 	case USB_SPEED_SUPER:
--		return ep->ss_ep_comp.wBytesPerInterval;
-+		return ep->ss_ep_comp->desc.wBytesPerInterval;
- 	case USB_SPEED_HIGH:
- 		psize = usb_endpoint_maxp(&ep->desc);
- 		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
diff --git a/backports/v2.6.34_usb_ss_ep_comp.patch b/backports/v2.6.34_usb_ss_ep_comp.patch
new file mode 100644
index 0000000..d3624f3
--- /dev/null
+++ b/backports/v2.6.34_usb_ss_ep_comp.patch
@@ -0,0 +1,11 @@
+--- linux.orig/drivers/media/usb/uvc/uvc_video.c	2012-11-14 14:33:51.995088200 -0500
++++ linux/drivers/media/usb/uvc/uvc_video.c	2012-11-14 14:36:23.510088227 -0500
+@@ -1447,7 +1447,7 @@
+ 
+ 	switch (dev->speed) {
+ 	case USB_SPEED_SUPER:
+-		return ep->ss_ep_comp.wBytesPerInterval;
++		return ep->ss_ep_comp->desc.wBytesPerInterval;
+ 	case USB_SPEED_HIGH:
+ 		psize = usb_endpoint_maxp(&ep->desc);
+ 		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
-- 
1.8.2.2

