Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36943 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab1CXJ7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 05:59:02 -0400
Received: by iyb26 with SMTP id 26so9487303iyb.19
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2011 02:59:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103222140.28674.laurent.pinchart@ideasonboard.com>
References: <AANLkTimdFVDLLz2o9Fb2OJM2EsJ9R9q-xKAP63g9uSi+@mail.gmail.com>
	<201103222140.28674.laurent.pinchart@ideasonboard.com>
Date: Thu, 24 Mar 2011 10:59:01 +0100
Message-ID: <AANLkTim8C73WGHkKXsC1nQzV3PjjYjTVUr7U3Ud8jaxk@mail.gmail.com>
Subject: Re: OMAP3 ISP outputs 5555 5555 5555 5555 ...
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Jones <michael.jones@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/3/22 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Bastian,
>
> On Tuesday 22 March 2011 17:11:04 Bastian Hecht wrote:
>> Hello omap isp devs,
>>
>> maybe you can help me, I am a bit desperate with my current cam problem:
>>
>> I use a ov5642 chip and get only 0x55 in my data output when I use a
>> camclk > 1 MHz. With 1 MHz data rate from the camera chip to the omap
>> all works (well the colorspace is strange - it's greenish, but that is
>> not my main concern).
>> I looked up the data on the oscilloscope and all flanks seem to be
>> fine at the isp. Very clear cuts with 4 MHz and 10MHz. Also the data
>> pins are flickering fine. Looks like a picture.
>>
>> I found that the isp stats module uses 0x55 as a magic number but I
>> don't see why it should confuse my readout.
>>
>> I use 2592x1944 raw bayer output via the ccdc. Next to the logical
>> right config I tried all possible configurations of vs/hs active high
>> and low on camera and isp. The isp gets the vs flanks right as the
>> images come out in time (sometimes it misses 1 frame).
>>
>> Anyone of you had this behaviour before?
>
> How do you capture images ? yavta will fill buffers with 0x55 before queueing
> them, so this might indicate that no data is written to the buffer at all.

Yes I use yavta. So what does that all mean? As far as I understand things:
The isp gets a new frame start. Then it counts up the lines as I
receive a vd0 interrupt (I added a printk at the isr).
In between the isp doesn't write/dma-transfer any data. I
double-checked the pclk-line but I see nice flanks.

yavta Output with 4MHz:
Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
Video format set: width: 2592 height: 1944 buffer size: 10077696
Video format: BA10 (30314142) 2592x1944
2 buffers requested.
length: 10077696 offset: 0
Buffer 0 mapped at address 0x4016e000.
length: 10077696 offset: 10080256
Buffer 1 mapped at address 0x40b0b000.
[  528.454376] pad_op 4, framix addr: dea0a800
[  528.462341] s_stream is it! enable: 1
[  530.026184] last line of image received
0 (0) [-] 0 10077696 bytes 530.213853 1300960526.930187 -0.001 fps
[  531.558898] last line of image received
1 (1) [-] 1 10077696 bytes 531.746555 1300960528.462828 0.652 fps
[  533.091613] last line of image received
[  533.098571] s_stream is it! enable: 0
Captured 2 frames in 3.075627 seconds (0.650274 fps, 6553262.798122 B/s).

cheers,

 Bastian Hecht


> --
> Regards,
>
> Laurent Pinchart
>
