Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:36974 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZFTWds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 18:33:48 -0400
Date: Sat, 20 Jun 2009 17:48:40 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@radix.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Sakar 57379 USB Digital Video Camera...
In-Reply-To: <1245525813.3178.24.camel@palomino.walls.org>
Message-ID: <alpine.LNX.2.00.0906201652460.27108@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>  <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>  <1245386416.20630.31.camel@palomino.walls.org>  <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>  <1245435414.4181.7.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>  <1245462845.3168.40.camel@palomino.walls.org>  <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu> <1245525813.3178.24.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sat, 20 Jun 2009, Andy Walls wrote:

> On Fri, 2009-06-19 at 23:38 -0500, Theodore Kilgore wrote:
>
>>>>
>>>> Now it is using the other pair of endpoints, 0x03 and 0x84.
>>>
>>> Hmmmm.  I wonder if we can use them anyway, without being connected in
>>> "webcam" mode.
>>
>> Nope. That was the previously mentioned bug in the Linux mass storage
>> driver. Namely the spec calls for using the first pair of endpoints
>> encountered. The bug consisted of the mass storage driver looking for the
>> last pair of endpoints encountered, instead. This was back around kernel
>> 2.6.18 or so when the problem got fixed.
>>
>> The second pair of endpoints appears to be very much disconnected in mass
>> storage mode. The attempt to use them will result only in a string of
>> error messages. How well I remember. As to whether the first pair can be
>> used in webcam mode, I clearly have not tried to use them, but I would
>> have strong doubts whether it is even worth trying. Even if they would
>> work, what on earth would they be good for?
>
> Just not having to disconnect the cam to get at the files on it.  It'll
> probably be too much for the cheap device to deal with though.
>

Well, I do not see any way around that. If you want to use it as a webcam, 
it needs a webcam support module. If you want to use it as a still cam, 
then it needs the mass storage module. Even if it were possible for the 
hardware to come up set in the webcam mode and use those two endpoints for 
something or other, then just how would it be possible to do the mass 
storage stuff? Actually, the producers of the camera were being very good 
citizens about that. They have the camera come up with two different 
Product numbers and two different Class-subclass-protocol IDs, depending 
on the way the camera has been set. One cannot ask for more. And the 
devices which do not act thus are a real pain in the neck.

This brings up another topic, not immediately relevant to the question of 
supporting your/my camera, but extremely relevant for this list:


Think about a camera which needs, say, libgphoto2 for stillcam support but 
needs a module in order to emit a stream. Then there is the issue of a 
userspace program to access the camera through libusb, and a kernel module 
to access it for streaming. Until something recently was done for a 
partial solution of this problem, then this implied the kernel module must 
be blacklisted, else the camera could never be used as a still camera.

The current solution to this userspace-kernelspace conundrum is only a 
halfway solution. Nowadays, libusb disables the kernel module if called, 
and if you want to use the camera as a webcam after that, you must replug. 
This causes problems, too, because of some distros which have the 
too-bright idea of associating the camera, through libusb, to HAL and 
fixing it so that a program pops up immediately for the purpose of 
downloading the pictures on it. Those distros want to make things "easy" 
for their users. But then, what happens? Well, as soon as the camera is 
plugged in, its module gets loaded automatically, so that it can stream. 
Then immediately the module has been disabled, because the camera is 
automatically accessed from userspace. If the user wants to stream instead 
of downloading pictures from it, then the user is screwed. To replug the 
camera is no solution, because then the cycle merely gets repeated. 
Therefore, I submit that this problem is still not solved. The great 
difficulty is, of course, that the problem raises some very difficult 
issues, which strike at the heart of the Linux security model. A better 
solution needs to be sought.

Returning to the issue on the table, I would say simply to be glad that 
the camera comes up as two different devices, depending on its switch 
settings, and does not use the same pair of endpoints for its two 
different functionalities, either.

>
> It is interesting to note that the transfer logic of the the device
> seems to be oriented around a 512 byte block size - the defacto disk
> block size.
>

Yes, but in view of the mass-storage nature of the camera's alter ego, 
that seems to me natural. Also, all the other Jeilin cameras I know of, 
both supported and unsupported, count the allocation for the photos in 
blocks. Some of them use a smaller blocksize, but many of their purely 
proprietary cameras do also use this "standard" blocksize. In other words, 
this approach seems to me to be somewhat standard for Jeilin.

<snip>


>> Sure looks that way. I took a closer look at the lines starting with ff ff
>> ff ff strings, and I found a couple more things. Here are several lines
>> from an extract from that snoop, consisting of what appear to be
>> consecutive SOF lines.
>>
>>      00000000: ff ff ff ff 00 00 1c 70 3c 00 0f 01 00 00 00 00
>>      00000000: ff ff ff ff 00 00 34 59 1e 00 1b 06 00 00 00 00
>>      00000000: ff ff ff ff 00 00 36 89 1e 00 1c 07 00 00 00 00
>>      00000000: ff ff ff ff 00 00 35 fc 1e 00 1b 08 00 00 00 00
>>      00000000: ff ff ff ff 00 00 35 84 1e 00 1b 09 00 00 00 00
>>
>> The last non-zero byte is a frame counter. Presumably, the gap between the
>> 01 and the 06 occurs because the camera was just then starting up and
>> things were a bit chaotic. The rest of the lines in the file are
>> completely consistent, counting consecutively from 09 to 49 (hex, of
>> course) at which point I killed the stream.
>>
>> The byte previous to that one (reading downwards 0f 1b 1c 1b 1b ...) gives
>> the number of 0x200-byte blocks in that frame, before the next marker
>> comes along. So if we start from the frame labeled "06" then from there on
>> the frames are approximately the same size, but not identical. For example
>> the size of frame 06 is 0x1b*0x200. That is, 27*512 bytes.
>>
>> I am not sure what the other numbers mean. Perhaps you have better guesses
>> than I do.
>
> The first few become easy given your observations.  They are the actaul
> payload size:
>
> ceil(0x1c70/0x200) = ceil(0x0e.380) = 0x0f
> ceil(0x3549/0x200) = ceil(0x1a.a48) = 0x1b
> ceil(0x3689/0x200) = ceil(0x1b.448) = 0x1c
> ceil(0x35fc/0x200) = ceil(0x1a.fe0) = 0x1b
> ceil(0x3584/0x200) = ceil(0x1a.c20) = 0x1b
>

Yes, it looks as though you are right. And furthermore I have seen this 
kind of thing before, too, with other cams. Some of them do not provide 
this information but oblige you to calculate it, instead, but some 
others actually do provide the information. So, that settles that.

BTW, where do you have something that does floating point arithmetic in 
hex? That is interesting, but seems rather heavy, too. Everything I have 
over here does only integer arithmetic, not that it is insufficient for 
answering similar questions. Actually, for most of this kind of thing I 
use an integer-arithmetic onscreen calculator which is a modernized and 
debugged version of DJ Delorie's hcalc. It is a nice little lightweight 
program which is only good for what it is good for. It will do integer 
arithmetic, base conversions, and the bitwise logic operations and the 
shift operations (and nothing else). You can get a copy of it at 
<www.auburn.edu/~kilgota> if you are curious. (end of shameless plug)

> The lone 0x3c and the 0x1e's are not so easy:
>
> 0x3c = 60
> 0x1e = 30
>
> Maybe an inidcation of frame rate?
>

That looks like as good an explanation as any other that will come up. 
Camera starts to stream at a (default?) 60 fps and some frames are 
dropped, so camera goes down to 30 fps, which seems to work.


> I'll try and think about them a little more.

It looks to me as if you have nailed it.

<snip>

(got your other mail, that you successfully received my log file)

>>> However, without
>>> the "source" of the image, it might be a little hard to decode the dump.

Unless it is already in JPEG format (and it is only needed to supply the 
missing header) you are probably right about that. What I fear at this 
point is that the camera is using the same proprietary compression 
algorithm in this mode as the JL2005B and C and D cameras. I learned long 
ago how to get the data out of those, and such would obviously also not be 
difficult here, either. The problem is what do do with that data 
afterwards. I have made no tangible progress on that one for a couple of 
years. So I hope that either this one is not so difficult or we will have 
better luck working together.


>
> I'm booting over to Windows now, to grab some dumps.

OK.

Theodore Kilgore
