Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUAwq2e018261
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 05:58:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUAwYk1013346
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 05:58:34 -0500
Date: Tue, 30 Dec 2008 08:58:19 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Julia Lawall <julia@diku.dk>
Message-ID: <20081230085819.7fb1ebc3@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0812292248410.2265@ask.diku.dk>
References: <Pine.LNX.4.64.0812292248410.2265@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, gregkh@suse.de,
	kernel-janitors@vger.kernel.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/13, revised] drivers/media/video: use USB API
 functions rather than constants
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

On Mon, 29 Dec 2008 22:49:22 +0100 (CET)
Julia Lawall <julia@diku.dk> wrote:

> As compared to the previous version, this one takes advantage of
> usb_endpoint_is_isoc_in.
> 
> 
> From: Julia Lawall <julia@diku.dk>
> 
> This set of patches introduces calls to the following set of functions:

Applied, thanks.

I needed to do a manual conflict fix (applied patch enclosed), since the USB
code on em28xx were moved from em28xx-video.c into em28xx-cards.c on a patch
that I've applied before your patch.

Cheers,
Mauro

From: Julia Lawall  <julia@diku.dk>
use USB API functions rather than constants


This set of patches introduces calls to the following set of functions:

usb_endpoint_dir_in(epd)
usb_endpoint_dir_out(epd)
usb_endpoint_is_bulk_in(epd)
usb_endpoint_is_bulk_out(epd)
usb_endpoint_is_int_in(epd)
usb_endpoint_is_int_out(epd)
usb_endpoint_is_isoc_in(epd)
usb_endpoint_is_isoc_out(epd)
usb_endpoint_num(epd)
usb_endpoint_type(epd)
usb_endpoint_xfer_bulk(epd)
usb_endpoint_xfer_control(epd)
usb_endpoint_xfer_int(epd)
usb_endpoint_xfer_isoc(epd)

In some cases, introducing one of these functions is not possible, and it
just replaces an explicit integer value by one of the following constants:

USB_ENDPOINT_XFER_BULK
USB_ENDPOINT_XFER_CONTROL
USB_ENDPOINT_XFER_INT
USB_ENDPOINT_XFER_ISOC

An extract of the semantic patch that makes these changes is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r1@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
- \(USB_ENDPOINT_XFER_CONTROL\|0\))
+ usb_endpoint_xfer_control(epd)

@r5@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
-  \(USB_DIR_IN\|0x80\))
+ usb_endpoint_dir_in(epd)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


---

 linux/drivers/media/video/em28xx/em28xx-cards.c         |    8 ++++----
 linux/drivers/media/video/stk-webcam.c                  |    7 ++-----
 linux/drivers/media/video/usbvideo/ibmcam.c             |    4 ++--
 linux/drivers/media/video/usbvideo/konicawc.c           |    4 ++--
 linux/drivers/media/video/usbvideo/quickcam_messenger.c |    7 ++-----
 linux/drivers/media/video/usbvideo/ultracam.c           |    4 ++--
 linux/drivers/media/video/usbvideo/vicam.c              |    3 +--
 linux/drivers/media/video/usbvision/usbvision-video.c   |    5 ++---
 8 files changed, 17 insertions(+), 25 deletions(-)

diff -r 567e6e49f817 -r 333f701e1ae8 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Fri Dec 12 02:01:14 2008 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Tue Dec 30 00:49:22 2008 +0000
@@ -2064,8 +2064,8 @@ static int em28xx_usb_probe(struct usb_i
 	endpoint = &interface->cur_altsetting->endpoint[0].desc;
 
 	/* check if the device has the iso in endpoint at the correct place */
-	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
-	    USB_ENDPOINT_XFER_ISOC &&
+	if (usb_endpoint_xfer_isoc(endpoint)
+	    &&
 	    (interface->altsetting[1].endpoint[0].desc.wMaxPacketSize == 940)) {
 		/* It's a newer em2874/em2875 device */
 		isoc_pipe = 0;
@@ -2073,11 +2073,11 @@ static int em28xx_usb_probe(struct usb_i
 		int check_interface = 1;
 		isoc_pipe = 1;
 		endpoint = &interface->cur_altsetting->endpoint[1].desc;
-		if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) !=
+		if (usb_endpoint_type(endpoint) !=
 		    USB_ENDPOINT_XFER_ISOC)
 			check_interface = 0;
 
-		if ((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT)
+		if (usb_endpoint_dir_out(endpoint))
 			check_interface = 0;
 
 		if (!check_interface) {
diff -r 567e6e49f817 -r 333f701e1ae8 linux/drivers/media/video/stk-webcam.c
--- a/linux/drivers/media/video/stk-webcam.c	Fri Dec 12 02:01:14 2008 +0000
+++ b/linux/drivers/media/video/stk-webcam.c	Tue Dec 30 00:49:22 2008 +0000
@@ -1397,12 +1397,9 @@ static int stk_camera_probe(struct usb_i
 		endpoint = &iface_desc->endpoint[i].desc;
 
 		if (!dev->isoc_ep
-			&& ((endpoint->bEndpointAddress
-				& USB_ENDPOINT_DIR_MASK) == USB_DIR_IN)
-			&& ((endpoint->bmAttributes
-				& USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_ISOC)) {
+			&& usb_endpoint_is_isoc_in(endpoint)) {
 			/* we found an isoc in endpoint */
-			dev->isoc_ep = (endpoint->bEndpointAddress & 0xF);
+			dev->isoc_ep = usb_endpoint_num(endpoint);
 			break;
 		}
 	}
diff -r 567e6e49f817 -r 333f701e1ae8 linux/drivers/media/video/usbvideo/ibmcam.c
--- a/linux/drivers/media/video/usbvideo/ibmcam.c	Fri Dec 12 02:01:14 2008 +0000
+++ b/linux/drivers/media/video/usbvideo/ibmcam.c	Tue Dec 30 00:49:22 2008 +0000
@@ -3779,11 +3779,11 @@ static int ibmcam_probe(struct usb_inter
 			err("Alternate settings have different endpoint addresses!");
 			return -ENODEV;
 		}
-		if ((endpoint->bmAttributes & 0x03) != 0x01) {
+		if (usb_endpoint_type(endpoint) != USB_ENDPOINT_XFER_ISOC) {
 			err("Interface %d. has non-ISO endpoint!", ifnum);
 			return -ENODEV;
 		}
-		if ((endpoint->bEndpointAddress & 0x80) == 0) {
+		if (usb_endpoint_dir_out(endpoint)) {
 			err("Interface %d. has ISO OUT endpoint!", ifnum);
 			return -ENODEV;
 		}
diff -r 567e6e49f817 -r 333f701e1ae8 linux/drivers/media/video/usbvideo/konicawc.c
--- a/linux/drivers/media/video/usbvideo/konicawc.c	Fri Dec 12 02:01:14 2008 +0000
+++ b/linux/drivers/media/video/usbvideo/konicawc.c	Tue Dec 30 00:49:22 2008 +0000
@@ -836,12 +836,12 @@ static int konicawc_probe(struct usb_int
 			err("Alternate settings have different endpoint addresses!");
 			return -ENODEV;
 		}
-		if ((endpoint->bmAttributes & 0x03) != 0x01) {
+		if (usb_endpoint_type(endpoint) != USB_ENDPOINT_XFER_ISOC) {
 			err("Interface %d. has non-ISO endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
 		}
-		if ((endpoint->bEndpointAddress & 0x80) == 0) {
+		if (usb_endpoint_dir_out(endpoint)) {
 			err("Interface %d. has ISO OUT endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
diff -r 567e6e49f817 -r 333f701e1ae8 linux/drivers/media/video/usbvideo/quickcam_messenger.c
--- a/linux/drivers/media/video/usbvideo/quickcam_messenger.c	Fri Dec 12 02:01:14 2008 +0000
+++ b/linux/drivers/media/video/usbvideo/quickcam_messenger.c	Tue Dec 30 00:49:22 2008 +0000
@@ -972,8 +972,7 @@ static int qcm_probe(struct usb_interfac
 		for (j=0; j < interface->desc.bNumEndpoints; j++) {
 			endpoint = &interface->endpoint[j].desc;
 
-			if ((endpoint->bEndpointAddress &
-				USB_ENDPOINT_DIR_MASK) != USB_DIR_IN)
+			if (usb_endpoint_dir_out(endpoint))
 				continue; /* not input then not good */
 
 			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
@@ -982,9 +981,7 @@ static int qcm_probe(struct usb_interfac
 				continue; /* 0 pkt size is not what we want */
 			}
 
-			if ((endpoint->bmAttributes &
-				USB_ENDPOINT_XFERTYPE_MASK) ==
-				USB_ENDPOINT_XFER_ISOC) {
+			if (usb_endpoint_xfer_isoc(endpoint)) {
 				video_ep = endpoint->bEndpointAddress;
 				/* break out of the search */
 				goto good_videoep;
diff -r 567e6e49f817 -r 333f701e1ae8 linux/drivers/media/video/usbvideo/ultracam.c
--- a/linux/drivers/media/video/usbvideo/ultracam.c	Fri Dec 12 02:01:14 2008 +0000
+++ b/linux/drivers/media/video/usbvideo/ultracam.c	Tue Dec 30 00:49:22 2008 +0000
@@ -556,12 +556,12 @@ static int ultracam_probe(struct usb_int
 			err("Alternate settings have different endpoint addresses!");
 			return -ENODEV;
 		}
-		if ((endpoint->bmAttributes & 0x03) != 0x01) {
+		if (usb_endpoint_type(endpoint) != USB_ENDPOINT_XFER_ISOC) {
 			err("Interface %d. has non-ISO endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
 		}
-		if ((endpoint->bEndpointAddress & 0x80) == 0) {
+		if (usb_endpoint_dir_out(endpoint)) {
 			err("Interface %d. has ISO OUT endpoint!",
 			    interface->desc.bInterfaceNumber);
 			return -ENODEV;
diff -r 567e6e49f817 -r 333f701e1ae8 linux/drivers/media/video/usbvideo/vicam.c
--- a/linux/drivers/media/video/usbvideo/vicam.c	Fri Dec 12 02:01:14 2008 +0000
+++ b/linux/drivers/media/video/usbvideo/vicam.c	Tue Dec 30 00:49:22 2008 +0000
@@ -1154,8 +1154,7 @@ vicam_probe( struct usb_interface *intf,
 	       interface->desc.bInterfaceNumber, (unsigned) (interface->desc.bNumEndpoints));
 	endpoint = &interface->endpoint[0].desc;
 
-	if ((endpoint->bEndpointAddress & 0x80) &&
-	    ((endpoint->bmAttributes & 3) == 0x02)) {
+	if (usb_endpoint_is_bulk_in(endpoint)) {
 		/* we found a bulk in endpoint */
 		bulkEndpoint = endpoint->bEndpointAddress;
 	} else {
diff -r 567e6e49f817 -r 333f701e1ae8 linux/drivers/media/video/usbvision/usbvision-video.c
--- a/linux/drivers/media/video/usbvision/usbvision-video.c	Fri Dec 12 02:01:14 2008 +0000
+++ b/linux/drivers/media/video/usbvision/usbvision-video.c	Tue Dec 30 00:49:22 2008 +0000
@@ -1679,7 +1679,7 @@ static int __devinit usbvision_probe(str
 		interface = &dev->actconfig->interface[ifnum]->altsetting[0];
 	}
 	endpoint = &interface->endpoint[1].desc;
-	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) !=
+	if (usb_endpoint_type(endpoint) !=
 	    USB_ENDPOINT_XFER_ISOC) {
 		err("%s: interface %d. has non-ISO endpoint!",
 		    __func__, ifnum);
@@ -1687,8 +1687,7 @@ static int __devinit usbvision_probe(str
 		    __func__, endpoint->bmAttributes);
 		return -ENODEV;
 	}
-	if ((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK) ==
-	    USB_DIR_OUT) {
+	if (usb_endpoint_dir_out(endpoint)) {
 		err("%s: interface %d. has ISO OUT endpoint!",
 		    __func__, ifnum);
 		return -ENODEV;


---

Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/333f701e1ae886614635132dbf7527fd54dce229

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
