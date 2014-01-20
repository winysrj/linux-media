Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:48220 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaATD7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 22:59:36 -0500
Received: by mail-vc0-f175.google.com with SMTP id ij19so2498010vcb.6
        for <linux-media@vger.kernel.org>; Sun, 19 Jan 2014 19:59:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140119153224.122ce0d4@samsung.com>
References: <20140119022328.55f6a741@samsung.com>
	<20140119113926.60e0f586@samsung.com>
	<CAGoCfiwp0WPMceeyQUHU-GJkSkiQzpF-YoJ+ueiFNqNOEQNK4A@mail.gmail.com>
	<20140119153224.122ce0d4@samsung.com>
Date: Sun, 19 Jan 2014 22:59:33 -0500
Message-ID: <CAGoCfixnHRgHFkHtn3+M2Nn3NiPcLLXZozZP7fHXqCTsB9RyvA@mail.gmail.com>
Subject: Re: [ANNOUNCE EXPERIMENTAL] PCTV 80e driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 19, 2014 at 12:32 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Sun, 19 Jan 2014 11:50:55 -0500
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
>
>> On Sun, Jan 19, 2014 at 8:39 AM, Mauro Carvalho Chehab
>> <m.chehab@samsung.com> wrote:
>> > It seems that subsequent tuning makes the device worse, reducing the
>> > maximum effective packet bandwidth. Btw, this happens with both xHCI
>> > and EHCI drivers, so, it is not related to any USB 3.0 issue.
>>
>> I'm pretty sure I saw this and had a patch.  I don't recall the exact
>> circumstances under which it happened, but I believe it had to do with
>> stopping and then restarting the streaming on the em28xx too quickly.
>> The state machine inside the em28xx gets confused and you end up
>> getting a misaligned stream (which is why you see hundreds of
>> different PIDs in output from tools such as dvbtraffic).
>
> Do you still has your old tree? I'm not seeing it anymore at kernellabs.

Yeah, I still have the tree.  It's not the HG tree that you saw a
couple of years ago - it's on one of my private git trees because it
was part of a commercial project.  I'll have to dig around and see if
I can find it.

>>
>> > Enabling some demux logs, it is possible to see that there are too many
>> > FEC errors:
>> >
>> > [73514.186880] dvb_dmx_swfilter_packet: 4546 callbacks suppressed
>> > [73514.186933] TEI detected. PID=0x17f data1=0xc1
>> > [73514.186965] TEI detected. PID=0x1c68 data1=0xbc
>> > [73514.186993] TEI detected. PID=0x17f data1=0xc1
>> > [73514.187022] TEI detected. PID=0x1c68 data1=0xbc
>> > [73514.187049] TEI detected. PID=0x17f data1=0xc1
>> > [73514.187080] TEI detected. PID=0x1c68 data1=0xbc
>> > [73514.187105] TEI detected. PID=0x17f data1=0xc1
>> > [73514.194878] TEI detected. PID=0x1c68 data1=0xbc
>> > [73514.194906] TEI detected. PID=0x17f data1=0xc1
>> > [73514.194927] TEI detected. PID=0x1c68 data1=0xbc
>> > [73521.569205] TS speed 402 Kbits/sec
>>
>> Are these actually valid PIDs you're expecting data on?  If not, then
>> it could just be the issue I described above.  Does the TEI check
>> occur after it has found the SYNC byte?
>
> Yes. it keeps repeating several times, even after finding the SYNC.
>
> This patch makes the behavior stable:
>         http://git.linuxtv.org/mchehab/experimental.git/commitdiff/88c9318cbea60d189a9b10cbc4c5a73f8b002336
>
> Even so, the bitstream of my test signal is 19Mbps, while the measured
> speed with the valid packets is being about 3Mbps.

Something is seriously wrong then - I had it delivering all 19 Mbps.

>> Probably worth mentioning that while I got signal lock on ATSC, I
>> didn't any significant analysis into the quality of the SNR. It's
>> possible that additional optimization of the frontend is required in
>> order to achieve optimal performance.
>
> It is unlikely to be due to some optimization, as I'm not injecting
> any errors via the RF generator.

Sorry, I wasn't clear.  I didn't intend to suggest any RF optimization
is causing the issue you're seeing.  I was just saying that I didn't
do any optimization of the RF path so while it works under ideal
signal conditions it may not work as well under more adverse signal
conditions.  In other words, I did what most of the other LinuxTV
developers do - I got a successful signal lock and said "good enough".
 ;-)

On that note, it's probably worth mentioning that particular design
has an LNA controlled by one of the GPIOs on the DRX-J.  So if you're
consistently having poor RF performance (especially with a generator),
try sticking an attenuator in-line, and/or make sure that the LNA is
actually being properly disabled.

> Btw, I noticed that there are two "extra" firmwares, that aren't currently
> used, defined, on your driver, at drxj_mc_vsb.h and drxj_mc_vsbqam.h.
>
> Do you remember when those should be used? Or are them just two variants
> of the main firmware, with support for just VSB and just ClearQAM?

I would have to look at the source again to be sure, but if I recall
it was just so you could reduce the size of the firmware if you didn't
care about the other modulation scheme.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
