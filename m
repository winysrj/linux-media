Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:56513 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZCFViG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 16:38:06 -0500
Received: from localhost (localhost.lie-comtel.li [127.0.0.1])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id 2EAD79FEC12
	for <linux-media@vger.kernel.org>; Fri,  6 Mar 2009 22:38:03 +0100 (GMT-1)
Received: from [192.168.0.16] (217-173-228-198.cmts.powersurf.li [217.173.228.198])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id 101499FEC11
	for <linux-media@vger.kernel.org>; Fri,  6 Mar 2009 22:38:02 +0100 (GMT-1)
Message-ID: <49B197B9.8040506@kaiser-linux.li>
Date: Fri, 06 Mar 2009 22:38:01 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: Linux Media <linux-media@vger.kernel.org>
Subject: [Fwd: Re: Topro 6800 driver]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, did not send it to linux-media@vger.kernel.org.

-------- Original Message --------
Subject: Re: Topro 6800 driver
Date: Fri, 06 Mar 2009 22:24:55 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
To: Anders Blomdell <anders.blomdell@control.lth.se>
CC: video4linux-list@redhat.com
References: <49A8661A.4090907@control.lth.se>

Hello Anders

Anders Blomdell wrote:
> Hi,
> 
> I'm trying to write a driver for a webcam based on Topro TP6801/CX0342
> (06a2:0003). My first attempt (needs gspca) can be found on:

I own a cam with a TP6810 USB bridge and a CX0342 sensor (this is
written on the driver CD).

> 
> http://www.control.lth.se/user/andersb/tp6800.c
> 
> Unfortunately the JPEG images (one example dump is in
> http://www.control.lth.se/user/andersb/topro_img_dump.txt), seems to be bogus,
> they start with (data is very similar to windows data):
> 
> 00000000: 0xff,0xd8,0xff,0xfe,0x28,0x3c,0x01,0xe8,...
> ...
> 0000c340: ...,0xf4,0xc0,0xff,0xd9
> 
> Anybody who has a good idea of how to find a DQT/Huffman table that works with
> this image data?

I did some usbsnoops today and see some similar things in the stream as
in your trace. Maybe you can comment on my observation?

When I stop the capturing, the las 2 Bytes are always 0xff 0xd9 which
look like a valid JPEG marker (End of Image)

When I search for 0xffd9, I see the following sequence:

FF D9 5x FF D8 FF FE 14 1E xx xx xx

- 5x is 55 or 5A
- the 3 xx are mostly the same, but they change a lot when I cover the
lens of the cam. So I think this is some image information (brightness?).

This said, i don't think that FF D8 and FF FE are JPEG markers, just a
unique Byte pattern to mark the start of a new frame.

I guess 5x FF D8 FF FE 14 1E xx xx xx and may be some more bytes is the
frame marker.

Comments?

Thomas


