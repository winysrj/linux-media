Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:35921 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZBSXid (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 18:38:33 -0500
Date: Thu, 19 Feb 2009 17:50:44 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Thomas Kaiser <v4l@kaiser-linux.li>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Kyle Guinn <elyk03@gmail.com>, linux-media@vger.kernel.org
Subject: Re: MR97310A and other image formats
In-Reply-To: <499DE107.80502@kaiser-linux.li>
Message-ID: <alpine.LNX.2.00.0902191723380.7472@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <alpine.LNX.2.00.0902182305300.6388@banach.math.auburn.edu> <499DB030.7010206@kaiser-linux.li> <alpine.LNX.2.00.0902191502380.7303@banach.math.auburn.edu> <499DE107.80502@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 19 Feb 2009, Thomas Kaiser wrote:

> kilgota@banach.math.auburn.edu wrote:
>> Yes, what you quote is the SOF marker for all of these cameras. The total 
>> header length, including the SOF marker ought to be 12 bytes. On all of the 
>> mr97310 cameras that I have dealt with, the last 5 bytes are obviously 
>> related somehow to the image (contrast, color balance, gamma, whatever).  I 
>> have no idea how to interpret those values, but we can hope
>> that someone will figure out how.
>
> Two of them are luminance values (middle and edge) for the PAC207.

Which two, and how do those numbers translate into anything relevant?

>
>> Thus, it is not a good idea to throw them away as the driver is currently 
>> doing. If they have to be tossed, then toss them over in libv4lconvert, I 
>> would say, instead of shaving them off in the driver. It makes for much 
>> simpler driver code when one does not try to work around them, too.
>
> Yes, there are always some additional Bytes in the SOF header for a good 
> reason.
>
>> FF FF 00 FF 96 64 00     uncompressed
>> FF FF 00 FF 96 64 50    "standard compression" supported here and in 
>> libgphoto2/camlibs/mars. Supports all cameras in stillcam mode except for 
>> the next one listed
>> FF FF 00 FF 96 64 20    another compression, used by one stillcam, not 
>> resolved
>> FF FF 00 FF 96 64 D0    new compression algorithm used by all the 
>> 0x093a:0x010e cameras that I own (several of them), when running in 
>> streaming mode.
>
> So, you found the meaning of an other Byte in the SOF header. I have to check 
> whats in there for the PAC207 and PAC7311.

That information would be good to know. As far as what I already knew is 
concerned, the latest revision of libgphoto2/camlibs/mars/README.mars is 
stated at the top of the file. I have known this for quite a while before 
that, actually. That date is the date, more or less, that the 
decompression algorithm was finally made to work right.

>
>> Incidentally, I did have something to do with solving the the 0x50 
>> decompression. Bertrik Sikkens figured out the basics. It is a differential 
>> Huffman encoding, as I said. One computes a "predictor" for the next pixel 
>> to be decompressed by taking a weighted average of some previously 
>> decompressed pixel data. Then one applies a "corrector" which is the next 
>> piece of decoded data. Bertrik figured out the Huffman scheme, as I said. 
>> What I did was to figure out the right pixels to average for the predictor 
>> part and what weights they get assigned in the weighted average.
>
> That is a similar compression like on the PAC207 the first 2 pixels of the 
> line have the real value and for the other pixels, only the diff to these two 
> pixels are stored in Huffman codes.

Yes. Except that for the 0x50 compression the diff is not to the pixels to 
the left only. The pixel to the left and the nearest three above are the 
ones in use there to compute the predictor. Four neighbor pixels in all 
are used, and they do not all get the same weight in the average. If one 
does not use all four and if one does not use the correct weighting, then 
one can see that decompression is working, more or less, but the result is 
full of nasty artifacts and diagonal color striping and therefore is 
useless.

> Now you can guess who found out how to decompress -> Bertrik Sikkens

What I said. He has done a lot for us.

>
>> 
>> But it seems that you know something about this kind of thing and probably 
>> have the right tools or clues to be able to handle them. I have a couple of 
>> other unsolved formats lying around, too. You might be the person I have 
>> been trying to meet. Interested?
>
> Always interested, but my free time is very limited :-(
>
> It looks like I have 22 webcams on my desk and 3 or 4 of them are _not_ 
> working in Linux.

You remind me of myself. But mine are typically dual-mode, and I was first 
of all looking at them as stillcams. With one or two exceptions, that is 
done, now.

> Thus, I have a lot of homework to do.....

By any chance, you do not have a JL2005B or JL2005C or JL2005D camera 
among them, do you? AFAICT they all use the same compression algorithm (in 
stillcam mode), and it appears to me to be a really nasty one. Any help I 
could get with that algorithm is welcome indeed.

Theodore Kilgore
