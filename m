Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:49444 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZFSTyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 15:54:41 -0400
Date: Fri, 19 Jun 2009 15:09:30 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@radix.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Sakar 57379 USB Digital Video Camera...
In-Reply-To: <1245435414.4181.7.camel@palomino.walls.org>
Message-ID: <alpine.LNX.2.00.0906191452580.18311@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>  <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>  <1245386416.20630.31.camel@palomino.walls.org>  <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>
 <1245435414.4181.7.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 19 Jun 2009, Andy Walls wrote:

> On Fri, 2009-06-19 at 12:47 -0500, Theodore Kilgore wrote:
>>
>> On Fri, 19 Jun 2009, Andy Walls wrote:
>>
>>> On Thu, 2009-06-18 at 21:43 -0500, Theodore Kilgore wrote:
>>>>
>>>> On Thu, 18 Jun 2009, Andy Walls wrote:
>>>>>
>>>>>
>>>>>
>>>>
>>>> Interesting. To answer your question, I have no idea off the top of my
>>>> head. I do have what seems to be a similar camera. It is
>>>>
>>>> Bus 005 Device 006: ID 0979:0371 Jeilin Technology Corp., Ltd
>>>>
>>>> and the rest of the lsusb output looks quite similar. I do not know,
>>>> though, if it has any chance of working as a webcam. Somehow, the thought
>>>> never occurred to me back when I got the thing. I would have to hunt some
>>>> stuff down even to know if it is claimed to work as a webcam.
>>>
>>> The packaging that mine came in claims "3-in-1":
>>>
>>> digital video camcorder (with microphone)
>>> digital camera
>>> web cam
>>>
>>>
>>>> You did say that it comes up as a different USB device when it is a
>>>> webcam? You mean, a different product ID or so?
>>>
>>> Yes
>>>
>>> Look for this in the original lsusb output I provided
>>> :
>>>>> Webcam mode:
>>>>>
>>>>> Bus 003 Device 005: ID 0979:0280 Jeilin Technology Corp., Ltd
>>>>> Device Descriptor:
>>
>> Oops, right you are. Blame it on my old eyes. They are the same age as the
>> rest of me, but sometimes they feel older.
>>
>> Another thing I could not see in front of me when I looked at my Jeilin
>> Mass Storage camera, was what is written on it. It says there it is a
>> Cobra DMC300, and it says
>>
>> "Digital Video & Camera"
>>
>> I never paid any attention to that before, because for years my priorities
>> were still cameras. But now, just in case I have lost the driver CD, I
>> went out to Google and found what claims to be a driver for it. I hope
>> that, with such a long idleness just sitting on a back corner of the desk,
>> the battery has not died in the camera. If I get some time in the next few
>> days to try to fight Windows, I will make some logs of my own. Then we can
>> compare notes and see if the two cameras are similar, or not. What I am
>> hoping for, obviously, is that both cameras are downloading JPEG frames,
>> and use similar methods to do that. If that is true (we don't know that,
>> of course) then the only problem I can imagine is that both of them are
>> reported, even in webcam mode, as Mass Storage Bulk Transport devices. If
>> so, then the camera(s) would need to be blacklisted by mass-storage when
>> set up as webcams.
>>
>> Now that I got the supposed driver, I should go out on the web and get the
>> supposed manual for my camera. Then perhaps I can know how it is supposed
>> to be used as a webcam and get the needed sniffs. Meanwhile, I hope that
>> you will do the same.
>
> OK.  I have two steps to take:
>
> 1. Installing the driver and software on my sole remaining Windows
> machine.  It already has snoopy.

Great.

>
> 2. Getting the camera away from my daughter for more than 2 minutes.
> It's like the thing is glued to her hand. :)
>

Oops. Not so good. Luck to you with that. But I hope that your daughter is 
suitably impressed with the idea of making things work in Linux, and 
suitably impressed with her father's skills about that kind of thing.

I should mention. Mine has a microphone, too. Let us hope that the two are 
essentially identical except for things like packaging. And let us hope 
that the webcam functionality is not using some kind of weird compression 
algorithm. But yours, like mine, is using JPEG in still mode, right? So if 
it is using some weirdo scheme in webcam mode that will be both unpleasant 
and surprising.

The only other things which might interfere are the following:

1. I am teaching in summer school. I just gave a test and I have to grade 
it over the weekend. The final exam is next Friday, so I will be 
similarly engaged.

2. We are going on vacation on July 7 and returning on July 23. My wife 
says that we will spend our spare time this weekend in planning. Because 
of this and because of item 1, I do not know whether or not I will be able 
to do the OEM install over here, or not, before next week.

3. Still working to finish expanding the mr97310a driver to support all 
known cameras with that chip in them. Believe it or not, some of those 
which have the chip and share a common Vendor:Product number work 
differently. So, ad-hoc methods needed to be figured out to classify them. 
This has been done, and all known cameras now work. There are four 
different initialization sequences to be taken into account. They all 
work. What is left to do now is to figure out how to apply the needed 
control sequences for things like brightness, gamma, white balance, and so 
forth and so on.

So I am busy, but at the same time I am very much interested in taking 
this project on, too, because it involves something I have worked on in 
the past, myself. So let us see how it appears to come out. If I can get 
your log file, it will probably give a good start.

Theodore Kilgore
