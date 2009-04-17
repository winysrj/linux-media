Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:51551 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbZDQRhr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 13:37:47 -0400
Date: Fri, 17 Apr 2009 12:50:51 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Kyle Guinn <elyk03@gmail.com>
cc: Thomas Kaiser <v4l@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <200904162333.49502.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0904171225120.11123@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200904160014.32558.elyk03@gmail.com> <alpine.LNX.2.00.0904161247530.10195@banach.math.auburn.edu> <200904162333.49502.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 16 Apr 2009, Kyle Guinn wrote:

> On Thursday 16 April 2009 13:22:11 Theodore Kilgore wrote:
>> On Thu, 16 Apr 2009, Kyle Guinn wrote:
>>> On Wednesday 04 March 2009 02:41:05 Thomas Kaiser wrote:
>>>> Hello Theodore
>>>>
>>>> kilgota@banach.math.auburn.edu wrote:
>>>>> Also, after the byte indicator for the compression algorithm there are
>>>>> some more bytes, and these almost definitely contain information which
>>>>> could be valuable while doing image processing on the output. If they
>>>>> are already kept and passed out of the module over to libv4lconvert,
>>>>> then it would be very easy to do something with those bytes if it is
>>>>> ever figured out precisely what they mean. But if it is not done now it
>>>>> would have to be done then and would cause even more trouble.
>>>>
>>>> I sent it already in private mail to you. Here is the observation I made
>>>> for the PAC207 SOF some years ago:
>>>>
>>>>  From usb snoop.
>>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx 00 00
>>>> 1. xx: looks like random value
>>>> 2. xx: changed from 0x03 to 0x0b
>>>> 3. xx: changed from 0x06 to 0x49
>>>> 4. xx: changed from 0x07 to 0x55
>>>> 5. xx: static 0x96
>>>> 6. xx: static 0x80
>>>> 7. xx: static 0xa0
>>>>
>>>> And I did play in Linux and could identify some fields :-) .
>>>> In Linux the header looks like this:
>>>>
>>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00
>>>> 1. xx: don't know but value is changing between 0x00 to 0x07
>>>> 2. xx: this is the actual pixel clock
>>>> 3. xx: this is changing according light conditions from 0x03 (dark) to
>>>> 0xfc (bright) (center)
>>>> 4. xx: this is changing according light conditions from 0x03 (dark) to
>>>> 0xfc (bright) (edge)
>>>> 5. xx: set value "Digital Gain of Red"
>>>> 6. xx: set value "Digital Gain of Green"
>>>> 7. xx: set value "Digital Gain of Blue"
>>>>
>>>> Thomas
>>>
>>> I've been looking through the frame headers sent by the MR97310A (the
>>> Aiptek PenCam VGA+, 08ca:0111).  Here are my observations.
>>>
>>> FF FF 00 FF 96 6x x0 xx xx xx xx xx
>>>
>>> In binary that looks something like this:
>>>
>>> 11111111 11111111 00000000 11111111
>>> 10010110 011001aa a1010000 bbbbbbbb
>>> bbbbbbbb cccccccc ccccdddd dddddddd
>>>
>>> All of the values look to be MSbit first.  A looks like a 3-bit frame
>>> sequence number that seems to start with 1 and increments for each frame.
>>
>> Hmmm. This I never noticed. What you are saying is that the two bytes 6x
>> and x0 are variable? You are sure about that? What I have previously
>> experienced is that the first is always 64 with these cameras, and the
>> second one indicates the absence of compression (in which case it is 0,
>> which of course only arises for still cameras), or if there is data
>> compression then it is not zero. I have never seen this byte to change
>> during a session with a camera. Here is a little table of what I have
>> previously witnessed, and perhaps you can suggest what to do in order to
>> see this is not happening:
>>
>> Camera		that byte	compression	solved, or not	streaming
>> Aiptek 		00		no		N/A		no
>> Aiptek		50		yes		yes		both
>> the Sakar cam	00		no		N/A		no
>> ditto		50		yes		yes		both
>> Argus QuikClix	20		yes		no	doesn't work
>> Argus DC1620	50		yes		yes	doesn't work
>> CIF cameras	00		no		N/A		no
>> ditto		50		yes		yes		no
>> ditto		d0		yes		no		yes
>>
>> Other strange facts are
>>
>> -- that the Sakar camera, the Argus QuikClix, and the
>> DC1620 all share the same USB ID of 0x93a:0x010f and yet only one of them
>> will stream with the existing driver. The other two go through the
>> motions, but the isoc packets do not actually get sent, so there is no
>> image coming out. I do not understand the reason for this; I have been
>> trying to figure it out and it is rather weird. I should add that, yes,
>> those two cameras were said to be capable of streaming when I bought them.
>> Could it be a problem of age? I don't expect that, but maybe.
>>
>> -- the CIF cameras all share the USB id of 0x93a:0x010e (I bought several
>> of them) and they all are using a different compression algorithm while
>> streaming from what they use if running as still cameras in compressed
>> mode. This leads to the question whether it is possible to set the
>> compression algorithm during the initialization sequence, so that the
>> camera also uses the "0x50" mode while streaming, because we already know
>> how to use that mode.
>>
>> But I have never seen the 0x64 0xX0 bytes used to count the frames. Could
>> you tell me how to repeat that? It certainly would knock down the validity
>> of the above table wouldn't it?
>>
>
> I've modified libv4l to print out the 12-byte header before it skips over it.

Good idea, and an obvious one. Why did I not think of that?

> Then when I fire up mplayer it prints out each header as each frame is
> received.  The framerate is only about 5 fps so there isn't a ton of data to
> parse through.  When I point the camera into a light I get this (at 640x480):
>
> ...
> ff ff 00 ff 96 64 d0 c1 5c c6 00 00
> ff ff 00 ff 96 65 50 c1 5c c6 00 00
> ff ff 00 ff 96 65 d0 c1 5c c6 00 00
> ff ff 00 ff 96 66 50 c1 5c c6 00 00
> ff ff 00 ff 96 66 d0 c1 5c c6 00 00
> ff ff 00 ff 96 67 50 c1 5c c6 00 00
> ff ff 00 ff 96 67 d0 c1 5c c6 00 00
> ff ff 00 ff 96 64 50 c1 5c c6 00 00
> ff ff 00 ff 96 64 d0 c1 5c c6 00 00
> ff ff 00 ff 96 65 50 c1 5c c6 00 00
> ...

Which camera is this? Is it the Aiptek Pencam VGA+? If so, then I can try 
it, too, because I also have one of them.

>
> Only those 3 bits change, and it looks like a counter to me.  Take a look at
> the gspca-mars (MR97113A?) subdriver.  I think it tries to accommodate the
> frame sequence number when looking for the SOF.

No, I don't see that, sorry. What I see is that it looks for the SOF, 
which is declared in pac_common.h to be the well-known FF FF 00 FF 96 and 
no more bytes after that.

>
> Maybe all or part of the 7 bytes between A and B specify the compression?
> That explains all but the last row of your table since (0xd0 & 0x7f) == 0x50.
> Double-check that it's actually d0 if you can, and that it is a constant d0
> unlike the toggling between 50 and d0 above.
>
> For your cameras that aren't streaming anything, do they stream in Windows?
> If so, have you tried snooping the USB traffic?  I'm curious if their drivers
> use a slightly different initialization sequence, or if some of the
> initialization data varies between runs.  I know some of the initialization
> data varied between runs for the pencam, and I don't know what kind of effect
> it has on the camera.

Me, too, I am curious. But I have had increasing trouble with Windows, and 
with the installation of the drivers. I have 3 machines for that. The 
oldest is a dual-boot Linux and Win98 box. If I want to install a driver 
over there I have to move it over on a USB stick. To get the machine to 
read a USB stick, it has to be booted in Linux. Also to get the log file 
off it, afterwards. All of this because Win98 does not recognize a 
standard device by its class, only if a driver specifically for it has 
been installed. There are also registry problems because I have done too 
many installs on it. Also it is possible to do an install of a driver, but 
apparently there is no streaming app. So I can diagnose things with still 
cameras (which I no longer need to do) but the streaming will not work. 
The streaming apps which came with those cameras, it seems that I no 
longer have or I can not find the old CD and make a definite match with 
the old camera. Then there is a Win2K box. Similar story. Then there is a 
discarded HP laptop of my youngest son, which he says had a buggy Broadcom 
wireless card in it which was frying the motherboard. It runs Vista. 
It is flaky. But I thought it might have some kind of generic streaming 
app installed. The last experience I had with it is I tried to install the 
driver for the Argus DC-1620, hoping to be able to get some sniffs. The 
machine would not accept the driver. On rebooting, it attempted to do a 
systematic check of the entire installation, which it claimed was now 
"corrupted" and finally announced after 30 minutes of looking for its 
nuts, that I had installed a bad hardware driver. Well, I guess that I 
need to try again, but my more recent experiences with that other OS, in 
its variations, have been time-consuming, unpleasant, and fruitless. This 
is all getting a bit off topic, but perhaps it will encourage others to be 
even more grateful for having Linux.

I will continue to look into these things, because there are unresolved 
mysteries. Thanks for your log of the headers. I will definitely check 
that out.

Theodore Kilgore
