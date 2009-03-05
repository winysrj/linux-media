Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:38093 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZCEGfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 01:35:36 -0500
Date: Thu, 5 Mar 2009 00:47:50 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Kyle Guinn <elyk03@gmail.com>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <200903042354.40787.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0903050010320.23480@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200903042049.37829.elyk03@gmail.com> <alpine.LNX.2.00.0903042210500.23365@banach.math.auburn.edu> <200903042354.40787.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 4 Mar 2009, Kyle Guinn wrote:

> On Wednesday 04 March 2009 22:34:13 kilgota@banach.math.auburn.edu wrote:
>> On Wed, 4 Mar 2009, Kyle Guinn wrote:
>>> On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:
>>>> contents of file mr97310a.patch follow, for gspca/mr97310a.c
>>>> --------------------------------------------------------
>>>> --- mr97310a.c.old	2009-02-23 23:59:07.000000000 -0600
>>>> +++ mr97310a.c.new	2009-03-03 17:19:06.000000000 -0600
>>>> @@ -302,21 +302,9 @@ static void sd_pkt_scan(struct gspca_dev
>>>>   					data, n);
>>>>   		sd->header_read = 0;
>>>>   		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
>>>> -		len -= sof - data;
>>>> -		data = sof;
>>>> -	}
>>>> -	if (sd->header_read < 7) {
>>>> -		int needed;
>>>> -
>>>> -		/* skip the rest of the header */
>>>> -		needed = 7 - sd->header_read;
>>>> -		if (len <= needed) {
>>>> -			sd->header_read += len;
>>>> -			return;
>>>> -		}
>>>> -		data += needed;
>>>> -		len -= needed;
>>>> -		sd->header_read = 7;
>>>> +		/* keep the header, including sof marker, for coming frame */
>>>> +		len -= n;
>>>> +		data = sof - sizeof pac_sof_marker;;
>>>>   	}
>>>>
>>>>   	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
>>>
>>> A few notes:
>>>
>>> 1.  There is an extra semicolon on that last added line.
>>
>> Oops. My bifocals.
>>
>>> 2.  sd->header_read no longer seems necessary.

True, and if you remove it then you can also delete some other things. Try 
it and heed the compile warnings, and you will see.

>>> 3.  If the SOF marker is split over two transfers then everything falls
>>> apart.
>>
>> Are you sure about that?
>>
>
> Simple example:  One transfer ends with FF FF 00 and the next begins with FF
> 96 64.  pac_find_sof() returns a pointer to 64, n is set to 0, len stays the
> same, data now points at 3 bytes _before_ the transfer buffer, and we will
> most likely get undefined behavior when trying to copy the data out of the
> transfer buffer.  Not only that, but the FF FF 00 portion of the SOF won't
> get copied to the frame buffer.


Yes, you are right. I was chasing through all of it, and I found the same 
thing. I will point out, though, that this danger is not a new one. The 
code which you originally had there suffers the same defect. The problem 
is not whether one decides to keep the SOF marker in the frame output. 
Rather, the problem is that one must *detect* it. And to detect it one 
must needs be able to read all of it at once. If you read only three bytes 
from it, and that is the end of the packet, then that will be analysed as 
still belonging to the same frame. Then the next packet will continue to 
be in the same frame, too.

A mitigating factor here is that when the next packet is "in the same 
frame" then what will happen in practice is that the decompressor will 
run, fill up the current frame, and stop when it reaches the end of the 
frame and will toss the rest of the data. So in other words the next frame 
will just get tossed.


> Since we know what the SOF looks like, we don't need to worry about losing the
> FF FF 00 portion

Yes, you do. You know what the marker looks like, and I know. But the FF 
FF 00 is the end of the packet. So a computer will not know. It will not 
be detected as part of an SOF marker. Instead, it will just be tacked onto 
the data from the current frame and any special meaning will be lost. 
However, the consequence is that the decompression algorithm will use 
enough data to finish the current frame, stop before it has to use the FF 
FF 00, and, since no marker has been detected in the next packet, either, 
all new data will just be ignored as junk until another SOF marker comes 
up and is detected. Then and only then a new output frame will be 
initiated.

-- just copy sd->sof_read bytes from pac_sof_marker.
> Unfortunately my brain is fried right now and I can't come up with a working
> example.
>
>>> I don't know if the camera will allow that to happen, but it's better to
>>> be safe.
>>
>> Agreed.

Maybe not. Perhaps according to my analysis above it is actually no big 
deal. My analysis of what will happen is based upon the way the 
decomressor function works (uses data until it is finished with a frame, 
and then quits). So if it occasionally happens that an SOF marker is split 
in two across two packets, then it just causes a frame's data to be 
skipped. I can't imagine any other ill effect. Of course, if this bad 
thing happens for 350 frames in succession, that would be quite 
interesting.

Therefore, what I think is that the attempt to code around the possibility 
that an SOF marker is split across two frames would be quite likely to 
cause more trouble than it is worth. What would be needed is to consider 
two successive packets at a time. If there is no SOF marker which can 
start inside the first one and end in the second one, then put the data 
from the  first packet away, get a new packet, rinse. lather, and repeat.

Probably we need the opinion of a real expert about whether it is 
necessary to go to such lengths, now that it is seen what the problem 
might be.


Theodore Kilgore
