Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8CGIk1S024184
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 12:18:46 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8CGHv0F021979
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 12:17:57 -0400
Received: by rv-out-0506.google.com with SMTP id f6so886587rvb.51
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 09:17:56 -0700 (PDT)
Message-ID: <2df568dc0809120917w1638438bp21c2dd30a7d9997f@mail.gmail.com>
Date: Fri, 12 Sep 2008 10:17:56 -0600
From: "Gordon Smith" <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <DB0F63C32D074C01B14D2466868D9FF8@in.tippyturtle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
References: <200606152230.04490.hverkuil@xs4all.nl>
	<200701201749.02254.ulfbart@gmx.net>
	<1204328672.3190.9.camel@pc08.localdom.local>
	<DB0F63C32D074C01B14D2466868D9FF8@in.tippyturtle.com>
Content-Transfer-Encoding: 8bit
Subject: Re: Can anyone test the saa6752hs (saa7134-empress)?
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

On Fri, Sep 12, 2008 at 2:24 AM, Todd Duffin <nospam@tippyturtle.com> wrote:
>
> Hello, We can help test...we are trying to implement this chip for a client. Here is a note from our developer (on the TO: line).  Can anyone help us work through these issues?
>
> Background:
> I am working on a video capture solution for law enforcement that uses an SAA7134/SAA6752 to capture two MPEG video streams on an AMD (National Semiconductor) SC1200 based system.  I would like to capture the MPEG compressed output from the SAA6752 chips to a buffer set that is also transferred to multiple destination files on different drives, and I would like to switch output files every hour on a key-frame.
>
> The hardware is very similar to the RTD VFG7350 frame grabber board; in fact I am using this board for software prototyping and proof of concept.  I am using a Linux distribution based on Debi an, but I am not particularly attached to it (the application note for the RTD VFG73xx cards only mentions Fedora Core 4 running Linux 2.6.15).
>

I'm also using an RTD VFG7350 in Gentoo 2.6.25-gentoo-r7 + latest
v4l-dvb on x86 PC104. Currently:
  - video2/3 capture works.
  - video2/3 QBUF/DQBUF is set as capable, but does not function
  - there is a disconnect between input and compression and the input
signal standard is lost - NTSC input signal is compressed as PAL
format

> Questions:
> 1. Has anyone managed to capture MPEG compressed video from /dev/video2 and /dev/video3 using Debian and an RTD VFG7350?  If so, how? (Note:  Those who only use software compression on /dev/video0 and/or /dev/video1 need not respond).
>
> 2. Under Debian, any attempt to close an open pipe to /dev/video2 and /dev/video3 permanently blocks the active thread, apparently in the video capture driver. This prevents the user-land process that opened the pipe from terminating.  You can't even get back to the prompt after "cat /dev/video2 [enter] [ctrl+c]"; switching consoles and killing the blocked process with "kill -KILL" doesn't help, and Debian also reports [failure] when trying to terminate all the processes on shutdown.  Does anyone else experience this?
>

I had a similar experience on my first attempts in Gentoo, approx. 2.6.23.

> 3. Under Fedora Core, (I don't remember the exact version, but many of them won't install on a SC1200, so take your pick of whichever one would be easiest to get working under this condition), I found that the interface to /dev/video3 returned bogus information for the QUERRY and ENUM ioctl functions.  Does anyone know of any alternative distribution that installs and correctly supports /dev/video3 on the RTD VFG73xx?
>

I've not noticed a difference between video2 and video3 in my experience.

> 4. I also tried the latest Linux kernel, 2.6.26.5 (actually, I started with 2.6.26 in the unstable version, but this applies to the latest as well).  I found that with this kernel, the VIDIOC_QUERYBUF ioctl fails, although calls to the same function did not fail under earlier kernels.  I checked the saa7134 driver and found that VIDIOC_REQBUFS, VIDIOC_QUERYBUF, VIDIOC_QBUF, VIDIOC_DQBUF, VIDIOC_STREAMON and VIDIOC_STREAMOFF have all been completely removed from the current driver.
>
> I absolutely must know when the buffer contains a key-frame, so I can switch target files smoothly.  I don't see a way to find keyframes short of decoding the stream on the fly if I don't have the buffer information associated with that interface.  I don't think the SC1200 has enough processing power to capture and decode two high quality MPEG streams on the fly, and still stream all the output to multiple files.  Also, I'm morally opposed to writing an MPEG stream decoder, just to locate keyframes.  Should I just give up on using the newer kernels or is there an alternate mechanism for finding keyframes that doesn't involve decoding the stream on the fly?
>
> 5. Even with older kernel/driver combinations that support VIDIOC_QUERYBUF in the saa7134 driver, I have had difficulty with VIDIOC_DQBUF constantly failing (errno == IOC) and it is clearly not getting around to de-queuing the buffer properly since I always get buffer 0 back and the result isn't properly initialized.  The Video 4 Linux 2 API documentation indicates IOC is an internal driver error, but I'm not entirely clear on why this is happening.  Does this look familiar to anyone?
>

I don't know what IOC error means, but in v4l2 versions that attempt
to buffer (2.6.16-gentoo-r13), I get EIO error every 0.5 second which
means there is no data. Notice that the buffer index is likely to be
UNINITIALIZED. See
http://lists-archives.org/video4linux/19252-howto-handle-errors-during-vidioc_dqbuf.html.
I believe all buffers must be examined to determine which can be
returned to the queue.

> 6. I have spent more than a week trying different Linux distributions, looking for one that has consistent support for V4L2 and the RTD VFG7350. Every single distribution I've tried is broken in a different way, and none of them have really come close to working out of the box.
>

I have only attempted various Gentoo kernels from 2.6.16 to 2.6.25. It
appears that the VFG7350 never fully functioned in v4l2 in 2.6

> I may also need to switch to different MPEG capture hardware in the future, due to various parts going end-of-life.  I would really prefer to not be forced into spending months re-working and debugging the video capture software again.
>
> Is this a reasonable expectation, or is MPEG capture support sufficiently difficult to implement and maintain that I should expect to go through this every time I change the hardware if I stick with Linux?  I am sure I wouldn't be experiencing this pain if I just used XP Embedded, but I would really prefer to give Linux a fair chance… its build level configurability makes it strongly attractive for this specific application, and I've got a lot of time already invested in this.
>

I'd like to read about experiences with other cards and if
manufacturers routinely run v4l2 code against their cards to verify
compatibility.

> Thanks in advance,
> Todd
>
> ----- Original Message ----- From: "hermann pitton" <hermann-pitton@arcor.de>
> To: "Linux and Kernel Video" <video4linux-list@redhat.com>
> Sent: Friday, February 29, 2008 4:44 PM
> Subject: Re: Can anyone test the saa6752hs (saa7134-empress)?
>
>
>> Am Samstag, den 20.01.2007, 17:48 +0100 schrieb Ulf Bartholomäus:
>>>
>>> Hi Hans,
>>>
>>> On Thursday 15 June 2006 22:30, Hans Verkuil wrote:
>>> > I'm currently working to switch cx88-blackbird and saa7134-empress over
>>> > to the new MPEG encoding API. So I need someone to test the changes to
>>> > the empress driver and saa6752hs module for me.
>>> On which place I found more information about this. What packages should be
>>> installed?
>>>
>>> > If you have a card with that hardware and are willing to test it (and
>>> > possibly even do some development to improve the current driver) then
>>> > please contact me. The changes I made to the cx88-blackbird work fine,
>>> > so I hope that the same is true for the saa6752hs changes but without
>>> > hardware I simply can't test it.
>>> Yes I have a KNC1 TV-Station DVR with this chipset.
>>> http://www.knc1.de/d/produkte/analog_dvr.htm
>>>
>>> Is your offer sometimes available now (more than a half year ago)?
>>>
>>> Ciao Ulf
>>>
>>
>> Hi,
>>
>> have started to mess around with a not yet supported saa7134_empress
>> hybrid device.
>>
>> I have anything going, except the mpeg encoder.
>>
>> Last track of having it working seems 2.4.18, but I get even EIO stuff
>> on trying to read from the device there, but that might be device
>> specific. At least it has two gpio switchers not seen before, but the
>> whole stuff seems not to be that well documented ...
>>
>> Current stuff is definitely broken,
>> any known last working status out there?
>>
>> Cheers,
>> Hermann
>>
>>
>>
>>
>>
>>
>>
>>
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
