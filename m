Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:50769 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZCDFKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 00:10:32 -0500
Date: Tue, 3 Mar 2009 23:21:50 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Kyle Guinn <elyk03@gmail.com>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <200903032050.13915.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 3 Mar 2009, Kyle Guinn wrote:

> On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:
>> Hans, Jean-Francois, and Kyle,
>>
>> The proposed patches are not very long, so I will give each of them, with
>> my comments after each, to explain why I believe that these changes are a
>> good idea.
>>
>> First, the patch to libv4lconvert is short and sweet:
>>
>> contents of file mr97310av4l.patch follow
>> ----------------------------------------------
>> --- mr97310a.c.old	2009-03-01 15:37:38.000000000 -0600
>> +++ mr97310a.c.new	2009-02-18 22:39:48.000000000 -0600
>> @@ -102,6 +102,9 @@ void v4lconvert_decode_mr97310a(const un
>>   	if (!decoder_initialized)
>>   		init_mr97310a_decoder();
>>
>> +	/* remove the header */
>> +	inp += 12;
>> +
>>   	bitpos = 0;
>>
>>   	/* main decoding loop */
>>
>> ----------------- here ends the v4lconvert patch ------------------
>>
>> The reason I want to do this should be obvious. It is to preserve the
>> entire header of each frame over in the gspca driver, and to throw it away
>> over here. The SOF marker FF FF 00 FF 96 is also kept. The reason why all
>> of this should be kept is that it makes it possible to look at a raw
>> output and to know if it is exactly aligned or not. Furthermore, the next
>> byte after the 96 is a code for the compression algorithm used, and the
>> bytes after that in the header might be useful in the future for better
>> image processing. In other words, these headers contain information which
>> might be useful in the future and they should not be jettisoned in the
>> kernel module.
>>
>
> No complaints here.  I copied off of the pac207 driver, thinking that one
> compression format == one pixel format and that all mr97310a cameras use the
> same compression.  I was hesitant to say that the mr97310a pixel format can
> correspond to multiple compression formats, especially since I only have one
> such camera and I don't know if it's preferred to use multiple pixel formats
> for this reason.

Well, it is a fact that different compression formats are used by some 
cameras. First, the two 0x093a:0x010f cameras which I have that do *not* 
work with this module actually do use different compression algorithms. 
The proof is that what will convert the raw files of one of them, will not 
work on the other. The only place this is visible is in the header of the 
raw file (see previous discussion about this on the list). Well, OK, these 
cameras do not work. But then there are the 0x093a:0x010e cameras. They 
work very nicely with all of your code, up to the point that they use a 
different compressed format for the raw output and the frames come out 
looking wrong. Again, the only place this is marked is there is an 
indicator byte for the compression algorithm, and it is in the header.

> From what I understand, sending the frame header to userspace solves at least
> two problems (if indeed the compression is specified in the header):

It is. Really.

> * One frame may be compressed and the next frame isn't, or the next 
> frame uses a different compression.

These are very unlikely scenarios for a webcam. They assuredly do occur 
with still cameras, true. At least, one finds that the still camera will 
support a compressed mode, and an uncompressed mode. And, yes, the 
different kinds can be all mixed together. For, the user can reset the 
compression setting before each picture is shot.

>
> * Two cameras with the same vendor/product ID use different compression
> formats.  Distinguishing the two cameras in the kernel driver could be messy.

Well, sending the header along takes care of that. Once it is known how to 
decompress them, all that one needs to do is to look at the telltale byte 
from the header, and one knows which algorithm to use. Simple, actually.

>
> Just a random thought, but maybe the pac207 driver can benefit from such a
> change as well?

Probably. It just isn't my business. I would really be curious what those 
bytes are that are in the pac207 header, too, for comparison purposes and 
because someone ought to make a record of these things. Thus, if it were 
left to me I would probably rewrite the pac_common.h file change all apps 
which use it, in accord with the changes there and in accord with what I 
proposed here. But those would be too many changes which involve too many 
people at once, and something can go wrong when one does that. So better 
just to change the one driver I am interested in, hoping that you would 
not mind, and because I have a couple of cameras that I could test it with 
and I can say it works well after the changes.

Why would I change pac_common.h? Well, the sof marker should not be 
tossed, either, IMHO, because it is after all an sof marker. It is very 
comforting to be able to look at a raw output and to know for certain that 
at least it starts out right because it begins with an sof marker. One 
knows then that things are going well. That after all is part of the 
reason an sof marker is put there in the first place. To know where the 
start of a frame is. So, why throw such a thing away as if it has no 
value? I used to throw away things like that in my gphoto2 drivers, too, 
but I learned a lesson. So I am trying to pass it on.

Also, after the byte indicator for the compression algorithm there are 
some more bytes, and these almost definitely contain information which 
could be valuable while doing image processing on the output. If they are 
already kept and passed out of the module over to libv4lconvert, then it 
would be very easy to do something with those bytes if it is ever figured 
out precisely what they mean. But if it is not done now it would have to 
be done then and would cause even more trouble.

If these little changes are not made, then anyone who is curious about 
things like this and about compression algorithms (me, for instance) is 
going to have to maintain two gspca trees. One for himself, and one for 
everyone else. I was getting tired of that, and getting tired of accidents 
that I blow away my mr97310.c file whenever I do an upgrade of gspca, if I 
do not look out, and things like that.

So, let's do it. That's my suggestion.

Theodore Kilgore
