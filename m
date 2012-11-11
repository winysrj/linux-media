Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56833 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2KKEt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Nov 2012 23:49:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TXPUh-0001D9-Vy
	for linux-media@vger.kernel.org; Sun, 11 Nov 2012 05:50:04 +0100
Received: from 183.62.57.93 ([183.62.57.93])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 11 Nov 2012 05:50:03 +0100
Received: from yze007 by 183.62.57.93 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 11 Nov 2012 05:50:03 +0100
To: linux-media@vger.kernel.org
From: Michael Yang <yze007@gmail.com>
Subject: The em28xx driver error
Date: Sun, 11 Nov 2012 04:46:40 +0000 (UTC)
Message-ID: <loom.20121111T054512-795@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi I am using a v4l2 usb video capturer (em28xx based) on the TI-DM3730 board
I used the  default driver ,the video can't be captured. I solve this issue by 
change the em28xx driver :

linux-stable/drivers/media/video/em28xx/em28xx-core.c

/* FIXME: this only function read values from dev */
int em28xx_resolution_set(struct em28xx *dev)
{
int width, height;
width = norm_maxw(dev);
height = norm_maxh(dev);

/* Properly setup VBI */
dev->vbi_width = 720;
if (dev->norm & V4L2_STD_525_60)
dev->vbi_height = 12;
else
dev->vbi_height = 18;

if (!dev->progressive)
height >>= norm_maxh(dev) ;//change to" height = norm_maxh(dev) >> 1 ;"

em28xx_set_outfmt(dev);



Then I can capture the video.But  about 3 minutes later, the os throw out 
errors:

Read a frame, the size is:325 
Read a frame, the size is:304 
ehci-omap ehci-omap.0: request c15b1000 would overflow (3898+63 >= 3936)  //the 
video shut up
ehci-omap ehci-omap.0: request c15b0000 would overflow (3906+63 >= 3936) 
ehci-omap ehci-omap.0: request c1558800 would overflow (3915+63 >= 3936) 
ehci-omap ehci-omap.0: request c15b0800 would overflow (3924+63 >= 3936) 
Read a frame, the size is:253 
ehci-omap ehci-omap.0: request c143f800 would overflow (3909+63 >= 3936) 
usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
usb 1-2.2: kworker/0:2 timed out on ep0in len=8/1 
............
usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
usb 1-2.2: kworker/0:2 timed out on ep0in len=8/1 
^Cusb 1-2.2: test_h264 timed out on ep0in len=0/1 
usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
^Cusb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
^Cusb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 

usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 

usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
^C 
usb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
^Cusb 1-2.2: kworker/0:2 timed out on ep0in len=0/1 
usb 1-2.2: test_h264 timed out on ep0out len=8/0 
em28xx #0: cannot change alternate number to 0 (error=-110) 



Then I try TI OMAP-3530 ,after change the em28xx-driver , the image can be 
captured but throw the same error after about 3 minutes
em28xx #0: cannot change alternate number to 0 (error=-110) 


This driver source about this error is
int em28xx_set_alternate(struct em28xx *dev)
{
int errCode, prev_alt = dev->alt;
int i;
unsigned int min_pkt_size = dev->width * 2 + 4;

/*
* alt = 0 is used only for control messages, so, only values
* greater than 0 can be used for streaming.
*/
if (alt && alt < dev->num_alt) {
em28xx_coredbg("alternate forced to %d\n", dev->alt);
dev->alt = alt;
goto set_alt;
}

/* When image size is bigger than a certain value,
the frame size should be increased, otherwise, only
green screen will be received.
*/
if (dev->width * 2 * dev->height > 720 * 240 * 2)
min_pkt_size *= 2;

for (i = 0; i < dev->num_alt; i++) {
/* stop when the selected alt setting offers enough bandwidth */
if (dev->alt_max_pkt_size[i] >= min_pkt_size) {
dev->alt = i;
break;
/* otherwise make sure that we end up with the maximum bandwidth
because the min_pkt_size equation might be wrong...
*/
} else if (dev->alt_max_pkt_size[i] >
dev->alt_max_pkt_size[dev->alt])
dev->alt = i;
}

set_alt:
if (dev->alt != prev_alt) {
em28xx_coredbg("minimum isoc packet size: %u (alt=%d)\n",
min_pkt_size, dev->alt);
dev->max_pkt_size = dev->alt_max_pkt_size[dev->alt];
em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
dev->alt, dev->max_pkt_size);
errCode = usb_set_interface(dev->udev, 0, dev->alt);
if (errCode < 0) {
em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
dev->alt, errCode);
return errCode;
}
}
return 0;
}




How can I solve this problem ? Or is there some other USBDVR can work well on 
the TI DM3730?

