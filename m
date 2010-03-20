Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2209 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0CTI7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 04:59:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: Phase 1: Proposal to convert V4L1 drivers
Date: Sat, 20 Mar 2010 09:58:49 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003200958.49649.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Well, I certainly fired everyone up with my RFC. Based on the replies I got I
do think the time is right to start the removal process.

Phase 1 would be to convert the remaining V4L1 drivers.

To see what needs to be done I decided to analyse the remaining V4L1 drivers:

- usbvideo (really four drivers: vicam, ibmcam, konicawc, quickcam_messenger)

Hans de Goede added support for the quickcam_messenger to gspca, so that driver
is scheduled for removal. Devin has hardware to test the vicam driver. David
Ellingsworth has hardware to test the ibmcam driver. It would be great if
Devin and David can either send it to Hans de Goede or work on it themselves.

The konicawc is for an Intel YC76 webcam. I found one for sale here:

http://www.ecrater.com/product.php?pid=6593985

Unfortunately the seller does not ship to the Netherlands or to Norway. Can
some kind US developer buy it and donate it to Hans de Goede? It's fairly
expensive at $39.99, but it's for a good cause.

So in theory all these drivers can be tested and converted.

- bw-qcam

A parallel port Connectix QuickCam webcam. To my knowledge no one has hardware
to test this. However, it should not be hard to convert this to V4L2, even
without having hardware since this driver doesn't do any streaming or DMA.

- c-qcam

A parallel port color Connectix QuickCam webcam. To my knowledge no one has
hardware to test this. However, it should not be hard to convert this to V4L2,
even without having hardware since this driver doesn't do any streaming or DMA.

- w9966

A parallel port LifeView FlyCam Supra webcam. To my knowledge no one has
hardware to test this. However, it should not be hard to convert this to V4L2,
even without having hardware since this driver doesn't do any streaming or DMA.

- cpia_pp

Parallel port webcam driver for the Creative Webcam II. I found one on eBay,
so with luck I can get hold of the hardware and get it to HdG.

- cpia_usb

USB variant of cpia_pp. Deprecated since it is now supported by gspca.

- stradis

Supports the Stradis SDM-275 4:2:2 MPEG-2 video decoder. I just found one on
eBay and bought it. This being an MPEG decoder I think that I will try to
convert this to V4L2. It does not look like that will be very difficult.

- arv

Driver for the the Renesas AR module on the M32700UT platform. Looking at
this driver it seems that it should be very easy to convert this to v4l2.
It's very basic and has no DMA or streaming support. We can try contacting
the author to see whether he can test a converted driver. Or perhaps try
and find the maintainer for this platform.

- ov511
- ovcamchip
- w9968cf
- stv680

Deprecated. Are now supported by gspca.

- se401

Hans de Goede has hardware. The current V4L1 driver does not work.

Kconfig mistakes:

I found four errors in drivers/media/video/Kconfig: the saa7191, meye, mxb
and cpia2 drivers are all marked as V4L1 only, while all support V4L2!
The cpia2 driver supports both v4l1 and v4l2. I can test this driver and
will look at removing the V4L1 support from that driver.

Conclusion:

These drivers have no hardware to test with: bw-qcam, c-qcam, arv, w9966.
However, all four should be easy to convert to v4l2, even without hardware.
Volunteers?

Hardware is available for these drivers: se401, ibmcam, vicam. If Devin and
David can either donate the hardware to HdG or do the work themselves, then
these drivers can all be moved to gspca.

Hardware is ordered for the stradis driver. I'll do that one.

The V4L1 support should be removed from the cpia2 driver, leaving just the
V4L2 API. I can do that.

It is very likely that I can get hold of a cpia_pp device. I'll make sure
that HdG gets it.

That leaves the konicawc. We need a friendly US citizen who is willing to
buy one and donate it to HdG.

So if we all pitch in, then can get everything converted without having to
remove drivers.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
