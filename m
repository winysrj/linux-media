Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAK9Ww3X024974
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 04:32:58 -0500
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAK9WgLi016226
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 04:32:42 -0500
Message-ID: <49253004.4010504@hhs.nl>
Date: Thu, 20 Nov 2008 10:38:12 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
	<200811190020.15663.linux@baker-net.org.uk>
	<4923D159.9070204@hhs.nl>
	<alpine.LNX.1.10.0811192005020.2980@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.1.10.0811192005020.2980@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, sqcam-devel@lists.sourceforge.net
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
	driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

kilgota@banach.math.auburn.edu wrote:

<snip>

> 
>> libv4l currently uses linear interpolated demosaicing, the 4 (or 2) 
>> surrounding pixels with the missing color components are taken and 
>> then straight forward averaged. At the borders only those pixels which 
>> are actually present get used ofcourse.
> 
> Perhaps you ought at least to use what is in gp_bayer_accrue() as well 
> (see libgphoto2/libgphoto2/bayer.c) because it cuts down on the zipper 
> effect.
> 

Interesting, although I must say the libgphoto code certainly is not written 
with speed in mind, but we can fix that. Still doing something like 
gp_bayer_accrue() will cause a significant additional CPU load, please keep in 
mind that:
1) We often also need to decompress the bayer data first using some form of
    Huffman decompression as usb11 bandwidth is not enough for raw bayer
2) Then we have 352x288 (luckily all raw bayer cams seem to be this low) at
    30 fps
3) Which we then need to demosaic
4) And do white balance *
5) And normalize *
6) And gamma correct *
7) And flip / rotate the image
8) And the app may want to do stuff with it like display it, which might
    involve pixelformat conversion, and / or software scaling
9) And if the app wants to record broadcast, the app often also needs to do
    some form of framerate modification to get a steady framerate (webcam
    framerate is exposure setting dependend)
10) And the app may do even more such as HG264 compression for video
    conferencing
11) And this may all be part of the user just having a chat window open, while
    he is mostly using his PC for something else.

*) Not yet implemented

So all in all we need to be carefull with CPU usage here.


>> I'm always open for convincing examples of differences in algorithms, 
>> esp. when backed up with a proposed patch and benchmarks showing the 
>> additional costs.
> 
> The algorithm in libgphoto2/libgphoto2/ahd_bayer.c requires 3X the time 
> which is required for the old algorithm in bayer.c

Ugh, and I'm quite sure the algorithm in bayer.c is much much slower then what 
is in libv4l, not only because of gp_bayer_accrue(), but because it is not 
written very efficient in general IMHO (lots of if's instead of seperate 
methods for different cases like borders, different bayer orders).

> . For still photos 
> with some rather low quality cameras, it gives much better results. I 
> have written a paper about this algorithm, and also some demonstration 
> photos from some different cameras, and you can find the paper and the 
> demonstration photos at www.auburn.edu/~kilgota. As to whether the speed 
> hit of 3X is crucial for a webcam, I am not sure.

Nor am I, but I think we should be careful with not causing too much cpuload, 
also think of things like netbooks, which do not come with a very powerful cpu.


<snip>

>>> I clearly have to read the version and either flip the data myself or 
>>> inform libv4l that it needs to be flipped. The do as much work in 
>>> userspace as possible argument says I should just provide an 
>>> indicator that it needs flipping but I don't know how to do that.
>>>
>>
>> Ah interesting, 2 things:
>>
>> 1) Do not do the flipping in the kernel libv4l already has all the 
>> necessary
>>   code.
>>
>> 2) Currently there is no API for telling libv4l to do the flipping, 
>> but I think
>>   we should design one. Currently for the few cams which need software
>>   flipping (or rather software rotate 180 as that is what libv4l 
>> does), are
>>   detected by libv4l by doing string comparisons on the 
>> v4l2_capability struct
>>   card string. We could cheat and let the sq905 driver put something 
>> special
>>   in there for cams with upside down mounted sensors, but given that 
>> this is a
>>   re-occuring problem, defining a proper API for this would be good I 
>> think.
> 
> 
> Well, for these particular cameras the problem is twofold. First, the 
> image is always upside down (and the way to fix that is with a byte 
> reversal of the raw image). Second, it is also true for *some* of them 
> that the image has reversed left and right. So what you have to do is 
> read the firmware, know which firmware number corresponds to what, and 
> then have a standard way to tell the app precisely what it should do. 
> Something like a variable called "orientation" and then the appropriate 
> one of the bitmap values 00, 01, 10, or 11, or, in ordinary numbers
> 
> 0    oriented correctly, no action needed
> 1    reversal of byte string needed (giving 180 degree rotation)
> 2    reverse bytes on lines (i. e. do de-mirroring)
> 3    do both 1 and 2 (notice that 3 = 1|2)
> 

Erm, 3 just boils down to only doing vflip, rotate 180 == vflip + hflip,
so rotate180 + hflip == vflip + hflip + hflip == vflip

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
