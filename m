Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54068 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab2K0Uza (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 15:55:30 -0500
Message-ID: <50B528A3.4050408@iki.fi>
Date: Tue, 27 Nov 2012 22:54:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Ingo Kofler <ingo.kofler@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Tuning problems with em28xx-dvb & tda10071 on MIPS-based router
 board
References: <CAK02SCLV3677t1UQe56aWA7qBwoLna2=UREq1GAfS9PqT2deEA@mail.gmail.com> <50B3BA92.6090407@iki.fi> <CAK02SCK9DqKSt6e145iYCp-gMsS3vgoVvXi0+3Y=HTUM-qN2Wg@mail.gmail.com>
In-Reply-To: <CAK02SCK9DqKSt6e145iYCp-gMsS3vgoVvXi0+3Y=HTUM-qN2Wg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/27/2012 10:38 PM, Ingo Kofler wrote:
> Thanks for the info. Then I'll try to fix it by myself and isolate the
> error by comparing the driver behavior on the PC and my router. I hope
> I can provide a patch for that afterwards.
>
> Are there any hints where I might look first. Since it only works for
> very few transponders I suppose the error in the frontend.... or not?

Your help is very much welcome!

Try to found out some difference between working and non-working muxes. 
Like you supposed, the error must be somewhere at the frontend side, 
which means TDA10071 or A8293 drivers. Error descriptions sounds like 
em28xx driver is not involved.


regards
Antti


>
> Regards
> Ingo
>
> 2012/11/26, Antti Palosaari <crope@iki.fi>:
>> On 11/26/2012 07:50 PM, Ingo Kofler wrote:
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
>>
>> No idea if it works or not any other than AMD64 (and i386). I use AMD64
>> Kernel on my computer and I cannot test easily any other arch's as I
>> don't have suitable hardware. i386 is so common which means bug reports
>> are got very quickly and fixed.
>>
>> Generally speaking I am a little bit surprised these drivers seems to
>> just work from arch to arch quite often.
>>
>> regards
>> Antti
>>
>> --
>> http://palosaari.fi/
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
