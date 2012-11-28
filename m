Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39254 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab2K1Lja (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 06:39:30 -0500
Message-ID: <50B5F7D2.9020005@iki.fi>
Date: Wed, 28 Nov 2012 13:38:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Ingo Kofler <ingo.kofler@gmail.com>
CC: =?UTF-8?B?Sm9lbCBXaXLEgW11IFBhdWxpbmc=?= <joel@aenertia.net>,
	linux-media@vger.kernel.org
Subject: Re: Tuning problems with em28xx-dvb & tda10071 on MIPS-based router
 board
References: <CAK02SCLV3677t1UQe56aWA7qBwoLna2=UREq1GAfS9PqT2deEA@mail.gmail.com> <CAKiAkGTWXfC6yW8NSdbRqgm5G4EmXjRp2=MCwAiQzmEfSBMC9w@mail.gmail.com> <CAK02SCLaUB-aeXYKPj+2-js5n7Z+qtQ0hJoYgKTCeOUc1umz-g@mail.gmail.com>
In-Reply-To: <CAK02SCLaUB-aeXYKPj+2-js5n7Z+qtQ0hJoYgKTCeOUc1umz-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/28/2012 10:05 AM, Ingo Kofler wrote:
> I know that they are not that powerful. I don't want to dump the whole
> transportstream but just a single program (~ 10 mbit/s) contained in
> it. Filtering based on the PID is done in the device isn't it?

Used em28xx chip supports pid filtering but driver doesn't.

Antti

>
> Ingo
>
> 2012/11/27 Joel Wirāmu Pauling <joel@aenertia.net>:
>> The 1043nd and similar ar7xxx chipsets only support around 30-40bit
>> transfers across the CPU and chip-set bus.
>>
>> I would be very surprised if you could reliably put an mpeg2 stream on the
>> wire from them.
>>
>>
>> -Joel
>>
>> http://gplus.to/aenertia
>> http://linkedin.com/in/aenertia
>> @aenertia
>>
>>
>>
>>
>> On 27 November 2012 06:50, Ingo Kofler <ingo.kofler@gmail.com> wrote:
>>>
>>> Hi,
>>>
>>> I am trying to get my PCTV DVB-S2 stick running on my TP-Link
>>> TL-WR1043ND that runs OpenWrt (Attitude Adjustment Beta, Kernel
>>> 3.3.8). I have cross-compiled the corresponding kernel modules and
>>> deployed them on the router. I have also deployed the firmware on the
>>> device.
>>>
>>> After loading the corresponding modules the /dev/dvb/... devices show
>>> up and the dmesg output seems to be fine. Then I tried to test the
>>> device using szap and a channels.conf file. Unfortunately, the device
>>> cannot tune to most of the transponders except of two. Both are
>>> located in the vertical high band of the Astra 19E. For all other
>>> transponders I do not get a lock of the frontend.
>>>
>>> Tuning works fine on my PC using kernel verions 3.2 and 3.5 (the ones
>>> that ship with Ubuntu) and using the same channels.conf file and
>>> stick. So I conclude that both the stick, the satellite dish and the
>>> channels.conf is working. I've also tested it on the router board with
>>> an external powered USB Hub (I though that maybe the power of the
>>> router's USB port wasn't good enough).
>>>
>>> Now I have no further ideas. Before I start to debug the C code and
>>> try to figure out the difference between the PC and the router - Are
>>> there any known issues with this driver? Does it work on MIPS and
>>> different endianess?
>>>
>>> Best regards,
>>> Ingo
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
