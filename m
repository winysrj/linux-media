Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:44153 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZBSVmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 16:42:05 -0500
Date: Thu, 19 Feb 2009 15:54:14 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Thomas Kaiser <v4l@kaiser-linux.li>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Kyle Guinn <elyk03@gmail.com>, linux-media@vger.kernel.org
Subject: Re: MR97310A and other image formats
In-Reply-To: <499DB030.7010206@kaiser-linux.li>
Message-ID: <alpine.LNX.2.00.0902191502380.7303@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <alpine.LNX.2.00.0902182305300.6388@banach.math.auburn.edu> <499DB030.7010206@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 19 Feb 2009, Thomas Kaiser wrote:

> kilgota@banach.math.auburn.edu wrote:
>> ID 0x093a:0x010e are working, because the image does not come out. Well,
>
> Just if you don't know.....
>
> ID 0x093a is the vendor ID from Pixart. Did MARS change the name to Pixart?

No idea. But the single camera which the module presently supports is the 
Aiptek Pencam VGA+ which IIRC has a vendor number from Aiptek, not Mars. 
So that much is consistent. Anyway, there are lots of dual-mode mr97310 
cameras. Cf. libgphoto2/camlibs/mars.

>
>> What I found:
>> 
>> After shooting a raw frame, I get
>> 
>> FF FF 00 FF 96 64 D0 01 27 00 06 2D
>
> There is the same Frame Header for the PAC207 and PAC7311 (FF FF 00 FF 96 
> ..... 12 Bytes in total as I remember).

Yes, what you quote is the SOF marker for all of these cameras. The total 
header length, including the SOF marker ought to be 12 bytes. On all of 
the mr97310 cameras that I have dealt with, the last 5 bytes are obviously 
related somehow to the image (contrast, color balance, gamma, whatever). I 
have no idea how to interpret those values, but we can hope that someone 
will figure out how. Thus, it is not a good idea to throw them away as the 
driver is currently doing. If they have to be tossed, then toss them over 
in libv4lconvert, I would say, instead of shaving them off in the driver. 
It makes for much simpler driver code when one does not try to work around 
them, too.

> PAC207 does a line based compression and PAC7311 is jpeg based with a marker 
> in front of each MCU. Both decompression are supported by libv4l :-)

The marker for compression/no compression and for what kind of 
compression if there is any is the next one that you do not quote here. 
What i know from previous experience is

FF FF 00 FF 96 64 00 	uncompressed
FF FF 00 FF 96 64 50	"standard compression" supported here and 
in libgphoto2/camlibs/mars. Supports all cameras in stillcam mode except 
for the next one listed
FF FF 00 FF 96 64 20	another compression, used by one stillcam, not 
resolved
FF FF 00 FF 96 64 D0	new compression algorithm used by all the 
0x093a:0x010e cameras that I own (several of them), when running in 
streaming mode.

What else I know about this, or think I know:

Both the 0x20 format and the 0xD0 format are probably variants of the 
differential Huffman encoding scheme which is the 0x50. One can see 
sometimes a little bit of the picture, which is recognizable. But the 
pattern is screwed up. For example, today I have been experimenting a bit 
with the new one. I am pretty sure it starts from a different row, like 
row 2 or so, instead of from row 0 as does the 0x50 algorithm. I have been 
surprised before, but I will be very surprised indeed if the algorithm 
signified by 0xD0 turns out to be one of the two you mention just now.


>
> The PAC207 can be configured to run in raw mode or compressed mode. The same 
> should be possible to do with the PAC7311, but I could not find the right 
> register to set this :-(
>
> Don't know if this info helps you? (or you already know)

No, I know nothing about how to do that. Heretofore, I have dealt with 
these cameras as still cameras.

Incidentally, I did have something to do with solving the the 0x50 
decompression. Bertrik Sikkens figured out the basics. It is a 
differential Huffman encoding, as I said. One computes a "predictor" for 
the next pixel to be decompressed by taking a weighted average of some 
previously decompressed pixel data. Then one applies a "corrector" which 
is the next piece of decoded data. Bertrik figured out the Huffman scheme, 
as I said. What I did was to figure out the right pixels to average for 
the predictor part and what weights they get assigned in the weighted 
average.

But it seems that you know something about this kind of thing and probably 
have the right tools or clues to be able to handle them. I have a couple 
of other unsolved formats lying around, too. You might be the person I 
have been trying to meet. Interested?

Theodore Kilgore
