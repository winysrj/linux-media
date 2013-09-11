Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44109 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3IKNSX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 09:18:23 -0400
Message-ID: <52306D73.5040104@iki.fi>
Date: Wed, 11 Sep 2013 16:17:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: remi <remi@remis.cc>
CC: linux-media@vger.kernel.org
Subject: Re: avermedia A306 / PCIe-minicard (laptop)
References: <641271032.80124.1376921926586.open-xchange@email.1and1.fr> <52123758.4090007@iki.fi> <679222974.18260.1378902446194.open-xchange@email.1and1.fr> <52306619.2000808@iki.fi> <727808325.20610.1378905022978.open-xchange@email.1and1.fr>
In-Reply-To: <727808325.20610.1378905022978.open-xchange@email.1and1.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I don't know anything about CX23885 analog stuff. My interest in that 
case comes from AF9013 (digitial TV). I think it is Steven Toth 
<stoth@linuxtv.org> who is mostly responsible as he has done that 
driver. Resend your patches to linux-media mailing list and Cc Steven.

regards
Antti


On 09/11/2013 04:10 PM, remi wrote:
> I agree, but at least we have video, we can at least use a composite webcam , or
> a camcorder / vcr  ...
>
> my self, i used video capture cards this way since the 90's , a lot faster than
> USB webcams ...
>
>
> For the 9013, do you think it's a matter of porting the existing USB code to
> PCIe/I2C ?
>
> I see a driver with 9015 that includes it,
>
>
> (As I said, here we have af9013 as one stanalone CHIP ...)
>
> If you know of a good reading, i'll be more than glad to go thru it , I paused
> this project
> because I dont want to play Maze ( :) ) in the sources, I do program, even in
> assembly,
>
> but didnt read alot about dvb/v4l api architecture ...
>
>
> I CC the mailing list , if anybody else can orient me also .... :)
>
>
>
> Regards
>
>
>
>> Le 11 septembre 2013 à 14:46, Antti Palosaari <crope@iki.fi> a écrit :
>>
>>
>> Hello
>> I think you didn't get it working as I didn't saw af9013 attached?
>>
>>
>> Antti
>>
>> On 09/11/2013 03:27 PM, remi wrote:
>>> Hi Antti
>>>
>>>
>>> I hope you'r doing ok, I had zero answers for my work ... :p
>>>
>>>
>>> Are you on vacation ? :)
>>>
>>>
>>> Is there anything else I can do to have this card "supported" / my little
>>> patch
>>> "assimilated"  ? :)
>>>
>>> I can really go further and have even the complete wiring/ PCB   reverse
>>> engeneered if I get some attention :)
>>>
>>>
>>> Or do I have to contact directly the maintainer of the XC3028 or the CX23885
>>> ...
>>> ?
>>>
>>>
>>> Best regards
>>>
>>>
>>>> Le 19 août 2013 à 17:18, Antti Palosaari <crope@iki.fi> a écrit :
>>>>
>>>>
>>>> On 08/19/2013 05:18 PM, remi wrote:
>>>>> Hello
>>>>>
>>>>> I have this card since months,
>>>>>
>>>>> http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=376&SI=true
>>>>>
>>>>> I have finally retested it with the cx23885 driver : card=39
>>>>>
>>>>>
>>>>>
>>>>> If I could do anything to identify : [    2.414734] cx23885[0]: i2c scan:
>>>>> found
>>>>> device @ 0x66  [???]
>>>>>
>>>>> Or "hookup" the xc5000 etc
>>>>>
>>>>> I'll be more than glad .
>>>>>
>>>>
>>>>
>>>>>
>>>>> ps: i opened it up a while ago,i saw an af9013 chip ? dvb-tuner looks like
>>>>> maybe the "device @ 0x66 i2c"
>>>>>
>>>>> I will double check , and re-write-down all the chips , i think 3 .
>>>>
>>>> You have to identify all the chips, for DVB-T there is tuner missing.
>>>>
>>>> USB-interface: cx23885
>>>> DVB-T demodulator: AF9013
>>>> RF-tuner: ?
>>>>
>>>> If there is existing driver for used RF-tuner it comes nice hacking
>>>> project for some newcomer.
>>>>
>>>> It is just tweaking and hacking to find out all settings. AF9013 driver
>>>> also needs likely some changes, currently it is used only for devices
>>>> having AF9015 with integrated AF9013, or AF9015 dual devices having
>>>> AF9015 + external AF9013 providing second tuner.
>>>>
>>>> I have bought quite similar AverMedia A301 ages back as I was looking
>>>> for that AF9013 model, but maybe I have bought just wrong one... :)
>>>>
>>>>
>>>> regards
>>>> Antti
>>>>
>>>>
>>>> --
>>>> http://palosaari.fi/
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> --
>> http://palosaari.fi/


-- 
http://palosaari.fi/
