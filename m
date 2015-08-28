Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:60083 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbbH1I0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 04:26:42 -0400
Message-ID: <55E01B0B.1040704@xs4all.nl>
Date: Fri, 28 Aug 2015 10:25:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] saa7164: convert to the control framework
References: <55D730F4.80100@xs4all.nl>	<CAPybu_2hn8LuKy-n74cpQ1UOFvxgTv8SmXka6PwPY+U1XnZeDg@mail.gmail.com>	<55D85325.80607@xs4all.nl>	<CALzAhNVSY=yDWFk1fZnibOuThGW3J_s0sTQNhGGN8z1_U_regw@mail.gmail.com>	<55D86F3C.6090004@xs4all.nl>	<CALzAhNWhu-w+3x6S-_0ToAUAzELZSuQqo7q5NmpxXfCdciY0hw@mail.gmail.com>	<55DDBB73.5010902@xs4all.nl> <CALzAhNVxrWOsU72jin4_ygwazX2cnqBaMoPGZ_Kv77xgGx7KmA@mail.gmail.com> <55E014E6.5000801@xs4all.nl>
In-Reply-To: <55E014E6.5000801@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/28/2015 09:59 AM, Hans Verkuil wrote:
> On 08/26/2015 03:23 PM, Steven Toth wrote:
>>>>>> Has anyone tested the patch and validated each of the controls continue to work?
>>>>>
>>>>> As I said: my saa7146 card is no longer recognized (not sure why), so I was hoping
>>>>> you could test it.
>>>>
>>>> OK, will do. I probably won't get to this until the weekend, but I'll
>>>> put this on my todo list.
>>>
>>> That's OK, there is no hurry. I tried to put my saa7164 in a different PC as well,
>>> but it seems to be really broken as nothing appears in lspci :-(
>>
>> Send me your shipping address _privately_, I talk to Hauppauge about a
>> replacement.
>>
> 
> No need, I managed to get it working if I use a PCI-to-PCIe adapter card. Very
> strange, it won't work in the PCIe slot of my motherboard, but using the PCI slot
> and that adapter it works fine.
> 
> It's good that it was tested since the menu control creation code was wrong.
> 
> One thing that is very confusing to me: I have this board:
> 
> [ 1878.280918] CORE saa7164[0]: subsystem: 0070:8900, board: Hauppauge WinTV-HVR2200 [card=5,autodetected]
> [ 1878.280928] saa7164[0]/0: found at 0000:09:00.0, rev: 129, irq: 18, latency: 0, mmio: 0xfb800000
> [ 1878.327399] tveeprom 14-0000: Hauppauge model 89519, rev B2F2, serial# 4029789519
> [ 1878.327405] tveeprom 14-0000: MAC address is 00:0d:fe:31:b5:4f
> [ 1878.327409] tveeprom 14-0000: tuner model is NXP 18271C2_716x (idx 152, type 4)
> [ 1878.327413] tveeprom 14-0000: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> [ 1878.327416] tveeprom 14-0000: audio processor is SAA7164 (idx 43)
> [ 1878.327418] tveeprom 14-0000: decoder processor is CX23887A (idx 39)
> [ 1878.327420] tveeprom 14-0000: has radio
> [ 1878.327423] saa7164[0]: Hauppauge eeprom: model=89519
> 
> but the default firmware with size 4919072 fails to work (image corrupt), instead
> I need to use the firmware with size 4038864 (v4l-saa7164-1.0.3-3.fw).

That's v4l-saa7164-1.0.2-3.fw, sorry for the confusion.

Googling suggests that you have patches for this that never made it upstream.
Can you post it?

Regards,

	Hans

> 
> For that I have to patch the driver.
> 
> Do you have an overview of which firmware is for which board?
> 
> There are a bunch of firmwares here:
> 
> http://www.steventoth.net/linux/hvr22xx/firmwares
> 
> but there are no instructions or an overview of which should be used.
> 
> I faintly remember asking you this before, but that's been a long time ago
> and I can't find it in my mail archive.
> 
> I'm willing to do some driver cleanup and fix v4l2-compliance issues, but
> I'd really like to fix this firmware issue first.
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

