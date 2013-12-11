Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48029 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab3LKUfL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 15:35:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VqqUv-0000DI-Tj
	for linux-media@vger.kernel.org; Wed, 11 Dec 2013 21:35:09 +0100
Received: from p54bd0ac1.dip0.t-ipconnect.de ([84.189.10.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 11 Dec 2013 21:35:09 +0100
Received: from linux by p54bd0ac1.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 11 Dec 2013 21:35:09 +0100
To: linux-media@vger.kernel.org
From: Martin Kittel <linux@martin-kittel.de>
Subject: Re: Patch mceusb: fix invalid urb interval
Date: Wed, 11 Dec 2013 21:34:55 +0100
Message-ID: <l8ai94$cbr$1@ger.gmane.org>
References: <loom.20131110T113621-661@post.gmane.org> <20131211131751.GA434@pequod.mess.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <20131211131751.GA434@pequod.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, hi Sean,

thanks for considering the patch. I have added an updated version at the
end of this mail.

Regarding the info Sean was requesting, it is indeed an xhci hub. I also
added the details of the remote itself.

Please let me know if there is anything missing.

Best wishes,

Martin.


lsusb -vvv
------
Bus 001 Device 002: ID 2304:0225 Pinnacle Systems, Inc. Remote Kit
Infrared Transceiver
Device Descriptor:
  bLength		 18
  bDescriptorType	  1
  bcdUSB	       2.00
  bDeviceClass		  0 (Defined at Interface level)
  bDeviceSubClass	  0
  bDeviceProtocol	  0
  bMaxPacketSize0	  8
  idVendor	     0x2304 Pinnacle Systems, Inc.
  idProduct	     0x0225 Remote Kit Infrared Transceiver
  bcdDevice	       0.01
  iManufacturer		  1 Pinnacle Systems
  iProduct		  2 PCTV Remote USB
  iSerial		  5 7FFFFFFFFFFFFFFF
  bNumConfigurations	  1
  Configuration Descriptor:
    bLength		    9
    bDescriptorType	    2
    wTotalLength	   32
    bNumInterfaces	    1
    bConfigurationValue	    1
    iConfiguration	    3 StandardConfiguration
    bmAttributes	 0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower		  100mA
    Interface Descriptor:
      bLength		      9
      bDescriptorType	      4
      bInterfaceNumber	      0
      bAlternateSetting	      0
      bNumEndpoints	      2
      bInterfaceClass	    255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface	      4 StandardInterface
      Endpoint Descriptor:
	bLength			7
	bDescriptorType		5
	bEndpointAddress     0x81  EP 1 IN
	bmAttributes		2
	  Transfer Type		   Bulk
	  Synch Type		   None
	  Usage Type		   Data
	wMaxPacketSize	   0x0040  1x 64 bytes
	bInterval	       10
      Endpoint Descriptor:
	bLength			7
	bDescriptorType		5
	bEndpointAddress     0x02  EP 2 OUT
	bmAttributes		2
	  Transfer Type		   Bulk
	  Synch Type		   None
	  Usage Type		   Data
	wMaxPacketSize	   0x0040  1x 64 bytes
	bInterval	       10
Device Status:	   0x0000
  (Bus Powered)

-----------

>From 67589c156e4b205821dda67f7e96804224c24cb8 Mon Sep 17 00:00:00 2001
From: Martin Kittel <linux@martin-kittel.de>
Date: Wed, 11 Dec 2013 21:08:49 +0100
Subject: [PATCH] mceusb: fix invalid urb interval

With very fast usb hubs it can happen that urbs are processed
in less than a single 126 microsecond interval. Such an urb has
urb->interval set to 0 on receive and s rejected on resubmit.
Make sure urb->interval is reset to its initial value before
resubmitting it.

Signed-off-by: Martin Kittel <linux@martin-kittel.de>
---
 drivers/media/rc/mceusb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 3c76101..6652f6a 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1030,7 +1030,7 @@ static void mceusb_process_ir_data(struct
mceusb_dev *ir, int buf_len)
 static void mceusb_dev_recv(struct urb *urb)
 {
 	struct mceusb_dev *ir;
-	int buf_len;
+	int buf_len, res;

 	if (!urb)
 		return;
@@ -1067,7 +1067,10 @@ static void mceusb_dev_recv(struct urb *urb)
 		break;
 	}

-	usb_submit_urb(urb, GFP_ATOMIC);
+	urb->interval = ir->usb_ep_out->bInterval; /* reset urb interval */
+	res = usb_submit_urb(urb, GFP_ATOMIC);
+	if (res)
+		mce_dbg(ir->dev, "restart request FAILED! (res=%d)\n", res);
 }

 static void mceusb_get_emulator_version(struct mceusb_dev *ir)
-- 
1.8.4.rc3



