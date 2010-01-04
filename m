Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o04Jbh0L010761
	for <video4linux-list@redhat.com>; Mon, 4 Jan 2010 14:37:44 -0500
Received: from swip.net (mailfe16.swipnet.se [212.247.155.225])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o04JbQXi019238
	for <video4linux-list@redhat.com>; Mon, 4 Jan 2010 14:37:27 -0500
Received: from [188.126.201.140] (account mc467741@c2i.net HELO
	laptop002.hselasky.homeunix.org)
	by mailfe16.swip.net (CommuniGate Pro SMTP 5.2.16)
	with ESMTPA id 591670537 for video4linux-list@redhat.com;
	Mon, 04 Jan 2010 20:37:25 +0100
To: video4linux-list@redhat.com
Subject: [patch] UVC driver on FreeBSD 8/9
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 4 Jan 2010 20:36:03 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_jMkQLj4DSWCd35g"
Message-Id: <201001042036.03703.hselasky@c2i.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--Boundary-00=_jMkQLj4DSWCd35g
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi,

The attached patch fixes a segfault on AMD64, because the USB pipe type is of 
kind "void *" on FreeBSD, whilst on Linux it is an integer. Using long type 
instead of int type allows the code to work on both systems.

Please verify and commit the attached patches!

--HPS

--Boundary-00=_jMkQLj4DSWCd35g
Content-Type: text/x-patch;
  charset="utf-8";
  name="uvc_status.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="uvc_status.c.diff"

--- uvc_status.c.orig	2010-01-03 21:21:21.000000000 +0100
+++ uvc_status.c	2010-01-03 21:22:04.000000000 +0100
@@ -174,7 +174,7 @@ static void uvc_status_complete(struct u
 int uvc_status_init(struct uvc_device *dev)
 {
 	struct usb_host_endpoint *ep = dev->int_ep;
-	unsigned int pipe;
+	unsigned long pipe;
 	int interval;
 
 	if (ep == NULL)

--Boundary-00=_jMkQLj4DSWCd35g
Content-Type: text/x-patch;
  charset="utf-8";
  name="uvc_video.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="uvc_video.c.diff"

--- uvc_video.c.orig	2010-01-03 21:21:35.000000000 +0100
+++ uvc_video.c	2010-01-03 21:22:48.000000000 +0100
@@ -34,7 +34,7 @@ static int __uvc_query_ctrl(struct uvc_d
 			int timeout)
 {
 	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
-	unsigned int pipe;
+	unsigned long pipe;
 
 	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
 			      : usb_sndctrlpipe(dev->udev, 0);
@@ -887,7 +887,8 @@ static int uvc_init_video_bulk(struct uv
 	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
-	unsigned int npackets, pipe, i;
+	unsigned int npackets, i;
+	unsigned long pipe;
 	u16 psize;
 	u32 size;
 

--Boundary-00=_jMkQLj4DSWCd35g
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_jMkQLj4DSWCd35g--
