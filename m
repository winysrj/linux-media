Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53461 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1CXKkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 06:40:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP3 ISP outputs 5555 5555 5555 5555 ...
Date: Thu, 24 Mar 2011 11:40:22 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Jones <michael.jones@matrix-vision.de>
References: <AANLkTimdFVDLLz2o9Fb2OJM2EsJ9R9q-xKAP63g9uSi+@mail.gmail.com> <201103222140.28674.laurent.pinchart@ideasonboard.com> <AANLkTim8C73WGHkKXsC1nQzV3PjjYjTVUr7U3Ud8jaxk@mail.gmail.com>
In-Reply-To: <AANLkTim8C73WGHkKXsC1nQzV3PjjYjTVUr7U3Ud8jaxk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103241140.22986.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Thursday 24 March 2011 10:59:01 Bastian Hecht wrote:
> 2011/3/22 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Tuesday 22 March 2011 17:11:04 Bastian Hecht wrote:
> >> Hello omap isp devs,
> >> 
> >> maybe you can help me, I am a bit desperate with my current cam problem:
> >> 
> >> I use a ov5642 chip and get only 0x55 in my data output when I use a
> >> camclk > 1 MHz. With 1 MHz data rate from the camera chip to the omap
> >> all works (well the colorspace is strange - it's greenish, but that is
> >> not my main concern).
> >> I looked up the data on the oscilloscope and all flanks seem to be
> >> fine at the isp. Very clear cuts with 4 MHz and 10MHz. Also the data
> >> pins are flickering fine. Looks like a picture.
> >> 
> >> I found that the isp stats module uses 0x55 as a magic number but I
> >> don't see why it should confuse my readout.
> >> 
> >> I use 2592x1944 raw bayer output via the ccdc. Next to the logical
> >> right config I tried all possible configurations of vs/hs active high
> >> and low on camera and isp. The isp gets the vs flanks right as the
> >> images come out in time (sometimes it misses 1 frame).
> >> 
> >> Anyone of you had this behaviour before?
> > 
> > How do you capture images ? yavta will fill buffers with 0x55 before
> > queueing them, so this might indicate that no data is written to the
> > buffer at all.
> 
> Yes I use yavta. So what does that all mean?

It means that the ISP doesn't write data to the buffer. I have no idea why.

> As far as I understand things: The isp gets a new frame start. Then it
> counts up the lines as I receive a vd0 interrupt (I added a printk at the
> isr). In between the isp doesn't write/dma-transfer any data. I double-
> checked the pclk-line but I see nice flanks.
> 
> yavta Output with 4MHz:
> Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> Video format set: width: 2592 height: 1944 buffer size: 10077696
> Video format: BA10 (30314142) 2592x1944
> 2 buffers requested.
> length: 10077696 offset: 0
> Buffer 0 mapped at address 0x4016e000.
> length: 10077696 offset: 10080256
> Buffer 1 mapped at address 0x40b0b000.
> [  528.454376] pad_op 4, framix addr: dea0a800
> [  528.462341] s_stream is it! enable: 1
> [  530.026184] last line of image received
> 0 (0) [-] 0 10077696 bytes 530.213853 1300960526.930187 -0.001 fps
> [  531.558898] last line of image received
> 1 (1) [-] 1 10077696 bytes 531.746555 1300960528.462828 0.652 fps
> [  533.091613] last line of image received
> [  533.098571] s_stream is it! enable: 0
> Captured 2 frames in 3.075627 seconds (0.650274 fps, 6553262.798122 B/s).

-- 
Regards,

Laurent Pinchart
