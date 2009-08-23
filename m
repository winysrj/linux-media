Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-6.eutelia.it ([62.94.10.166]:41986 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755895AbZHWKdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 06:33:01 -0400
Received: from [192.168.1.170] (ip-173-14.sn3.eutelia.it [213.136.173.14])
	by smtp.eutelia.it (Eutelia) with ESMTP id DD35654C899
	for <linux-media@vger.kernel.org>; Sun, 23 Aug 2009 12:32:52 +0200 (CEST)
Message-ID: <4A911AB0.2040800@email.it>
Date: Sun, 23 Aug 2009 12:32:16 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: New device: Dikom DK-300 (maybe Kworld 323U rebranded)
References: <9577d4e00908130614q1d8c2c60kdcf74d324c897572@mail.gmail.com>	 <4A84138A.3050909@email.it> <9577d4e00908130934k77fb2b2ag124da076f448b1be@mail.gmail.com> <4A854761.7080102@email.it> <4A854A08.507@email.it> <4A85D05E.9040307@email.it> <4A8D03A5.8060605@email.it>
In-Reply-To: <4A8D03A5.8060605@email.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there any news?
Xwang

xwang1976@email.it ha scritto:
> Hi to all,
> I would like to know if the usbsnoop I have done under windows xp is ok 
> or if, otherwise, I have to do something different when opening the 
> video application under windows xp (I've opened it in analogical mode. 
> Should I open it also in digital tv mode?).
> Till sunday I can take usbsnoopes of the device using my brother pc.
> After such date I've to wait two weeks.
> Thank you,
> Xwang
> 
> xwang1976@email.it ha scritto:
>> This is the link to the usbsnoop I've done under windows xp:
>> http://rapidshare.com/files/267432234/UsbSnoop2.zip.html
>> I hope it is useful to:
>> 1) understand if the dikom DK-300 is really a rebranded kworld 323u
>> 2)resolve the analog tv issues (kernel panic while scanning channels 
>> and absence of audio)
>> Thank you,
>> Xwang
>>
>> xwang1976@email.it ha scritto:
>>> I forgot to send the dmesg I have had using the latest kernel 
>>> (dmesg_dikom-dk300.txt) and the Dainius modified one 
>>> (dmesg_dikom-dk300-mod.txt).
>>> Xwang
>>>
>>> xwang1976@email.it ha scritto:
>>>> Hi to all!
>>>> I've bought this device because I've seen that it has a better 
>>>> digital tuner when compared with my empire dual pen usb device.
>>>> It does not work with the latest driver because there is no digital 
>>>> tv while analog tv works with audio (even if it is a bit noisy) 
>>>> using the start script I have attached, but when I search for analog 
>>>> tv channels using tvtime-scanner, the system hangs and I have to 
>>>> turn it off being alt+sys+REISUB unable to reboot the machine.
>>>> If I modify the driver as suggest by Dainius, the digital tv works 
>>>> perfectly, but analog audio disappears and the hangs when tuning 
>>>> analog channels persist.
>>>> Can you help me so that to have this device fully functional (I'll 
>>>> continue to test also the Empire one, but this is better)?
>>>> If you need it I can take an usbsnoop of the same device, but I 
>>>> don't know how to use it exactly.
>>>> I'll search if I find some howto.
>>>> Thank you,
>>>> Xwang
>>>>
>>>> Dainius Ridzevicius ha scritto:
>>>>> Hi,
>>>>>
>>>>> replace files in /v4l-dvb/linux/drivers/media/video/em28xx
>>>>> with attached ones and make all v4l-dvb.
>>>>> make && make install. Reboot to clean old modules.
>>>>>
>>>>> DVB-T on kwordl 323ur is working, watching TV for an hour now.
>>>>>
>>>>> regards,
>>>>>
>>>>>
>>>>> On Thu, Aug 13, 2009 at 4:22 PM, <xwang1976@email.it 
>>>>> <mailto:xwang1976@email.it>> wrote:
>>>>>
>>>>>     Yes,
>>>>>     I'm still interested.
>>>>>     I suppose it is the same device.
>>>>>     In the next days I hope I will be able to take an usbsnoop of the
>>>>>     device under windows xp.
>>>>>     Meantime, I would like to test your drive.
>>>>>     Regards,
>>>>>     Xwang
>>>>>
>>>>>     Dainius Ridzevicius ha scritto:
>>>>>
>>>>>         Hello,
>>>>>
>>>>>         I have got Kworld 323UR hybrid tuner and managed to get dvb-t
>>>>>         lock today, will do some more testing later, but I can email
>>>>>         or post you a link for v4l-dvb sources changed by me (from
>>>>>         todays mercurial) if You are still interested.
>>>>>
>>>>>         Regards,
>>>>>         Dainius
>>>>>
>>>>>
>>>>>         --         -----------------------------------------
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> -- 
>>>>> -----------------------------------------
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
