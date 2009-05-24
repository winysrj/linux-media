Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58738 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbZEXOrx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 10:47:53 -0400
Received: from [192.168.1.2] (01-143.155.popsite.net [66.217.131.143])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id n4OElqsj023230
	for <linux-media@vger.kernel.org>; Sun, 24 May 2009 10:47:53 -0400 (EDT)
Subject: Re: CPen driver development / image format
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
In-Reply-To: <4A193230.3040205@gmx.de>
References: <4A193230.3040205@gmx.de>
Content-Type: text/plain
Date: Sun, 24 May 2009 10:48:39 -0400
Message-Id: <1243176519.3175.74.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-05-24 at 13:40 +0200, Stefan Below wrote:
> Hello,
> 
> i have a nice penscanner (CPEN-20, like Iris pen) and i am trying to 
> write a driver for it.
> Everything runs fine, except that i have no clue what kind of image 
> format i receive.
> 
> The penscanner has a little camera (i think its only gray or bw camera).
> 
> additional technical informations from the CPEN website:
>    Image Resolution: Grayscale 330 DPI
>    Scan Area Size: 10 x 6 mm
> 

Some thoughts:

> Here is the first part from the transfered image (cutout from usb-sniff 
> output):
> [547050 ms]  <<<  URB 499 coming back  <<< -- 
> URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
> PipeHandle           = 88a69984 [endpoint 0x00000082]
> TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, 
> USBD_SHORT_TRANSFER_OK)
> TransferBufferLength = 000001ee
> TransferBuffer       = 88be9be0
> TransferBufferMDL    = 889b77a8
>  00000000: 02 01 08 01 00 20 23 78 b5 20 00 00 00 00 80 00
>  00000010: 50 00 03 00 d8 01 
                         ^^^^^
Payload length is here ----+
It always seems to be divisible by 4.

This payload looks to be some sort of tagged format, but it's not TIFF.

Portions of th payload seems to have a periodicity that is divisible by
3 and 5.  That was obvious as some runs of data with length 5 (8f ff ff
ff f0) show a barber-pole pattern when printed 16 bytes per line.

The payload *always* starts with 0x80 and then it never appears again in
the payload.  So there is likely some encoding for data that would look
like a tag in the payload.


>                              80 71 f1 ff df ff 88 11 51 f1
>  00000020: ff df ff 88 71 f2 ff cf ff f8 ff ff 0f ff f8 ff
>  00000030: ff 0f ff f8 ff ff 0f ff f8 ff ff 0f ff f8 ff ff
>  00000040: 0f ff f8 12 18 25 ff bf ff f8 12 ff ff fc 8f 2f
>  00000050: f1 ff cf ff 18 f1 ff ff fd 8f 18 ff ff 6f ff f8
>  00000060: ff ff 0f ff f8 ff ff 0f ff f8 ff ff 0f ff 28 c2
>  00000070: 44 54 53 f1 ff f3 8f 1f 81 71 62 f2 ff f2 8f 1f
>  00000080: f1 1a ff 2f ff 88 f1 15 ff ff f0 8f ff ff ff f0
>  00000090: 8f ff ff ff f0 8f 1f f2 ff cf ff f8 ff 11 ff fd
>  000000a0: 8f 1f 31 a1 82 51 f1 cf ff f8 1a ff ff f4 8f ff
>  000000b0: 1d ff 1f ff f8 ff ff 0f ff f8 ff ff 0f ff f8 ff
>  000000c0: ff 0f ff f8 ff ff 0f ff f8 ff ff 0f ff f8 ff ff
>  000000d0: 0f ff f8 ff ff 0f ff f8 ff ff 0f ff a8 f1 ff ff
>  000000e0: f4 8f ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0
>  000000f0: 8f ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f
>  00000100: ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f ff
>  00000110: ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f ff ff
>  00000120: ff f0 8f ff ff ff f0 9f ff ff ef ff fa ff ff fd
>  00000130: 8f 13 14 ff ff 6f ff f8 ff ff 0f ff f9 ff ff fe
>  00000140: 8f ff ff ff f0 8f 12 ff ff cf ff 88 f1 ff ff f6
>  00000150: 8f 13 14 ff ff 6f ff 28 f2 ff ff fb 8f 22 ff ff
>  00000160: bf ff f9 ff ff fe bf 11 23 ff ff 5f ff 3d 21 f1
>  00000170: ff ff f3 cf 12 51 14 ff ff fc 8f 42 32 16 ff ff
>  00000180: fc ff 44 f3 ff cf ff 2d 26 f3 ff cf ff 0f 41 33
>  00000190: 11 0f f1 ff f9 cf 64 12 22 13 ff ff f5 cf 12 41
>  000001a0: 14 12 16 ff ff f3 df 11 41 23 ff ff fd df 33 ff
>  000001b0: ff 4f ff 3d 22 31 f1 ff df ff 3d 92 f2 ff 9f ff
>  000001c0: 3d 35 21 81 f1 ff 1f ff 2e 12 41 22 41 f2 ff 3f
>  000001d0: ff 1d 11 44 27 f3 ff 2f ff 1d 11 32 21 65 32 f1
>  000001e0: ff fc ff 27 13 31 31 61 f1 ff f9 8f f1 ff
> UrbLink              = 00000000
> [547050 ms] UsbSnoop - DispatchAny(b5572610) : 
> IRP_MJ_INTERNAL_DEVICE_CONTROL
> 
> The first 0x16 bytes should be a header.
> 
> I attached the image output from windows and the whole usb sniff logfile.

Why does the PBM image have this text in it:

	# CREATOR: GIMP PNM Filter Version 1.1

if it came from Windows?  Also why does the filename have "crop" in it?
Did you do some manipulation of the output file from the Windows
application?

I ask because it may be the case that the C-Pen puts out a format very
close to the default format the Windows app software would like to save
things in.  Comparing that default save format to the data in the URBs
may provide some insight.


Also a solid field isn't very helpful for making deductions about the
image data format.  Try a series of images: vertical line, horizontal
line, diagonal line, ellipse, rectangle, triangle, and square grid.
Then comparison of those source images vs the data bytes might give you
more insight into the format.


Godd Luck,
Andy

> I hope someone can help me to :-)
> 
> Stefan

