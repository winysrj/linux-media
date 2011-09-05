Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:43077 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1IECDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2011 22:03:00 -0400
Date: Sun, 4 Sep 2011 21:07:23 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Mauricio Henriquez <buhochileno@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: spca1528 device (Device 015: ID 04fc:1528 Sunplus Technology)..libv4l2:
 error turning on stream: Timer expired issue
In-Reply-To: <4E63D3F2.8090500@gmail.com>
Message-ID: <alpine.LNX.2.00.1109042055540.8537@banach.math.auburn.edu>
References: <4E63D3F2.8090500@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 4 Sep 2011, Mauricio Henriquez wrote:

> Hi guys,
> 
> Not sure if is the right place to ask since this device use a gspca driver
> and not sure if that driver is related to uvc or not, if not please point
> me to the right place...

Looks right to me, and I hope that someone has more direct knowledge about 
your camera, which I do not. I do have a couple of questions, however, and 
a comment.

> 
> Recently I'm trying to make work a Sunplus crappy mini HD USB camera, lsusb
> list this info related to the device:
> 
> Picture Transfer Protocol (PIMA 15470)
> Bus 001 Device 015: ID 04fc:1528 Sunplus Technology Co., Ltd
> 
>  idVendor           0x04fc Sunplus Technology Co., Ltd
>   idProduct          0x1528
>   bcdDevice            1.00
>   iManufacturer           1 Sunplus Co Ltd
>   iProduct                2 General Image Devic
>   iSerial                 0
> ...
> 
> Using the gspca-2.13.6 on my Fed12 (2.6.31.6-166.fc12.i686.PAE kernel), the
> device is listed as /dev/video1 and no error doing a dmesg...but trying to
> make it work, let say with xawtv, I get:
> 
> This is xawtv-3.95, running on Linux/i686 (2.6.31.6-166.fc12.i686.PAE)
> xinerama 0: 1600x900+0+0
> WARNING: No DGA direct video mode for this display.
> /dev/video1 [v4l2]: no overlay support
> v4l-conf had some trouble, trying to continue anyway
> Warning: Missing charsets in String to FontSet conversion
> Warning: Missing charsets in String to FontSet conversion
> libv4l2: error turning on stream: Timer expired
> ioctl: VIDIOC_STREAMON(int=1): Timer expired
> ioctl: VIDIOC_S_STD(std=0x0 []): Invalid argument
> v4l2: oops: select timeout
> 
> ..or doing:
> xawtv -c /dev/video1 -nodga -novm -norandr -noxv -noxv-video
> 
> I get:
> ioctl: VIDIOC_STREAMON(int=1): Timer expired
> ioctl: VIDIOC_S_STD(std=0x0 []): Invalid argument
> v4l2: oops: select timeout
> libv4l2: error turning on stream: Timer expired
> libv4l2: error reading: Invalid argument
> 
> 
> vlc, cheese, etc give me similar "Timeout" related messages...

The comment:

Perhaps a good thing to try would be the nice, simple, basic program svv, 
which you can get from the website of Jean-Francois Moine. Some of these 
other things do not always work. Especially I have had trouble with xawtv, 
though the xawtv people may have fixed a lot of problems while I was not 
watching them.

The question:

Is this a dual-mode camera which is also supposed to have still camera 
capabilities? If so, you might be interested in contacting the Gphoto 
project. I just searched for it there, and it does not seem to be listed.

I assume that the specialists on the spca cameras will step forward. I 
am not one of them, as I said. Good luck.

Theodore Kilgore
