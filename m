Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50247 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbZCETBq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 14:01:46 -0500
Message-ID: <49B022FE.3050206@redhat.com>
Date: Thu, 05 Mar 2009 20:07:42 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
References: <20090217200928.1ae74819@free.fr> <200903042049.37829.elyk03@gmail.com> <alpine.LNX.2.00.0903042210500.23365@banach.math.auburn.edu> <200903042354.40787.elyk03@gmail.com> <49AF78A0.1030508@redhat.com> <alpine.LNX.2.00.0903051232350.27780@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0903051232350.27780@banach.math.auburn.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



kilgota@banach.math.auburn.edu wrote:
> 
> 
> On Thu, 5 Mar 2009, Hans de Goede wrote:
> 
>>
>>
>> Kyle Guinn wrote:
>>> On Wednesday 04 March 2009 22:34:13 kilgota@banach.math.auburn.edu 
>>> wrote:
>>>> On Wed, 4 Mar 2009, Kyle Guinn wrote:
>>>>> On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu 
>>>>> wrote:
>>>>>> contents of file mr97310a.patch follow, for gspca/mr97310a.c
>>>>>> --------------------------------------------------------
>>>>>> --- mr97310a.c.old    2009-02-23 23:59:07.000000000 -0600
>>>>>> +++ mr97310a.c.new    2009-03-03 17:19:06.000000000 -0600
>>>>>> @@ -302,21 +302,9 @@ static void sd_pkt_scan(struct gspca_dev
>>>>>>                       data, n);
>>>>>>           sd->header_read = 0;
>>>>>>           gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
>>>>>> -        len -= sof - data;
>>>>>> -        data = sof;
>>>>>> -    }
>>>>>> -    if (sd->header_read < 7) {
>>>>>> -        int needed;
>>>>>> -
>>>>>> -        /* skip the rest of the header */
>>>>>> -        needed = 7 - sd->header_read;
>>>>>> -        if (len <= needed) {
>>>>>> -            sd->header_read += len;
>>>>>> -            return;
>>>>>> -        }
>>>>>> -        data += needed;
>>>>>> -        len -= needed;
>>>>>> -        sd->header_read = 7;
>>>>>> +        /* keep the header, including sof marker, for coming 
>>>>>> frame */
>>>>>> +        len -= n;
>>>>>> +        data = sof - sizeof pac_sof_marker;;
>>>>>>       }
>>>>>>
>>>>>>       gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
>>>>> A few notes:
>>>>>
>>>>> 1.  There is an extra semicolon on that last added line.
>>>> Oops. My bifocals.
>>>>
>>>>> 2.  sd->header_read no longer seems necessary.
>>>> This is very likely true.
>>>>
>>>>> 3.  If the SOF marker is split over two transfers then everything 
>>>>> falls
>>>>> apart.
>>>> Are you sure about that?
>>>>
>>>
>>> Simple example:  One transfer ends with FF FF 00 and the next begins 
>>> with FF 96 64.  pac_find_sof() returns a pointer to 64, n is set to 
>>> 0, len stays the same, data now points at 3 bytes _before_ the 
>>> transfer buffer, and we will most likely get undefined behavior when 
>>> trying to copy the data out of the transfer buffer.  Not only that, 
>>> but the FF FF 00 portion of the SOF won't get copied to the frame 
>>> buffer.
>>>
>>
>> Good point, since we will always pass frames to userspace which start 
>> with the
>> sof, maybe we should just only pass the variable part of the header to 
>> userspace?
>>
>> That sure feels like the easiest solution to me.
>>
>> Regards,
>>
>> Hans
>>
> 
> Hans, that would not solve the problem. In fact, it appears to me that 
> this problem was already inherent in the driver code before I proposed 
> any patches at all.

Erm, if I understood correctly (haven't looked yet) the driver is working
with the sof detection from pac_common, which does work with a SOF split
over multiple frames.

The problem with the new code is that it takes the return value of the sof
detection (which is a pointer into the current frame) and then
substracts the length of the sofmarker, however if only part of the sof was
in the current frame the resulting pointer (after substracting the sof length)
will point to before the current frame buffer.

Hence my proposal to fix this by simple only sending the variable part of the
header to userspace (and thus not do the substraction).

Anyways this is just what I understood from the former discussion I have *not*
looked at the actual code (-ENOTIME)

Regards,

Hans
