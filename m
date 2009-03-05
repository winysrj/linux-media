Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:39965 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbZCES5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 13:57:14 -0500
Date: Thu, 5 Mar 2009 13:08:59 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
cc: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <49AF78A0.1030508@redhat.com>
Message-ID: <alpine.LNX.2.00.0903051232350.27780@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200903042049.37829.elyk03@gmail.com> <alpine.LNX.2.00.0903042210500.23365@banach.math.auburn.edu> <200903042354.40787.elyk03@gmail.com> <49AF78A0.1030508@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 5 Mar 2009, Hans de Goede wrote:

>
>
> Kyle Guinn wrote:
>> On Wednesday 04 March 2009 22:34:13 kilgota@banach.math.auburn.edu wrote:
>>> On Wed, 4 Mar 2009, Kyle Guinn wrote:
>>>> On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:
>>>>> contents of file mr97310a.patch follow, for gspca/mr97310a.c
>>>>> --------------------------------------------------------
>>>>> --- mr97310a.c.old	2009-02-23 23:59:07.000000000 -0600
>>>>> +++ mr97310a.c.new	2009-03-03 17:19:06.000000000 -0600
>>>>> @@ -302,21 +302,9 @@ static void sd_pkt_scan(struct gspca_dev
>>>>>   					data, n);
>>>>>   		sd->header_read = 0;
>>>>>   		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
>>>>> -		len -= sof - data;
>>>>> -		data = sof;
>>>>> -	}
>>>>> -	if (sd->header_read < 7) {
>>>>> -		int needed;
>>>>> -
>>>>> -		/* skip the rest of the header */
>>>>> -		needed = 7 - sd->header_read;
>>>>> -		if (len <= needed) {
>>>>> -			sd->header_read += len;
>>>>> -			return;
>>>>> -		}
>>>>> -		data += needed;
>>>>> -		len -= needed;
>>>>> -		sd->header_read = 7;
>>>>> +		/* keep the header, including sof marker, for coming frame */
>>>>> +		len -= n;
>>>>> +		data = sof - sizeof pac_sof_marker;;
>>>>>   	}
>>>>>
>>>>>   	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
>>>> A few notes:
>>>> 
>>>> 1.  There is an extra semicolon on that last added line.
>>> Oops. My bifocals.
>>> 
>>>> 2.  sd->header_read no longer seems necessary.
>>> This is very likely true.
>>> 
>>>> 3.  If the SOF marker is split over two transfers then everything falls
>>>> apart.
>>> Are you sure about that?
>>> 
>> 
>> Simple example:  One transfer ends with FF FF 00 and the next begins with 
>> FF 96 64.  pac_find_sof() returns a pointer to 64, n is set to 0, len stays 
>> the same, data now points at 3 bytes _before_ the transfer buffer, and we 
>> will most likely get undefined behavior when trying to copy the data out of 
>> the transfer buffer.  Not only that, but the FF FF 00 portion of the SOF 
>> won't get copied to the frame buffer.
>> 
>
> Good point, since we will always pass frames to userspace which start with 
> the
> sof, maybe we should just only pass the variable part of the header to 
> userspace?
>
> That sure feels like the easiest solution to me.
>
> Regards,
>
> Hans
>

Hans, that would not solve the problem. In fact, it appears to me that 
this problem was already inherent in the driver code before I proposed any 
patches at all. The problem is that one must _detect_ the SOF marker. The 
further problem is (and was, and nothing yet has changed that) that if the 
SOF marker is split across two packets it will fail to be detected.

Two possible courses of action:

1. Leave the matter alone. It could be maintained that one of the 
following is the case:
 	(a) this never happens
 	(b) even if it does happen (rarely), it will do no great harm, 
because the only effect will be that the output skips a frame, having not 
detected its start of frame marker. For, the frames consist of compressed 
data, and if there is too much compressed data for a given frame, then 
that extra compressed data will simply be tossed. The next frame which is 
actually seen and used will be the next frame for which an SOF marker is 
actually detected.

So, the argument for number 1 would be that, yes, this is sort of a bug, 
but it is insignificant, not serious, and could never cause a problem in 
practice even if it occurs, because the only result would be for a frame 
to get dropped. Another argument in favor of it would be that in any event 
the camera is sending isochronous packets, and there is in any event no 
guarantee of the validity and accuracy of any one single packet. Instead, 
the reliance is on the high rate at which the packets get sent, received, 
and processed.

2. If it is deemed that, yes, it can happen that an SOF marker gets split 
between two packets, and, no, if that happens it is a problem which should 
not be ignored, then there is an alternative course of action:
 	Keep a cache consisting of the last 4 bytes of each packet, and 
see if, when the next packet comes down, a SOF marker is detected in those 
bytes, plus the new bytes from the beginning of the new packet. Then a SOF 
marker will not be missed, even if it occurs in the situation described 
above.

Alternative number two is in fact not very much more difficult, but it 
would involve putting an if-then-else or two into the code and also would 
require one to have a place to put those last four bytes of each packet, 
keep them around until the next packet is obtained, and then parse the 
result. This might slow things down, but probably not by very much. So 
which way to do this would obviously depend upon some evaluation of the 
danger of doing nothing.

However, the discussion of whether or not to deal with an SOF marker which 
is split across two packets has nothing at all to do with the question of 
whether to preserve the SOF marker in the raw frame output. The two 
questions are independent.

I say that, whatever else is done, it is good to preserve the SOF marker 
in the raw frame output. It is nice to see it there because then one 
incontrovertibly knows that the frame is aligned with the SOF marker at 
its start. I mean, if there is something wrong and one needs to do 
debugging, or if there is a new compression algorithm which needs to be 
studied, then if the SOF marker is absent in the raw output how in hell 
does one know the output is correctly aligned? Simple answer. One does 
not know. There really was a way to know that, but it has been thrown 
away. It is also much easier to code in the module, because then 
there is no need to code around the need to keep everything that came 
down, unless it is an SOF marker and then one throws it away and is forced 
to re-align the remaining data.

I wonder if anyone with wider experience could come up with an intelligent 
evaluation of whether to go with item 1, or item 2? I think I have listed 
the arguments for and against each of them, but to know which one of these 
is actually best, is another thing.

Finally, again, the question of what happens if the SOF marker is split 
between two packets in fact has nothing to do with the changes I was 
proposing. It is independent. Except for one thing: Could it be that the 
simplifications I was proposing have eliminated a lot of convoluted code 
and thereby brought this problem to the surface?

Theodore Kilgore
