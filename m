Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8EM2XZL022543
	for <video4linux-list@redhat.com>; Sun, 14 Sep 2008 18:02:34 -0400
Received: from mho-02-bos.mailhop.org (mho-02-bos.mailhop.org [63.208.196.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8EM1uuD000579
	for <video4linux-list@redhat.com>; Sun, 14 Sep 2008 18:01:56 -0400
Message-ID: <48CD89D1.9070905@edgehp.net>
Date: Sun, 14 Sep 2008 18:01:53 -0400
From: Dale Pontius <DEPontius@edgehp.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <48C9D060.6080808@edgehp.net>
	<1221188372.2648.100.camel@morgan.walls.org>
	<48CB06EF.9020803@edgehp.net>
	<1221271455.2648.112.camel@morgan.walls.org>
In-Reply-To: <1221271455.2648.112.camel@morgan.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dale Pontius <pontius@us.ibm.com>
Subject: Re: Hauppauge HVR-1600 (cx18) newbie - stuff loads, can't get output
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

I've been having troubles with my ISP and now mailserver, so this has 
been languishing for a day or two...

Andy Walls wrote:
> On Fri, 2008-09-12 at 20:18 -0400, Dale Pontius wrote:
>> Andy Walls wrote:
>>> On Thu, 2008-09-11 at 22:13 -0400, Dale Pontius wrote:
>>>   
>> Thanks for all of the info.  Cutting to save space, more specifics below.
>>>> -------------------------------------------------------------------------------
>>>> When I try "mplayer /dev/video1" it suggests I try a few options.  I did 
>>>> some trial and error with that, and with modprobe ivtv before cx18. So 
>>>> the latest when I try "mplayer -vf spp,scale /dev/video1":
>>>> -------------------------------------------------------------------------------
>>>> MPlayer dev-SVN-r26753-4.1.2 (C) 2000-2008 MPlayer Team
>>>> CPU: AMD Athlon(tm) 64 Processor 3000+ (Family: 15, Model: 47, Stepping: 0)
>>>> SSE2 supported but disabled
>>>> 3DNowExt supported but disabled
>>>> CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 0 SSE: 1 SSE2: 0
>>>> Compiled for x86 CPU with extensions: MMX MMX2 3DNow SSE
>>>>
>>>> Playing /dev/video1.
>>>> MPEG-PS file format detected.
>>>> VIDEO:  MPEG2  384x288  (aspect 2)  29.970 fps  8000.0 kbps (1000.0 kbyte/s)
>>>>     
>>>                  ^^^^^^^
>>> That resolution seems really odd to me ATM.
>>>   
>> It's worth noting that MythTV has tried to use the card.  It's default 
>> resolution for the bttv card is 480x480, so I'm not sure what's 
>> happening here.  On other attempts I've seen it start up at 720x480.
>>
>>
>> <snip>
> 
> OK.  MythTV mucked with it.  No big deal, moving on...
> 
> 
>>> OK. Some questions and things to try:
>>>
>>> 1. Do you set the mmio_ndelay module option to anything specific when
>>> you load the cx18 module?  (The very latest v4l-dvb defaults it to 0).
>>>   
>> I have not tried that.  This is an nForce4 board, with PCIe, so I 
>> believe that pretty much guarantees that it's PCI 2.3.  In addition I 
>> verified that I have a subtractive pci bridge, if I remember your 
>> earlier posts.  I did as you suggested there, and read the whole i2c/pci 
>> thread, and I think I'm good.
> 
> Just realize that at the default mmio_ndelay=0 you are *relying* on your
> motherboard hardware to fix things when the CX23418 doesn't respond
> properly.  Not the most reliable mode of operation in my opinion.
> 
I tried "modprobe cx18 mmio_ndelay=61" as you suggested elsewhere, and
it didn't seem to make a lot of difference.  Then I tried unloading all
of the v4l pieces I could readily find, including the bttv driver, and
tried modprobing cx18 with the delay, again.  I get:

Sep 13 07:04:55 localnost Linux video capture interface: v2.00
Sep 13 07:04:55 localnost cx18:  Start initialization, version 1.0.0
Sep 13 07:04:55 localnost cx18-0: Initializing card #0
Sep 13 07:04:55 localnost cx18-0: Autodetected Hauppauge card
Sep 13 07:04:55 localnost ACPI: PCI Interrupt 0000:05:08.0[A] -> Link
[APC3] -> GSI 18 (level, low) -> IRQ 18
Sep 13 07:04:55 localnost cx18-0: cx23418 revision 01010000 (B)
Sep 13 07:04:55 localnost tveeprom 2-0050: Hauppauge model 74041, rev
C6B2, serial# 3334244
Sep 13 07:04:55 localnost tveeprom 2-0050: MAC address is 00-0D-FE-32-E0-64
Sep 13 07:04:55 localnost tveeprom 2-0050: tuner model is TCL M2523_5N_E
(idx 112, type 50)
Sep 13 07:04:55 localnost tveeprom 2-0050: TV standards NTSC(M) (eeprom
0x08)
Sep 13 07:04:55 localnost tveeprom 2-0050: audio processor is CX23418
(idx 38)
Sep 13 07:04:55 localnost tveeprom 2-0050: decoder processor is CX23418
(idx 31)
Sep 13 07:04:55 localnost tveeprom 2-0050: has no radio, has IR
receiver, has IR transmitter
Sep 13 07:04:55 localnost cx18-0: Autodetected Hauppauge HVR-1600
Sep 13 07:04:55 localnost cx18-0: VBI is not yet supported
Sep 13 07:05:43 localnost cs5345 2-004c: chip found @ 0x98 (cx18 i2c
driver #0-0)
Sep 13 07:05:43 localnost cx18-0: Disabled encoder IDX device
Sep 13 07:05:43 localnost cx18-0: Registered device video0 for encoder
MPEG (2 MB)
Sep 13 07:05:43 localnost DVB: registering new adapter (cx18)
Sep 13 07:05:43 localnost MXL5005S: Attached at address 0x63
Sep 13 07:05:43 localnost DVB: registering frontend 0 (Samsung S5H1409
QAM/8VSB Frontend)...
Sep 13 07:05:43 localnost cx18-0: DVB Frontend registered
Sep 13 07:05:43 localnost cx18-0: Registered device video32 for encoder
YUV (2 MB)
Sep 13 07:05:43 localnost cx18-0: Registered device video24 for encoder
PCM audio (1 MB)
Sep 13 07:05:43 localnost cx18-0: Initialized card #0: Hauppauge HVR-1600
Sep 13 07:05:43 localnost cx18:  End initialization

Which is not significantly different.  (Sorry about the line-wrap)
The only real difference I see is that this timer there is no:

cx18-0: Unreasonably low latency timer, setting to 64 (was 32)
...
PCI: Setting latency timer of device 0000:00:04.0 to 64

Still no tuner messages.  I see from the tveeprom line that it's got a
"TCL M2523_5N_E", which in the source references TCL 2002N, which
matches your listing.

I also tried blacklisting my bttv driver, in case there's some sort of
contention or confusion between the two inside tuner-simple.
Unfortunately it didn't work, though I've been able to blacklist cx18.
(so bttv can grab video0 and be ready for MythTV)  I need to look at the
Gentoo docs harder, because ISTR that there may be something more than
just /etc/modprobe.conf needed for blacklisting.

I got some other messages a bit later that might be relevant:

it87: Found IT8712F chip at 0x290, revision 7
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
it87 it87.656: Detected broken BIOS defaults, disabling PWM interface

It's lm_sensor stuff, but it it possible that that "broken BIOS
defaults" is part of the tuner problem, since they're both i2c?

Thanks,
Dale



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
