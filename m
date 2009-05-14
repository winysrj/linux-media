Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:43739 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763455AbZENXMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 19:12:10 -0400
Received: by yw-out-2324.google.com with SMTP id 5so907856ywb.1
        for <linux-media@vger.kernel.org>; Thu, 14 May 2009 16:12:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b886b790905140042j3fb27a3bhf8629a764f433b19@mail.gmail.com>
References: <1240238024.5388.21.camel@mountainboyzlinux0> <b886b790905140042j3fb27a3bhf8629a764f433b19@mail.gmail.com>
From: Matthew Gardeski <garmat@gmail.com>
Date: Thu, 14 May 2009 19:11:51 -0400
Message-ID: <b886b790905141611x295ac8caq42ce918d86540280@mail.gmail.com>
Subject: Re: [linux-dvb] Is HP rebranded Hauppauge HVR-1500 ok on 64bit
	versions of stable distributions?
To: linux-media@vger.kernel.org, pghben@yahoo.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 14, 2009 at 03:42, Matthew Gardeski <garmat@gmail.com> wrote:
> On Mon, Apr 20, 2009 at 10:33, Benster & Jeremy <pghben@yahoo.com> wrote:
>> I have the hp expresscard version of the hauppauge VHR-1500 tuner. I am
>> having problems getting it to operate under the latest 64bit versions of
>> ubuntu and  suse.
>>
>> Has anyone had one of these combinations working?
>>
>> I've looked back over the archive on this list and found several threads,
>> but being a recent convert to linux, I couldn't recognize if  I needed to
>> download and recompile modules more recent than those shipped with 2.6.27
>> kernels. Nor did I know how to tell if the people that had it working were
>> running 32 or 64 bit versions.
>>
>> I'm wondering if this may only be an issue with 64 bit, only because I've
>> had a few things that took some work to get going that were related to using
>> 64bit.
>>
>> Any suggestions as to what to look for or where to go for help?
>>
>> Looking at dmesg, the card is recognized, the firmware is in /lib/firmware,
>> but no messages indicating it is being shipped to the card.
>>
>> When I try to scan for channels with either metv or w_scan, it goes through
>> the motions, but finds no channels. The light on the card does not come on.
>>
>> Thanks in advance,
>> Ben (pghben@yahoo.com)
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
> I have just finished setting up an HVR-1500q and mythtv on gentoo
> amd64.  I am happy to report that this setup works great with ATSC
> channels.  Although it is loading the firmware properly when mythtv
> tries to tune a channel, I don't see anything come up in dmesg either.
>  I get warnings in dmesg on boot, but that doesn't really mean it's
> failing.
>
> I have been able to tune into ATSC channels with the drivers from
> http://linuxtv.org/hg/v4l-dvb for the past few months with i386.
> Before that, I would get very similar messages in dmesg to what I do
> now, but mythtv could not scan or tune any channels.
>
> If you have any more questions about what I had to do to get this
> working, I'd be glad to answer them.
>
> By the way, is there any support for the analog mode or s-video input?
>
> [    9.455353] cx23885 driver version 0.0.2 loaded
> [    9.455403] cx23885 0000:06:00.0: enabling device (0000 -> 0002)
> [    9.455411] cx23885 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    9.455535] CORE cx23885[0]: subsystem: 0070:7790, board: Hauppauge
> WinTV-HVR1500Q [card=5,autodetected]
> [    9.584355] tveeprom 1-0050: Encountered bad packet header [ff].
> Corrupt or not a Hauppauge eeprom.
> [    9.584361] cx23885[0]: warning: unknown hauppauge model #0
> [    9.584363] cx23885[0]: hauppauge eeprom: model=0
> [    9.584365] cx23885_dvb_register() allocating 1 frontend(s)
> [    9.584379] cx23885[0]: cx23885 based dvb card
> [    9.954789] xc5000 2-0061: creating new instance
> [    9.955463] xc5000: Successfully identified at address 0x61
> [    9.955464] xc5000: Firmware has not been loaded previously
> [    9.955467] DVB: registering new adapter (cx23885[0])
> [    9.955470] DVB: registering adapter 0 frontend 0 (Samsung S5H1409
> QAM/8VSB Frontend)...
> [    9.955722] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [    9.955730] cx23885[0]/0: found at 0000:06:00.0, rev: 2, irq: 18,
> latency: 0, mmio: 0xf4000000
> [    9.955752] cx23885 0000:06:00.0: setting latency timer to 64
>
>
> Matt
>

I forgot to mention that even when it's working, the light on this
card doesn't come on.  I sort of prefer it this way, because it's
really bright and I find it annoying when watching tv in a dark room,
but just keep in mind, that no light doesn't indicate a failure.

Matt
