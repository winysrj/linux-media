Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAKJWafG005297
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 14:32:36 -0500
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAKJWN1B008647
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 14:32:24 -0500
Message-ID: <4925BC94.7090008@hhs.nl>
Date: Thu, 20 Nov 2008 20:37:56 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
	<200811190020.15663.linux@baker-net.org.uk>
	<4923D159.9070204@hhs.nl>
	<alpine.LNX.1.10.0811192005020.2980@banach.math.auburn.edu>
	<49253004.4010504@hhs.nl>
	<Pine.LNX.4.64.0811201130410.3570@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811201130410.3570@banach.math.auburn.edu>
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
> 

<snip>

>>>
>>> 0    oriented correctly, no action needed
>>> 1    reversal of byte string needed (giving 180 degree rotation)
>>> 2    reverse bytes on lines (i. e. do de-mirroring)
>>> 3    do both 1 and 2 (notice that 3 = 1|2)
>>>
>>
>> Erm, 3 just boils down to only doing vflip, rotate 180 == vflip + hflip,
>> so rotate180 + hflip == vflip + hflip + hflip == vflip
> 
> Yeah, right. In a still photo processing it does not matter, of course, 
> so I was not paying attention to such things. Well, then, instead of 
> using 0, 1, 2, and 3 one could use 0, 1, 2 and so on, in which
>     0    do nothing
>     1    vflip
>     2    hflip
>     3    rotate 180    (1|2)
>     4    apply decompression
>     5    4|1
>     6    4|2
>     7    4|3
>     upper nibble gives Bayer tiling code of 0 thru 7.
>     If upper nibble is 8 or more, this could signify one of several
>     ways that the data could have already been processed, such as if
>     a camera emits finished JPEG frames. Or, this could have been
>     done, too, with using 8 or more in the lower nibble.
> 
> So one way to do this kind of thing might be to create in the kernel 
> module a bitmapped char variable, similar to the above, and send it out 
> to the app, during initialization, and the app is supposed to understand 
> it.
> 

Eh, no you are confusing different things now and stuffing them all into 1 byte.

We already have a pixelformat integer in the API, which can contain things like 
"this is raw bayer, first line rgrg second line gbgb" or like:
"this is bayer compressed by the spca561 bridge, compression level 1" or like:
"this is jpeg data without a quantization table", etc.

We call all this pixelformat, a pixelformat should contain all info to get from 
the raw data to say plain rgb. The image may then still be upside down / 
mirrored / whatever.

Currently we have no clear API to allow a driver to tell userspace that it is 
sending out upside down images, I've send a proposal for this to the 
video4linux-list@redhat.com

> OK, so I will look again at the Bayer algorithm and see if my suspicion 
> is correct, that it is possible to come out with something which is both 
> faster than the ahd_bayer.c code and gives better results than straight 
> bilinear interpolation, which can give such ugly artifacting. Probably, 
> the most effective use of my time right now is to work on that, because 
> I am pretty familiar with the code that I wrote.
> 
> As far as the rest of things are concerned, it would probably help if I 
> know where to go and look for your existing code about this stuff.

Easiest way to get my latest code is here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.5.tar.gz

You are looking for libv4lconvert/bayer.c

As you can see I've got separate code to render the borders and to render the 
center. I think it would be interesting to use an optimized version of your 
gp_bayer_accrue() for the center rendering. Optimalizations I'm thinking about are:
1) no need to check for having all 4 pixels, you always do
2) just pass in the 4 pixel values instead of passing in coordinates
3) make separate green and blue_red versions.

Maybe also only do the horizontal / vertical line detection for green without 
the fallback to the red_blue code when no line is detected (in that case just 
return the avg of all 4).

Regards,

Hans

p.s.

If you are experienced with reverse engineering decompression algorithms 9for 
raw bayer), I've got multiple issues where you could help me.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
