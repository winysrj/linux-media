Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8CIomro021801
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 14:50:51 -0400
Received: from mail01.ipns.com (mail01.ipns.com [208.110.132.145])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8CIoUu1026228
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 14:50:33 -0400
Message-ID: <4ABCFFE6531E4A9B8FB97A2B94A87079@in.tippyturtle.com>
From: "Todd Duffin" <nospam@tippyturtle.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
References: <22811.208.105.65.130.1221223937.squirrel@webmail.xs4all.nl>
In-Reply-To: <22811.208.105.65.130.1221223937.squirrel@webmail.xs4all.nl>
Date: Fri, 12 Sep 2008 11:49:35 -0700
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	ken_taylor@pheonix.com
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

Thank you very much.  We will move forward with your advice.  If we have any 
other problems or information I will forward it knowing you are away from 
the connected world for the most part.

Thanks again,
Todd

----- Original Message ----- 
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Todd Duffin" <nospam@tippyturtle.com>
Cc: "hermann pitton" <hermann-pitton@arcor.de>; "Linux and Kernel Video" 
<video4linux-list@redhat.com>; <ken_taylor@pheonix.com>
Sent: Friday, September 12, 2008 5:52 AM
Subject: Re: Can anyone test the saa6752hs (saa7134-empress)?


> Hi Todd,
>
>> Hello, We can help test...we are trying to implement this chip for a
>> client.
>> Here is a note from our developer (on the TO: line).  Can anyone help us
>> work through these issues?
>
> The empress driver was basically broken for a long time. The latest
> v4l-dvb repository (www.linuxtv.org/hg/v4l-dvb) has fixed most of the
> problems. There is no point in using drivers included with any of the
> recent kernels.
>
> So try the driver in v4l-dvb. Hopefully that will work. I am unfortunately
> unable to help you further at the moment, at least not until the end of
> this month when I return from traveling abroad.
>
> Regards,
>
>        Hans
>
>> Background:
>> I am working on a video capture solution for law enforcement that uses an
>> SAA7134/SAA6752 to capture two MPEG video streams on an AMD (National
>> Semiconductor) SC1200 based system.  I would like to capture the MPEG
>> compressed output from the SAA6752 chips to a buffer set that is also
>> transferred to multiple destination files on different drives, and I 
>> would
>> like to switch output files every hour on a key-frame.
>>
>> The hardware is very similar to the RTD VFG7350 frame grabber board; in
>> fact
>> I am using this board for software prototyping and proof of concept.  I 
>> am
>> using a Linux distribution based on Debi an, but I am not particularly
>> attached to it (the application note for the RTD VFG73xx cards only
>> mentions
>> Fedora Core 4 running Linux 2.6.15).
>>
>> Questions:
>> 1. Has anyone managed to capture MPEG compressed video from /dev/video2
>> and
>> /dev/video3 using Debian and an RTD VFG7350?  If so, how? (Note:  Those
>> who
>> only use software compression on /dev/video0 and/or /dev/video1 need not
>> respond).
>>
>> 2. Under Debian, any attempt to close an open pipe to /dev/video2 and
>> /dev/video3 permanently blocks the active thread, apparently in the video
>> capture driver. This prevents the user-land process that opened the pipe
>> from terminating.  You canâ?Tt even get back to the prompt after â?ocat
>> /dev/video2 [enter] [ctrl+c]â?; switching consoles and killing the
>> blocked
>> process with â?okill -KILLâ? doesnâ?Tt help, and Debian also reports
>> [failure]
>> when trying to terminate all the processes on shutdown.  Does anyone else
>> experience this?
>>
>> 3. Under Fedora Core, (I donâ?Tt remember the exact version, but many of
>> them
>> wonâ?Tt install on a SC1200, so take your pick of whichever one would be
>> easiest to get working under this condition), I found that the interface
>> to
>> /dev/video3 returned bogus information for the QUERRY and ENUM ioctl
>> functions.  Does anyone know of any alternative distribution that 
>> installs
>> and correctly supports /dev/video3 on the RTD VFG73xx?
>>
>> 4. I also tried the latest Linux kernel, 2.6.26.5 (actually, I started
>> with
>> 2.6.26 in the unstable version, but this applies to the latest as well).
>> I
>> found that with this kernel, the VIDIOC_QUERYBUF ioctl fails, although
>> calls
>> to the same function did not fail under earlier kernels.  I checked the
>> saa7134 driver and found that VIDIOC_REQBUFS, VIDIOC_QUERYBUF,
>> VIDIOC_QBUF,
>> VIDIOC_DQBUF, VIDIOC_STREAMON and VIDIOC_STREAMOFF have all been
>> completely
>> removed from the current driver.
>>
>> I absolutely must know when the buffer contains a key-frame, so I can
>> switch
>> target files smoothly.  I donâ?Tt see a way to find keyframes short of
>> decoding the stream on the fly if I donâ?Tt have the buffer information
>> associated with that interface.  I donâ?Tt think the SC1200 has enough
>> processing power to capture and decode two high quality MPEG streams on
>> the
>> fly, and still stream all the output to multiple files.  Also, Iâ?Tm
>> morally
>> opposed to writing an MPEG stream decoder, just to locate keyframes.
>> Should
>> I just give up on using the newer kernels or is there an alternate
>> mechanism
>> for finding keyframes that doesnâ?Tt involve decoding the stream on the
>> fly?
>>
>> 5. Even with older kernel/driver combinations that support 
>> VIDIOC_QUERYBUF
>> in the saa7134 driver, I have had difficulty with VIDIOC_DQBUF constantly
>> failing (errno == IOC) and it is clearly not getting around to de-queuing
>> the buffer properly since I always get buffer 0 back and the result
>> isnâ?Tt
>> properly initialized.  The Video 4 Linux 2 API documentation indicates 
>> IOC
>> is an internal driver error, but Iâ?Tm not entirely clear on why this is
>> happening.  Does this look familiar to anyone?
>>
>> 6. I have spent more than a week trying different Linux distributions,
>> looking for one that has consistent support for V4L2 and the RTD VFG7350.
>> Every single distribution Iâ?Tve tried is broken in a different way, and
>> none
>> of them have really come close to working out of the box.
>>
>> I may also need to switch to different MPEG capture hardware in the
>> future,
>> due to various parts going end-of-life.  I would really prefer to not be
>> forced into spending months re-working and debugging the video capture
>> software again.
>>
>> Is this a reasonable expectation, or is MPEG capture support sufficiently
>> difficult to implement and maintain that I should expect to go through
>> this
>> every time I change the hardware if I stick with Linux?  I am sure I
>> wouldnâ?Tt
>> be experiencing this pain if I just used XP Embedded, but I would really
>> prefer to give Linux a fair chanceâ?¦ its build level configurability
>> makes it
>> strongly attractive for this specific application, and Iâ?Tve got a lot 
>> of
>> time already invested in this.
>>
>> Thanks in advance,
>> Todd
>>
>> ----- Original Message -----
>> From: "hermann pitton" <hermann-pitton@arcor.de>
>> To: "Linux and Kernel Video" <video4linux-list@redhat.com>
>> Sent: Friday, February 29, 2008 4:44 PM
>> Subject: Re: Can anyone test the saa6752hs (saa7134-empress)?
>>
>>
>>> Am Samstag, den 20.01.2007, 17:48 +0100 schrieb Ulf BartholomÃ¤us:
>>>> Hi Hans,
>>>>
>>>> On Thursday 15 June 2006 22:30, Hans Verkuil wrote:
>>>> > I'm currently working to switch cx88-blackbird and saa7134-empress
>>>> over
>>>> > to the new MPEG encoding API. So I need someone to test the changes
>>>> to
>>>> > the empress driver and saa6752hs module for me.
>>>> On which place I found more information about this. What packages
>>>> should
>>>> be
>>>> installed?
>>>>
>>>> > If you have a card with that hardware and are willing to test it (and
>>>> > possibly even do some development to improve the current driver) then
>>>> > please contact me. The changes I made to the cx88-blackbird work
>>>> fine,
>>>> > so I hope that the same is true for the saa6752hs changes but without
>>>> > hardware I simply can't test it.
>>>> Yes I have a KNC1 TV-Station DVR with this chipset.
>>>> http://www.knc1.de/d/produkte/analog_dvr.htm
>>>>
>>>> Is your offer sometimes available now (more than a half year ago)?
>>>>
>>>> Ciao Ulf
>>>>
>>>
>>> Hi,
>>>
>>> have started to mess around with a not yet supported saa7134_empress
>>> hybrid device.
>>>
>>> I have anything going, except the mpeg encoder.
>>>
>>> Last track of having it working seems 2.4.18, but I get even EIO stuff
>>> on trying to read from the device there, but that might be device
>>> specific. At least it has two gpio switchers not seen before, but the
>>> whole stuff seems not to be that well documented ...
>>>
>>> Current stuff is definitely broken,
>>> any known last working status out there?
>>>
>>> Cheers,
>>> Hermann
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe 
>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
